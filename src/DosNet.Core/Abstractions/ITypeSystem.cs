using DosNet.Core.Types;

namespace DosNet.Core.Abstractions;

/// <summary>
/// Interface para o sistema de tipos.
/// Permite resolver tipos primitivos e referências.
/// </summary>
public interface ITypeSystem
{
    /// <summary>
    /// Obtém um tipo primitivo pelo nome
    /// </summary>
    TypeDef GetPrimitiveType(string name);
    
    /// <summary>
    /// Obtém System.Object
    /// </summary>
    TypeDef ObjectType { get; }
    
    /// <summary>
    /// Obtém System.String
    /// </summary>
    TypeDef StringType { get; }
    
    /// <summary>
    /// Obtém System.Void
    /// </summary>
    TypeDef VoidType { get; }
    
    /// <summary>
    /// Obtém System.Int32
    /// </summary>
    TypeDef Int32Type { get; }
    
    /// <summary>
    /// Obtém System.Int64
    /// </summary>
    TypeDef Int64Type { get; }
    
    /// <summary>
    /// Obtém System.Single
    /// </summary>
    TypeDef SingleType { get; }
    
    /// <summary>
    /// Obtém System.Double
    /// </summary>
    TypeDef DoubleType { get; }
    
    /// <summary>
    /// Obtém System.Boolean
    /// </summary>
    TypeDef BooleanType { get; }
    
    /// <summary>
    /// Obtém System.Char
    /// </summary>
    TypeDef CharType { get; }
    
    /// <summary>
    /// Obtém System.Byte
    /// </summary>
    TypeDef ByteType { get; }
    
    /// <summary>
    /// Obtém System.IntPtr
    /// </summary>
    TypeDef IntPtrType { get; }
    
    /// <summary>
    /// Resolve um tipo pelo nome completo
    /// </summary>
    TypeDef ResolveType(string fullName);
    
    /// <summary>
    /// Registra um tipo no sistema
    /// </summary>
    void RegisterType(TypeDef type);
    
    /// <summary>
    /// Verifica se o sistema de tipos foi inicializado com corlib
    /// </summary>
    bool IsInitialized { get; }
    
    /// <summary>
    /// Obtém todos os tipos registrados
    /// </summary>
    IEnumerable<TypeDef> AllTypes { get; }
}
