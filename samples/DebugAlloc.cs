using System;

class Program
{
    static void Main()
    {
        // Teste 1: String literal (não usa GC)
        Console.WriteLine("1-Start");
        
        // Teste 2: Criar objeto simples
        Console.WriteLine("2-Before new");
        
        object o = new object();
        
        Console.WriteLine("3-After new");
        
        Console.WriteLine("4-Done");
    }
}
