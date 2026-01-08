namespace System
{
    public sealed class String
    {
        internal readonly int _length;
        internal readonly char _firstChar;
        
        public int Length => _length;
        
        public String(char[] value)
        {
            if (value == null || value.Length == 0)
            {
                _length = 0;
                _firstChar = '\0';
                return;
            }
            _length = value.Length;
            _firstChar = value[0];
            // Os demais caracteres são copiados pelo runtime
            RuntimeHelpers.CopyCharsToString(this, value);
        }
        
        public char this[int index]
        {
            get
            {
                if ((uint)index >= (uint)_length)
                    throw new IndexOutOfRangeException();
                return RuntimeHelpers.GetCharAt(this, index);
            }
        }
        
        public static readonly String Empty = "";
        
        public static bool IsNullOrEmpty(String value)
        {
            return (object)value == null || value.Length == 0;
        }
        
        public static bool IsNullOrWhiteSpace(String value)
        {
            if ((object)value == null)
                return true;
            
            for (int i = 0; i < value.Length; i++)
            {
                if (!Char.IsWhiteSpace(value[i]))
                    return false;
            }
            return true;
        }
        
        public override bool Equals(Object obj)
        {
            if (obj is String str)
                return Equals(this, str);
            return false;
        }
        
        public bool Equals(String value)
        {
            return Equals(this, value);
        }
        
        public static bool Equals(String a, String b)
        {
            if (Object.ReferenceEquals(a, b))
                return true;
            if ((object)a == null || (object)b == null)
                return false;
            if (a.Length != b.Length)
                return false;
            
            return RuntimeHelpers.StringEquals(a, b);
        }
        
        public override int GetHashCode()
        {
            return RuntimeHelpers.StringGetHashCode(this);
        }
        
        public override String ToString()
        {
            return this;
        }
        
        public static String Concat(String str0, String str1)
        {
            if (IsNullOrEmpty(str0))
                return str1 ?? Empty;
            if (IsNullOrEmpty(str1))
                return str0;
            
            return RuntimeHelpers.StringConcat(str0, str1);
        }
        
        public static String Concat(String str0, String str1, String str2)
        {
            return Concat(Concat(str0, str1), str2);
        }
        
        public static String Concat(String str0, String str1, String str2, String str3)
        {
            return Concat(Concat(str0, str1), Concat(str2, str3));
        }
        
        public static bool operator ==(String a, String b)
        {
            return Equals(a, b);
        }
        
        public static bool operator !=(String a, String b)
        {
            return !Equals(a, b);
        }
    }
}
