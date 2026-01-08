using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Exception Test");
        
        // Teste try-catch básico
        try
        {
            Console.WriteLine("Before throw");
            ThrowException();
            Console.WriteLine("After throw (should not print)");
        }
        catch (Exception ex)
        {
            Console.WriteLine("Caught exception:");
            Console.WriteLine(ex.Message);
        }
        
        // Teste try-finally
        try
        {
            Console.WriteLine("In try block");
            return;
        }
        finally
        {
            Console.WriteLine("Finally executed");
        }
    }
    
    static void ThrowException()
    {
        throw new InvalidOperationException("Test exception message");
    }
}
