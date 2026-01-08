namespace System
{
    public abstract class Type
    {
        public abstract String Name { get; }
        public abstract String Namespace { get; }
        public abstract String FullName { get; }
        public abstract Type BaseType { get; }
        public abstract bool IsValueType { get; }
        public abstract bool IsClass { get; }
        public abstract bool IsInterface { get; }
        public abstract bool IsEnum { get; }
        public abstract bool IsArray { get; }
        
        public override String ToString()
        {
            return FullName;
        }
        
        public override bool Equals(Object obj)
        {
            if (obj is Type t)
                return this == t;
            return false;
        }
        
        public override int GetHashCode()
        {
            return FullName.GetHashCode();
        }
        
        public static bool operator ==(Type left, Type right)
        {
            if (Object.ReferenceEquals(left, right))
                return true;
            if ((object)left == null || (object)right == null)
                return false;
            return left.FullName == right.FullName;
        }
        
        public static bool operator !=(Type left, Type right)
        {
            return !(left == right);
        }
        
        public static Type GetType(String typeName)
        {
            return RuntimeType.GetType(typeName);
        }
    }
    
    internal sealed class RuntimeType : Type
    {
        private readonly int _typeIndex;
        private readonly String _name;
        private readonly String _namespace;
        private readonly RuntimeType _baseType;
        private readonly TypeFlags _flags;
        
        internal RuntimeType(int typeIndex, String name, String ns, RuntimeType baseType, TypeFlags flags)
        {
            _typeIndex = typeIndex;
            _name = name;
            _namespace = ns;
            _baseType = baseType;
            _flags = flags;
        }
        
        public override String Name => _name;
        public override String Namespace => _namespace;
        public override String FullName => String.IsNullOrEmpty(_namespace) ? _name : _namespace + "." + _name;
        public override Type BaseType => _baseType;
        public override bool IsValueType => (_flags & TypeFlags.ValueType) != 0;
        public override bool IsClass => !IsValueType && !IsInterface;
        public override bool IsInterface => (_flags & TypeFlags.Interface) != 0;
        public override bool IsEnum => (_flags & TypeFlags.Enum) != 0;
        public override bool IsArray => (_flags & TypeFlags.Array) != 0;
        
        internal static new Type GetType(String typeName)
        {
            return null;
        }
        
        [Flags]
        internal enum TypeFlags
        {
            None = 0,
            ValueType = 1,
            Interface = 2,
            Enum = 4,
            Array = 8,
        }
    }
}
