using System;

class MyClass
{
    public int Value;
}

class Program
{
    static void Main()
    {
        Console.WriteLine("Step 1");
        
        // Alocar um objeto simples
        MyClass obj = new MyClass();
        
        Console.WriteLine("Step 2");
        
        obj.Value = 42;
        
        Console.WriteLine("Step 3");
        
        Console.WriteLine("Done");
    }
}
