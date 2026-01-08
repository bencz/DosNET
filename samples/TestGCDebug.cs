using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("GC Debug Test");
        Console.WriteLine("Before alloc - if you see this, GC init worked");
        
        // Tentar alocar um objeto muito simples
        object obj = new object();
        
        Console.WriteLine("After alloc - if you see this, allocation worked!");
    }
}
