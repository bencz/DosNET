namespace DosNet.Core.Runtime;

/// <summary>
/// Classe base para geradores de runtime.
/// </summary>
public abstract class RuntimeGeneratorBase
{
    /// <summary>
    /// Nome do runtime
    /// </summary>
    public abstract string Name { get; }
    
    /// <summary>
    /// Descrição do runtime
    /// </summary>
    public abstract string Description { get; }
    
    /// <summary>
    /// Gera o código assembly do runtime
    /// </summary>
    public abstract string Generate();
    
    /// <summary>
    /// Gera código de inicialização (chamado no startup)
    /// </summary>
    public virtual string GenerateInit() => "";
    
    /// <summary>
    /// Gera código de finalização (chamado no shutdown)
    /// </summary>
    public virtual string GenerateShutdown() => "";
    
    /// <summary>
    /// Lista de símbolos exportados por este runtime
    /// </summary>
    public virtual IEnumerable<string> ExportedSymbols => Array.Empty<string>();
    
    /// <summary>
    /// Lista de símbolos externos requeridos
    /// </summary>
    public virtual IEnumerable<string> RequiredSymbols => Array.Empty<string>();
}

/// <summary>
/// Opções de configuração do runtime
/// </summary>
public class RuntimeOptions
{
    /// <summary>
    /// Habilitar Garbage Collector
    /// </summary>
    public bool EnableGC { get; set; } = true;
    
    /// <summary>
    /// Tamanho do heap em bytes
    /// </summary>
    public int HeapSize { get; set; } = 64 * 1024; // 64KB (reduzido para teste)
    
    /// <summary>
    /// Tamanho da stack em bytes
    /// </summary>
    public int StackSize { get; set; } = 64 * 1024; // 64KB
    
    /// <summary>
    /// Habilitar suporte a reflection
    /// </summary>
    public bool EnableReflection { get; set; } = true;
    
    /// <summary>
    /// Habilitar tratamento de exceções
    /// </summary>
    public bool EnableExceptions { get; set; } = true;
    
    /// <summary>
    /// Usar apenas software float (sem FPU)
    /// </summary>
    public bool SoftFloatOnly { get; set; } = false;
    
    /// <summary>
    /// Requer FPU (falha se não presente)
    /// </summary>
    public bool FpuRequired { get; set; } = false;
    
    /// <summary>
    /// Detectar FPU em runtime
    /// </summary>
    public bool FpuDetect { get; set; } = true;
    
    /// <summary>
    /// Nível de CPU target
    /// </summary>
    public CpuLevel CpuLevel { get; set; } = CpuLevel.I386;
}

/// <summary>
/// Níveis de CPU suportados
/// </summary>
public enum CpuLevel
{
    /// <summary>
    /// Intel 80386 - Base
    /// </summary>
    I386,
    
    /// <summary>
    /// Intel 80486 - Adiciona BSWAP, CMPXCHG, XADD
    /// </summary>
    I486,
    
    /// <summary>
    /// Intel Pentium - Adiciona RDTSC, CPUID, CMPXCHG8B
    /// </summary>
    I586,
}
