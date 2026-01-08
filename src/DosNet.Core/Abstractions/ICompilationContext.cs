using DosNet.Core.Runtime;
using DosNet.Core.Types;

namespace DosNet.Core.Abstractions;

/// <summary>
/// Contexto de compilação que mantém estado durante todo o processo
/// </summary>
public interface ICompilationContext
{
    /// <summary>
    /// Sistema de tipos
    /// </summary>
    ITypeSystem TypeSystem { get; }
    
    /// <summary>
    /// Opções de runtime
    /// </summary>
    RuntimeOptions Options { get; }
    
    /// <summary>
    /// Assembly corlib (BCL customizada)
    /// </summary>
    IAssemblyReader CorlibAssembly { get; }
    
    /// <summary>
    /// Assemblies de entrada
    /// </summary>
    IReadOnlyList<IAssemblyReader> InputAssemblies { get; }
    
    /// <summary>
    /// Todos os tipos carregados
    /// </summary>
    IReadOnlyList<TypeDef> AllTypes { get; }
    
    /// <summary>
    /// Todos os métodos a serem compilados
    /// </summary>
    IReadOnlyList<MethodDef> AllMethods { get; }
    
    /// <summary>
    /// Indica se está compilando sem stdlib (-nostdlib)
    /// </summary>
    bool NoStdLib { get; }
    
    /// <summary>
    /// Reporta um erro de compilação
    /// </summary>
    void ReportError(string message);
    
    /// <summary>
    /// Reporta um warning
    /// </summary>
    void ReportWarning(string message);
    
    /// <summary>
    /// Reporta informação (verbose)
    /// </summary>
    void ReportInfo(string message);
}
