using DosNet.Core.IR;

namespace DosNet.Core.Types;

/// <summary>
/// Representa a definição de um método.
/// </summary>
public class MethodDef
{
    /// <summary>
    /// Nome do método
    /// </summary>
    public string Name { get; set; }
    
    /// <summary>
    /// Tipo que declara este método
    /// </summary>
    public TypeDef DeclaringType { get; set; }
    
    /// <summary>
    /// Flags do método
    /// </summary>
    public MethodFlags Flags { get; set; }
    
    /// <summary>
    /// Tipo de retorno
    /// </summary>
    public TypeDef ReturnType { get; set; }
    
    /// <summary>
    /// Parâmetros do método
    /// </summary>
    public List<ParameterDef> Parameters { get; } = new();
    
    /// <summary>
    /// Variáveis locais
    /// </summary>
    public List<LocalVariable> Locals { get; } = new();
    
    /// <summary>
    /// Parâmetros genéricos (se método genérico)
    /// </summary>
    public List<GenericParameter> GenericParameters { get; } = new();
    
    /// <summary>
    /// Corpo do método em IL (bytes originais)
    /// </summary>
    public byte[] ILBody { get; set; }
    
    /// <summary>
    /// Control Flow Graph (após análise)
    /// </summary>
    public ControlFlowGraph CFG { get; set; }
    
    /// <summary>
    /// Índice na tabela de métodos
    /// </summary>
    public int MethodIndex { get; set; }
    
    /// <summary>
    /// Slot na VTable (se virtual)
    /// </summary>
    public int VTableSlot { get; set; } = -1;
    
    /// <summary>
    /// Offset do código no segmento de código
    /// </summary>
    public int CodeOffset { get; set; }
    
    /// <summary>
    /// Tamanho máximo da pilha de avaliação
    /// </summary>
    public int MaxStack { get; set; }
    
    /// <summary>
    /// Tamanho do frame de stack (locais + spills)
    /// </summary>
    public int StackFrameSize { get; set; }
    
    /// <summary>
    /// Código assembly customizado (de AsmImplementationAttribute)
    /// </summary>
    public string CustomAssembly { get; set; }
    
    /// <summary>
    /// Código assembly alternativo para soft-float
    /// </summary>
    public string SoftFloatAssembly { get; set; }
    
    /// <summary>
    /// Nome da rotina de runtime (se IsRuntimeCall)
    /// </summary>
    public string RuntimeRoutine { get; set; }
    
    /// <summary>
    /// Indica se é um intrinsic do compilador
    /// </summary>
    public bool IsIntrinsic { get; set; }
    
    /// <summary>
    /// Nome do intrinsic (se IsIntrinsic)
    /// </summary>
    public string IntrinsicName { get; set; }
    
    /// <summary>
    /// Indica se usa FPU x87
    /// </summary>
    public bool UsesX87 { get; set; }
    
    /// <summary>
    /// Convenção de chamada
    /// </summary>
    public CallingConvention CallingConvention { get; set; } = CallingConvention.Cdecl;
    
    // Propriedades de conveniência
    public bool IsStatic => Flags.HasFlag(MethodFlags.Static);
    public bool IsVirtual => Flags.HasFlag(MethodFlags.Virtual);
    public bool IsAbstract => Flags.HasFlag(MethodFlags.Abstract);
    public bool IsFinal => Flags.HasFlag(MethodFlags.Final);
    public bool IsPublic => Flags.HasFlag(MethodFlags.Public);
    public bool IsPrivate => Flags.HasFlag(MethodFlags.Private);
    public bool IsConstructor => Name == ".ctor";
    public bool IsStaticConstructor => Name == ".cctor";
    public bool IsSpecialName => Flags.HasFlag(MethodFlags.SpecialName);
    public bool HasCustomAssembly => !string.IsNullOrEmpty(CustomAssembly);
    public bool IsRuntimeCall => !string.IsNullOrEmpty(RuntimeRoutine);
    public bool IsGenericDefinition => GenericParameters.Count > 0;
    
    /// <summary>
    /// Obtém label para uso em assembly (inclui assinatura para overloads)
    /// </summary>
    public string GetLabel()
    {
        var typeName = DeclaringType?.GetMangledName() ?? "Global";
        var methodName = Name.Replace('.', '_').Replace('<', '_').Replace('>', '_');
        
        // Incluir tipos dos parâmetros para distinguir overloads
        if (Parameters.Count > 0)
        {
            var paramSuffix = string.Join("_", Parameters.Select(p => 
                p.ParameterType?.Name?.Replace('.', '_').Replace('<', '_').Replace('>', '_').Replace('[', '_').Replace(']', '_') ?? "obj"));
            return $"__{typeName}_{methodName}_{paramSuffix}";
        }
        
        return $"__{typeName}_{methodName}";
    }
    
    /// <summary>
    /// Obtém assinatura do método para display
    /// </summary>
    public string GetSignature()
    {
        var returnTypeName = ReturnType?.Name ?? "void";
        var paramTypes = string.Join(", ", Parameters.Select(p => p.ParameterType?.Name ?? "?"));
        return $"{returnTypeName} {DeclaringType?.Name ?? ""}.{Name}({paramTypes})";
    }
    
    /// <summary>
    /// Calcula tamanho total dos parâmetros em bytes
    /// </summary>
    public int GetParametersSize()
    {
        int size = 0;
        
        // this pointer para métodos de instância
        if (!IsStatic)
            size += 4;
        
        foreach (var param in Parameters)
        {
            size += param.ParameterType?.GetStackSize() ?? 4;
        }
        
        return size;
    }
    
    /// <summary>
    /// Calcula tamanho total das variáveis locais em bytes
    /// </summary>
    public int GetLocalsSize()
    {
        int size = 0;
        foreach (var local in Locals)
        {
            size += local.Type?.GetStackSize() ?? 4;
        }
        return size;
    }
    
    public override string ToString() => GetSignature();
}

/// <summary>
/// Flags de método
/// </summary>
[Flags]
public enum MethodFlags
{
    None = 0,
    Public = 1,
    Private = 2,
    Protected = 4,
    Internal = 8,
    Static = 16,
    Virtual = 32,
    Abstract = 64,
    Final = 128,
    NewSlot = 256,
    SpecialName = 512,
    RTSpecialName = 1024,
    PInvokeImpl = 2048,
    HasSecurity = 4096,
    RequireSecObject = 8192,
}

/// <summary>
/// Convenção de chamada
/// </summary>
public enum CallingConvention
{
    Cdecl,      // Caller limpa stack, args right-to-left
    Stdcall,    // Callee limpa stack, args right-to-left
    Fastcall,   // Primeiros 2 args em ECX, EDX
    Thiscall,   // this em ECX
}

/// <summary>
/// Representa um parâmetro de método
/// </summary>
public class ParameterDef
{
    public string Name { get; set; }
    public int Index { get; set; }
    public TypeDef ParameterType { get; set; }
    public ParameterFlags Flags { get; set; }
    public object DefaultValue { get; set; }
    
    public bool IsIn => Flags.HasFlag(ParameterFlags.In);
    public bool IsOut => Flags.HasFlag(ParameterFlags.Out);
    public bool IsOptional => Flags.HasFlag(ParameterFlags.Optional);
    public bool HasDefault => Flags.HasFlag(ParameterFlags.HasDefault);
    
    public override string ToString() => $"{ParameterType?.Name ?? "?"} {Name}";
}

[Flags]
public enum ParameterFlags
{
    None = 0,
    In = 1,
    Out = 2,
    Optional = 4,
    HasDefault = 8,
}

/// <summary>
/// Representa uma variável local
/// </summary>
public class LocalVariable
{
    public int Index { get; set; }
    public TypeDef Type { get; set; }
    public string Name { get; set; }
    public int Offset { get; set; } // Offset no stack frame (negativo de EBP)
    
    public override string ToString() => $"local_{Index}: {Type?.Name ?? "?"}";
}
