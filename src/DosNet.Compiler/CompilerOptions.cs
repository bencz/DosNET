using DosNet.Core.Runtime;

namespace DosNet.Compiler;

/// <summary>
/// Opções de compilação
/// </summary>
public class CompilerOptions
{
    /// <summary>
    /// Arquivo de entrada (.dll ou .exe)
    /// </summary>
    public string InputFile { get; set; }
    
    /// <summary>
    /// Arquivo de saída (.asm)
    /// </summary>
    public string OutputFile { get; set; }
    
    /// <summary>
    /// Caminho para o corlib customizado
    /// </summary>
    public string CorlibPath { get; set; }
    
    /// <summary>
    /// Não usar stdlib (para compilar o próprio corlib)
    /// </summary>
    public bool NoStdLib { get; set; }
    
    /// <summary>
    /// Mostrar ajuda
    /// </summary>
    public bool ShowHelp { get; set; }
    
    /// <summary>
    /// Mostrar versão
    /// </summary>
    public bool ShowVersion { get; set; }
    
    /// <summary>
    /// Saída verbosa
    /// </summary>
    public bool Verbose { get; set; }
    
    /// <summary>
    /// Nível de otimização (0-3)
    /// </summary>
    public int OptimizationLevel { get; set; } = 1;
    
    /// <summary>
    /// Opções de runtime
    /// </summary>
    public RuntimeOptions RuntimeOptions { get; } = new();
}
