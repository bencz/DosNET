using DosNet.Core.Abstractions;

namespace DosNet.Core.Types;

/// <summary>
/// Implementação do sistema de tipos.
/// Gerencia tipos primitivos e referências ao corlib customizado.
/// </summary>
public class TypeSystem : ITypeSystem
{
    private readonly Dictionary<string, TypeDef> _types = new();
    private readonly Dictionary<string, TypeDef> _primitiveTypes = new();
    
    public bool IsInitialized { get; private set; }
    
    public TypeDef ObjectType => GetPrimitiveType("Object");
    public TypeDef StringType => GetPrimitiveType("String");
    public TypeDef VoidType => GetPrimitiveType("Void");
    public TypeDef Int32Type => GetPrimitiveType("Int32");
    public TypeDef Int64Type => GetPrimitiveType("Int64");
    public TypeDef SingleType => GetPrimitiveType("Single");
    public TypeDef DoubleType => GetPrimitiveType("Double");
    public TypeDef BooleanType => GetPrimitiveType("Boolean");
    public TypeDef CharType => GetPrimitiveType("Char");
    public TypeDef ByteType => GetPrimitiveType("Byte");
    public TypeDef IntPtrType => GetPrimitiveType("IntPtr");
    
    /// <summary>
    /// Inicializa o sistema de tipos com os tipos do corlib
    /// </summary>
    public void InitializeFromCorlib(IEnumerable<TypeDef> corlibTypes)
    {
        foreach (var type in corlibTypes)
        {
            RegisterType(type);
            
            // Mapear tipos primitivos
            if (type.Namespace == "System")
            {
                _primitiveTypes[type.Name] = type;
            }
        }
        
        IsInitialized = true;
    }
    
    /// <summary>
    /// Inicializa com tipos placeholder (para -nostdlib)
    /// </summary>
    public void InitializeMinimal()
    {
        var primitives = new[]
        {
            ("Void", true, 0),
            ("Boolean", true, 1),
            ("Char", true, 2),
            ("SByte", true, 1),
            ("Byte", true, 1),
            ("Int16", true, 2),
            ("UInt16", true, 2),
            ("Int32", true, 4),
            ("UInt32", true, 4),
            ("Int64", true, 8),
            ("UInt64", true, 8),
            ("Single", true, 4),
            ("Double", true, 8),
            ("IntPtr", true, 4),
            ("UIntPtr", true, 4),
            ("Object", false, 4),
            ("String", false, 8),
            ("Array", false, 8),
            ("ValueType", true, 0),
            ("Enum", true, 4),
            ("Type", false, 4),
            ("Exception", false, 4),
        };
        
        foreach (var (name, isValueType, size) in primitives)
        {
            var type = new TypeDef
            {
                Name = name,
                Namespace = "System",
                Flags = isValueType ? TypeFlags.ValueType | TypeFlags.Public : TypeFlags.Public,
                InstanceSize = size,
            };
            
            _primitiveTypes[name] = type;
            RegisterType(type);
        }
        
        IsInitialized = true;
    }
    
    public TypeDef GetPrimitiveType(string name)
    {
        if (_primitiveTypes.TryGetValue(name, out var type))
            return type;
        
        // Fallback: criar tipo placeholder
        type = new TypeDef
        {
            Name = name,
            Namespace = "System",
            Flags = TypeFlags.Public,
        };
        
        _primitiveTypes[name] = type;
        return type;
    }
    
    public TypeDef ResolveType(string fullName)
    {
        if (_types.TryGetValue(fullName, out var type))
            return type;
        
        return null;
    }
    
    public void RegisterType(TypeDef type)
    {
        var fullName = type.FullName;
        if (!_types.ContainsKey(fullName))
        {
            type.TypeIndex = _types.Count;
            _types[fullName] = type;
        }
    }
    
    /// <summary>
    /// Obtém todos os tipos registrados
    /// </summary>
    public IEnumerable<TypeDef> GetAllTypes() => _types.Values;
    
    /// <summary>
    /// Obtém todos os tipos registrados (propriedade para interface)
    /// </summary>
    public IEnumerable<TypeDef> AllTypes => _types.Values;
}
