namespace System
{
    public class Object
    {
        public virtual bool Equals(Object obj)
        {
            return ReferenceEquals(this, obj);
        }
        
        public virtual int GetHashCode()
        {
            return RuntimeHelpers.GetHashCode(this);
        }
        
        public virtual String ToString()
        {
            return GetType().FullName;
        }
        
        public Type GetType()
        {
            return RuntimeHelpers.GetTypeFromHandle(RuntimeHelpers.GetTypeHandle(this));
        }
        
        protected virtual void Finalize()
        {
        }
        
        protected Object MemberwiseClone()
        {
            return RuntimeHelpers.MemberwiseClone(this);
        }
        
        public static bool Equals(Object objA, Object objB)
        {
            if ((object)objA == (object)objB)
                return true;
            if ((object)objA == null || (object)objB == null)
                return false;
            return objA.Equals(objB);
        }
        
        public static bool ReferenceEquals(Object objA, Object objB)
        {
            return (object)objA == (object)objB;
        }
    }
}