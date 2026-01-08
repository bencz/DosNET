namespace System
{
    public class Exception
    {
        private readonly String _message;
        private readonly Exception _innerException;
        
        public Exception()
        {
            _message = "Exception of type '" + GetType().FullName + "' was thrown.";
        }
        
        public Exception(String message)
        {
            _message = message;
        }
        
        public Exception(String message, Exception innerException)
        {
            _message = message;
            _innerException = innerException;
        }
        
        public virtual String Message => _message;
        public Exception InnerException => _innerException;
        
        public override String ToString()
        {
            return GetType().FullName + ": " + Message;
        }
    }
    
    public class SystemException : Exception
    {
        public SystemException() : base() { }
        public SystemException(String message) : base(message) { }
        public SystemException(String message, Exception innerException) : base(message, innerException) { }
    }
    
    public class NullReferenceException : SystemException
    {
        public NullReferenceException() : base("Object reference not set to an instance of an object.") { }
        public NullReferenceException(String message) : base(message) { }
    }
    
    public class InvalidOperationException : SystemException
    {
        public InvalidOperationException() : base("Operation is not valid due to the current state of the object.") { }
        public InvalidOperationException(String message) : base(message) { }
    }
    
    public class ArgumentException : SystemException
    {
        public ArgumentException() : base("Value does not fall within the expected range.") { }
        public ArgumentException(String message) : base(message) { }
    }
    
    public class ArgumentNullException : ArgumentException
    {
        public ArgumentNullException() : base("Value cannot be null.") { }
        public ArgumentNullException(String paramName) : base("Value cannot be null. Parameter name: " + paramName) { }
    }
    
    public class ArgumentOutOfRangeException : ArgumentException
    {
        public ArgumentOutOfRangeException() : base("Specified argument was out of the range of valid values.") { }
        public ArgumentOutOfRangeException(String paramName) : base("Specified argument was out of the range of valid values. Parameter name: " + paramName) { }
    }
    
    public class IndexOutOfRangeException : SystemException
    {
        public IndexOutOfRangeException() : base("Index was outside the bounds of the array.") { }
        public IndexOutOfRangeException(String message) : base(message) { }
    }
    
    public class OutOfMemoryException : SystemException
    {
        public OutOfMemoryException() : base("Insufficient memory to continue the execution of the program.") { }
        public OutOfMemoryException(String message) : base(message) { }
    }
    
    public class OverflowException : SystemException
    {
        public OverflowException() : base("Arithmetic operation resulted in an overflow.") { }
        public OverflowException(String message) : base(message) { }
    }
    
    public class DivideByZeroException : SystemException
    {
        public DivideByZeroException() : base("Attempted to divide by zero.") { }
        public DivideByZeroException(String message) : base(message) { }
    }
    
    public class NotSupportedException : SystemException
    {
        public NotSupportedException() : base("Specified method is not supported.") { }
        public NotSupportedException(String message) : base(message) { }
    }
    
    public class NotImplementedException : SystemException
    {
        public NotImplementedException() : base("The method or operation is not implemented.") { }
        public NotImplementedException(String message) : base(message) { }
    }
}
