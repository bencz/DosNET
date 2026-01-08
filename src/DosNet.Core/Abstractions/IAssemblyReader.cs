using DosNet.Core.Types;

namespace DosNet.Core.Abstractions;

/// <summary>
/// Interface para leitura de assemblies .NET
/// </summary>
public interface IAssemblyReader : IDisposable
{
    /// <summary>
    /// Abre o assembly para leitura
    /// </summary>
    void Open();
    
    /// <summary>
    /// Nome do assembly
    /// </summary>
    string AssemblyName { get; }
    
    /// <summary>
    /// Caminho do arquivo
    /// </summary>
    string FilePath { get; }
    
    /// <summary>
    /// Lê todos os tipos definidos no assembly
    /// </summary>
    IEnumerable<TypeDef> ReadTypes();
    
    /// <summary>
    /// Resolve uma referência de tipo
    /// </summary>
    TypeDef ResolveType(string fullName);
}
