using DosNet.Core.Abstractions;
using DosNet.Core.Runtime;

namespace DosNet.Compiler.CodeGen.x86;

/// <summary>
/// Seleciona instruções baseado no nível de CPU.
/// Gera código otimizado para i386, i486 ou i586.
/// </summary>
public class X86InstructionSelector : IInstructionSelector
{
    private readonly CpuLevel _cpuLevel;
    private readonly MasmEmitter _emitter;
    
    public X86InstructionSelector(CpuLevel cpuLevel, MasmEmitter emitter)
    {
        _cpuLevel = cpuLevel;
        _emitter = emitter;
    }
    
    public string SelectInstruction(InstructionOperation operation, params string[] operands)
    {
        return operation switch
        {
            InstructionOperation.ByteSwap => SelectByteSwap(operands[0]),
            InstructionOperation.CompareExchange => SelectCompareExchange(operands[0], operands[1], operands[2]),
            InstructionOperation.ConditionalMove => SelectConditionalMove(operands[0], operands[1], operands[2]),
            InstructionOperation.FloatCompare => SelectFloatCompare(),
            InstructionOperation.ReadTimestamp => SelectReadTimestamp(operands[0], operands[1]),
            InstructionOperation.CpuId => SelectCpuId(),
            _ => throw new NotSupportedException($"Operation {operation} not supported")
        };
    }
    
    public bool IsInstructionAvailable(string instruction)
    {
        var upper = instruction.ToUpperInvariant();
        
        return upper switch
        {
            // i486+ instructions
            "BSWAP" or "CMPXCHG" or "XADD" => _cpuLevel >= CpuLevel.I486,
            
            // i586+ instructions
            "RDTSC" or "CPUID" or "CMPXCHG8B" => _cpuLevel >= CpuLevel.I586,
            
            // i686+ instructions (not supported yet)
            "CMOVA" or "CMOVAE" or "CMOVB" or "CMOVBE" or
            "CMOVE" or "CMOVNE" or "CMOVG" or "CMOVGE" or
            "CMOVL" or "CMOVLE" or "FCOMI" or "FCOMIP" => false,
            
            // All other instructions available on i386+
            _ => true
        };
    }
    
    /// <summary>
    /// Byte swap - BSWAP (i486+) ou ROL sequence (i386)
    /// </summary>
    private string SelectByteSwap(string reg)
    {
        if (_cpuLevel >= CpuLevel.I486)
        {
            return $"BSWAP {reg}";
        }
        
        // i386: usar ROL sequence
        return $@"ROL {reg.Substring(1, 1)}X, 8
ROL {reg}, 16
ROL {reg.Substring(1, 1)}X, 8";
    }
    
    /// <summary>
    /// Compare and exchange - CMPXCHG (i486+) ou CLI/CMP/MOV/STI (i386)
    /// </summary>
    private string SelectCompareExchange(string mem, string expected, string newValue)
    {
        if (_cpuLevel >= CpuLevel.I486)
        {
            return $"LOCK CMPXCHG [{mem}], {newValue}";
        }
        
        // i386: simular (não é realmente atômico, mas OK para DOS single-task)
        return $@"CLI
CMP EAX, [{mem}]
JNE @F
MOV [{mem}], {newValue}
@@:
STI";
    }
    
    /// <summary>
    /// Conditional move - usa branch em i386-i586
    /// </summary>
    private string SelectConditionalMove(string condition, string dest, string src)
    {
        // CMOVcc não disponível até i686, sempre usar branch
        return $@"CMP {dest}, {src}
J{GetInverseCondition(condition)} @F
MOV {dest}, {src}
@@:";
    }
    
    /// <summary>
    /// Float compare - FCOMI (i686+) ou FCOM/FNSTSW/SAHF (i386-i586)
    /// </summary>
    private string SelectFloatCompare()
    {
        // FCOMI não disponível até i686
        return @"FCOM ST(1)
FNSTSW AX
SAHF";
    }
    
    /// <summary>
    /// Read timestamp counter - RDTSC (i586+)
    /// </summary>
    private string SelectReadTimestamp(string highReg, string lowReg)
    {
        if (_cpuLevel >= CpuLevel.I586)
        {
            return $@"RDTSC
MOV {highReg}, EDX
MOV {lowReg}, EAX";
        }
        
        // i386/i486: não disponível, retornar 0
        return $@"XOR {highReg}, {highReg}
XOR {lowReg}, {lowReg}";
    }
    
    /// <summary>
    /// CPUID - disponível em i586+
    /// </summary>
    private string SelectCpuId()
    {
        if (_cpuLevel >= CpuLevel.I586)
        {
            return "CPUID";
        }
        
        // i386/i486: não disponível
        return @"XOR EAX, EAX
XOR EBX, EBX
XOR ECX, ECX
XOR EDX, EDX";
    }
    
    private static string GetInverseCondition(string condition)
    {
        return condition.ToUpperInvariant() switch
        {
            "E" or "Z" => "NE",
            "NE" or "NZ" => "E",
            "L" => "GE",
            "LE" => "G",
            "G" => "LE",
            "GE" => "L",
            "A" => "BE",
            "AE" => "B",
            "B" => "AE",
            "BE" => "A",
            _ => "NE"
        };
    }
    
    /// <summary>
    /// Emite código para multiplicação otimizada
    /// </summary>
    public void EmitMultiply(string dest, string src)
    {
        // IMUL reg, reg disponível em i386+
        _emitter.Imul(dest, src);
    }
    
    /// <summary>
    /// Emite código para divisão
    /// </summary>
    public void EmitDivide(string dividend, string divisor, bool signed = true)
    {
        if (signed)
        {
            _emitter.Cdq(); // Sign extend EAX to EDX:EAX
            _emitter.Idiv(divisor);
        }
        else
        {
            _emitter.Xor("EDX", "EDX");
            _emitter.EmitInstruction("DIV", divisor);
        }
    }
}
