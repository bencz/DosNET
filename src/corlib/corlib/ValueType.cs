namespace System
{
    public abstract class ValueType
    {
        public override bool Equals(Object obj)
        {
            if ((object)obj == null)
                return false;
            
            if (GetType() != obj.GetType())
                return false;
            
            return RuntimeHelpers.ValueTypeEquals(this, obj);
        }
        
        public override int GetHashCode()
        {
            return RuntimeHelpers.ValueTypeGetHashCode(this);
        }
        
        public override String ToString()
        {
            return GetType().FullName;
        }
    }
}
