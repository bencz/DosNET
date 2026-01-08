using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Before alloc");
        
        // Alocar um objeto simples (object)
        object obj = new object();
        
        Console.WriteLine("After alloc");
    }
}
