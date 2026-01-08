namespace System
{
    public abstract class Enum : ValueType
    {
        public override String ToString()
        {
            return base.ToString();
        }
        
        public override bool Equals(Object obj)
        {
            return base.Equals(obj);
        }
        
        public override int GetHashCode()
        {
            return base.GetHashCode();
        }
    }
}
