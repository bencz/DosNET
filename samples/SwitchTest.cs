using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Switch Test");
        
        // Teste switch com int
        for (int i = 0; i < 5; i++)
        {
            TestSwitch(i);
        }
        
        // Teste switch com string
        TestStringSwitch("hello");
        TestStringSwitch("world");
        TestStringSwitch("unknown");
    }
    
    static void TestSwitch(int value)
    {
        switch (value)
        {
            case 0:
                Console.WriteLine("Zero");
                break;
            case 1:
                Console.WriteLine("One");
                break;
            case 2:
                Console.WriteLine("Two");
                break;
            case 3:
                Console.WriteLine("Three");
                break;
            default:
                Console.WriteLine("Other");
                break;
        }
    }
    
    static void TestStringSwitch(string value)
    {
        switch (value)
        {
            case "hello":
                Console.WriteLine("Greeting!");
                break;
            case "world":
                Console.WriteLine("Planet!");
                break;
            default:
                Console.WriteLine("Unknown string");
                break;
        }
    }
}
