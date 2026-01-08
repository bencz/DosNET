using DosNet.Compiler.Metadata;
using DosNet.Core.IR;
using DosNet.Core.Runtime;
using DosNet.Core.Types;

namespace DosNet.Compiler.CodeGen.x86;

/// <summary>
/// Compila um método individual para x86 assembly.
/// </summary>
public class MethodCompiler
{
    private readonly MasmEmitter _emitter;
    private readonly X86InstructionSelector _selector;
    private readonly X86RegisterAllocator _regAlloc;
    private readonly RuntimeOptions _options;
    private readonly DataSectionGenerator _dataGen;
    
    private MethodDef _currentMethod;
    private int _localLabelCounter;
    
    public MethodCompiler(MasmEmitter emitter, X86InstructionSelector selector, RuntimeOptions options)
        : this(emitter, selector, options, null)
    {
    }
    
    public MethodCompiler(MasmEmitter emitter, X86InstructionSelector selector, RuntimeOptions options, DataSectionGenerator dataGen)
    {
        _emitter = emitter;
        _selector = selector;
        _regAlloc = new X86RegisterAllocator();
        _options = options;
        _dataGen = dataGen;
    }
    
    /// <summary>
    /// Compila um método
    /// </summary>
    public void Compile(MethodDef method)
    {
        _currentMethod = method;
        _localLabelCounter = 0;
        _regAlloc.Reset();
        
        var label = method.GetLabel();
        
        _emitter.EmitComment(method.GetSignature());
        _emitter.EmitProc(label, method.IsPublic);
        
        // Prólogo
        EmitProlog();
        
        // Corpo
        if (method.HasCustomAssembly)
        {
            EmitCustomAssembly();
        }
        else if (method.CFG != null)
        {
            EmitFromCFG();
        }
        else
        {
            _emitter.EmitComment("TODO: IL body not yet processed");
        }
        
        // Epílogo
        EmitEpilog();
        
        _emitter.EmitEndProc(label);
    }
    
    private void EmitProlog()
    {
        _emitter.Push("EBP");
        _emitter.Mov("EBP", "ESP");
        
        // Alocar espaço para variáveis locais
        int localsSize = _currentMethod.GetLocalsSize();
        if (localsSize > 0)
        {
            _emitter.Sub("ESP", localsSize.ToString());
        }
        
        // Salvar registradores callee-saved
        _emitter.Push("EBX");
        _emitter.Push("ESI");
        _emitter.Push("EDI");
    }
    
    private void EmitEpilog()
    {
        _emitter.Pop("EDI");
        _emitter.Pop("ESI");
        _emitter.Pop("EBX");
        _emitter.Mov("ESP", "EBP");
        _emitter.Pop("EBP");
        
        // Retorno baseado na calling convention
        switch (_currentMethod.CallingConvention)
        {
            case CallingConvention.Cdecl:
                _emitter.Ret();
                break;
            case CallingConvention.Stdcall:
                int argsSize = _currentMethod.GetParametersSize();
                if (argsSize > 0)
                    _emitter.Ret(argsSize);
                else
                    _emitter.Ret();
                break;
        }
    }
    
    private void EmitCustomAssembly()
    {
        string asm = _currentMethod.CustomAssembly;
        
        // Verificar se precisa usar soft-float
        if (_currentMethod.UsesX87 && _options.SoftFloatOnly && 
            !string.IsNullOrEmpty(_currentMethod.SoftFloatAssembly))
        {
            asm = _currentMethod.SoftFloatAssembly;
        }
        
        // Substituir placeholders
        asm = SubstitutePlaceholders(asm);
        
        foreach (var line in asm.Split('\n'))
        {
            var trimmed = line.Trim();
            if (!string.IsNullOrEmpty(trimmed))
            {
                _emitter.EmitLine(trimmed);
            }
        }
    }
    
    private string SubstitutePlaceholders(string asm)
    {
        // {THIS} - ponteiro this
        if (!_currentMethod.IsStatic)
        {
            asm = asm.Replace("{THIS}", "[EBP+8]");
        }
        
        // {ARG0}, {ARG1}, etc
        int argOffset = _currentMethod.IsStatic ? 8 : 12;
        for (int i = 0; i < _currentMethod.Parameters.Count; i++)
        {
            asm = asm.Replace($"{{ARG{i}}}", $"[EBP+{argOffset}]");
            argOffset += _currentMethod.Parameters[i].ParameterType?.GetStackSize() ?? 4;
        }
        
        // {LOCAL0}, {LOCAL1}, etc
        int localOffset = -12; // Após EBX, ESI, EDI salvos
        for (int i = 0; i < _currentMethod.Locals.Count; i++)
        {
            asm = asm.Replace($"{{LOCAL{i}}}", $"[EBP{localOffset}]");
            localOffset -= _currentMethod.Locals[i].Type?.GetStackSize() ?? 4;
        }
        
        return asm;
    }
    
    private void EmitFromCFG()
    {
        foreach (var block in _currentMethod.CFG.Blocks)
        {
            _emitter.EmitLabel(block.Label);
            
            foreach (var inst in block.Instructions)
            {
                EmitInstruction(inst);
            }
        }
    }
    
    private void EmitInstruction(IRInstruction inst)
    {
        switch (inst.OpCode)
        {
            case IROpCode.Nop:
                _emitter.Nop();
                break;
                
            case IROpCode.LoadNull:
                _emitter.Push("0");
                break;
                
            case IROpCode.LoadConst:
                EmitLoadConst(inst.Operand);
                break;
                
            case IROpCode.LoadLocal:
                EmitLoadLocal((int)inst.Operand);
                break;
                
            case IROpCode.StoreLocal:
                EmitStoreLocal((int)inst.Operand);
                break;
                
            case IROpCode.LoadArg:
                EmitLoadArg((int)inst.Operand);
                break;
                
            case IROpCode.StoreArg:
                EmitStoreArg((int)inst.Operand);
                break;
                
            case IROpCode.Add:
                EmitBinaryOp("ADD");
                break;
                
            case IROpCode.Sub:
                EmitBinaryOp("SUB");
                break;
                
            case IROpCode.Mul:
                EmitMul();
                break;
                
            case IROpCode.Div:
                EmitDiv(signed: true);
                break;
                
            case IROpCode.DivUn:
                EmitDiv(signed: false);
                break;
                
            case IROpCode.Rem:
                EmitRem(signed: true);
                break;
                
            case IROpCode.RemUn:
                EmitRem(signed: false);
                break;
                
            case IROpCode.And:
                EmitBinaryOp("AND");
                break;
                
            case IROpCode.Or:
                EmitBinaryOp("OR");
                break;
                
            case IROpCode.Xor:
                EmitBinaryOp("XOR");
                break;
                
            case IROpCode.Shl:
                EmitShift("SHL");
                break;
                
            case IROpCode.Shr:
                EmitShift("SAR");
                break;
                
            case IROpCode.ShrUn:
                EmitShift("SHR");
                break;
                
            case IROpCode.Neg:
                _emitter.Pop("EAX");
                _emitter.Neg("EAX");
                _emitter.Push("EAX");
                break;
                
            case IROpCode.Not:
                _emitter.Pop("EAX");
                _emitter.Not("EAX");
                _emitter.Push("EAX");
                break;
                
            case IROpCode.CompareEqual:
                EmitCompare("SETE");
                break;
                
            case IROpCode.CompareNotEqual:
                EmitCompare("SETNE");
                break;
                
            case IROpCode.CompareLessThan:
                EmitCompare("SETL");
                break;
                
            case IROpCode.CompareLessThanUn:
                EmitCompare("SETB");
                break;
                
            case IROpCode.CompareGreaterThan:
                EmitCompare("SETG");
                break;
                
            case IROpCode.CompareGreaterThanUn:
                EmitCompare("SETA");
                break;
                
            case IROpCode.Branch:
                _emitter.Jmp((string)inst.Operand);
                break;
                
            case IROpCode.BranchTrue:
                _emitter.Pop("EAX");
                _emitter.Test("EAX", "EAX");
                _emitter.Jnz((string)inst.Operand);
                break;
                
            case IROpCode.BranchFalse:
                _emitter.Pop("EAX");
                _emitter.Test("EAX", "EAX");
                _emitter.Jz((string)inst.Operand);
                break;
                
            case IROpCode.BranchEqual:
                _emitter.Pop("EBX");
                _emitter.Pop("EAX");
                _emitter.Cmp("EAX", "EBX");
                _emitter.Je((string)inst.Operand);
                break;
                
            case IROpCode.BranchNotEqual:
                _emitter.Pop("EBX");
                _emitter.Pop("EAX");
                _emitter.Cmp("EAX", "EBX");
                _emitter.Jne((string)inst.Operand);
                break;
                
            case IROpCode.BranchLessThan:
                _emitter.Pop("EBX");
                _emitter.Pop("EAX");
                _emitter.Cmp("EAX", "EBX");
                _emitter.Jl((string)inst.Operand);
                break;
                
            case IROpCode.BranchGreaterThan:
                _emitter.Pop("EBX");
                _emitter.Pop("EAX");
                _emitter.Cmp("EAX", "EBX");
                _emitter.Jg((string)inst.Operand);
                break;
                
            case IROpCode.BranchLessOrEqual:
                _emitter.Pop("EBX");
                _emitter.Pop("EAX");
                _emitter.Cmp("EAX", "EBX");
                _emitter.Jle((string)inst.Operand);
                break;
                
            case IROpCode.BranchGreaterOrEqual:
                _emitter.Pop("EBX");
                _emitter.Pop("EAX");
                _emitter.Cmp("EAX", "EBX");
                _emitter.Jge((string)inst.Operand);
                break;
                
            case IROpCode.Call:
                if (inst.Operand is MethodDef callMethod)
                    EmitCall(callMethod);
                else
                    _emitter.EmitComment($"call (unresolved token)");
                break;
                
            case IROpCode.CallVirtual:
                if (inst.Operand is MethodDef callVirtMethod)
                    EmitCallVirtual(callVirtMethod);
                else
                    _emitter.EmitComment($"callvirt (unresolved token)");
                break;
                
            case IROpCode.Return:
                // Se o método retorna um valor, ele está no topo da pilha
                // Precisamos colocá-lo em EAX antes do epílogo
                if (_currentMethod.ReturnType != null && _currentMethod.ReturnType.Name != "Void")
                {
                    _emitter.Pop("EAX");
                }
                break;
                
            case IROpCode.NewObj:
                if (inst.Operand is MethodDef ctor)
                    EmitNewObj(ctor);
                else if (inst.Operand is TypeDef newObjType)
                    EmitNewObj(newObjType);
                else
                    _emitter.EmitComment($"newobj (unresolved token)");
                break;
                
            case IROpCode.LoadField:
                if (inst.Operand is FieldDef loadField)
                    EmitLoadField(loadField);
                else
                    _emitter.EmitComment($"ldfld (unresolved token)");
                break;
                
            case IROpCode.StoreField:
                if (inst.Operand is FieldDef storeField)
                    EmitStoreField(storeField);
                else
                    _emitter.EmitComment($"stfld (unresolved token)");
                break;
                
            case IROpCode.LoadStaticField:
                if (inst.Operand is FieldDef loadStaticField)
                    EmitLoadStaticField(loadStaticField);
                else
                    _emitter.EmitComment($"ldsfld (unresolved token)");
                break;
                
            case IROpCode.StoreStaticField:
                if (inst.Operand is FieldDef storeStaticField)
                    EmitStoreStaticField(storeStaticField);
                else
                    _emitter.EmitComment($"stsfld (unresolved token)");
                break;
                
            case IROpCode.Dup:
                _emitter.Push("DWORD PTR [ESP]");
                break;
                
            case IROpCode.Pop:
                _emitter.Add("ESP", "4");
                break;
                
            // Arrays
            case IROpCode.NewArray:
                EmitNewArray(inst.Operand as TypeDef);
                break;
                
            case IROpCode.LoadArrayLength:
            case IROpCode.LoadLength:
                _emitter.Pop("EAX");
                _emitter.Push("DWORD PTR [EAX+4]"); // Length está em offset 4 após VTable
                break;
                
            case IROpCode.LoadElement:
                EmitLoadElement();
                break;
                
            case IROpCode.StoreElement:
                EmitStoreElement();
                break;
                
            // Boxing
            case IROpCode.Box:
                EmitBox(inst.Operand as TypeDef);
                break;
                
            case IROpCode.Unbox:
            case IROpCode.UnboxAny:
                EmitUnbox(inst.Operand as TypeDef);
                break;
                
            // Type checks
            case IROpCode.IsInstance:
                EmitIsInstance(inst.Operand as TypeDef);
                break;
                
            case IROpCode.CastClass:
                EmitCastClass(inst.Operand as TypeDef);
                break;
                
            // Exceptions
            case IROpCode.Throw:
                _emitter.Pop("EAX");
                _emitter.Call("__throw_exception");
                break;
                
            case IROpCode.Rethrow:
                _emitter.Call("__rethrow_exception");
                break;
                
            case IROpCode.Leave:
                _emitter.Jmp((string)inst.Operand);
                break;
                
            case IROpCode.EndFinally:
                _emitter.EmitComment("endfinally");
                break;
                
            // Indirect memory access
            case IROpCode.LoadIndirect:
                _emitter.Pop("EAX");
                _emitter.Push("DWORD PTR [EAX]");
                break;
                
            case IROpCode.StoreIndirect:
                _emitter.Pop("EBX"); // value
                _emitter.Pop("EAX"); // address
                _emitter.Mov("[EAX]", "EBX");
                break;
                
            // Field addresses
            case IROpCode.LoadFieldAddress:
                if (inst.Operand is FieldDef fieldAddr)
                    EmitLoadFieldAddress(fieldAddr);
                else
                    _emitter.EmitComment("ldflda (unresolved)");
                break;
                
            case IROpCode.LoadStaticFieldAddress:
                if (inst.Operand is FieldDef staticFieldAddr)
                    EmitLoadStaticFieldAddress(staticFieldAddr);
                else
                    _emitter.EmitComment("ldsflda (unresolved)");
                break;
                
            case IROpCode.LoadString:
                EmitLoadString(inst.Operand as string);
                break;
                
            // Conversões
            case IROpCode.ConvertI1:
                _emitter.Pop("EAX");
                _emitter.EmitInstruction("MOVSX", "EAX, AL");
                _emitter.Push("EAX");
                break;
                
            case IROpCode.ConvertI2:
                _emitter.Pop("EAX");
                _emitter.EmitInstruction("MOVSX", "EAX, AX");
                _emitter.Push("EAX");
                break;
                
            case IROpCode.ConvertI4:
            case IROpCode.ConvertIPtr:
                // Já é 32-bit, nada a fazer
                break;
                
            case IROpCode.ConvertU1:
                _emitter.Pop("EAX");
                _emitter.EmitInstruction("MOVZX", "EAX, AL");
                _emitter.Push("EAX");
                break;
                
            case IROpCode.ConvertU2:
                _emitter.Pop("EAX");
                _emitter.EmitInstruction("MOVZX", "EAX, AX");
                _emitter.Push("EAX");
                break;
                
            case IROpCode.ConvertU4:
            case IROpCode.ConvertUPtr:
                // Já é 32-bit, nada a fazer
                break;
                
            default:
                _emitter.EmitComment($"TODO: {inst.OpCode}");
                break;
        }
    }
    
    private void EmitLoadConst(object value)
    {
        switch (value)
        {
            case int i:
                _emitter.Push(i.ToString());
                break;
            case long l:
                _emitter.Push(((int)(l >> 32)).ToString());
                _emitter.Push(((int)(l & 0xFFFFFFFF)).ToString());
                break;
            case float f:
                var floatBits = BitConverter.SingleToInt32Bits(f);
                _emitter.Push(floatBits.ToString());
                break;
            case double d:
                var doubleBits = BitConverter.DoubleToInt64Bits(d);
                _emitter.Push(((int)(doubleBits >> 32)).ToString());
                _emitter.Push(((int)(doubleBits & 0xFFFFFFFF)).ToString());
                break;
            case null:
                _emitter.Push("0");
                break;
            default:
                _emitter.Push(value.ToString());
                break;
        }
    }
    
    private void EmitLoadLocal(int index)
    {
        int offset = CalculateLocalOffset(index);
        _emitter.Push($"DWORD PTR [EBP{offset}]");
    }
    
    private void EmitStoreLocal(int index)
    {
        int offset = CalculateLocalOffset(index);
        _emitter.Pop("EAX");
        _emitter.Mov($"[EBP{offset}]", "EAX");
    }
    
    private void EmitLoadArg(int index)
    {
        int offset = CalculateArgOffset(index);
        _emitter.Push($"DWORD PTR [EBP+{offset}]");
    }
    
    private void EmitStoreArg(int index)
    {
        int offset = CalculateArgOffset(index);
        _emitter.Pop("EAX");
        _emitter.Mov($"[EBP+{offset}]", "EAX");
    }
    
    private int CalculateLocalOffset(int index)
    {
        int offset = -12; // Após EBX, ESI, EDI salvos
        for (int i = 0; i < index; i++)
        {
            offset -= _currentMethod.Locals[i].Type?.GetStackSize() ?? 4;
        }
        return offset;
    }
    
    private int CalculateArgOffset(int index)
    {
        int offset = 8; // Após EBP salvo e return address
        if (!_currentMethod.IsStatic)
        {
            if (index == 0) return offset; // this
            offset += 4;
            index--;
        }
        for (int i = 0; i < index; i++)
        {
            offset += _currentMethod.Parameters[i].ParameterType?.GetStackSize() ?? 4;
        }
        return offset;
    }
    
    private void EmitBinaryOp(string op)
    {
        _emitter.Pop("EBX");
        _emitter.Pop("EAX");
        _emitter.EmitInstruction(op, "EAX", "EBX");
        _emitter.Push("EAX");
    }
    
    private void EmitMul()
    {
        _emitter.Pop("EBX");
        _emitter.Pop("EAX");
        _emitter.Imul("EAX", "EBX");
        _emitter.Push("EAX");
    }
    
    private void EmitDiv(bool signed)
    {
        _emitter.Pop("EBX");
        _emitter.Pop("EAX");
        if (signed)
        {
            _emitter.Cdq();
            _emitter.Idiv("EBX");
        }
        else
        {
            _emitter.Xor("EDX", "EDX");
            _emitter.EmitInstruction("DIV", "EBX");
        }
        _emitter.Push("EAX");
    }
    
    private void EmitRem(bool signed)
    {
        _emitter.Pop("EBX");
        _emitter.Pop("EAX");
        if (signed)
        {
            _emitter.Cdq();
            _emitter.Idiv("EBX");
        }
        else
        {
            _emitter.Xor("EDX", "EDX");
            _emitter.EmitInstruction("DIV", "EBX");
        }
        _emitter.Push("EDX"); // Remainder in EDX
    }
    
    private void EmitShift(string op)
    {
        _emitter.Pop("ECX");
        _emitter.Pop("EAX");
        _emitter.EmitInstruction(op, "EAX", "CL");
        _emitter.Push("EAX");
    }
    
    private void EmitCompare(string setInstr)
    {
        _emitter.Pop("EBX");
        _emitter.Pop("EAX");
        _emitter.Cmp("EAX", "EBX");
        _emitter.EmitInstruction(setInstr, "AL");
        _emitter.Movzx("EAX", "AL");
        _emitter.Push("EAX");
    }
    
    private void EmitCall(MethodDef method)
    {
        if (method == null)
        {
            _emitter.EmitComment("call (unresolved method)");
            return;
        }
        
        _emitter.Call(method.GetLabel());
        
        // Limpar argumentos da pilha (cdecl)
        if (method.CallingConvention == CallingConvention.Cdecl)
        {
            int argsSize = method.GetParametersSize();
            if (argsSize > 0)
            {
                _emitter.Add("ESP", argsSize.ToString());
            }
        }
        
        // Push resultado se não void
        if (method.ReturnType != null && method.ReturnType.Name != "Void")
        {
            _emitter.Push("EAX");
        }
    }
    
    private void EmitCallVirtual(MethodDef method)
    {
        if (method == null)
        {
            _emitter.EmitComment("callvirt (unresolved method)");
            return;
        }
        
        // Se o método não é virtual ou não tem VTableSlot válido, fazer chamada direta
        if (!method.IsVirtual || method.VTableSlot < 0)
        {
            // Chamada direta (não virtual)
            _emitter.Call(method.GetLabel());
            
            // Limpar argumentos (incluindo this)
            int argsSize = method.GetParametersSize() + 4; // +4 para this
            if (argsSize > 0)
            {
                _emitter.Add("ESP", argsSize.ToString());
            }
            
            // Push resultado
            if (method.ReturnType != null && method.ReturnType.Name != "Void")
            {
                _emitter.Push("EAX");
            }
            return;
        }
        
        // Carregar this
        _emitter.Mov("ESI", "[ESP]");
        // Carregar VTable
        _emitter.Mov("EAX", "[ESI]");
        // Chamar método via VTable
        int slot = method.VTableSlot;
        _emitter.Call($"DWORD PTR [EAX+{slot * 4}]");
        
        // Limpar argumentos
        int argsSize2 = method.GetParametersSize();
        if (argsSize2 > 0)
        {
            _emitter.Add("ESP", argsSize2.ToString());
        }
        
        // Push resultado
        if (method.ReturnType != null && method.ReturnType.Name != "Void")
        {
            _emitter.Push("EAX");
        }
    }
    
    private void EmitNewObj(MethodDef ctor)
    {
        if (ctor == null || ctor.DeclaringType == null)
        {
            _emitter.EmitComment("newobj (unresolved constructor)");
            _emitter.Push("0");
            return;
        }
        
        var type = ctor.DeclaringType;
        _emitter.EmitComment($"newobj {type.FullName}::{ctor.Name}");
        
        // Alocar objeto
        _emitter.Mov("EAX", type.InstanceSize.ToString());
        _emitter.Mov("EBX", type.TypeIndex.ToString());
        _emitter.Call("__gc_alloc_typed");
        _emitter.Test("EAX", "EAX");
        _emitter.Jz("__throw_out_of_memory");
        
        // Inicializar VTable
        _emitter.Mov($"DWORD PTR [EAX]", $"OFFSET {type.VTableLabel}");
        
        // Salvar ponteiro do objeto
        _emitter.Push("EAX");
        
        // Chamar construtor (this já está na pilha)
        // Os argumentos do construtor já devem estar na pilha antes do newobj
        _emitter.Call(ctor.GetLabel());
        
        // Limpar argumentos do construtor (exceto this que fica)
        int argsSize = ctor.GetParametersSize();
        if (argsSize > 0)
        {
            _emitter.Add("ESP", argsSize.ToString());
        }
        
        // O ponteiro do objeto permanece no topo da pilha
    }
    
    private void EmitNewObj(TypeDef type)
    {
        if (type == null)
        {
            _emitter.EmitComment("newobj (unresolved type)");
            _emitter.Push("0");
            return;
        }
        
        _emitter.EmitComment($"newobj {type.FullName}");
        _emitter.Mov("EAX", type.InstanceSize.ToString());
        _emitter.Mov("EBX", type.TypeIndex.ToString());
        _emitter.Call("__gc_alloc_typed");
        _emitter.Test("EAX", "EAX");
        _emitter.Jz("__throw_out_of_memory");
        
        // Inicializar VTable
        _emitter.Mov($"DWORD PTR [EAX]", $"OFFSET {type.VTableLabel}");
        
        _emitter.Push("EAX");
    }
    
    private void EmitLoadField(FieldDef field)
    {
        if (field == null)
        {
            _emitter.EmitComment("ldfld (unresolved field)");
            _emitter.Pop("ESI");
            _emitter.Push("0");
            return;
        }
        _emitter.Pop("ESI");
        _emitter.Push($"DWORD PTR [ESI+{field.Offset}]");
    }
    
    private void EmitStoreField(FieldDef field)
    {
        if (field == null)
        {
            _emitter.EmitComment("stfld (unresolved field)");
            _emitter.Pop("EAX");
            _emitter.Pop("ESI");
            return;
        }
        _emitter.Pop("EAX");
        _emitter.Pop("ESI");
        _emitter.Mov($"[ESI+{field.Offset}]", "EAX");
    }
    
    private void EmitLoadStaticField(FieldDef field)
    {
        if (field == null)
        {
            _emitter.EmitComment("ldsfld (unresolved field)");
            _emitter.Push("0");
            return;
        }
        _emitter.Push($"DWORD PTR [{field.GetStaticLabel()}]");
    }
    
    private void EmitStoreStaticField(FieldDef field)
    {
        if (field == null)
        {
            _emitter.EmitComment("stsfld (unresolved field)");
            _emitter.Pop("EAX");
            return;
        }
        _emitter.Pop("EAX");
        _emitter.Mov($"[{field.GetStaticLabel()}]", "EAX");
    }
    
    private string GenerateLocalLabel()
    {
        return $"@@L{_localLabelCounter++}";
    }
    
    private void EmitNewArray(TypeDef elementType)
    {
        // Stack: [length] -> [array ref]
        _emitter.Pop("ECX"); // length
        
        // Calcular tamanho: header(8) + length(4) + elements(length * elementSize)
        int elementSize = elementType?.GetStackSize() ?? 4;
        _emitter.Mov("EAX", "ECX");
        if (elementSize != 1)
        {
            _emitter.EmitInstruction("IMUL", $"EAX, {elementSize}");
        }
        _emitter.Add("EAX", "12"); // header + length field
        
        // Alocar
        _emitter.Push("ECX"); // salvar length
        _emitter.Call("__gc_alloc");
        _emitter.Pop("ECX");
        
        _emitter.Test("EAX", "EAX");
        _emitter.Jz("__throw_out_of_memory");
        
        // Inicializar: VTable, length
        _emitter.Mov("DWORD PTR [EAX]", "OFFSET __vtbl_System_Array");
        _emitter.Mov("[EAX+4]", "ECX"); // length
        
        _emitter.Push("EAX");
    }
    
    private void EmitLoadElement()
    {
        // Stack: [array, index] -> [element]
        _emitter.Pop("ECX"); // index
        _emitter.Pop("ESI"); // array
        
        // Calcular offset: 8 (header) + index * 4
        _emitter.EmitInstruction("LEA", "EAX, [ESI + ECX*4 + 8]");
        _emitter.Push("DWORD PTR [EAX]");
    }
    
    private void EmitStoreElement()
    {
        // Stack: [array, index, value] -> []
        _emitter.Pop("EBX"); // value
        _emitter.Pop("ECX"); // index
        _emitter.Pop("ESI"); // array
        
        // Calcular offset: 8 (header) + index * 4
        _emitter.EmitInstruction("LEA", "EAX, [ESI + ECX*4 + 8]");
        _emitter.Mov("[EAX]", "EBX");
    }
    
    private void EmitBox(TypeDef type)
    {
        if (type == null)
        {
            _emitter.EmitComment("box (unresolved type)");
            return;
        }
        
        // Stack: [value] -> [boxed ref]
        int size = type.GetStackSize();
        
        // Alocar objeto boxed
        _emitter.Mov("EAX", (size + 4).ToString()); // VTable + value
        _emitter.Mov("EBX", type.TypeIndex.ToString());
        _emitter.Call("__gc_alloc_typed");
        _emitter.Test("EAX", "EAX");
        _emitter.Jz("__throw_out_of_memory");
        
        // Inicializar VTable
        _emitter.Mov($"DWORD PTR [EAX]", $"OFFSET {type.VTableLabel}");
        
        // Copiar valor
        _emitter.Pop("EBX");
        _emitter.Mov("[EAX+4]", "EBX");
        
        _emitter.Push("EAX");
    }
    
    private void EmitUnbox(TypeDef type)
    {
        if (type == null)
        {
            _emitter.EmitComment("unbox (unresolved type)");
            return;
        }
        
        // Stack: [boxed ref] -> [value]
        _emitter.Pop("EAX");
        _emitter.Push("DWORD PTR [EAX+4]"); // valor está após VTable
    }
    
    private void EmitIsInstance(TypeDef type)
    {
        if (type == null)
        {
            _emitter.EmitComment("isinst (unresolved type)");
            _emitter.Pop("EAX");
            _emitter.Push("0");
            return;
        }
        
        // Stack: [obj] -> [obj or null]
        _emitter.Pop("EAX");
        _emitter.Test("EAX", "EAX");
        var labelNull = GenerateLocalLabel();
        var labelDone = GenerateLocalLabel();
        _emitter.Jz(labelNull);
        
        // Verificar tipo via VTable
        _emitter.Mov("EBX", "[EAX]"); // VTable
        _emitter.Cmp("EBX", $"OFFSET {type.VTableLabel}");
        _emitter.Je(labelDone);
        
        // TODO: verificar hierarquia de tipos
        _emitter.Xor("EAX", "EAX"); // null se não é instância
        
        _emitter.EmitLabel(labelNull);
        _emitter.EmitLabel(labelDone);
        _emitter.Push("EAX");
    }
    
    private void EmitCastClass(TypeDef type)
    {
        if (type == null)
        {
            _emitter.EmitComment("castclass (unresolved type)");
            return;
        }
        
        // Stack: [obj] -> [obj]
        // Se cast falhar, lança exceção
        _emitter.Pop("EAX");
        _emitter.Test("EAX", "EAX");
        var labelOk = GenerateLocalLabel();
        _emitter.Jz(labelOk); // null é válido
        
        // Verificar tipo
        _emitter.Mov("EBX", "[EAX]");
        _emitter.Cmp("EBX", $"OFFSET {type.VTableLabel}");
        _emitter.Je(labelOk);
        
        // TODO: verificar hierarquia
        _emitter.Call("__throw_invalid_cast");
        
        _emitter.EmitLabel(labelOk);
        _emitter.Push("EAX");
    }
    
    private void EmitLoadFieldAddress(FieldDef field)
    {
        // Stack: [obj] -> [field address]
        _emitter.Pop("ESI");
        _emitter.EmitInstruction("LEA", $"EAX, [ESI+{field.Offset}]");
        _emitter.Push("EAX");
    }
    
    private void EmitLoadStaticFieldAddress(FieldDef field)
    {
        // Stack: [] -> [field address]
        _emitter.EmitInstruction("LEA", $"EAX, [{field.GetStaticLabel()}]");
        _emitter.Push("EAX");
    }
    
    private void EmitLoadString(string value)
    {
        if (value == null)
        {
            _emitter.Push("0");
            return;
        }
        
        // Registrar string no DataSectionGenerator e obter label
        string label;
        if (_dataGen != null)
        {
            label = _dataGen.RegisterString(value);
        }
        else
        {
            // Fallback - criar label baseado no hash
            label = $"__str_{value.GetHashCode():X8}";
        }
        
        _emitter.Push($"OFFSET {label}");
    }
}
