using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Step 1");
        
        // Apenas criar um array de chars (usado internamente por Int32ToString)
        char[] chars = new char[5];
        
        Console.WriteLine("Step 2");
        
        // Atribuir um caractere
        chars[0] = 'A';
        
        Console.WriteLine("Step 3");
        
        Console.WriteLine("Done");
    }
}
