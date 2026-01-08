namespace DosNet.Compiler.IL;

/// <summary>
/// Representa uma instrução IL decodificada.
/// </summary>
public class ILInstruction
{
    /// <summary>
    /// Offset da instrução no corpo do método
    /// </summary>
    public int Offset { get; set; }
    
    /// <summary>
    /// Opcode da instrução
    /// </summary>
    public ILOpCode OpCode { get; set; }
    
    /// <summary>
    /// Operando da instrução (pode ser null)
    /// Tipos possíveis:
    /// - int, long, float, double para constantes
    /// - int para branches (offset alvo)
    /// - int[] para switch (offsets alvos)
    /// - MetadataToken para referências
    /// </summary>
    public object Operand { get; set; }
    
    /// <summary>
    /// Tamanho total da instrução em bytes
    /// </summary>
    public int Size { get; set; }
    
    /// <summary>
    /// Offset da próxima instrução
    /// </summary>
    public int NextOffset => Offset + Size;
    
    public ILInstruction(int offset, ILOpCode opCode)
    {
        Offset = offset;
        OpCode = opCode;
    }
    
    public ILInstruction(int offset, ILOpCode opCode, object operand)
    {
        Offset = offset;
        OpCode = opCode;
        Operand = operand;
    }
    
    /// <summary>
    /// Para branches, obtém o offset alvo absoluto
    /// </summary>
    public int GetBranchTarget()
    {
        if (!OpCode.IsBranch())
            throw new InvalidOperationException($"{OpCode} is not a branch instruction");
        
        return (int)Operand;
    }
    
    /// <summary>
    /// Para switch, obtém os offsets alvos absolutos
    /// </summary>
    public int[] GetSwitchTargets()
    {
        if (OpCode != ILOpCode.Switch)
            throw new InvalidOperationException($"{OpCode} is not a switch instruction");
        
        return (int[])Operand;
    }
    
    public override string ToString()
    {
        if (Operand == null)
            return $"IL_{Offset:X4}: {OpCode}";
        
        if (OpCode.IsBranch())
            return $"IL_{Offset:X4}: {OpCode} IL_{(int)Operand:X4}";
        
        if (OpCode == ILOpCode.Switch)
        {
            var targets = (int[])Operand;
            var targetsStr = string.Join(", ", targets.Select(t => $"IL_{t:X4}"));
            return $"IL_{Offset:X4}: {OpCode} ({targetsStr})";
        }
        
        return $"IL_{Offset:X4}: {OpCode} {Operand}";
    }
}

/// <summary>
/// Token de metadata (referência a tipo, método, campo, etc.)
/// </summary>
public readonly struct MetadataToken
{
    public readonly uint Value;
    
    public MetadataToken(uint value) => Value = value;
    
    /// <summary>
    /// Tipo do token (TypeDef, TypeRef, MethodDef, etc.)
    /// </summary>
    public MetadataTokenType TokenType => (MetadataTokenType)(Value >> 24);
    
    /// <summary>
    /// Índice na tabela correspondente
    /// </summary>
    public int Index => (int)(Value & 0x00FFFFFF);
    
    public override string ToString() => $"{TokenType}:{Index:X6}";
    
    public static implicit operator uint(MetadataToken token) => token.Value;
    public static implicit operator MetadataToken(uint value) => new(value);
}

/// <summary>
/// Tipos de token de metadata
/// </summary>
public enum MetadataTokenType : byte
{
    Module = 0x00,
    TypeRef = 0x01,
    TypeDef = 0x02,
    FieldDef = 0x04,
    MethodDef = 0x06,
    ParamDef = 0x08,
    InterfaceImpl = 0x09,
    MemberRef = 0x0A,
    CustomAttribute = 0x0C,
    Permission = 0x0E,
    Signature = 0x11,
    Event = 0x14,
    Property = 0x17,
    ModuleRef = 0x1A,
    TypeSpec = 0x1B,
    Assembly = 0x20,
    AssemblyRef = 0x23,
    File = 0x26,
    ExportedType = 0x27,
    ManifestResource = 0x28,
    GenericParam = 0x2A,
    MethodSpec = 0x2B,
    GenericParamConstraint = 0x2C,
    String = 0x70,
}
