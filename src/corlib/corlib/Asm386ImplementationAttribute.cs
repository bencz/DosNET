namespace System
{
    [AttributeUsage(AttributeTargets.Method, AllowMultiple = false)]
    public sealed class Asm386ImplementationAttribute : Attribute
    {
        public String Assembly { get; }
        public String SoftFloatAssembly { get; }
        
        public Asm386ImplementationAttribute(String assembly)
        {
            Assembly = assembly;
        }
        
        public Asm386ImplementationAttribute(String assembly, String softFloatAssembly)
        {
            Assembly = assembly;
            SoftFloatAssembly = softFloatAssembly;
        }
    }
    
    [AttributeUsage(AttributeTargets.Method, AllowMultiple = false)]
    public sealed class Asm386IntrinsicAttribute : Attribute
    {
        public String IntrinsicName { get; }
        
        public Asm386IntrinsicAttribute(String intrinsicName)
        {
            IntrinsicName = intrinsicName;
        }
    }
    
    [AttributeUsage(AttributeTargets.Struct | AttributeTargets.Class, AllowMultiple = false)]
    public sealed class Asm386LayoutAttribute : Attribute
    {
        public int Size { get; set; }
        public int Alignment { get; set; } = 4;
    }
    
    [AttributeUsage(AttributeTargets.All, AllowMultiple = true)]
    public sealed class AttributeUsageAttribute : Attribute
    {
        public AttributeTargets ValidOn { get; }
        public bool AllowMultiple { get; set; }
        public bool Inherited { get; set; } = true;
        
        public AttributeUsageAttribute(AttributeTargets validOn)
        {
            ValidOn = validOn;
        }
    }
    
    public abstract class Attribute
    {
    }
    
    [Flags]
    public enum AttributeTargets
    {
        Assembly = 1,
        Module = 2,
        Class = 4,
        Struct = 8,
        Enum = 16,
        Constructor = 32,
        Method = 64,
        Property = 128,
        Field = 256,
        Event = 512,
        Interface = 1024,
        Parameter = 2048,
        Delegate = 4096,
        ReturnValue = 8192,
        GenericParameter = 16384,
        All = 32767
    }
    
    [AttributeUsage(AttributeTargets.All)]
    public sealed class FlagsAttribute : Attribute
    {
    }
}
