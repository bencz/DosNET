namespace DosNet.Core.IR;

/// <summary>
/// Representa um bloco básico no Control Flow Graph.
/// Um bloco básico é uma sequência de instruções onde:
/// - A execução sempre começa na primeira instrução
/// - A execução sempre termina na última instrução
/// - Não há branches no meio do bloco
/// </summary>
public class BasicBlock
{
    /// <summary>
    /// Identificador único do bloco
    /// </summary>
    public int Id { get; set; }
    
    /// <summary>
    /// Label para referência em assembly
    /// </summary>
    public string Label { get; set; }
    
    /// <summary>
    /// Offset IL do início do bloco
    /// </summary>
    public int StartOffset { get; set; }
    
    /// <summary>
    /// Offset IL do fim do bloco
    /// </summary>
    public int EndOffset { get; set; }
    
    /// <summary>
    /// Instruções do bloco
    /// </summary>
    public List<IRInstruction> Instructions { get; } = new();
    
    /// <summary>
    /// Blocos predecessores (quem pode saltar para este bloco)
    /// </summary>
    public List<BasicBlock> Predecessors { get; } = new();
    
    /// <summary>
    /// Blocos sucessores (para onde este bloco pode saltar)
    /// </summary>
    public List<BasicBlock> Successors { get; } = new();
    
    /// <summary>
    /// Indica se este é o bloco de entrada do método
    /// </summary>
    public bool IsEntry { get; set; }
    
    /// <summary>
    /// Indica se este bloco termina com um return
    /// </summary>
    public bool IsExit { get; set; }
    
    /// <summary>
    /// Indica se este bloco é alvo de um handler de exceção
    /// </summary>
    public bool IsExceptionHandler { get; set; }
    
    /// <summary>
    /// Tipo de terminador do bloco
    /// </summary>
    public BlockTerminator Terminator { get; set; }
    
    public BasicBlock(int id)
    {
        Id = id;
        Label = $"BB_{id}";
    }
    
    public void AddInstruction(IRInstruction instruction)
    {
        instruction.Block = this;
        instruction.Index = Instructions.Count;
        Instructions.Add(instruction);
    }
    
    public void AddSuccessor(BasicBlock successor)
    {
        if (!Successors.Contains(successor))
        {
            Successors.Add(successor);
            successor.Predecessors.Add(this);
        }
    }
    
    public override string ToString()
    {
        return $"{Label} ({Instructions.Count} instructions)";
    }
}

/// <summary>
/// Tipo de terminador de um bloco básico
/// </summary>
public enum BlockTerminator
{
    None,           // Bloco não terminado (erro)
    FallThrough,    // Cai para o próximo bloco
    Branch,         // Branch incondicional
    ConditionalBranch, // Branch condicional
    Switch,         // Switch table
    Return,         // Retorno de método
    Throw,          // Lança exceção
    Leave,          // Sai de bloco protegido
}
