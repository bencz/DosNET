using System.Text;
using DosNet.Compiler.CodeGen.x86;
using DosNet.Compiler.IL;
using DosNet.Compiler.Metadata;
using DosNet.Core.Abstractions;
using DosNet.Core.Runtime;
using DosNet.Core.Runtime.Exception;
using DosNet.Core.Runtime.GC;
using DosNet.Core.Runtime.IO;
using DosNet.Core.Runtime.SoftFloat;
using DosNet.Core.Runtime.Startup;

namespace DosNet.Compiler;

/// <summary>
/// Compilador principal - orquestra todo o processo de compilação
/// </summary>
public class Compiler
{
    private readonly CompilerOptions _options;
    private readonly CompilationContext _context;
    
    public Compiler(CompilerOptions options)
    {
        _options = options;
        _context = new CompilationContext(options.RuntimeOptions, options.NoStdLib)
        {
            Verbose = options.Verbose
        };
    }
    
    /// <summary>
    /// Executa a compilação
    /// </summary>
    public int Compile()
    {
        try
        {
            // 1. Inicializar sistema de tipos
            InitializeTypeSystem();
            if (_context.HasErrors) return 1;
            
            // 2. Carregar assemblies de entrada
            LoadInputAssemblies();
            if (_context.HasErrors) return 1;
            
            // 3. Analisar tipos e métodos
            AnalyzeTypes();
            if (_context.HasErrors) return 1;
            
            // 4. Gerar código
            var output = GenerateCode();
            if (_context.HasErrors) return 1;
            
            // 5. Escrever saída
            WriteOutput(output);
            
            return 0;
        }
        catch (Exception ex)
        {
            _context.ReportError(ex.Message);
            if (_options.Verbose)
            {
                Console.Error.WriteLine(ex.StackTrace);
            }
            return 1;
        }
    }
    
    private void InitializeTypeSystem()
    {
        if (_options.NoStdLib)
        {
            // Modo -nostdlib: não carregar corlib
            _context.InitializeTypeSystem(null);
            return;
        }
        
        // Determinar caminho do corlib
        var corlibPath = _options.CorlibPath;
        if (string.IsNullOrEmpty(corlibPath))
        {
            // Tentar encontrar corlib no mesmo diretório do compilador
            var compilerDir = AppContext.BaseDirectory;
            corlibPath = Path.Combine(compilerDir, "corlib.dll");
            
            if (!File.Exists(corlibPath))
            {
                // Tentar diretório do arquivo de entrada
                if (!string.IsNullOrEmpty(_options.InputFile))
                {
                    var inputDir = Path.GetDirectoryName(_options.InputFile);
                    corlibPath = Path.Combine(inputDir, "corlib.dll");
                }
            }
        }
        
        if (!string.IsNullOrEmpty(corlibPath) && File.Exists(corlibPath))
        {
            // Carregar corlib usando InitializeTypeSystem que já registra os tipos
            var corlibReader = new AssemblyReader(corlibPath);
            corlibReader.Open();
            _context.InitializeTypeSystem(corlibReader);
        }
        else
        {
            _context.ReportWarning("corlib.dll not found, using minimal type system");
            _context.InitializeTypeSystem(null);
        }
    }
    
    private void LoadInputAssemblies()
    {
        if (string.IsNullOrEmpty(_options.InputFile))
        {
            _context.ReportError("No input file specified");
            return;
        }
        
        if (!File.Exists(_options.InputFile))
        {
            _context.ReportError($"Input file not found: {_options.InputFile}");
            return;
        }
        
        // Usar AssemblyReader (System.Reflection.Metadata) para corlib customizado
        // pois System.Reflection não consegue carregar assemblies sem System.Object padrão
        var reader = new AssemblyReader(_options.InputFile, _context.TypeSystem);
        reader.Open();
        _context.AddInputAssembly(reader);
    }
    
    private void AnalyzeTypes()
    {
        _context.ReportInfo($"Analyzing {_context.AllTypes.Count} types...");
        _context.ReportInfo($"Found {_context.AllMethods.Count} methods");
        
        // Calcular layouts de objetos (tamanho de instância, offsets de campos)
        CalculateTypeLayouts();
        
        // Construir VTables
        var vtableBuilder = new VTableBuilder(_context.AllTypes);
        vtableBuilder.BuildVTables();
        
        // Decodificar IL e gerar CFG para todos os métodos
        foreach (var reader in _context.InputAssemblies)
        {
            if (reader is AssemblyReader asmReader)
            {
                asmReader.DecodeAllMethodBodies();
            }
        }
        
        // TODO: Análise de generics (monomorphization)
    }
    
    private void CalculateTypeLayouts()
    {
        foreach (var type in _context.AllTypes)
        {
            if (type.IsInterface)
                continue;
            
            int offset = 0;
            
            // Primeiro campo é sempre o ponteiro para VTable (para classes)
            if (!type.IsValueType)
            {
                offset = 4; // sizeof(void*)
            }
            
            // Herdar tamanho do tipo base
            if (type.BaseType != null)
            {
                offset = type.BaseType.InstanceSize;
            }
            
            // Calcular offset de cada campo
            foreach (var field in type.Fields)
            {
                if (field.IsStatic)
                    continue;
                
                // Alinhar ao tamanho do campo
                int fieldSize = field.FieldType?.GetStackSize() ?? 4;
                field.Size = fieldSize;
                
                // Alinhar
                int alignment = Math.Min(fieldSize, 4);
                offset = (offset + alignment - 1) & ~(alignment - 1);
                
                field.Offset = offset;
                offset += fieldSize;
            }
            
            // Alinhar tamanho total
            type.InstanceSize = (offset + 3) & ~3;
        }
    }
    
    private string GenerateCode()
    {
        _context.ReportInfo("Generating code...");
        
        var output = new StringBuilder();
        
        if (_options.NoStdLib)
        {
            // Compilando corlib - apenas gerar código dos tipos/métodos
            GenerateCorlibCode(output);
        }
        else
        {
            // Compilando aplicação normal
            // Startup code (inclui .386, .MODEL, .DATA, .DATA?, .CODE e entry point)
            GenerateStartupCode(output);
            
            // Runtime code (GC, SoftFloat, etc)
            GenerateRuntimeCode(output);
            
            // User code
            GenerateUserCode(output);
            
            // End
            output.AppendLine("END __start");
        }
        
        return output.ToString();
    }
    
    private void GenerateCorlibCode(StringBuilder output)
    {
        // Header
        output.AppendLine("; ============================================================");
        output.AppendLine("; DosNET CoreLib - Base Class Library");
        output.AppendLine("; ============================================================");
        output.AppendLine();
        
        // Diretiva de CPU
        var cpuDirective = _options.RuntimeOptions.CpuLevel switch
        {
            CpuLevel.I386 => ".386",
            CpuLevel.I486 => ".486",
            CpuLevel.I586 => ".586",
            _ => ".386"
        };
        output.AppendLine(cpuDirective);
        output.AppendLine(".MODEL FLAT, C");
        output.AppendLine();
        
        // Criar DataSectionGenerator
        var dataGen = new DataSectionGenerator();
        
        // Registrar campos estáticos
        foreach (var type in _context.AllTypes)
        {
            dataGen.AddStaticFields(type.Fields);
        }
        
        // Gerar código dos métodos PRIMEIRO (para registrar strings)
        var codeGen = new X86CodeGenerator(_options.RuntimeOptions, dataGen);
        
        foreach (var type in _context.AllTypes)
        {
            codeGen.GenerateType(type);
        }
        
        foreach (var method in _context.AllMethods)
        {
            codeGen.GenerateMethod(method);
        }
        
        var generatedCode = codeGen.GetGeneratedCode();
        
        // AGORA gerar seção de dados (com strings registradas)
        output.AppendLine(dataGen.GenerateDataSection());
        
        // Adicionar dados do runtime
        GenerateCorlibRuntimeData(output);
        
        output.AppendLine(dataGen.GenerateBssSection());
        
        // Seção de código
        output.AppendLine(".CODE");
        output.AppendLine();
        
        // Gerar código de runtime (GC, exceptions, etc.) - faz parte do corlib
        GenerateCorlibRuntimeCode(output);
        
        // Gerar VTables
        var vtableBuilder = new VTableBuilder(_context.AllTypes);
        output.AppendLine(vtableBuilder.GenerateVTables());
        
        // Gerar tabelas de metadados
        var metadataBuilder = new MetadataBuilder(_context.AllTypes);
        output.AppendLine(metadataBuilder.GenerateMetadataTables());
        
        // Código dos métodos
        output.AppendLine(generatedCode);
        
        output.AppendLine();
        output.AppendLine("END");
    }
    
    private void GenerateCorlibRuntimeCode(StringBuilder output)
    {
        // O corlib contém a implementação do runtime
        // Gerar apenas o código (sem seções .DATA/.CODE pois já foram geradas)
        output.AppendLine("; ============================================================");
        output.AppendLine("; RUNTIME CODE (GC, Exceptions, I/O)");
        output.AppendLine("; ============================================================");
        output.AppendLine();
        
        // GC Runtime - apenas código
        var gcGen = new GCRuntimeGenerator();
        output.AppendLine(gcGen.GenerateCodeOnly());
        output.AppendLine();
        
        // SoftFloat Runtime (se necessário)
        if (_options.RuntimeOptions.SoftFloatOnly || _options.RuntimeOptions.FpuDetect)
        {
            var softFloatGen = new SoftFloatRuntimeGenerator();
            output.AppendLine(softFloatGen.GenerateCodeOnly());
            output.AppendLine();
        }
        
        // Timer GC - apenas código (sem startup completo)
        var startupGen = new StartupCodeGenerator(_options.RuntimeOptions);
        output.AppendLine(startupGen.GenerateGCTimerCodeOnly());
        output.AppendLine();
        
        // Exception runtime
        var exceptionGen = new ExceptionRuntimeGenerator();
        output.AppendLine(exceptionGen.GenerateCodeOnly());
        output.AppendLine();
        
        // I/O functions (__write, __read, __getch, __kbhit, __putch)
        var ioGen = new IORuntimeGenerator();
        output.AppendLine(ioGen.GenerateCodeOnly());
        output.AppendLine();
        
        // Placeholder para __program_end
        output.AppendLine("PUBLIC __program_end");
        output.AppendLine("__program_end:");
        output.AppendLine();
    }
    
    private void GenerateCorlibRuntimeData(StringBuilder output)
    {
        // Gerar dados do runtime para seção .DATA
        var gcGen = new GCRuntimeGenerator();
        output.AppendLine(gcGen.GenerateDataOnly());
        
        // SoftFloat data (se necessário)
        if (_options.RuntimeOptions.SoftFloatOnly || _options.RuntimeOptions.FpuDetect)
        {
            var softFloatGen = new SoftFloatRuntimeGenerator();
            output.AppendLine(softFloatGen.GenerateDataOnly());
        }
        
        // Exception data
        var exceptionGen = new ExceptionRuntimeGenerator();
        output.AppendLine(exceptionGen.GenerateDataOnly());
        
        var startupGen = new StartupCodeGenerator(_options.RuntimeOptions);
        output.AppendLine(startupGen.GenerateGCTimerDataOnly());
    }
    
    private void GenerateStartupCode(StringBuilder output)
    {
        var startupGen = new StartupCodeGenerator(_options.RuntimeOptions);
        // Para aplicações, usar startup simplificado (exception handlers vêm do corlib)
        output.AppendLine(startupGen.GenerateAppStartup());
        output.AppendLine();
    }
    
    private void GenerateRuntimeCode(StringBuilder output)
    {
        // O runtime (GC, SoftFloat, etc.) está no corlib.lib
        // Aqui apenas declaramos as funções externas que serão linkadas
        output.AppendLine("; ============================================================");
        output.AppendLine("; External Runtime Functions (from corlib.lib)");
        output.AppendLine("; ============================================================");
        output.AppendLine();
        
        // GC externals
        if (_options.RuntimeOptions.EnableGC)
        {
            output.AppendLine("EXTRN __gc_init:PROC");
            output.AppendLine("EXTRN __gc_alloc:PROC");
            output.AppendLine("EXTRN __gc_alloc_typed:PROC");
            output.AppendLine("EXTRN __gc_collect:PROC");
        }
        
        // Exception externals
        if (_options.RuntimeOptions.EnableExceptions)
        {
            output.AppendLine("EXTRN __throw_exception:PROC");
            output.AppendLine("EXTRN __throw_out_of_memory:PROC");
            output.AppendLine("EXTRN __throw_null_reference:PROC");
            output.AppendLine("EXTRN __throw_invalid_cast:PROC");
            output.AppendLine("EXTRN __throw_index_out_of_range:PROC");
        }
        
        // SoftFloat externals
        if (_options.RuntimeOptions.SoftFloatOnly || _options.RuntimeOptions.FpuDetect)
        {
            output.AppendLine("EXTRN __soft_fadd:PROC");
            output.AppendLine("EXTRN __soft_fsub:PROC");
            output.AppendLine("EXTRN __soft_fmul:PROC");
            output.AppendLine("EXTRN __soft_fdiv:PROC");
        }
        
        // I/O functions are defined in CORLIB via IORuntimeGenerator
        // No need for EXTRN declarations here
        
        output.AppendLine();
    }
    
    private void GenerateUserCode(StringBuilder output)
    {
        output.AppendLine("; ============================================================");
        output.AppendLine("; User Code");
        output.AppendLine("; ============================================================");
        output.AppendLine();
        
        // Filtrar apenas tipos/métodos do assembly do usuário (não do corlib)
        var userTypes = _context.AllTypes.Where(t => !IsCorlibType(t)).ToList();
        var userMethods = _context.AllMethods.Where(m => !IsCorlibType(m.DeclaringType)).ToList();
        var corlibMethods = _context.AllMethods.Where(m => IsCorlibType(m.DeclaringType)).ToList();
        
        // Gerar EXTRN para métodos do corlib
        output.AppendLine("; External Corlib Methods");
        foreach (var method in corlibMethods)
        {
            output.AppendLine($"EXTRN {method.GetLabel()}:PROC");
        }
        output.AppendLine();
        
        // Criar DataSectionGenerator para strings do usuário
        var dataGen = new DataSectionGenerator();
        
        // Registrar campos estáticos do usuário
        foreach (var type in userTypes)
        {
            dataGen.AddStaticFields(type.Fields);
        }
        
        var codeGen = new X86CodeGenerator(_options.RuntimeOptions, dataGen);
        
        // Registrar tipos do usuário
        foreach (var type in userTypes)
        {
            codeGen.GenerateType(type);
        }
        
        // Gerar métodos do usuário
        foreach (var method in userMethods)
        {
            codeGen.GenerateMethod(method);
        }
        
        var generatedCode = codeGen.GetGeneratedCode();
        
        // Gerar seção de dados do usuário
        output.AppendLine(dataGen.GenerateDataSection());
        output.AppendLine(dataGen.GenerateBssSection());
        
        output.AppendLine(".CODE");
        output.AppendLine();
        
        // Gerar VTables do usuário
        var vtableBuilder = new VTableBuilder(userTypes);
        output.AppendLine(vtableBuilder.GenerateVTables());
        
        // Gerar metadata do usuário (se reflection habilitado)
        if (_options.RuntimeOptions.EnableReflection)
        {
            var metadataBuilder = new MetadataBuilder(userTypes);
            output.AppendLine(metadataBuilder.GenerateMetadataTables());
        }
        
        output.AppendLine(generatedCode);
    }
    
    private bool IsCorlibType(DosNet.Core.Types.TypeDef type)
    {
        if (type == null) return false;
        var ns = type.Namespace ?? "";
        // Tipos do System.* são do corlib
        // Tipos do Microsoft.CodeAnalysis.* são gerados pelo compilador (ignorar)
        // Tipos com namespace vazio e nome começando com "<" são gerados pelo compilador
        if (ns.StartsWith("System")) return true;
        if (ns.StartsWith("Microsoft.CodeAnalysis")) return true;
        if (ns == "" && type.Name.StartsWith("<")) return true;
        return false;
    }
    
    private void WriteOutput(string output)
    {
        var outputFile = _options.OutputFile ?? 
                         Path.ChangeExtension(_options.InputFile, ".asm");
        
        // Converter para nome 8.3 compatível
        var dir = Path.GetDirectoryName(outputFile) ?? ".";
        var originalName = Path.GetFileNameWithoutExtension(outputFile);
        var shortName = ConvertTo83Name(originalName);
        outputFile = Path.Combine(dir, shortName + ".ASM");
        
        File.WriteAllText(outputFile, output);
        Console.WriteLine($"Output written to: {outputFile}");
        
        // Gerar arquivo .bat para build com MASM
        GenerateBuildScript(outputFile, shortName);
    }
    
    /// <summary>
    /// Converte nome para formato DOS 8.3 usando algoritmo inteligente
    /// </summary>
    private static string ConvertTo83Name(string name)
    {
        // Remover caracteres inválidos para DOS
        var clean = new string(name.Where(c => char.IsLetterOrDigit(c)).ToArray()).ToUpperInvariant();
        
        if (clean.Length <= 8)
            return clean;
        
        // Para nomes compostos (CamelCase), extrair iniciais significativas
        var parts = SplitCamelCase(name);
        if (parts.Count > 1)
        {
            // Tentar usar primeiras letras de cada parte
            var initials = string.Concat(parts.Select(p => p.Length > 0 ? p[0].ToString().ToUpperInvariant() : ""));
            if (initials.Length >= 3 && initials.Length <= 8)
            {
                // Adicionar mais caracteres da última parte se necessário
                var lastPart = parts.Last().ToUpperInvariant();
                var remaining = 8 - initials.Length;
                if (remaining > 0 && lastPart.Length > 1)
                {
                    initials += lastPart.Substring(1, Math.Min(remaining, lastPart.Length - 1));
                }
                return initials.Length > 8 ? initials.Substring(0, 8) : initials;
            }
        }
        
        // Fallback: primeiros 6 caracteres + últimos 2
        if (clean.Length > 8)
        {
            return clean.Substring(0, 6) + clean.Substring(clean.Length - 2, 2);
        }
        
        return clean;
    }
    
    private static List<string> SplitCamelCase(string name)
    {
        var parts = new List<string>();
        var current = new StringBuilder();
        
        foreach (var c in name)
        {
            if (char.IsUpper(c) && current.Length > 0)
            {
                parts.Add(current.ToString());
                current.Clear();
            }
            if (char.IsLetterOrDigit(c))
                current.Append(c);
        }
        
        if (current.Length > 0)
            parts.Add(current.ToString());
        
        return parts;
    }
    
    private void GenerateBuildScript(string asmFile, string shortName)
    {
        var dir = Path.GetDirectoryName(asmFile) ?? ".";
        var batFile = Path.Combine(dir, $"{shortName}.BAT");
        
        var sb = new StringBuilder();
        sb.AppendLine("@echo off");
        sb.AppendLine("REM ============================================================");
        sb.AppendLine($"REM Build script for {shortName}");
        sb.AppendLine("REM Generated by DosNET Compiler");
        sb.AppendLine("REM Target: HX DOS Extender (32-bit Protected Mode)");
        sb.AppendLine("REM ============================================================");
        sb.AppendLine();
        sb.AppendLine("REM ============================================================");
        sb.AppendLine("REM Configure paths (JWASM + JWLINK)");
        sb.AppendLine("REM ============================================================");
        sb.AppendLine("SET JWASM_PATH=C:\\JWASM");
        sb.AppendLine("SET ASM=%JWASM_PATH%\\JWASMR.EXE");
        sb.AppendLine("SET LINK=%JWASM_PATH%\\JWLINKD.EXE");
        sb.AppendLine("SET LIB=%JWASM_PATH%\\JWLIBD.EXE");
        sb.AppendLine();
        sb.AppendLine("SET HX_PATH=C:\\HX");
        sb.AppendLine();
        
        if (_options.NoStdLib)
        {
            // Compilando corlib - gerar biblioteca
            sb.AppendLine("REM ============================================================");
            sb.AppendLine("REM Building corlib.lib (DosNET Base Class Library)");
            sb.AppendLine("REM ============================================================");
            sb.AppendLine();
            sb.AppendLine($"echo [1/2] Assembling {shortName}.ASM...");
            sb.AppendLine($"\"%ASM%\" {shortName}.ASM");
            sb.AppendLine("if errorlevel 1 goto error");
            sb.AppendLine();
            sb.AppendLine($"echo [2/2] Creating {shortName}.LIB...");
            sb.AppendLine($"\"%LIB%\" -n -b {shortName}.LIB +{shortName}.OBJ");
            sb.AppendLine("if errorlevel 1 goto error");
            sb.AppendLine();
            sb.AppendLine("echo.");
            sb.AppendLine("echo ============================================================");
            sb.AppendLine("echo Build successful!");
            sb.AppendLine("echo ============================================================");
            sb.AppendLine($"echo Output: {shortName}.LIB");
            sb.AppendLine($"echo.");
            sb.AppendLine("echo To use this library, copy it to your project directory");
            sb.AppendLine("echo and link with your application.");
        }
        else
        {
            // Compilando aplicação - gerar executável
            var heapSize = _options.RuntimeOptions.HeapSize;
            var stackSize = _options.RuntimeOptions.StackSize;
            
            sb.AppendLine("REM ============================================================");
            sb.AppendLine("REM Building HX DOS Extender Application");
            sb.AppendLine("REM ============================================================");
            sb.AppendLine();
            sb.AppendLine($"echo [1/2] Assembling {shortName}.ASM...");
            sb.AppendLine($"\"%ASM%\" {shortName}.ASM");
            sb.AppendLine("if errorlevel 1 goto error");
            sb.AppendLine();
            sb.AppendLine($"echo [2/3] Linking {shortName}.EXE...");
            sb.AppendLine("REM Link with CORLIB.OBJ and HX libraries using JWLINK (PE format)");
            sb.AppendLine($"\"%LINK%\" format windows pe file {shortName}.OBJ,CORLIB.OBJ library %HX_PATH%\\LIB\\DKRNL32S.LIB library %HX_PATH%\\LIB\\LIBC32S.LIB library %HX_PATH%\\LIB\\IMPHLP.LIB name {shortName}.EXE");
            sb.AppendLine("if errorlevel 1 goto error");
            sb.AppendLine();
            sb.AppendLine($"echo [3/3] Adding HX DOS stub...");
            sb.AppendLine("REM Add HX DOS stub with embedded DPMI loader for standalone execution");
            sb.AppendLine($"%HX_PATH%\\BIN\\PESTUB.EXE {shortName}.EXE %HX_PATH%\\BIN\\DPMIST32.BIN");
            sb.AppendLine("if errorlevel 1 goto error");
            sb.AppendLine();
            sb.AppendLine("echo.");
            sb.AppendLine("echo ============================================================");
            sb.AppendLine("echo Build successful!");
            sb.AppendLine("echo ============================================================");
            sb.AppendLine($"echo Output:     {shortName}.EXE");
            sb.AppendLine($"echo Heap size:  {heapSize / 1024} KB ({heapSize / 1024 / 1024} MB)");
            sb.AppendLine($"echo Stack size: {stackSize / 1024} KB");
            sb.AppendLine("echo.");
            sb.AppendLine("echo To run in DOS:");
            sb.AppendLine($"echo   1. Copy {shortName}.EXE and HDPMI32.EXE to DOS");
            sb.AppendLine($"echo   2. Run: {shortName}.EXE");
            sb.AppendLine("echo.");
            sb.AppendLine("echo To run in Windows:");
            sb.AppendLine($"echo   Just run: {shortName}.EXE");
        }
        
        sb.AppendLine("goto end");
        sb.AppendLine();
        sb.AppendLine(":error");
        sb.AppendLine("echo.");
        sb.AppendLine("echo ============================================================");
        sb.AppendLine("echo BUILD FAILED!");
        sb.AppendLine("echo ============================================================");
        sb.AppendLine("echo Check the error messages above.");
        sb.AppendLine("echo.");
        sb.AppendLine("echo Common issues:");
        sb.AppendLine("echo   - MASM32 not installed or path incorrect");
        sb.AppendLine("echo   - HX DOS Extender not installed or path incorrect");
        sb.AppendLine("echo   - corlib.lib not found (build corlib first)");
        sb.AppendLine("exit /b 1");
        sb.AppendLine();
        sb.AppendLine(":end");
        
        File.WriteAllText(batFile, sb.ToString());
        Console.WriteLine($"Build script: {batFile}");
    }
}
