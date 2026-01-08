namespace DosNet.Core.Types;

/// <summary>
/// Representa uma instanciação de tipo genérico.
/// Usado para monomorphization.
/// </summary>
public class GenericInstantiation : IEquatable<GenericInstantiation>
{
    /// <summary>
    /// Definição genérica original
    /// </summary>
    public TypeDef GenericDefinition { get; }
    
    /// <summary>
    /// Argumentos de tipo
    /// </summary>
    public IReadOnlyList<TypeDef> TypeArguments { get; }
    
    /// <summary>
    /// Tipo especializado gerado
    /// </summary>
    public TypeDef SpecializedType { get; set; }
    
    /// <summary>
    /// Chave canônica para sharing
    /// </summary>
    public string CanonicalKey { get; }
    
    public GenericInstantiation(TypeDef genericDef, IReadOnlyList<TypeDef> typeArgs)
    {
        GenericDefinition = genericDef ?? throw new ArgumentNullException(nameof(genericDef));
        TypeArguments = typeArgs ?? throw new ArgumentNullException(nameof(typeArgs));
        CanonicalKey = ComputeCanonicalKey();
    }
    
    /// <summary>
    /// Computa chave canônica para determinar sharing.
    /// Reference types mapeiam para "__ref" para permitir compartilhamento.
    /// </summary>
    private string ComputeCanonicalKey()
    {
        var sb = new System.Text.StringBuilder();
        sb.Append(GenericDefinition.FullName);
        sb.Append('<');
        
        for (int i = 0; i < TypeArguments.Count; i++)
        {
            if (i > 0) sb.Append(',');
            sb.Append(GetCanonicalTypeName(TypeArguments[i]));
        }
        
        sb.Append('>');
        return sb.ToString();
    }
    
    /// <summary>
    /// Obtém nome canônico do tipo para sharing.
    /// Reference types compartilham implementação.
    /// </summary>
    private static string GetCanonicalTypeName(TypeDef type)
    {
        if (type.IsReferenceType)
            return "__ref";
        
        return type.FullName switch
        {
            "System.Boolean" => "__bool",
            "System.Byte" => "__u8",
            "System.SByte" => "__i8",
            "System.Int16" => "__i16",
            "System.UInt16" => "__u16",
            "System.Int32" => "__i32",
            "System.UInt32" => "__u32",
            "System.Int64" => "__i64",
            "System.UInt64" => "__u64",
            "System.Single" => "__f32",
            "System.Double" => "__f64",
            "System.Char" => "__char",
            "System.IntPtr" => "__iptr",
            "System.UIntPtr" => "__uptr",
            _ => $"__{type.FullName.Replace('.', '_')}"
        };
    }
    
    /// <summary>
    /// Gera nome para o tipo especializado
    /// </summary>
    public string GetSpecializedName()
    {
        return CanonicalKey
            .Replace('<', '_')
            .Replace('>', '_')
            .Replace(',', '_')
            .Replace("System.", "")
            .Replace(".", "_");
    }
    
    /// <summary>
    /// Verifica se todos os argumentos são reference types (pode compartilhar)
    /// </summary>
    public bool AllReferenceTypes => TypeArguments.All(t => t.IsReferenceType);
    
    /// <summary>
    /// Verifica se algum argumento é value type (precisa especializar)
    /// </summary>
    public bool HasValueTypeArguments => TypeArguments.Any(t => t.IsValueType);
    
    public bool Equals(GenericInstantiation other)
    {
        if (other is null) return false;
        return CanonicalKey == other.CanonicalKey;
    }
    
    public override bool Equals(object obj)
    {
        return Equals(obj as GenericInstantiation);
    }
    
    public override int GetHashCode()
    {
        return CanonicalKey.GetHashCode();
    }
    
    public override string ToString()
    {
        var args = string.Join(", ", TypeArguments.Select(t => t.Name));
        return $"{GenericDefinition.Name}<{args}>";
    }
}

/// <summary>
/// Grupo de instanciações que compartilham código.
/// </summary>
public class SharingGroup
{
    /// <summary>
    /// Chave canônica do grupo
    /// </summary>
    public string CanonicalKey { get; }
    
    /// <summary>
    /// Instanciações neste grupo
    /// </summary>
    public List<GenericInstantiation> Instantiations { get; } = new();
    
    /// <summary>
    /// Nome do tipo/método gerado para este grupo
    /// </summary>
    public string GeneratedName { get; }
    
    public SharingGroup(string canonicalKey)
    {
        CanonicalKey = canonicalKey;
        GeneratedName = canonicalKey
            .Replace('<', '_')
            .Replace('>', '_')
            .Replace(',', '_')
            .Replace("System.", "")
            .Replace(".", "_");
    }
    
    public void Add(GenericInstantiation inst)
    {
        if (!Instantiations.Contains(inst))
            Instantiations.Add(inst);
    }
    
    public override string ToString()
    {
        return $"{GeneratedName} ({Instantiations.Count} instantiations)";
    }
}
