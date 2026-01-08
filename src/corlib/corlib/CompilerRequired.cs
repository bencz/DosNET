namespace System
{
    public abstract class Delegate
    {
        internal Object _target;
        internal IntPtr _methodPtr;
        
        public Object Target => _target;
        
        public override bool Equals(Object obj)
        {
            if (obj is Delegate d)
                return _target == d._target && _methodPtr == d._methodPtr;
            return false;
        }
        
        public override int GetHashCode() => _methodPtr.GetHashCode();
    }
    
    public abstract class MulticastDelegate : Delegate
    {
        internal MulticastDelegate _prev;
    }
    
    public struct Nullable<T> where T : struct
    {
        private readonly bool _hasValue;
        private readonly T _value;
        
        public bool HasValue => _hasValue;
        public T Value => _hasValue ? _value : throw new InvalidOperationException("Nullable object must have a value.");
        
        public Nullable(T value)
        {
            _hasValue = true;
            _value = value;
        }
        
        public T GetValueOrDefault() => _value;
        public T GetValueOrDefault(T defaultValue) => _hasValue ? _value : defaultValue;
        
        public override bool Equals(Object other)
        {
            if (!_hasValue) return (object)other == null;
            if ((object)other == null) return false;
            return _value.Equals(other);
        }
        
        public override int GetHashCode() => _hasValue ? _value.GetHashCode() : 0;
        public override String ToString() => _hasValue ? _value.ToString() : "";
    }
    
    public delegate void Action();
    public delegate void Action<in T>(T obj);
    public delegate void Action<in T1, in T2>(T1 arg1, T2 arg2);
    public delegate TResult Func<out TResult>();
    public delegate TResult Func<in T, out TResult>(T arg);
    public delegate TResult Func<in T1, in T2, out TResult>(T1 arg1, T2 arg2);
    public delegate bool Predicate<in T>(T obj);
}

namespace System.Reflection
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Struct | AttributeTargets.Interface)]
    public sealed class DefaultMemberAttribute : Attribute
    {
        public String MemberName { get; }
        
        public DefaultMemberAttribute(String memberName)
        {
            MemberName = memberName;
        }
    }
}

namespace System.Runtime.CompilerServices
{
    [AttributeUsage(AttributeTargets.All, Inherited = true)]
    public sealed class CompilerGeneratedAttribute : Attribute
    {
    }
    
    [AttributeUsage(AttributeTargets.Parameter, Inherited = false)]
    public sealed class CallerMemberNameAttribute : Attribute
    {
    }
    
    [AttributeUsage(AttributeTargets.Parameter, Inherited = false)]
    public sealed class CallerFilePathAttribute : Attribute
    {
    }
    
    [AttributeUsage(AttributeTargets.Parameter, Inherited = false)]
    public sealed class CallerLineNumberAttribute : Attribute
    {
    }
    
    public static class IsExternalInit
    {
    }
    
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Struct | AttributeTargets.Field | AttributeTargets.Property, Inherited = false)]
    public sealed class RequiredMemberAttribute : Attribute
    {
    }
    
    [AttributeUsage(AttributeTargets.All, AllowMultiple = true, Inherited = false)]
    public sealed class CompilerFeatureRequiredAttribute : Attribute
    {
        public String FeatureName { get; }
        public bool IsOptional { get; set; }
        
        public CompilerFeatureRequiredAttribute(String featureName)
        {
            FeatureName = featureName;
        }
    }
    
    [AttributeUsage(AttributeTargets.Module, Inherited = false)]
    public sealed class NullableContextAttribute : Attribute
    {
        public readonly byte Flag;
        public NullableContextAttribute(byte flag) { Flag = flag; }
    }
    
    [AttributeUsage(AttributeTargets.All, Inherited = false)]
    public sealed class NullableAttribute : Attribute
    {
        public readonly byte[] NullableFlags;
        public NullableAttribute(byte flag) { NullableFlags = new byte[] { flag }; }
        public NullableAttribute(byte[] flags) { NullableFlags = flags; }
    }
}

namespace System.Runtime.InteropServices
{
    [AttributeUsage(AttributeTargets.Parameter)]
    public sealed class OutAttribute : Attribute
    {
    }
    
    [AttributeUsage(AttributeTargets.Parameter)]
    public sealed class InAttribute : Attribute
    {
    }
}

namespace System.Diagnostics.CodeAnalysis
{
    [AttributeUsage(AttributeTargets.Constructor, Inherited = false)]
    public sealed class SetsRequiredMembersAttribute : Attribute
    {
    }
}
