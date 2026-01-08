namespace DosNet.Compiler.CodeGen.x86;

/// <summary>
/// Gerencia alocação de registradores x86.
/// </summary>
public class X86RegisterAllocator
{
    // Registradores de propósito geral (32-bit)
    public static readonly string[] GeneralRegisters = { "EAX", "EBX", "ECX", "EDX", "ESI", "EDI" };
    
    // Registradores callee-saved (devem ser preservados)
    public static readonly string[] CalleeSaved = { "EBX", "ESI", "EDI" };
    
    // Registradores caller-saved (podem ser modificados livremente)
    public static readonly string[] CallerSaved = { "EAX", "ECX", "EDX" };
    
    // Registradores de 16-bit
    public static readonly string[] Registers16 = { "AX", "BX", "CX", "DX", "SI", "DI" };
    
    // Registradores de 8-bit (low)
    public static readonly string[] Registers8Low = { "AL", "BL", "CL", "DL" };
    
    // Registradores de 8-bit (high)
    public static readonly string[] Registers8High = { "AH", "BH", "CH", "DH" };
    
    private readonly HashSet<string> _usedRegisters = new();
    private readonly Stack<string> _freeRegisters = new();
    
    public X86RegisterAllocator()
    {
        Reset();
    }
    
    public void Reset()
    {
        _usedRegisters.Clear();
        _freeRegisters.Clear();
        
        // Adicionar registradores disponíveis (exceto EBP e ESP)
        foreach (var reg in CallerSaved.Reverse())
        {
            _freeRegisters.Push(reg);
        }
    }
    
    /// <summary>
    /// Aloca um registrador livre
    /// </summary>
    public string Allocate()
    {
        if (_freeRegisters.Count == 0)
        {
            throw new InvalidOperationException("No free registers available");
        }
        
        var reg = _freeRegisters.Pop();
        _usedRegisters.Add(reg);
        return reg;
    }
    
    /// <summary>
    /// Aloca um registrador específico
    /// </summary>
    public bool TryAllocate(string register, out string allocated)
    {
        var upper = register.ToUpperInvariant();
        if (!_usedRegisters.Contains(upper) && _freeRegisters.Contains(upper))
        {
            var temp = new Stack<string>();
            while (_freeRegisters.Count > 0)
            {
                var r = _freeRegisters.Pop();
                if (r == upper)
                {
                    _usedRegisters.Add(upper);
                    while (temp.Count > 0)
                        _freeRegisters.Push(temp.Pop());
                    allocated = upper;
                    return true;
                }
                temp.Push(r);
            }
            while (temp.Count > 0)
                _freeRegisters.Push(temp.Pop());
        }
        allocated = null;
        return false;
    }
    
    /// <summary>
    /// Libera um registrador
    /// </summary>
    public void Free(string register)
    {
        var upper = register.ToUpperInvariant();
        if (_usedRegisters.Remove(upper))
        {
            _freeRegisters.Push(upper);
        }
    }
    
    /// <summary>
    /// Verifica se um registrador está livre
    /// </summary>
    public bool IsFree(string register)
    {
        return !_usedRegisters.Contains(register.ToUpperInvariant());
    }
    
    /// <summary>
    /// Obtém a versão de 8-bit (low) de um registrador de 32-bit
    /// </summary>
    public static string GetLowByte(string reg32)
    {
        return reg32.ToUpperInvariant() switch
        {
            "EAX" => "AL",
            "EBX" => "BL",
            "ECX" => "CL",
            "EDX" => "DL",
            _ => throw new ArgumentException($"No low byte register for {reg32}")
        };
    }
    
    /// <summary>
    /// Obtém a versão de 16-bit de um registrador de 32-bit
    /// </summary>
    public static string Get16Bit(string reg32)
    {
        return reg32.ToUpperInvariant() switch
        {
            "EAX" => "AX",
            "EBX" => "BX",
            "ECX" => "CX",
            "EDX" => "DX",
            "ESI" => "SI",
            "EDI" => "DI",
            "EBP" => "BP",
            "ESP" => "SP",
            _ => throw new ArgumentException($"Unknown register {reg32}")
        };
    }
    
    /// <summary>
    /// Formata operando de memória
    /// </summary>
    public static string MemoryOperand(string baseReg, int offset = 0)
    {
        if (offset == 0)
            return $"[{baseReg}]";
        if (offset > 0)
            return $"[{baseReg}+{offset}]";
        return $"[{baseReg}{offset}]";
    }
    
    /// <summary>
    /// Formata operando de memória com índice
    /// </summary>
    public static string MemoryOperand(string baseReg, string indexReg, int scale = 1, int offset = 0)
    {
        var scaleStr = scale > 1 ? $"*{scale}" : "";
        var offsetStr = offset != 0 ? (offset > 0 ? $"+{offset}" : offset.ToString()) : "";
        return $"[{baseReg}+{indexReg}{scaleStr}{offsetStr}]";
    }
    
    /// <summary>
    /// Formata operando com tamanho explícito
    /// </summary>
    public static string SizedOperand(string operand, int size)
    {
        var sizeStr = size switch
        {
            1 => "BYTE PTR",
            2 => "WORD PTR",
            4 => "DWORD PTR",
            8 => "QWORD PTR",
            _ => throw new ArgumentException($"Invalid size {size}")
        };
        return $"{sizeStr} {operand}";
    }
}
