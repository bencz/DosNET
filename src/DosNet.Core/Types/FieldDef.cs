namespace DosNet.Core.Types;

/// <summary>
/// Representa a definição de um campo.
/// </summary>
public class FieldDef
{
    /// <summary>
    /// Nome do campo
    /// </summary>
    public string Name { get; set; }
    
    /// <summary>
    /// Tipo que declara este campo
    /// </summary>
    public TypeDef DeclaringType { get; set; }
    
    /// <summary>
    /// Tipo do campo
    /// </summary>
    public TypeDef FieldType { get; set; }
    
    /// <summary>
    /// Flags do campo
    /// </summary>
    public FieldFlags Flags { get; set; }
    
    /// <summary>
    /// Offset do campo na instância (para campos de instância)
    /// </summary>
    public int Offset { get; set; }
    
    /// <summary>
    /// Tamanho do campo em bytes
    /// </summary>
    public int Size { get; set; }
    
    /// <summary>
    /// Índice na tabela de campos
    /// </summary>
    public int FieldIndex { get; set; }
    
    /// <summary>
    /// Valor inicial (para campos estáticos com InitOnly)
    /// </summary>
    public object InitialValue { get; set; }
    
    // Propriedades de conveniência
    public bool IsStatic => Flags.HasFlag(FieldFlags.Static);
    public bool IsPublic => Flags.HasFlag(FieldFlags.Public);
    public bool IsPrivate => Flags.HasFlag(FieldFlags.Private);
    public bool IsInitOnly => Flags.HasFlag(FieldFlags.InitOnly);
    public bool IsLiteral => Flags.HasFlag(FieldFlags.Literal);
    public bool IsReferenceType => FieldType?.IsReferenceType ?? false;
    
    /// <summary>
    /// Obtém label para campos estáticos
    /// </summary>
    public string GetStaticLabel()
    {
        var typeName = DeclaringType?.GetMangledName() ?? "Global";
        return $"__static_{typeName}_{Name}";
    }
    
    public override string ToString()
    {
        var modifier = IsStatic ? "static " : "";
        return $"{modifier}{FieldType?.Name ?? "?"} {DeclaringType?.Name ?? ""}.{Name}";
    }
}

/// <summary>
/// Flags de campo
/// </summary>
[Flags]
public enum FieldFlags
{
    None = 0,
    Public = 1,
    Private = 2,
    Protected = 4,
    Internal = 8,
    Static = 16,
    InitOnly = 32,      // readonly
    Literal = 64,       // const
    NotSerialized = 128,
    SpecialName = 256,
    HasFieldRVA = 512,  // Tem dados iniciais
    HasDefault = 1024,
}

/// <summary>
/// Representa a definição de uma propriedade.
/// </summary>
public class PropertyDef
{
    /// <summary>
    /// Nome da propriedade
    /// </summary>
    public string Name { get; set; }
    
    /// <summary>
    /// Tipo que declara esta propriedade
    /// </summary>
    public TypeDef DeclaringType { get; set; }
    
    /// <summary>
    /// Tipo da propriedade
    /// </summary>
    public TypeDef PropertyType { get; set; }
    
    /// <summary>
    /// Método getter (pode ser null)
    /// </summary>
    public MethodDef Getter { get; set; }
    
    /// <summary>
    /// Método setter (pode ser null)
    /// </summary>
    public MethodDef Setter { get; set; }
    
    /// <summary>
    /// Índice na tabela de propriedades
    /// </summary>
    public int PropertyIndex { get; set; }
    
    public bool HasGetter => Getter != null;
    public bool HasSetter => Setter != null;
    public bool IsReadOnly => HasGetter && !HasSetter;
    public bool IsWriteOnly => !HasGetter && HasSetter;
    
    public override string ToString()
    {
        var accessors = "";
        if (HasGetter) accessors += "get; ";
        if (HasSetter) accessors += "set; ";
        return $"{PropertyType?.Name ?? "?"} {DeclaringType?.Name ?? ""}.{Name} {{ {accessors}}}";
    }
}
