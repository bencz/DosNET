namespace System
{
    public static class Console
    {
        [Asm386Implementation(@"
            MOV ESI, {ARG0}
            TEST ESI, ESI
            JZ @@done
            MOV ECX, [ESI]
            LEA EDX, [ESI+4]
            PUSH ECX
            PUSH EDX
            PUSH 1
            CALL __write
            ADD ESP, 12
        @@done:
        ")]
        public static extern void Write(String value);
        
        public static void WriteLine(String value)
        {
            Write(value);
            WriteLine();
        }
        
        [Asm386Implementation(@"
            PUSH 2
            PUSH OFFSET __crlf
            PUSH 1
            CALL __write
            ADD ESP, 12
        ")]
        public static extern void WriteLine();
        
        [Asm386Implementation(@"
            LEA EAX, {ARG0}
            PUSH 1
            PUSH EAX
            PUSH 1
            CALL __write
            ADD ESP, 12
        ")]
        public static extern void Write(char value);
        
        public static void Write(int value) => Write(RuntimeHelpers.Int32ToString(value));
        public static void WriteLine(int value) => WriteLine(RuntimeHelpers.Int32ToString(value));
        public static void Write(long value) => Write(RuntimeHelpers.Int64ToString(value));
        public static void WriteLine(long value) => WriteLine(RuntimeHelpers.Int64ToString(value));
        public static void Write(bool value) => Write(value ? "True" : "False");
        public static void WriteLine(bool value) => WriteLine(value ? "True" : "False");
        
        public static void Write(Object value)
        {
            if ((object)value != null)
                Write(value.ToString());
        }
        
        public static void WriteLine(Object value)
        {
            if ((object)value != null)
                WriteLine(value.ToString());
            else
                WriteLine();
        }
        
        [Asm386Implementation(@"
            SUB ESP, 4
            PUSH 1
            LEA EAX, [ESP+4]
            PUSH EAX
            PUSH 0
            CALL __read
            ADD ESP, 12
            MOVZX EAX, BYTE PTR [ESP]
            ADD ESP, 4
        ")]
        public static extern int Read();
        
        [Asm386Implementation(@"
            XOR EAX, EAX
        ")]
        public static extern String ReadLine();
        
        [Asm386Implementation(@"
            CALL __getch
            MOVZX EAX, AL
        ")]
        public static extern ConsoleKeyInfo ReadKey();
        
        [Asm386Implementation(@"
            CALL __kbhit
        ")]
        public static extern bool CheckKeyAvailable();
        
        public static bool KeyAvailable => CheckKeyAvailable();
    }
    
    public struct ConsoleKeyInfo
    {
        public char KeyChar;
        public ConsoleKey Key;
        public bool Shift;
        public bool Alt;
        public bool Control;
    }
    
    public enum ConsoleKey
    {
        None = 0,
        Backspace = 8,
        Tab = 9,
        Enter = 13,
        Escape = 27,
        Spacebar = 32,
    }
}
