namespace System
{
    public static class RuntimeHelpers
    {
        [Asm386Implementation(@"
            MOV EAX, {ARG0}
        ")]
        public static extern int GetHashCode(Object obj);
        
        [Asm386Implementation(@"
            MOV EAX, {ARG0}
            MOV EAX, [EAX-4]
            MOVZX EAX, AX
        ")]
        public static extern RuntimeTypeHandle GetTypeHandle(Object obj);
        
        [Asm386Implementation(@"
            XOR EAX, EAX
        ")]
        public static extern Type GetTypeFromHandle(RuntimeTypeHandle handle);
        
        [Asm386Implementation(@"
            MOV EAX, {ARG0}
        ")]
        public static extern Object MemberwiseClone(Object obj);
        
        [Asm386Implementation(@"
            MOV ESI, {ARG0}
            MOV EDI, {ARG1}
            MOV ECX, [ESI-8]
            SUB ECX, 12
            REPE CMPSB
            SETE AL
            MOVZX EAX, AL
        ")]
        public static extern bool ValueTypeEquals(Object a, Object b);
        
        [Asm386Implementation(@"
            MOV ESI, {ARG0}
            MOV ECX, [ESI-8]
            SUB ECX, 12
            XOR EAX, EAX
        @@loop:
            JECXZ @@done
            ROL EAX, 5
            XOR AL, [ESI]
            INC ESI
            DEC ECX
            JMP @@loop
        @@done:
        ")]
        public static extern int ValueTypeGetHashCode(Object obj);
        
        [Asm386Implementation(@"
            MOV ESI, {ARG0}
            MOV ECX, {ARG1}
            ADD ESI, 8
            MOVZX EAX, WORD PTR [ESI + ECX*2]
        ")]
        public static extern char GetCharAt(String str, int index);
        
        [Asm386Implementation(@"
            MOV ESI, {ARG0}
            MOV EDI, {ARG1}
            MOV ECX, [ESI]
            ADD ESI, 4
            ADD EDI, 4
            SHL ECX, 1
            REPE CMPSB
            SETE AL
            MOVZX EAX, AL
        ")]
        public static extern bool StringEquals(String a, String b);
        
        [Asm386Implementation(@"
            MOV ESI, {ARG0}
            MOV ECX, [ESI]
            ADD ESI, 4
            XOR EAX, EAX
        @@loop:
            JECXZ @@done
            ROL EAX, 5
            XOR AX, [ESI]
            ADD ESI, 2
            DEC ECX
            JMP @@loop
        @@done:
        ")]
        public static extern int StringGetHashCode(String str);
        
        [Asm386Implementation(@"
            ; CopyCharsToString - copia chars do array para a string
            ; {ARG0} = string destino, {ARG1} = char[] fonte
            MOV EDI, {ARG0}
            MOV ESI, {ARG1}
            MOV ECX, [ESI]          ; Length do array
            ADD EDI, 5              ; Pular length (4) + firstChar (1)
            ADD ESI, 5              ; Pular length (4) + primeiro elemento (1)
            DEC ECX                 ; Já copiamos o primeiro char
            TEST ECX, ECX
            JLE @@done
            REP MOVSB
        @@done:
        ")]
        public static extern void CopyCharsToString(String dest, char[] src);
        
        [Asm386Implementation(@"
            MOV EAX, {ARG0}
        ")]
        public static extern String StringConcat(String a, String b);
        
        [Asm386Implementation(@"
            XOR EAX, EAX
        ")]
        public static extern String CharToString(char c);
        
        public static String Int32ToString(int value)
        {
            if (value == 0)
                return "0";
            
            bool negative = value < 0;
            if (negative)
                value = -value;
            
            // Contar dígitos
            int temp = value;
            int digits = 0;
            while (temp > 0)
            {
                digits++;
                temp = temp / 10;
            }
            
            int length = negative ? digits + 1 : digits;
            char[] chars = new char[length];
            
            int pos = length - 1;
            while (value > 0)
            {
                chars[pos] = (char)('0' + (value % 10));
                value = value / 10;
                pos--;
            }
            
            if (negative)
                chars[0] = '-';
            
            return new String(chars);
        }
        
        public static String UInt32ToString(uint value)
        {
            if (value == 0)
                return "0";
            
            // Contar dígitos
            uint temp = value;
            int digits = 0;
            while (temp > 0)
            {
                digits++;
                temp = temp / 10;
            }
            
            char[] chars = new char[digits];
            
            int pos = digits - 1;
            while (value > 0)
            {
                chars[pos] = (char)('0' + (value % 10));
                value = value / 10;
                pos--;
            }
            
            return new String(chars);
        }
        
        [Asm386Implementation(@"
            XOR EAX, EAX
        ")]
        public static extern String Int64ToString(long value);
        
        [Asm386Implementation(@"
            XOR EAX, EAX
        ")]
        public static extern String UInt64ToString(ulong value);
        
        [Asm386Implementation(@"
            XOR EAX, EAX
        ")]
        public static extern String SingleToString(float value);
        
        [Asm386Implementation(@"
            XOR EAX, EAX
        ")]
        public static extern String DoubleToString(double value);
        
        [Asm386Implementation(@"
            MOV EAX, {ARG0}
        ")]
        public static extern int SingleToInt32Bits(float value);
        
        [Asm386Implementation(@"
            MOV EAX, {ARG0}
            MOV EDX, {ARG0}+4
        ")]
        public static extern long DoubleToInt64Bits(double value);
        
        [Asm386Implementation(@"
            XOR EAX, EAX
        ")]
        public static extern int ParseInt32(String s);
        
        [Asm386Implementation(@"
            MOV EDI, {ARG0}
            ADD EDI, {ARG1}
            MOV ECX, {ARG2}
            XOR EAX, EAX
            REP STOSB
        ")]
        public static extern void ArrayClear(Array array, int index, int length);
        
        [Asm386Implementation(@"
            MOV ESI, {ARG0}
            MOV ECX, {ARG1}
            MOV EAX, [ESI + ECX*4 + 8]
        ")]
        public static extern Object ArrayGetValue(Array array, int index);
    }
    
    public struct RuntimeTypeHandle
    {
        internal IntPtr _value;
        public IntPtr Value => _value;
    }
}
