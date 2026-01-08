namespace DosNet.Core.IR;

/// <summary>
/// Representa o Control Flow Graph de um método.
/// </summary>
public class ControlFlowGraph
{
    /// <summary>
    /// Método ao qual este CFG pertence
    /// </summary>
    public string MethodName { get; set; }
    
    /// <summary>
    /// Bloco de entrada do método
    /// </summary>
    public BasicBlock EntryBlock { get; set; }
    
    /// <summary>
    /// Todos os blocos básicos do método
    /// </summary>
    public List<BasicBlock> Blocks { get; } = new();
    
    /// <summary>
    /// Blocos de saída (que terminam com return)
    /// </summary>
    public List<BasicBlock> ExitBlocks { get; } = new();
    
    /// <summary>
    /// Contador para gerar IDs únicos de blocos
    /// </summary>
    private int _nextBlockId;
    
    public ControlFlowGraph(string methodName)
    {
        MethodName = methodName;
    }
    
    /// <summary>
    /// Cria um novo bloco básico
    /// </summary>
    public BasicBlock CreateBlock()
    {
        var block = new BasicBlock(_nextBlockId++);
        Blocks.Add(block);
        return block;
    }
    
    /// <summary>
    /// Define o bloco de entrada
    /// </summary>
    public void SetEntryBlock(BasicBlock block)
    {
        EntryBlock = block;
        block.IsEntry = true;
    }
    
    /// <summary>
    /// Marca um bloco como saída
    /// </summary>
    public void AddExitBlock(BasicBlock block)
    {
        block.IsExit = true;
        if (!ExitBlocks.Contains(block))
            ExitBlocks.Add(block);
    }
    
    /// <summary>
    /// Obtém bloco por offset IL
    /// </summary>
    public BasicBlock GetBlockAtOffset(int offset)
    {
        return Blocks.FirstOrDefault(b => b.StartOffset == offset);
    }
    
    /// <summary>
    /// Obtém ou cria bloco para um offset IL
    /// </summary>
    public BasicBlock GetOrCreateBlockAtOffset(int offset)
    {
        var existing = GetBlockAtOffset(offset);
        if (existing != null)
            return existing;
        
        var block = CreateBlock();
        block.StartOffset = offset;
        return block;
    }
    
    /// <summary>
    /// Valida o CFG
    /// </summary>
    public bool Validate(out List<string> errors)
    {
        errors = new List<string>();
        
        if (EntryBlock == null)
        {
            errors.Add("CFG has no entry block");
            return false;
        }
        
        if (ExitBlocks.Count == 0)
        {
            errors.Add("CFG has no exit blocks");
        }
        
        foreach (var block in Blocks)
        {
            if (block.Instructions.Count == 0 && !block.IsEntry)
            {
                errors.Add($"Block {block.Label} has no instructions");
            }
            
            if (block.Terminator == BlockTerminator.None && block.Instructions.Count > 0)
            {
                errors.Add($"Block {block.Label} has no terminator");
            }
        }
        
        return errors.Count == 0;
    }
    
    /// <summary>
    /// Retorna representação textual do CFG
    /// </summary>
    public override string ToString()
    {
        return $"CFG for {MethodName}: {Blocks.Count} blocks";
    }
    
    /// <summary>
    /// Gera representação detalhada para debug
    /// </summary>
    public string Dump()
    {
        var sb = new System.Text.StringBuilder();
        sb.AppendLine($"=== CFG: {MethodName} ===");
        sb.AppendLine();
        
        foreach (var block in Blocks)
        {
            sb.Append(block.Label);
            if (block.IsEntry) sb.Append(" [ENTRY]");
            if (block.IsExit) sb.Append(" [EXIT]");
            sb.AppendLine(":");
            
            foreach (var inst in block.Instructions)
            {
                sb.AppendLine($"    {inst}");
            }
            
            if (block.Successors.Count > 0)
            {
                sb.AppendLine($"    -> {string.Join(", ", block.Successors.Select(s => s.Label))}");
            }
            
            sb.AppendLine();
        }
        
        return sb.ToString();
    }
}
