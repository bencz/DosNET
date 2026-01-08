using System.Text;
using DosNet.Core.Runtime;

namespace DosNet.Compiler.CodeGen.x86;

/// <summary>
/// Emite instruções no formato MASM.
/// Responsável pela formatação correta da sintaxe assembly.
/// </summary>
public class MasmEmitter
{
    private readonly StringBuilder _output;
    private int _indentLevel;
    private const string IndentString = "    ";
    
    public MasmEmitter()
    {
        _output = new StringBuilder();
    }
    
    public void Indent() => _indentLevel++;
    public void Unindent() => _indentLevel = Math.Max(0, _indentLevel - 1);
    
    private string GetIndent() => string.Concat(Enumerable.Repeat(IndentString, _indentLevel));
    
    public void EmitLine(string line = "")
    {
        if (string.IsNullOrEmpty(line))
            _output.AppendLine();
        else
            _output.AppendLine($"{GetIndent()}{line}");
    }
    
    public void EmitComment(string comment)
    {
        EmitLine($"; {comment}");
    }
    
    public void EmitSectionHeader(string title)
    {
        EmitLine($"; {new string('=', 60)}");
        EmitLine($"; {title}");
        EmitLine($"; {new string('=', 60)}");
    }
    
    public void EmitLabel(string label)
    {
        _output.AppendLine($"{label}:");
    }
    
    public void EmitPublicLabel(string label)
    {
        EmitLine($"PUBLIC {label}");
        _output.AppendLine($"{label}:");
    }
    
    public void EmitProc(string name, bool isPublic = false)
    {
        if (isPublic)
            EmitLine($"PUBLIC {name}");
        _output.AppendLine($"{name} PROC");
        Indent();
    }
    
    public void EmitEndProc(string name)
    {
        Unindent();
        _output.AppendLine($"{name} ENDP");
        EmitLine();
    }
    
    public void EmitInstruction(string mnemonic)
    {
        EmitLine(mnemonic);
    }
    
    public void EmitInstruction(string mnemonic, string operand)
    {
        EmitLine($"{mnemonic} {operand}");
    }
    
    public void EmitInstruction(string mnemonic, string dest, string src)
    {
        EmitLine($"{mnemonic} {dest}, {src}");
    }
    
    public void EmitInstruction(string mnemonic, string dest, string src1, string src2)
    {
        EmitLine($"{mnemonic} {dest}, {src1}, {src2}");
    }
    
    // Instruções comuns
    public void Mov(string dest, string src) => EmitInstruction("MOV", dest, src);
    public void Push(string operand) => EmitInstruction("PUSH", operand);
    public void Pop(string operand) => EmitInstruction("POP", operand);
    public void Add(string dest, string src) => EmitInstruction("ADD", dest, src);
    public void Sub(string dest, string src) => EmitInstruction("SUB", dest, src);
    public void Imul(string dest, string src) => EmitInstruction("IMUL", dest, src);
    public void Idiv(string operand) => EmitInstruction("IDIV", operand);
    public void And(string dest, string src) => EmitInstruction("AND", dest, src);
    public void Or(string dest, string src) => EmitInstruction("OR", dest, src);
    public void Xor(string dest, string src) => EmitInstruction("XOR", dest, src);
    public void Not(string operand) => EmitInstruction("NOT", operand);
    public void Neg(string operand) => EmitInstruction("NEG", operand);
    public void Shl(string dest, string count) => EmitInstruction("SHL", dest, count);
    public void Shr(string dest, string count) => EmitInstruction("SHR", dest, count);
    public void Sar(string dest, string count) => EmitInstruction("SAR", dest, count);
    public void Cmp(string left, string right) => EmitInstruction("CMP", left, right);
    public void Test(string left, string right) => EmitInstruction("TEST", left, right);
    public void Jmp(string label) => EmitInstruction("JMP", label);
    public void Je(string label) => EmitInstruction("JE", label);
    public void Jne(string label) => EmitInstruction("JNE", label);
    public void Jz(string label) => EmitInstruction("JZ", label);
    public void Jnz(string label) => EmitInstruction("JNZ", label);
    public void Jl(string label) => EmitInstruction("JL", label);
    public void Jle(string label) => EmitInstruction("JLE", label);
    public void Jg(string label) => EmitInstruction("JG", label);
    public void Jge(string label) => EmitInstruction("JGE", label);
    public void Ja(string label) => EmitInstruction("JA", label);
    public void Jae(string label) => EmitInstruction("JAE", label);
    public void Jb(string label) => EmitInstruction("JB", label);
    public void Jbe(string label) => EmitInstruction("JBE", label);
    public void Call(string target) => EmitInstruction("CALL", target);
    public void Ret() => EmitInstruction("RET");
    public void Ret(int bytes) => EmitInstruction("RET", bytes.ToString());
    public void Lea(string dest, string src) => EmitInstruction("LEA", dest, src);
    public void Movzx(string dest, string src) => EmitInstruction("MOVZX", dest, src);
    public void Movsx(string dest, string src) => EmitInstruction("MOVSX", dest, src);
    public void Cdq() => EmitInstruction("CDQ");
    public void Nop() => EmitInstruction("NOP");
    
    // Set byte on condition
    public void Sete(string dest) => EmitInstruction("SETE", dest);
    public void Setne(string dest) => EmitInstruction("SETNE", dest);
    public void Setl(string dest) => EmitInstruction("SETL", dest);
    public void Setle(string dest) => EmitInstruction("SETLE", dest);
    public void Setg(string dest) => EmitInstruction("SETG", dest);
    public void Setge(string dest) => EmitInstruction("SETGE", dest);
    public void Seta(string dest) => EmitInstruction("SETA", dest);
    public void Setb(string dest) => EmitInstruction("SETB", dest);
    
    // Diretivas de dados
    public void EmitData(string label, string directive, string value)
    {
        _output.AppendLine($"{GetIndent()}{label,-20} {directive} {value}");
    }
    
    public void EmitDb(string label, string value) => EmitData(label, "DB", value);
    public void EmitDw(string label, string value) => EmitData(label, "DW", value);
    public void EmitDd(string label, string value) => EmitData(label, "DD", value);
    public void EmitDq(string label, string value) => EmitData(label, "DQ", value);
    
    public void EmitStringLiteral(string label, string value)
    {
        var escaped = EscapeString(value);
        EmitData(label, "DB", $"'{escaped}', 0");
    }
    
    private static string EscapeString(string value)
    {
        var sb = new StringBuilder();
        foreach (var c in value)
        {
            switch (c)
            {
                case '\'': sb.Append("', 27h, '"); break;
                case '\r': sb.Append("', 0Dh, '"); break;
                case '\n': sb.Append("', 0Ah, '"); break;
                case '\t': sb.Append("', 09h, '"); break;
                case '\0': sb.Append("', 00h, '"); break;
                default: sb.Append(c); break;
            }
        }
        return sb.ToString();
    }
    
    // Diretivas de segmento
    public void EmitDirective(string directive) => _output.AppendLine(directive);
    public void EmitCpuDirective(CpuLevel level)
    {
        var directive = level switch
        {
            CpuLevel.I386 => ".386",
            CpuLevel.I486 => ".486",
            CpuLevel.I586 => ".586",
            _ => ".386"
        };
        EmitDirective(directive);
    }
    public void EmitModelFlat() => EmitDirective(".MODEL FLAT, C");
    public void EmitDataSegment() => EmitDirective(".DATA");
    public void EmitBssSegment() => EmitDirective(".DATA?");
    public void EmitCodeSegment() => EmitDirective(".CODE");
    public void EmitEnd(string entryPoint) => EmitDirective($"END {entryPoint}");
    
    public override string ToString() => _output.ToString();
    public void Clear() => _output.Clear();
}
