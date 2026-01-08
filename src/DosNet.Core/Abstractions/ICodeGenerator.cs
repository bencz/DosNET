using DosNet.Core.Types;

namespace DosNet.Core.Abstractions;

/// <summary>
/// Interface para geração de código assembly
/// </summary>
public interface ICodeGenerator
{
    /// <summary>
    /// Gera código para um método
    /// </summary>
    void GenerateMethod(MethodDef method);
    
    /// <summary>
    /// Gera código para um tipo (VTable, metadata, etc)
    /// </summary>
    void GenerateType(TypeDef type);
    
    /// <summary>
    /// Obtém o código assembly gerado
    /// </summary>
    string GetGeneratedCode();
    
    /// <summary>
    /// Obtém a seção de dados
    /// </summary>
    string GetDataSection();
    
    /// <summary>
    /// Obtém a seção BSS (dados não inicializados)
    /// </summary>
    string GetBssSection();
}

/// <summary>
/// Interface para seleção de instruções baseada no nível de CPU
/// </summary>
public interface IInstructionSelector
{
    /// <summary>
    /// Seleciona a melhor instrução para uma operação
    /// </summary>
    string SelectInstruction(InstructionOperation operation, params string[] operands);
    
    /// <summary>
    /// Verifica se uma instrução está disponível no nível de CPU atual
    /// </summary>
    bool IsInstructionAvailable(string instruction);
}

/// <summary>
/// Operações que podem ser selecionadas
/// </summary>
public enum InstructionOperation
{
    ByteSwap,           // BSWAP (i486+) ou ROL sequence (i386)
    CompareExchange,    // CMPXCHG (i486+) ou CLI/CMP/MOV/STI (i386)
    ConditionalMove,    // CMOVcc (i686+) ou CMP/Jcc/MOV (i386-i586)
    FloatCompare,       // FCOMI (i686+) ou FCOM/FNSTSW/SAHF (i386-i586)
    ReadTimestamp,      // RDTSC (i586+)
    CpuId,              // CPUID (i586+)
}
