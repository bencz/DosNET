using System.Text;
using DosNet.Compiler.Metadata;
using DosNet.Core.Abstractions;
using DosNet.Core.Runtime;
using DosNet.Core.Types;

namespace DosNet.Compiler.CodeGen.x86;

/// <summary>
/// Gerador de código x86 para DOS.
/// Suporta i386, i486 e i586.
/// Coordena MasmEmitter, InstructionSelector e MethodCompiler.
/// </summary>
public class X86CodeGenerator : ICodeGenerator
{
    private readonly RuntimeOptions _options;
    private readonly MasmEmitter _emitter;
    private readonly X86InstructionSelector _selector;
    private readonly MethodCompiler _methodCompiler;
    private readonly DataSectionGenerator _dataGen;
    private readonly Dictionary<string, int> _stringLiterals;
    private readonly List<TypeDef> _types;
    private int _stringCounter;
    
    public X86CodeGenerator(RuntimeOptions options) : this(options, null)
    {
    }
    
    public X86CodeGenerator(RuntimeOptions options, DataSectionGenerator dataGen)
    {
        _options = options;
        _dataGen = dataGen;
        _emitter = new MasmEmitter();
        _selector = new X86InstructionSelector(options.CpuLevel, _emitter);
        _methodCompiler = new MethodCompiler(_emitter, _selector, options, dataGen);
        _stringLiterals = new Dictionary<string, int>();
        _types = new List<TypeDef>();
    }
    
    /// <summary>
    /// Gera código para um tipo (VTable, metadata, etc)
    /// </summary>
    public void GenerateType(TypeDef type)
    {
        _types.Add(type);
    }
    
    /// <summary>
    /// Gera código assembly para um método
    /// </summary>
    public void GenerateMethod(MethodDef method)
    {
        _methodCompiler.Compile(method);
    }
    
    /// <summary>
    /// Gera VTables para todos os tipos registrados
    /// </summary>
    public void GenerateVTables()
    {
        _emitter.EmitLine();
        _emitter.EmitSectionHeader("VTables");
        _emitter.EmitLine();
        
        foreach (var type in _types)
        {
            if (type.IsInterface || type.IsValueType)
                continue;
            
            GenerateVTable(type);
        }
    }
    
    private void GenerateVTable(TypeDef type)
    {
        _emitter.EmitComment($"VTable for {type.FullName}");
        _emitter.EmitLabel(type.VTableLabel);
        _emitter.Indent();
        
        // Coletar métodos virtuais
        var virtualMethods = CollectVirtualMethods(type);
        
        foreach (var method in virtualMethods)
        {
            _emitter.EmitLine($"DD OFFSET {method.GetLabel()}");
        }
        
        _emitter.Unindent();
        _emitter.EmitLine();
    }
    
    private List<MethodDef> CollectVirtualMethods(TypeDef type)
    {
        var methods = new List<MethodDef>();
        
        // Herdar métodos do tipo base
        if (type.BaseType != null)
        {
            methods.AddRange(CollectVirtualMethods(type.BaseType));
        }
        
        // Adicionar/substituir métodos deste tipo
        foreach (var method in type.Methods)
        {
            if (!method.IsVirtual)
                continue;
            
            // Verificar se é override
            int existingIndex = methods.FindIndex(m => 
                m.Name == method.Name && 
                ParametersMatch(m, method));
            
            if (existingIndex >= 0)
            {
                // Override
                method.VTableSlot = existingIndex;
                methods[existingIndex] = method;
            }
            else
            {
                // Novo slot
                method.VTableSlot = methods.Count;
                methods.Add(method);
            }
        }
        
        return methods;
    }
    
    private static bool ParametersMatch(MethodDef m1, MethodDef m2)
    {
        if (m1.Parameters.Count != m2.Parameters.Count)
            return false;
        
        for (int i = 0; i < m1.Parameters.Count; i++)
        {
            var p1 = m1.Parameters[i].ParameterType;
            var p2 = m2.Parameters[i].ParameterType;
            
            if (p1?.FullName != p2?.FullName)
                return false;
        }
        
        return true;
    }
    
    /// <summary>
    /// Gera tabelas de metadata para reflection
    /// </summary>
    public void GenerateMetadata()
    {
        _emitter.EmitLine();
        _emitter.EmitSectionHeader("Metadata Tables");
        _emitter.EmitLine();
        
        // Header
        _emitter.EmitLabel("__metadata_header");
        _emitter.Indent();
        _emitter.EmitLine($"DD {_types.Count}                ; TypeCount");
        _emitter.EmitLine("DD OFFSET __metadata_types   ; TypesOffset");
        _emitter.EmitLine("DD OFFSET __metadata_methods ; MethodsOffset");
        _emitter.EmitLine("DD OFFSET __metadata_fields  ; FieldsOffset");
        _emitter.EmitLine("DD OFFSET __metadata_strings ; StringsOffset");
        _emitter.Unindent();
        _emitter.EmitLine();
        
        // Type table
        _emitter.EmitLabel("__metadata_types");
        _emitter.Indent();
        foreach (var type in _types)
        {
            _emitter.EmitComment(type.FullName);
            _emitter.EmitLine($"DD 0                         ; NameOffset (TODO)");
            _emitter.EmitLine($"DD {type.TypeIndex}          ; TypeIndex");
            _emitter.EmitLine($"DD {type.BaseType?.TypeIndex ?? 0} ; BaseTypeIndex");
            _emitter.EmitLine($"DD {type.InstanceSize}       ; InstanceSize");
            _emitter.EmitLine($"DD {(int)type.Flags}         ; Flags");
            _emitter.EmitLine($"DD OFFSET {type.VTableLabel} ; VTablePtr");
            _emitter.EmitLine($"DW {type.Methods.Count}      ; MethodCount");
            _emitter.EmitLine($"DW {type.Fields.Count}       ; FieldCount");
        }
        _emitter.Unindent();
        _emitter.EmitLine();
        
        // Placeholder para outras tabelas
        _emitter.EmitLabel("__metadata_methods");
        _emitter.EmitLine("    ; TODO: Method metadata");
        _emitter.EmitLine();
        
        _emitter.EmitLabel("__metadata_fields");
        _emitter.EmitLine("    ; TODO: Field metadata");
        _emitter.EmitLine();
        
        _emitter.EmitLabel("__metadata_strings");
        _emitter.EmitLine("    ; TODO: String pool");
        _emitter.EmitLine();
    }
    
    /// <summary>
    /// Registra uma string literal
    /// </summary>
    public string RegisterStringLiteral(string value)
    {
        if (_stringLiterals.TryGetValue(value, out var id))
            return $"__str_{id}";
        
        id = _stringCounter++;
        _stringLiterals[value] = id;
        return $"__str_{id}";
    }
    
    /// <summary>
    /// Obtém o código assembly gerado
    /// </summary>
    public string GetGeneratedCode() => _emitter.ToString();
    
    /// <summary>
    /// Obtém a seção de dados
    /// </summary>
    public string GetDataSection()
    {
        var sb = new StringBuilder();
        
        // String literals
        foreach (var (value, id) in _stringLiterals)
        {
            var escaped = EscapeString(value);
            sb.AppendLine($"    __str_{id} DB '{escaped}', 0");
        }
        
        return sb.ToString();
    }
    
    /// <summary>
    /// Obtém a seção BSS
    /// </summary>
    public string GetBssSection()
    {
        return "";
    }
    
    private static string EscapeString(string value)
    {
        var sb = new StringBuilder();
        foreach (var c in value)
        {
            switch (c)
            {
                case '\'': sb.Append("', 27h, '"); break;
                case '\r': sb.Append("', 0Dh, '"); break;
                case '\n': sb.Append("', 0Ah, '"); break;
                case '\t': sb.Append("', 09h, '"); break;
                default: sb.Append(c); break;
            }
        }
        return sb.ToString();
    }
}
