namespace DosNet.Core.IR;

/// <summary>
/// Representa uma instrução na Intermediate Representation.
/// </summary>
public class IRInstruction
{
    /// <summary>
    /// Offset original no IL (para debug/mapeamento)
    /// </summary>
    public int ILOffset { get; set; }
    
    /// <summary>
    /// Opcode da instrução
    /// </summary>
    public IROpCode OpCode { get; set; }
    
    /// <summary>
    /// Operando da instrução (pode ser null)
    /// </summary>
    public object Operand { get; set; }
    
    /// <summary>
    /// Tipo do resultado (se aplicável)
    /// </summary>
    public IRType ResultType { get; set; }
    
    /// <summary>
    /// Bloco básico que contém esta instrução
    /// </summary>
    public BasicBlock Block { get; set; }
    
    /// <summary>
    /// Índice dentro do bloco básico
    /// </summary>
    public int Index { get; set; }
    
    public IRInstruction(IROpCode opCode)
    {
        OpCode = opCode;
    }
    
    public IRInstruction(IROpCode opCode, object operand)
    {
        OpCode = opCode;
        Operand = operand;
    }
    
    public override string ToString()
    {
        if (Operand != null)
            return $"{OpCode} {Operand}";
        return OpCode.ToString();
    }
}

/// <summary>
/// Tipos primitivos na IR
/// </summary>
public enum IRType
{
    Void,
    Bool,
    I1,         // int8
    I2,         // int16
    I4,         // int32
    I8,         // int64
    U1,         // uint8
    U2,         // uint16
    U4,         // uint32
    U8,         // uint64
    R4,         // float32
    R8,         // float64
    IPtr,       // IntPtr (32-bit no x86)
    UPtr,       // UIntPtr
    Ref,        // Reference type (ponteiro para objeto)
    ByRef,      // Referência gerenciada (ref/out)
    ValueType,  // Value type customizado
}
