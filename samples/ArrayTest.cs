using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Array Test");
        
        // Array de inteiros
        int[] numbers = new int[5];
        numbers[0] = 10;
        numbers[1] = 20;
        numbers[2] = 30;
        numbers[3] = 40;
        numbers[4] = 50;
        
        Console.WriteLine("Array length:");
        Console.WriteLine(numbers.Length);
        
        Console.WriteLine("Array elements:");
        for (int i = 0; i < numbers.Length; i++)
        {
            Console.WriteLine(numbers[i]);
        }
        
        // Array de strings
        string[] names = new string[3];
        names[0] = "Alice";
        names[1] = "Bob";
        names[2] = "Charlie";
        
        Console.WriteLine("Names:");
        for (int i = 0; i < names.Length; i++)
        {
            Console.WriteLine(names[i]);
        }
        
        // Array.Copy
        int[] copy = new int[5];
        Array.Copy(numbers, copy, 5);
        
        Console.WriteLine("Copied array:");
        for (int i = 0; i < copy.Length; i++)
        {
            Console.WriteLine(copy[i]);
        }
        
        // Array.IndexOf
        int index = Array.IndexOf(names, "Bob");
        Console.WriteLine("Index of Bob:");
        Console.WriteLine(index);
    }
}
