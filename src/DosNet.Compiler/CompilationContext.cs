using DosNet.Core.Abstractions;
using DosNet.Core.Runtime;
using DosNet.Core.Types;

namespace DosNet.Compiler;

/// <summary>
/// Contexto de compilação que mantém estado durante todo o processo
/// </summary>
public class CompilationContext : ICompilationContext
{
    private readonly List<IAssemblyReader> _inputAssemblies = new();
    private readonly List<TypeDef> _allTypes = new();
    private readonly List<MethodDef> _allMethods = new();
    private readonly List<string> _errors = new();
    private readonly List<string> _warnings = new();
    
    public ITypeSystem TypeSystem { get; }
    public RuntimeOptions Options { get; }
    public IAssemblyReader CorlibAssembly { get; private set; }
    public IReadOnlyList<IAssemblyReader> InputAssemblies => _inputAssemblies;
    public IReadOnlyList<TypeDef> AllTypes => _allTypes;
    public IReadOnlyList<MethodDef> AllMethods => _allMethods;
    public bool NoStdLib { get; }
    public bool Verbose { get; set; }
    
    public IReadOnlyList<string> Errors => _errors;
    public IReadOnlyList<string> Warnings => _warnings;
    public bool HasErrors => _errors.Count > 0;
    
    public CompilationContext(RuntimeOptions options, bool noStdLib)
    {
        Options = options;
        NoStdLib = noStdLib;
        TypeSystem = new TypeSystem();
    }
    
    /// <summary>
    /// Inicializa o sistema de tipos com o corlib
    /// </summary>
    public void InitializeTypeSystem(IAssemblyReader corlibReader)
    {
        CorlibAssembly = corlibReader;
        
        if (corlibReader != null)
        {
            var corlibTypes = corlibReader.ReadTypes().ToList();
            ((TypeSystem)TypeSystem).InitializeFromCorlib(corlibTypes);
            _allTypes.AddRange(corlibTypes);
            
            foreach (var type in corlibTypes)
            {
                foreach (var method in type.Methods)
                {
                    _allMethods.Add(method);
                }
            }
            
            ReportInfo($"Loaded corlib: {corlibReader.AssemblyName} ({corlibTypes.Count} types)");
        }
        else if (NoStdLib)
        {
            ((TypeSystem)TypeSystem).InitializeMinimal();
            ReportInfo("Initialized minimal type system (-nostdlib)");
        }
    }
    
    /// <summary>
    /// Adiciona um assembly de entrada
    /// </summary>
    public void AddInputAssembly(IAssemblyReader reader)
    {
        _inputAssemblies.Add(reader);
        
        var types = reader.ReadTypes().ToList();
        _allTypes.AddRange(types);
        
        foreach (var type in types)
        {
            TypeSystem.RegisterType(type);
            
            foreach (var method in type.Methods)
            {
                _allMethods.Add(method);
            }
        }
        
        ReportInfo($"Loaded assembly: {reader.AssemblyName} ({types.Count} types)");
    }
    
    public void ReportError(string message)
    {
        _errors.Add(message);
        Console.Error.WriteLine($"error: {message}");
    }
    
    public void ReportWarning(string message)
    {
        _warnings.Add(message);
        Console.Error.WriteLine($"warning: {message}");
    }
    
    public void ReportInfo(string message)
    {
        if (Verbose)
        {
            Console.WriteLine($"info: {message}");
        }
    }
}
