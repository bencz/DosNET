using DosNet.Core.IR;
using DosNet.Core.Types;

namespace DosNet.Compiler.IL;

/// <summary>
/// Converte instruções IL para IR (Intermediate Representation).
/// </summary>
public class ILToIRConverter
{
    private readonly MethodDef _method;
    private readonly List<ILInstruction> _ilInstructions;
    private readonly AssemblyReader _reader;
    private readonly Dictionary<int, BasicBlock> _blocksByOffset;
    private BasicBlock _currentBlock;
    private int _blockCounter = 0;
    
    public ILToIRConverter(MethodDef method, List<ILInstruction> ilInstructions, AssemblyReader reader = null)
    {
        _method = method;
        _ilInstructions = ilInstructions;
        _reader = reader;
        _blocksByOffset = new Dictionary<int, BasicBlock>();
    }
    
    public ControlFlowGraph Convert()
    {
        if (_ilInstructions.Count == 0)
            return null;
        
        // Fase 1: Identificar líderes de blocos básicos
        var leaders = IdentifyBlockLeaders();
        
        // Fase 2: Criar blocos básicos
        CreateBasicBlocks(leaders);
        
        // Fase 3: Converter instruções IL para IR
        ConvertInstructions();
        
        // Fase 4: Construir CFG
        var cfg = BuildCFG();
        
        return cfg;
    }
    
    private HashSet<int> IdentifyBlockLeaders()
    {
        var leaders = new HashSet<int> { 0 };
        
        foreach (var inst in _ilInstructions)
        {
            if (inst.OpCode.IsBranch())
            {
                leaders.Add(inst.GetBranchTarget());
                leaders.Add(inst.NextOffset);
            }
            else if (inst.OpCode == ILOpCode.Switch)
            {
                foreach (var target in inst.GetSwitchTargets())
                {
                    leaders.Add(target);
                }
                leaders.Add(inst.NextOffset);
            }
            else if (inst.OpCode == ILOpCode.Ret || inst.OpCode == ILOpCode.Throw)
            {
                leaders.Add(inst.NextOffset);
            }
        }
        
        return leaders;
    }
    
    private void CreateBasicBlocks(HashSet<int> leaders)
    {
        // Criar prefixo único baseado no nome do método
        var methodPrefix = _method?.GetLabel()?.Replace("__", "") ?? $"M{_blockCounter}";
        
        foreach (var offset in leaders.OrderBy(o => o))
        {
            if (offset < _ilInstructions.Last().NextOffset)
            {
                var block = new BasicBlock(_blockCounter++)
                {
                    // Label único: inclui prefixo do método para evitar duplicação
                    Label = $"L_{methodPrefix}_{offset:X4}",
                    StartOffset = offset
                };
                _blocksByOffset[offset] = block;
            }
        }
    }
    
    private void ConvertInstructions()
    {
        foreach (var inst in _ilInstructions)
        {
            if (_blocksByOffset.TryGetValue(inst.Offset, out var block))
            {
                _currentBlock = block;
            }
            
            if (_currentBlock == null)
                continue;
            
            var irInst = ConvertInstruction(inst);
            if (irInst != null)
            {
                _currentBlock.Instructions.Add(irInst);
            }
        }
    }
    
    private IRInstruction ConvertInstruction(ILInstruction il)
    {
        return il.OpCode switch
        {
            ILOpCode.Nop => new IRInstruction(IROpCode.Nop),
            
            // Load constants
            ILOpCode.Ldc_I4_M1 => new IRInstruction(IROpCode.LoadConst, -1),
            ILOpCode.Ldc_I4_0 => new IRInstruction(IROpCode.LoadConst, 0),
            ILOpCode.Ldc_I4_1 => new IRInstruction(IROpCode.LoadConst, 1),
            ILOpCode.Ldc_I4_2 => new IRInstruction(IROpCode.LoadConst, 2),
            ILOpCode.Ldc_I4_3 => new IRInstruction(IROpCode.LoadConst, 3),
            ILOpCode.Ldc_I4_4 => new IRInstruction(IROpCode.LoadConst, 4),
            ILOpCode.Ldc_I4_5 => new IRInstruction(IROpCode.LoadConst, 5),
            ILOpCode.Ldc_I4_6 => new IRInstruction(IROpCode.LoadConst, 6),
            ILOpCode.Ldc_I4_7 => new IRInstruction(IROpCode.LoadConst, 7),
            ILOpCode.Ldc_I4_8 => new IRInstruction(IROpCode.LoadConst, 8),
            ILOpCode.Ldc_I4_S => new IRInstruction(IROpCode.LoadConst, (int)(sbyte)il.Operand),
            ILOpCode.Ldc_I4 => new IRInstruction(IROpCode.LoadConst, il.Operand),
            ILOpCode.Ldc_I8 => new IRInstruction(IROpCode.LoadConst, il.Operand),
            ILOpCode.Ldc_R4 => new IRInstruction(IROpCode.LoadConst, il.Operand),
            ILOpCode.Ldc_R8 => new IRInstruction(IROpCode.LoadConst, il.Operand),
            ILOpCode.Ldnull => new IRInstruction(IROpCode.LoadNull),
            
            // Load/store locals
            ILOpCode.Ldloc_0 => new IRInstruction(IROpCode.LoadLocal, 0),
            ILOpCode.Ldloc_1 => new IRInstruction(IROpCode.LoadLocal, 1),
            ILOpCode.Ldloc_2 => new IRInstruction(IROpCode.LoadLocal, 2),
            ILOpCode.Ldloc_3 => new IRInstruction(IROpCode.LoadLocal, 3),
            ILOpCode.Ldloc_S or ILOpCode.Ldloc => new IRInstruction(IROpCode.LoadLocal, il.Operand),
            ILOpCode.Stloc_0 => new IRInstruction(IROpCode.StoreLocal, 0),
            ILOpCode.Stloc_1 => new IRInstruction(IROpCode.StoreLocal, 1),
            ILOpCode.Stloc_2 => new IRInstruction(IROpCode.StoreLocal, 2),
            ILOpCode.Stloc_3 => new IRInstruction(IROpCode.StoreLocal, 3),
            ILOpCode.Stloc_S or ILOpCode.Stloc => new IRInstruction(IROpCode.StoreLocal, il.Operand),
            
            // Load/store args
            ILOpCode.Ldarg_0 => new IRInstruction(IROpCode.LoadArg, 0),
            ILOpCode.Ldarg_1 => new IRInstruction(IROpCode.LoadArg, 1),
            ILOpCode.Ldarg_2 => new IRInstruction(IROpCode.LoadArg, 2),
            ILOpCode.Ldarg_3 => new IRInstruction(IROpCode.LoadArg, 3),
            ILOpCode.Ldarg_S or ILOpCode.Ldarg => new IRInstruction(IROpCode.LoadArg, il.Operand),
            ILOpCode.Starg_S or ILOpCode.Starg => new IRInstruction(IROpCode.StoreArg, il.Operand),
            
            // Arithmetic
            ILOpCode.Add => new IRInstruction(IROpCode.Add),
            ILOpCode.Sub => new IRInstruction(IROpCode.Sub),
            ILOpCode.Mul => new IRInstruction(IROpCode.Mul),
            ILOpCode.Div => new IRInstruction(IROpCode.Div),
            ILOpCode.Div_Un => new IRInstruction(IROpCode.DivUn),
            ILOpCode.Rem => new IRInstruction(IROpCode.Rem),
            ILOpCode.Rem_Un => new IRInstruction(IROpCode.RemUn),
            ILOpCode.Neg => new IRInstruction(IROpCode.Neg),
            
            // Bitwise
            ILOpCode.And => new IRInstruction(IROpCode.And),
            ILOpCode.Or => new IRInstruction(IROpCode.Or),
            ILOpCode.Xor => new IRInstruction(IROpCode.Xor),
            ILOpCode.Not => new IRInstruction(IROpCode.Not),
            ILOpCode.Shl => new IRInstruction(IROpCode.Shl),
            ILOpCode.Shr => new IRInstruction(IROpCode.Shr),
            ILOpCode.Shr_Un => new IRInstruction(IROpCode.ShrUn),
            
            // Comparison
            ILOpCode.Ceq => new IRInstruction(IROpCode.CompareEqual),
            ILOpCode.Cgt => new IRInstruction(IROpCode.CompareGreaterThan),
            ILOpCode.Cgt_Un => new IRInstruction(IROpCode.CompareGreaterThanUn),
            ILOpCode.Clt => new IRInstruction(IROpCode.CompareLessThan),
            ILOpCode.Clt_Un => new IRInstruction(IROpCode.CompareLessThanUn),
            
            // Branches
            ILOpCode.Br or ILOpCode.Br_S => new IRInstruction(IROpCode.Branch, GetBlockLabel((int)il.Operand)),
            ILOpCode.Brfalse or ILOpCode.Brfalse_S => new IRInstruction(IROpCode.BranchFalse, GetBlockLabel((int)il.Operand)),
            ILOpCode.Brtrue or ILOpCode.Brtrue_S => new IRInstruction(IROpCode.BranchTrue, GetBlockLabel((int)il.Operand)),
            
            ILOpCode.Beq or ILOpCode.Beq_S => new IRInstruction(IROpCode.BranchEqual, GetBlockLabel((int)il.Operand)),
            ILOpCode.Bne_Un or ILOpCode.Bne_Un_S => new IRInstruction(IROpCode.BranchNotEqual, GetBlockLabel((int)il.Operand)),
            ILOpCode.Bge or ILOpCode.Bge_S => new IRInstruction(IROpCode.BranchGreaterOrEqual, GetBlockLabel((int)il.Operand)),
            ILOpCode.Bgt or ILOpCode.Bgt_S => new IRInstruction(IROpCode.BranchGreaterThan, GetBlockLabel((int)il.Operand)),
            ILOpCode.Ble or ILOpCode.Ble_S => new IRInstruction(IROpCode.BranchLessOrEqual, GetBlockLabel((int)il.Operand)),
            ILOpCode.Blt or ILOpCode.Blt_S => new IRInstruction(IROpCode.BranchLessThan, GetBlockLabel((int)il.Operand)),
            
            // Stack
            ILOpCode.Dup => new IRInstruction(IROpCode.Dup),
            ILOpCode.Pop => new IRInstruction(IROpCode.Pop),
            
            // Calls
            ILOpCode.Call => new IRInstruction(IROpCode.Call, ResolveMethod(il.Operand)),
            ILOpCode.Callvirt => new IRInstruction(IROpCode.CallVirtual, ResolveMethod(il.Operand)),
            
            // Return
            ILOpCode.Ret => new IRInstruction(IROpCode.Return),
            
            // Objects
            ILOpCode.Newobj => new IRInstruction(IROpCode.NewObj, ResolveMethod(il.Operand)),
            ILOpCode.Ldfld => new IRInstruction(IROpCode.LoadField, ResolveField(il.Operand)),
            ILOpCode.Stfld => new IRInstruction(IROpCode.StoreField, ResolveField(il.Operand)),
            ILOpCode.Ldsfld => new IRInstruction(IROpCode.LoadStaticField, ResolveField(il.Operand)),
            ILOpCode.Stsfld => new IRInstruction(IROpCode.StoreStaticField, ResolveField(il.Operand)),
            ILOpCode.Ldflda => new IRInstruction(IROpCode.LoadFieldAddress, ResolveField(il.Operand)),
            ILOpCode.Ldsflda => new IRInstruction(IROpCode.LoadStaticFieldAddress, ResolveField(il.Operand)),
            
            // Arrays
            ILOpCode.Newarr => new IRInstruction(IROpCode.NewArray, ResolveType(il.Operand)),
            ILOpCode.Ldlen => new IRInstruction(IROpCode.LoadArrayLength),
            ILOpCode.Ldelem_I4 => new IRInstruction(IROpCode.LoadElement),
            ILOpCode.Ldelem_Ref => new IRInstruction(IROpCode.LoadElement),
            ILOpCode.Stelem_I4 => new IRInstruction(IROpCode.StoreElement),
            ILOpCode.Stelem_Ref => new IRInstruction(IROpCode.StoreElement),
            
            // Boxing
            ILOpCode.Box => new IRInstruction(IROpCode.Box, ResolveType(il.Operand)),
            ILOpCode.Unbox => new IRInstruction(IROpCode.Unbox, ResolveType(il.Operand)),
            ILOpCode.Unbox_Any => new IRInstruction(IROpCode.UnboxAny, ResolveType(il.Operand)),
            
            // Type checks
            ILOpCode.Isinst => new IRInstruction(IROpCode.IsInstance, ResolveType(il.Operand)),
            ILOpCode.Castclass => new IRInstruction(IROpCode.CastClass, ResolveType(il.Operand)),
            
            // Exceptions
            ILOpCode.Throw => new IRInstruction(IROpCode.Throw),
            ILOpCode.Rethrow => new IRInstruction(IROpCode.Rethrow),
            ILOpCode.Leave or ILOpCode.Leave_S => new IRInstruction(IROpCode.Leave, GetBlockLabel((int)il.Operand)),
            ILOpCode.Endfinally => new IRInstruction(IROpCode.EndFinally),
            
            // Indirect loads/stores
            ILOpCode.Ldind_I4 => new IRInstruction(IROpCode.LoadIndirect),
            ILOpCode.Stind_I4 => new IRInstruction(IROpCode.StoreIndirect),
            ILOpCode.Ldind_Ref => new IRInstruction(IROpCode.LoadIndirect),
            ILOpCode.Stind_Ref => new IRInstruction(IROpCode.StoreIndirect),
            
            // Strings
            ILOpCode.Ldstr => new IRInstruction(IROpCode.LoadString, ResolveString(il.Operand)),
            
            // Conversions
            ILOpCode.Conv_I1 => new IRInstruction(IROpCode.ConvertI1),
            ILOpCode.Conv_I2 => new IRInstruction(IROpCode.ConvertI2),
            ILOpCode.Conv_I4 => new IRInstruction(IROpCode.ConvertI4),
            ILOpCode.Conv_I8 => new IRInstruction(IROpCode.ConvertI8),
            ILOpCode.Conv_U1 => new IRInstruction(IROpCode.ConvertU1),
            ILOpCode.Conv_U2 => new IRInstruction(IROpCode.ConvertU2),
            ILOpCode.Conv_U4 => new IRInstruction(IROpCode.ConvertU4),
            ILOpCode.Conv_U8 => new IRInstruction(IROpCode.ConvertU8),
            ILOpCode.Conv_I or ILOpCode.Conv_U => new IRInstruction(IROpCode.ConvertIPtr),
            ILOpCode.Conv_R4 => new IRInstruction(IROpCode.ConvertR4),
            ILOpCode.Conv_R8 => new IRInstruction(IROpCode.ConvertR8),
            
            // Default - nop
            _ => new IRInstruction(IROpCode.Nop)
        };
    }
    
    private string GetBlockLabel(int offset)
    {
        // Usar o mesmo formato de label que CreateBasicBlocks
        if (_blocksByOffset.TryGetValue(offset, out var block))
        {
            return block.Label;
        }
        
        // Fallback: criar label com prefixo do método
        var methodPrefix = _method?.GetLabel()?.Replace("__", "") ?? $"M{_blockCounter}";
        return $"L_{methodPrefix}_{offset:X4}";
    }
    
    private object ResolveMethod(object operand)
    {
        if (operand is MetadataToken token && _reader != null)
        {
            return _reader.ResolveMethod(token.Value);
        }
        return operand;
    }
    
    private object ResolveType(object operand)
    {
        if (operand is MetadataToken token && _reader != null)
        {
            return _reader.ResolveTypeByToken(token.Value);
        }
        return operand;
    }
    
    private object ResolveField(object operand)
    {
        if (operand is MetadataToken token && _reader != null)
        {
            return _reader.ResolveField(token.Value);
        }
        return operand;
    }
    
    private string ResolveString(object operand)
    {
        if (operand is MetadataToken token && _reader != null)
        {
            return _reader.ResolveString(token.Value);
        }
        return operand?.ToString();
    }
    
    private ControlFlowGraph BuildCFG()
    {
        var cfg = new ControlFlowGraph(_method.Name);
        
        foreach (var block in _blocksByOffset.Values.OrderBy(b => b.StartOffset))
        {
            cfg.Blocks.Add(block);
        }
        
        if (cfg.Blocks.Count > 0)
        {
            cfg.EntryBlock = cfg.Blocks[0];
        }
        
        return cfg;
    }
}
