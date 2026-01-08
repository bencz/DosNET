using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Test 1: Before GC alloc");
        
        // Teste simples de alocação - criar um objeto
        object obj = new object();
        
        Console.WriteLine("Test 2: After object alloc");
        
        // Teste de array simples
        int[] arr = new int[3];
        
        Console.WriteLine("Test 3: After array alloc");
        
        // Atribuir valores
        arr[0] = 10;
        arr[1] = 20;
        arr[2] = 30;
        
        Console.WriteLine("Test 4: After array assign");
        
        Console.WriteLine("Done!");
    }
}
