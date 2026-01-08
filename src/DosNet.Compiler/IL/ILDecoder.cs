namespace DosNet.Compiler.IL;

/// <summary>
/// Decodifica bytes IL em instruções.
/// </summary>
public class ILDecoder
{
    private readonly byte[] _ilBytes;
    private int _position;
    
    public ILDecoder(byte[] ilBytes)
    {
        _ilBytes = ilBytes ?? Array.Empty<byte>();
    }
    
    public List<ILInstruction> Decode()
    {
        var instructions = new List<ILInstruction>();
        _position = 0;
        
        while (_position < _ilBytes.Length)
        {
            var inst = DecodeInstruction();
            if (inst != null)
                instructions.Add(inst);
        }
        
        return instructions;
    }
    
    private ILInstruction DecodeInstruction()
    {
        int offset = _position;
        
        byte b1 = ReadByte();
        ILOpCode opCode;
        
        if (b1 == 0xFE)
        {
            byte b2 = ReadByte();
            opCode = (ILOpCode)(0xFE00 | b2);
        }
        else
        {
            opCode = (ILOpCode)b1;
        }
        
        object operand = ReadOperand(opCode, offset);
        
        var inst = new ILInstruction(offset, opCode, operand)
        {
            Size = _position - offset
        };
        
        return inst;
    }
    
    private object ReadOperand(ILOpCode opCode, int instructionOffset)
    {
        int operandSize = opCode.GetOperandSize();
        
        if (operandSize == 0)
            return null;
        
        if (operandSize == -1) // Switch
        {
            return ReadSwitchOperand(instructionOffset);
        }
        
        return opCode switch
        {
            // Short branches (1 byte signed offset)
            ILOpCode.Br_S or ILOpCode.Brfalse_S or ILOpCode.Brtrue_S or
            ILOpCode.Beq_S or ILOpCode.Bne_Un_S or
            ILOpCode.Bge_S or ILOpCode.Bge_Un_S or
            ILOpCode.Bgt_S or ILOpCode.Bgt_Un_S or
            ILOpCode.Ble_S or ILOpCode.Ble_Un_S or
            ILOpCode.Blt_S or ILOpCode.Blt_Un_S or
            ILOpCode.Leave_S
                => _position + 1 + ReadSByte(),
            
            // Long branches (4 byte signed offset)
            ILOpCode.Br or ILOpCode.Brfalse or ILOpCode.Brtrue or
            ILOpCode.Beq or ILOpCode.Bne_Un or
            ILOpCode.Bge or ILOpCode.Bge_Un or
            ILOpCode.Bgt or ILOpCode.Bgt_Un or
            ILOpCode.Ble or ILOpCode.Ble_Un or
            ILOpCode.Blt or ILOpCode.Blt_Un or
            ILOpCode.Leave
                => _position + 4 + ReadInt32(),
            
            // 1 byte operands
            ILOpCode.Ldarg_S or ILOpCode.Ldarga_S or ILOpCode.Starg_S or
            ILOpCode.Ldloc_S or ILOpCode.Ldloca_S or ILOpCode.Stloc_S
                => (int)ReadByte(),
            
            ILOpCode.Ldc_I4_S => ReadSByte(),
            ILOpCode.Unaligned => ReadByte(),
            
            // 2 byte operands
            ILOpCode.Ldarg or ILOpCode.Ldarga or ILOpCode.Starg or
            ILOpCode.Ldloc or ILOpCode.Ldloca or ILOpCode.Stloc
                => ReadUInt16(),
            
            // 4 byte int
            ILOpCode.Ldc_I4 => ReadInt32(),
            
            // 4 byte float
            ILOpCode.Ldc_R4 => ReadSingle(),
            
            // 8 byte int
            ILOpCode.Ldc_I8 => ReadInt64(),
            
            // 8 byte float
            ILOpCode.Ldc_R8 => ReadDouble(),
            
            // Metadata tokens
            ILOpCode.Call or ILOpCode.Calli or ILOpCode.Callvirt or ILOpCode.Jmp or
            ILOpCode.Newobj or ILOpCode.Newarr or
            ILOpCode.Castclass or ILOpCode.Isinst or
            ILOpCode.Box or ILOpCode.Unbox or ILOpCode.Unbox_Any or
            ILOpCode.Ldfld or ILOpCode.Ldflda or ILOpCode.Stfld or
            ILOpCode.Ldsfld or ILOpCode.Ldsflda or ILOpCode.Stsfld or
            ILOpCode.Ldstr or ILOpCode.Ldtoken or
            ILOpCode.Ldftn or ILOpCode.Ldvirtftn or
            ILOpCode.Ldobj or ILOpCode.Stobj or ILOpCode.Cpobj or
            ILOpCode.Initobj or ILOpCode.Sizeof or
            ILOpCode.Ldelem or ILOpCode.Stelem or ILOpCode.Ldelema or
            ILOpCode.Constrained or ILOpCode.Mkrefany or ILOpCode.Refanyval
                => new MetadataToken(ReadUInt32()),
            
            _ => null
        };
    }
    
    private int[] ReadSwitchOperand(int instructionOffset)
    {
        int count = ReadInt32();
        int baseOffset = _position + count * 4;
        
        var targets = new int[count];
        for (int i = 0; i < count; i++)
        {
            targets[i] = baseOffset + ReadInt32();
        }
        
        return targets;
    }
    
    private byte ReadByte()
    {
        if (_position >= _ilBytes.Length)
            return 0;
        return _ilBytes[_position++];
    }
    
    private sbyte ReadSByte() => (sbyte)ReadByte();
    
    private ushort ReadUInt16()
    {
        ushort value = BitConverter.ToUInt16(_ilBytes, _position);
        _position += 2;
        return value;
    }
    
    private int ReadInt32()
    {
        int value = BitConverter.ToInt32(_ilBytes, _position);
        _position += 4;
        return value;
    }
    
    private uint ReadUInt32()
    {
        uint value = BitConverter.ToUInt32(_ilBytes, _position);
        _position += 4;
        return value;
    }
    
    private long ReadInt64()
    {
        long value = BitConverter.ToInt64(_ilBytes, _position);
        _position += 8;
        return value;
    }
    
    private float ReadSingle()
    {
        float value = BitConverter.ToSingle(_ilBytes, _position);
        _position += 4;
        return value;
    }
    
    private double ReadDouble()
    {
        double value = BitConverter.ToDouble(_ilBytes, _position);
        _position += 8;
        return value;
    }
}
