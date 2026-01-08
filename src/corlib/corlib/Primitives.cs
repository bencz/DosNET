namespace System
{
    public struct Boolean
    {
        internal readonly bool _value;
        
        public override String ToString() => _value ? "True" : "False";
        public override int GetHashCode() => _value ? 1 : 0;
        public override bool Equals(Object obj) => obj is Boolean b && _value == b._value;
    }
    
    public struct Char
    {
        internal readonly char _value;
        
        public override String ToString() => RuntimeHelpers.CharToString(_value);
        public override int GetHashCode() => _value;
        public override bool Equals(Object obj) => obj is Char c && _value == c._value;
        
        public static bool IsWhiteSpace(char c) => c == ' ' || c == '\t' || c == '\n' || c == '\r';
        public static bool IsDigit(char c) => c >= '0' && c <= '9';
        public static bool IsLetter(char c) => (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
        public static bool IsLetterOrDigit(char c) => IsLetter(c) || IsDigit(c);
        public static bool IsUpper(char c) => c >= 'A' && c <= 'Z';
        public static bool IsLower(char c) => c >= 'a' && c <= 'z';
        public static char ToUpper(char c) => IsLower(c) ? (char)(c - 32) : c;
        public static char ToLower(char c) => IsUpper(c) ? (char)(c + 32) : c;
    }
    
    public struct SByte
    {
        internal readonly sbyte _value;
        public const sbyte MinValue = -128;
        public const sbyte MaxValue = 127;
        
        public override String ToString() => RuntimeHelpers.Int32ToString(_value);
        public override int GetHashCode() => _value;
        public override bool Equals(Object obj) => obj is SByte b && _value == b._value;
    }
    
    public struct Byte
    {
        internal readonly byte _value;
        public const byte MinValue = 0;
        public const byte MaxValue = 255;
        
        public override String ToString() => RuntimeHelpers.UInt32ToString(_value);
        public override int GetHashCode() => _value;
        public override bool Equals(Object obj) => obj is Byte b && _value == b._value;
    }
    
    public struct Int16
    {
        internal readonly short _value;
        public const short MinValue = -32768;
        public const short MaxValue = 32767;
        
        public override String ToString() => RuntimeHelpers.Int32ToString(_value);
        public override int GetHashCode() => _value;
        public override bool Equals(Object obj) => obj is Int16 s && _value == s._value;
    }
    
    public struct UInt16
    {
        internal readonly ushort _value;
        public const ushort MinValue = 0;
        public const ushort MaxValue = 65535;
        
        public override String ToString() => RuntimeHelpers.UInt32ToString(_value);
        public override int GetHashCode() => _value;
        public override bool Equals(Object obj) => obj is UInt16 u && _value == u._value;
    }
    
    public struct Int32
    {
        internal readonly int _value;
        public const int MinValue = -2147483648;
        public const int MaxValue = 2147483647;
        
        public override String ToString() => RuntimeHelpers.Int32ToString(_value);
        public override int GetHashCode() => _value;
        public override bool Equals(Object obj) => obj is Int32 i && _value == i._value;
        
        public static int Parse(String s) => RuntimeHelpers.ParseInt32(s);
    }
    
    public struct UInt32
    {
        internal readonly uint _value;
        public const uint MinValue = 0;
        public const uint MaxValue = 4294967295;
        
        public override String ToString() => RuntimeHelpers.UInt32ToString(_value);
        public override int GetHashCode() => (int)_value;
        public override bool Equals(Object obj) => obj is UInt32 u && _value == u._value;
    }
    
    public struct Int64
    {
        internal readonly long _value;
        public const long MinValue = -9223372036854775808;
        public const long MaxValue = 9223372036854775807;
        
        public override String ToString() => RuntimeHelpers.Int64ToString(_value);
        public override int GetHashCode() => (int)_value ^ (int)(_value >> 32);
        public override bool Equals(Object obj) => obj is Int64 l && _value == l._value;
    }
    
    public struct UInt64
    {
        internal readonly ulong _value;
        public const ulong MinValue = 0;
        public const ulong MaxValue = 18446744073709551615;
        
        public override String ToString() => RuntimeHelpers.UInt64ToString(_value);
        public override int GetHashCode() => (int)_value ^ (int)(_value >> 32);
        public override bool Equals(Object obj) => obj is UInt64 u && _value == u._value;
    }
    
    public struct Single
    {
        internal readonly float _value;
        public const float MinValue = -3.40282347E+38f;
        public const float MaxValue = 3.40282347E+38f;
        public const float Epsilon = 1.401298E-45f;
        public const float NaN = 0.0f / 0.0f;
        public const float PositiveInfinity = 1.0f / 0.0f;
        public const float NegativeInfinity = -1.0f / 0.0f;
        
        public override String ToString() => RuntimeHelpers.SingleToString(_value);
        public override int GetHashCode() => RuntimeHelpers.SingleToInt32Bits(_value);
        public override bool Equals(Object obj) => obj is Single f && _value == f._value;
        
        public static bool IsNaN(float f) => f != f;
        public static bool IsInfinity(float f) => f == PositiveInfinity || f == NegativeInfinity;
    }
    
    public struct Double
    {
        internal readonly double _value;
        public const double MinValue = -1.7976931348623157E+308;
        public const double MaxValue = 1.7976931348623157E+308;
        public const double Epsilon = 4.94065645841247E-324;
        public const double NaN = 0.0 / 0.0;
        public const double PositiveInfinity = 1.0 / 0.0;
        public const double NegativeInfinity = -1.0 / 0.0;
        
        public override String ToString() => RuntimeHelpers.DoubleToString(_value);
        public override int GetHashCode()
        {
            long bits = RuntimeHelpers.DoubleToInt64Bits(_value);
            return (int)bits ^ (int)(bits >> 32);
        }
        public override bool Equals(Object obj) => obj is Double d && _value == d._value;
        
        public static bool IsNaN(double d) => d != d;
        public static bool IsInfinity(double d) => d == PositiveInfinity || d == NegativeInfinity;
    }
    
    public struct IntPtr
    {
        internal readonly int _value;
        
        public static readonly IntPtr Zero = new IntPtr(0);
        public static int Size => 4;
        
        public IntPtr(int value) => _value = value;
        
        public int ToInt32() => _value;
        public override String ToString() => RuntimeHelpers.Int32ToString(_value);
        public override int GetHashCode() => _value;
        public override bool Equals(Object obj) => obj is IntPtr p && _value == p._value;
        
        public static bool operator ==(IntPtr a, IntPtr b) => a._value == b._value;
        public static bool operator !=(IntPtr a, IntPtr b) => a._value != b._value;
    }
    
    public struct UIntPtr
    {
        internal readonly uint _value;
        
        public static readonly UIntPtr Zero = new UIntPtr(0);
        public static int Size => 4;
        
        public UIntPtr(uint value) => _value = value;
        
        public uint ToUInt32() => _value;
        public override String ToString() => RuntimeHelpers.UInt32ToString(_value);
        public override int GetHashCode() => (int)_value;
        public override bool Equals(Object obj) => obj is UIntPtr p && _value == p._value;
        
        public static bool operator ==(UIntPtr a, UIntPtr b) => a._value == b._value;
        public static bool operator !=(UIntPtr a, UIntPtr b) => a._value != b._value;
    }
    
    public struct Void { }
}
