namespace DosNet.Core.Types;

/// <summary>
/// Representa a definição de um tipo.
/// </summary>
public class TypeDef
{
    /// <summary>
    /// Nome do tipo (sem namespace)
    /// </summary>
    public string Name { get; set; }
    
    /// <summary>
    /// Namespace do tipo
    /// </summary>
    public string Namespace { get; set; }
    
    /// <summary>
    /// Nome completo (Namespace.Name)
    /// </summary>
    public string FullName => string.IsNullOrEmpty(Namespace) ? Name : $"{Namespace}.{Name}";
    
    /// <summary>
    /// Flags do tipo
    /// </summary>
    public TypeFlags Flags { get; set; }
    
    /// <summary>
    /// Tipo base (null para System.Object)
    /// </summary>
    public TypeDef BaseType { get; set; }
    
    /// <summary>
    /// Interfaces implementadas
    /// </summary>
    public List<TypeDef> Interfaces { get; } = new();
    
    /// <summary>
    /// Campos do tipo
    /// </summary>
    public List<FieldDef> Fields { get; } = new();
    
    /// <summary>
    /// Métodos do tipo
    /// </summary>
    public List<MethodDef> Methods { get; } = new();
    
    /// <summary>
    /// Propriedades do tipo
    /// </summary>
    public List<PropertyDef> Properties { get; } = new();
    
    /// <summary>
    /// Parâmetros genéricos (se tipo genérico)
    /// </summary>
    public List<GenericParameter> GenericParameters { get; } = new();
    
    /// <summary>
    /// Tamanho da instância em bytes (calculado)
    /// </summary>
    public int InstanceSize { get; set; }
    
    /// <summary>
    /// Alinhamento em bytes
    /// </summary>
    public int Alignment { get; set; } = 4;
    
    /// <summary>
    /// Índice na tabela de tipos (para metadata)
    /// </summary>
    public int TypeIndex { get; set; }
    
    /// <summary>
    /// Offset da VTable no código gerado
    /// </summary>
    public int VTableOffset { get; set; }
    
    /// <summary>
    /// Label da VTable no assembly
    /// </summary>
    public string VTableLabel => $"__vtbl_{GetMangledName()}";
    
    /// <summary>
    /// Métodos virtuais ordenados por slot (para VTable)
    /// </summary>
    public List<MethodDef> VirtualMethods { get; set; }
    
    /// <summary>
    /// Indica se é um tipo genérico aberto (com parâmetros não resolvidos)
    /// </summary>
    public bool IsGenericDefinition => GenericParameters.Count > 0 && !IsGenericInstance;
    
    /// <summary>
    /// Indica se é uma instanciação de tipo genérico
    /// </summary>
    public bool IsGenericInstance { get; set; }
    
    /// <summary>
    /// Definição genérica original (se IsGenericInstance)
    /// </summary>
    public TypeDef GenericDefinition { get; set; }
    
    /// <summary>
    /// Argumentos de tipo (se IsGenericInstance)
    /// </summary>
    public List<TypeDef> TypeArguments { get; } = new();
    
    // Propriedades de conveniência
    public bool IsClass => !IsValueType && !IsInterface;
    public bool IsValueType => Flags.HasFlag(TypeFlags.ValueType);
    public bool IsInterface => Flags.HasFlag(TypeFlags.Interface);
    public bool IsEnum => Flags.HasFlag(TypeFlags.Enum);
    public bool IsDelegate => Flags.HasFlag(TypeFlags.Delegate);
    public bool IsSealed => Flags.HasFlag(TypeFlags.Sealed);
    public bool IsAbstract => Flags.HasFlag(TypeFlags.Abstract);
    public bool IsPublic => Flags.HasFlag(TypeFlags.Public);
    public bool IsReferenceType => !IsValueType;
    
    /// <summary>
    /// Obtém nome mangled para uso em assembly
    /// </summary>
    public string GetMangledName()
    {
        // Substituir caracteres inválidos para MASM
        var name = FullName
            .Replace('.', '_')
            .Replace('<', '_')
            .Replace('>', '_')
            .Replace(',', '_')
            .Replace('`', '_')
            .Replace('[', '_')
            .Replace(']', '_')
            .Replace(' ', '_');
        
        if (IsGenericInstance && TypeArguments.Count > 0)
        {
            name = GenericDefinition?.GetMangledName() ?? name;
            name += "_" + string.Join("_", TypeArguments.Select(t => t.GetMangledName()));
        }
        
        return name;
    }
    
    /// <summary>
    /// Obtém tamanho do tipo quando usado como campo/variável
    /// </summary>
    public int GetStackSize()
    {
        if (IsReferenceType)
            return 4; // Ponteiro 32-bit
        
        return InstanceSize;
    }
    
    /// <summary>
    /// Verifica se este tipo é atribuível a outro
    /// </summary>
    public bool IsAssignableTo(TypeDef target)
    {
        if (this == target)
            return true;
        
        if (BaseType != null && BaseType.IsAssignableTo(target))
            return true;
        
        if (target.IsInterface && Interfaces.Any(i => i.IsAssignableTo(target)))
            return true;
        
        return false;
    }
    
    public override string ToString() => FullName;
}

/// <summary>
/// Flags de tipo
/// </summary>
[Flags]
public enum TypeFlags
{
    None = 0,
    Public = 1,
    Sealed = 2,
    Abstract = 4,
    Interface = 8,
    ValueType = 16,
    Enum = 32,
    Delegate = 64,
    HasGenericParams = 128,
    IsGenericInst = 256,
    Serializable = 512,
    HasFinalizer = 1024,
    SpecialName = 2048,
    BeforeFieldInit = 4096,
}

/// <summary>
/// Representa um parâmetro genérico
/// </summary>
public class GenericParameter
{
    public string Name { get; set; }
    public int Index { get; set; }
    public GenericParameterConstraints Constraints { get; set; }
    public List<TypeDef> ConstraintTypes { get; } = new();
    
    public override string ToString() => Name;
}

[Flags]
public enum GenericParameterConstraints
{
    None = 0,
    ReferenceType = 1,      // class constraint
    ValueType = 2,          // struct constraint
    DefaultConstructor = 4, // new() constraint
}
