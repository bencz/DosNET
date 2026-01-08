namespace DosNet.Compiler.IL;

/// <summary>
/// Opcodes IL (MSIL/CIL).
/// Baseado em System.Reflection.Emit.OpCodes.
/// </summary>
public enum ILOpCode : ushort
{
    // 0x00 - 0x0F
    Nop = 0x00,
    Break = 0x01,
    Ldarg_0 = 0x02,
    Ldarg_1 = 0x03,
    Ldarg_2 = 0x04,
    Ldarg_3 = 0x05,
    Ldloc_0 = 0x06,
    Ldloc_1 = 0x07,
    Ldloc_2 = 0x08,
    Ldloc_3 = 0x09,
    Stloc_0 = 0x0A,
    Stloc_1 = 0x0B,
    Stloc_2 = 0x0C,
    Stloc_3 = 0x0D,
    Ldarg_S = 0x0E,
    Ldarga_S = 0x0F,
    
    // 0x10 - 0x1F
    Starg_S = 0x10,
    Ldloc_S = 0x11,
    Ldloca_S = 0x12,
    Stloc_S = 0x13,
    Ldnull = 0x14,
    Ldc_I4_M1 = 0x15,
    Ldc_I4_0 = 0x16,
    Ldc_I4_1 = 0x17,
    Ldc_I4_2 = 0x18,
    Ldc_I4_3 = 0x19,
    Ldc_I4_4 = 0x1A,
    Ldc_I4_5 = 0x1B,
    Ldc_I4_6 = 0x1C,
    Ldc_I4_7 = 0x1D,
    Ldc_I4_8 = 0x1E,
    Ldc_I4_S = 0x1F,
    
    // 0x20 - 0x2F
    Ldc_I4 = 0x20,
    Ldc_I8 = 0x21,
    Ldc_R4 = 0x22,
    Ldc_R8 = 0x23,
    Dup = 0x25,
    Pop = 0x26,
    Jmp = 0x27,
    Call = 0x28,
    Calli = 0x29,
    Ret = 0x2A,
    Br_S = 0x2B,
    Brfalse_S = 0x2C,
    Brtrue_S = 0x2D,
    Beq_S = 0x2E,
    Bge_S = 0x2F,
    
    // 0x30 - 0x3F
    Bgt_S = 0x30,
    Ble_S = 0x31,
    Blt_S = 0x32,
    Bne_Un_S = 0x33,
    Bge_Un_S = 0x34,
    Bgt_Un_S = 0x35,
    Ble_Un_S = 0x36,
    Blt_Un_S = 0x37,
    Br = 0x38,
    Brfalse = 0x39,
    Brtrue = 0x3A,
    Beq = 0x3B,
    Bge = 0x3C,
    Bgt = 0x3D,
    Ble = 0x3E,
    Blt = 0x3F,
    
    // 0x40 - 0x4F
    Bne_Un = 0x40,
    Bge_Un = 0x41,
    Bgt_Un = 0x42,
    Ble_Un = 0x43,
    Blt_Un = 0x44,
    Switch = 0x45,
    Ldind_I1 = 0x46,
    Ldind_U1 = 0x47,
    Ldind_I2 = 0x48,
    Ldind_U2 = 0x49,
    Ldind_I4 = 0x4A,
    Ldind_U4 = 0x4B,
    Ldind_I8 = 0x4C,
    Ldind_I = 0x4D,
    Ldind_R4 = 0x4E,
    Ldind_R8 = 0x4F,
    
    // 0x50 - 0x5F
    Ldind_Ref = 0x50,
    Stind_Ref = 0x51,
    Stind_I1 = 0x52,
    Stind_I2 = 0x53,
    Stind_I4 = 0x54,
    Stind_I8 = 0x55,
    Stind_R4 = 0x56,
    Stind_R8 = 0x57,
    Add = 0x58,
    Sub = 0x59,
    Mul = 0x5A,
    Div = 0x5B,
    Div_Un = 0x5C,
    Rem = 0x5D,
    Rem_Un = 0x5E,
    And = 0x5F,
    
    // 0x60 - 0x6F
    Or = 0x60,
    Xor = 0x61,
    Shl = 0x62,
    Shr = 0x63,
    Shr_Un = 0x64,
    Neg = 0x65,
    Not = 0x66,
    Conv_I1 = 0x67,
    Conv_I2 = 0x68,
    Conv_I4 = 0x69,
    Conv_I8 = 0x6A,
    Conv_R4 = 0x6B,
    Conv_R8 = 0x6C,
    Conv_U4 = 0x6D,
    Conv_U8 = 0x6E,
    Callvirt = 0x6F,
    
    // 0x70 - 0x7F
    Cpobj = 0x70,
    Ldobj = 0x71,
    Ldstr = 0x72,
    Newobj = 0x73,
    Castclass = 0x74,
    Isinst = 0x75,
    Conv_R_Un = 0x76,
    Unbox = 0x79,
    Throw = 0x7A,
    Ldfld = 0x7B,
    Ldflda = 0x7C,
    Stfld = 0x7D,
    Ldsfld = 0x7E,
    Ldsflda = 0x7F,
    
    // 0x80 - 0x8F
    Stsfld = 0x80,
    Stobj = 0x81,
    Conv_Ovf_I1_Un = 0x82,
    Conv_Ovf_I2_Un = 0x83,
    Conv_Ovf_I4_Un = 0x84,
    Conv_Ovf_I8_Un = 0x85,
    Conv_Ovf_U1_Un = 0x86,
    Conv_Ovf_U2_Un = 0x87,
    Conv_Ovf_U4_Un = 0x88,
    Conv_Ovf_U8_Un = 0x89,
    Conv_Ovf_I_Un = 0x8A,
    Conv_Ovf_U_Un = 0x8B,
    Box = 0x8C,
    Newarr = 0x8D,
    Ldlen = 0x8E,
    Ldelema = 0x8F,
    
    // 0x90 - 0x9F
    Ldelem_I1 = 0x90,
    Ldelem_U1 = 0x91,
    Ldelem_I2 = 0x92,
    Ldelem_U2 = 0x93,
    Ldelem_I4 = 0x94,
    Ldelem_U4 = 0x95,
    Ldelem_I8 = 0x96,
    Ldelem_I = 0x97,
    Ldelem_R4 = 0x98,
    Ldelem_R8 = 0x99,
    Ldelem_Ref = 0x9A,
    Stelem_I = 0x9B,
    Stelem_I1 = 0x9C,
    Stelem_I2 = 0x9D,
    Stelem_I4 = 0x9E,
    Stelem_I8 = 0x9F,
    
    // 0xA0 - 0xAF
    Stelem_R4 = 0xA0,
    Stelem_R8 = 0xA1,
    Stelem_Ref = 0xA2,
    Ldelem = 0xA3,
    Stelem = 0xA4,
    Unbox_Any = 0xA5,
    
    // 0xB0 - 0xBF
    Conv_Ovf_I1 = 0xB3,
    Conv_Ovf_U1 = 0xB4,
    Conv_Ovf_I2 = 0xB5,
    Conv_Ovf_U2 = 0xB6,
    Conv_Ovf_I4 = 0xB7,
    Conv_Ovf_U4 = 0xB8,
    Conv_Ovf_I8 = 0xB9,
    Conv_Ovf_U8 = 0xBA,
    
    // 0xC0 - 0xCF
    Refanyval = 0xC2,
    Ckfinite = 0xC3,
    Mkrefany = 0xC6,
    
    // 0xD0 - 0xDF
    Ldtoken = 0xD0,
    Conv_U2 = 0xD1,
    Conv_U1 = 0xD2,
    Conv_I = 0xD3,
    Conv_Ovf_I = 0xD4,
    Conv_Ovf_U = 0xD5,
    Add_Ovf = 0xD6,
    Add_Ovf_Un = 0xD7,
    Mul_Ovf = 0xD8,
    Mul_Ovf_Un = 0xD9,
    Sub_Ovf = 0xDA,
    Sub_Ovf_Un = 0xDB,
    Endfinally = 0xDC,
    Leave = 0xDD,
    Leave_S = 0xDE,
    Stind_I = 0xDF,
    
    // 0xE0 - 0xEF
    Conv_U = 0xE0,
    
    // Two-byte opcodes (0xFE prefix)
    Prefix_FE = 0xFE,
    
    // 0xFE00 - 0xFE1F (two-byte)
    Arglist = 0xFE00,
    Ceq = 0xFE01,
    Cgt = 0xFE02,
    Cgt_Un = 0xFE03,
    Clt = 0xFE04,
    Clt_Un = 0xFE05,
    Ldftn = 0xFE06,
    Ldvirtftn = 0xFE07,
    Ldarg = 0xFE09,
    Ldarga = 0xFE0A,
    Starg = 0xFE0B,
    Ldloc = 0xFE0C,
    Ldloca = 0xFE0D,
    Stloc = 0xFE0E,
    Localloc = 0xFE0F,
    Endfilter = 0xFE11,
    Unaligned = 0xFE12,
    Volatile = 0xFE13,
    Tail = 0xFE14,
    Initobj = 0xFE15,
    Constrained = 0xFE16,
    Cpblk = 0xFE17,
    Initblk = 0xFE18,
    Rethrow = 0xFE1A,
    Sizeof = 0xFE1C,
    Refanytype = 0xFE1D,
    Readonly = 0xFE1E,
}

/// <summary>
/// Extensões para ILOpCode
/// </summary>
public static class ILOpCodeExtensions
{
    /// <summary>
    /// Verifica se é um opcode de branch
    /// </summary>
    public static bool IsBranch(this ILOpCode opCode)
    {
        return opCode switch
        {
            ILOpCode.Br or ILOpCode.Br_S or
            ILOpCode.Brfalse or ILOpCode.Brfalse_S or
            ILOpCode.Brtrue or ILOpCode.Brtrue_S or
            ILOpCode.Beq or ILOpCode.Beq_S or
            ILOpCode.Bne_Un or ILOpCode.Bne_Un_S or
            ILOpCode.Bge or ILOpCode.Bge_S or
            ILOpCode.Bge_Un or ILOpCode.Bge_Un_S or
            ILOpCode.Bgt or ILOpCode.Bgt_S or
            ILOpCode.Bgt_Un or ILOpCode.Bgt_Un_S or
            ILOpCode.Ble or ILOpCode.Ble_S or
            ILOpCode.Ble_Un or ILOpCode.Ble_Un_S or
            ILOpCode.Blt or ILOpCode.Blt_S or
            ILOpCode.Blt_Un or ILOpCode.Blt_Un_S or
            ILOpCode.Leave or ILOpCode.Leave_S => true,
            _ => false
        };
    }
    
    /// <summary>
    /// Verifica se é um branch incondicional
    /// </summary>
    public static bool IsUnconditionalBranch(this ILOpCode opCode)
    {
        return opCode is ILOpCode.Br or ILOpCode.Br_S or 
               ILOpCode.Leave or ILOpCode.Leave_S or
               ILOpCode.Jmp;
    }
    
    /// <summary>
    /// Verifica se termina um bloco básico
    /// </summary>
    public static bool IsBlockTerminator(this ILOpCode opCode)
    {
        return opCode.IsBranch() || opCode is 
            ILOpCode.Ret or 
            ILOpCode.Throw or 
            ILOpCode.Rethrow or
            ILOpCode.Switch or
            ILOpCode.Endfinally or
            ILOpCode.Endfilter;
    }
    
    /// <summary>
    /// Obtém o tamanho do operando em bytes
    /// </summary>
    public static int GetOperandSize(this ILOpCode opCode)
    {
        return opCode switch
        {
            // Sem operando
            ILOpCode.Nop or ILOpCode.Break or
            ILOpCode.Ldarg_0 or ILOpCode.Ldarg_1 or ILOpCode.Ldarg_2 or ILOpCode.Ldarg_3 or
            ILOpCode.Ldloc_0 or ILOpCode.Ldloc_1 or ILOpCode.Ldloc_2 or ILOpCode.Ldloc_3 or
            ILOpCode.Stloc_0 or ILOpCode.Stloc_1 or ILOpCode.Stloc_2 or ILOpCode.Stloc_3 or
            ILOpCode.Ldnull or
            ILOpCode.Ldc_I4_M1 or ILOpCode.Ldc_I4_0 or ILOpCode.Ldc_I4_1 or ILOpCode.Ldc_I4_2 or
            ILOpCode.Ldc_I4_3 or ILOpCode.Ldc_I4_4 or ILOpCode.Ldc_I4_5 or ILOpCode.Ldc_I4_6 or
            ILOpCode.Ldc_I4_7 or ILOpCode.Ldc_I4_8 or
            ILOpCode.Dup or ILOpCode.Pop or ILOpCode.Ret or
            ILOpCode.Add or ILOpCode.Sub or ILOpCode.Mul or ILOpCode.Div or ILOpCode.Div_Un or
            ILOpCode.Rem or ILOpCode.Rem_Un or ILOpCode.And or ILOpCode.Or or ILOpCode.Xor or
            ILOpCode.Shl or ILOpCode.Shr or ILOpCode.Shr_Un or ILOpCode.Neg or ILOpCode.Not or
            ILOpCode.Conv_I1 or ILOpCode.Conv_I2 or ILOpCode.Conv_I4 or ILOpCode.Conv_I8 or
            ILOpCode.Conv_R4 or ILOpCode.Conv_R8 or ILOpCode.Conv_U4 or ILOpCode.Conv_U8 or
            ILOpCode.Conv_U1 or ILOpCode.Conv_U2 or ILOpCode.Conv_I or ILOpCode.Conv_U or
            ILOpCode.Ldlen or ILOpCode.Throw or ILOpCode.Rethrow or
            ILOpCode.Ldind_I1 or ILOpCode.Ldind_U1 or ILOpCode.Ldind_I2 or ILOpCode.Ldind_U2 or
            ILOpCode.Ldind_I4 or ILOpCode.Ldind_U4 or ILOpCode.Ldind_I8 or ILOpCode.Ldind_I or
            ILOpCode.Ldind_R4 or ILOpCode.Ldind_R8 or ILOpCode.Ldind_Ref or
            ILOpCode.Stind_Ref or ILOpCode.Stind_I1 or ILOpCode.Stind_I2 or ILOpCode.Stind_I4 or
            ILOpCode.Stind_I8 or ILOpCode.Stind_R4 or ILOpCode.Stind_R8 or ILOpCode.Stind_I or
            ILOpCode.Ldelem_I1 or ILOpCode.Ldelem_U1 or ILOpCode.Ldelem_I2 or ILOpCode.Ldelem_U2 or
            ILOpCode.Ldelem_I4 or ILOpCode.Ldelem_U4 or ILOpCode.Ldelem_I8 or ILOpCode.Ldelem_I or
            ILOpCode.Ldelem_R4 or ILOpCode.Ldelem_R8 or ILOpCode.Ldelem_Ref or
            ILOpCode.Stelem_I or ILOpCode.Stelem_I1 or ILOpCode.Stelem_I2 or ILOpCode.Stelem_I4 or
            ILOpCode.Stelem_I8 or ILOpCode.Stelem_R4 or ILOpCode.Stelem_R8 or ILOpCode.Stelem_Ref or
            ILOpCode.Ceq or ILOpCode.Cgt or ILOpCode.Cgt_Un or ILOpCode.Clt or ILOpCode.Clt_Un or
            ILOpCode.Endfinally or ILOpCode.Endfilter or
            ILOpCode.Ckfinite or ILOpCode.Localloc or ILOpCode.Cpblk or ILOpCode.Initblk or
            ILOpCode.Arglist or ILOpCode.Refanytype
                => 0,
            
            // 1 byte (int8 ou uint8)
            ILOpCode.Ldarg_S or ILOpCode.Ldarga_S or ILOpCode.Starg_S or
            ILOpCode.Ldloc_S or ILOpCode.Ldloca_S or ILOpCode.Stloc_S or
            ILOpCode.Ldc_I4_S or
            ILOpCode.Br_S or ILOpCode.Brfalse_S or ILOpCode.Brtrue_S or
            ILOpCode.Beq_S or ILOpCode.Bge_S or ILOpCode.Bgt_S or ILOpCode.Ble_S or ILOpCode.Blt_S or
            ILOpCode.Bne_Un_S or ILOpCode.Bge_Un_S or ILOpCode.Bgt_Un_S or ILOpCode.Ble_Un_S or ILOpCode.Blt_Un_S or
            ILOpCode.Leave_S or
            ILOpCode.Unaligned
                => 1,
            
            // 2 bytes (int16 ou uint16)
            ILOpCode.Ldarg or ILOpCode.Ldarga or ILOpCode.Starg or
            ILOpCode.Ldloc or ILOpCode.Ldloca or ILOpCode.Stloc
                => 2,
            
            // 4 bytes (int32, token, ou offset)
            ILOpCode.Ldc_I4 or ILOpCode.Ldc_R4 or
            ILOpCode.Br or ILOpCode.Brfalse or ILOpCode.Brtrue or
            ILOpCode.Beq or ILOpCode.Bge or ILOpCode.Bgt or ILOpCode.Ble or ILOpCode.Blt or
            ILOpCode.Bne_Un or ILOpCode.Bge_Un or ILOpCode.Bgt_Un or ILOpCode.Ble_Un or ILOpCode.Blt_Un or
            ILOpCode.Leave or
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
                => 4,
            
            // 8 bytes (int64 ou float64)
            ILOpCode.Ldc_I8 or ILOpCode.Ldc_R8
                => 8,
            
            // Switch é especial (4 + 4*n)
            ILOpCode.Switch => -1,
            
            _ => 0
        };
    }
}
