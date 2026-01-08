using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Nullable Test");
        
        // Teste Nullable<int>
        int? a = 42;
        int? b = null;
        
        if (a.HasValue)
        {
            Console.WriteLine("a has value:");
            Console.WriteLine(a.Value);
        }
        
        if (!b.HasValue)
        {
            Console.WriteLine("b is null");
        }
        
        // Teste GetValueOrDefault
        int defaultValue = b.GetValueOrDefault(100);
        Console.WriteLine("Default value:");
        Console.WriteLine(defaultValue);
        
        // Teste com struct customizado
        Point? p1 = new Point(10, 20);
        Point? p2 = null;
        
        if (p1.HasValue)
        {
            Console.WriteLine("Point has value");
        }
        
        if (!p2.HasValue)
        {
            Console.WriteLine("Point is null");
        }
    }
}

struct Point
{
    public int X;
    public int Y;
    
    public Point(int x, int y)
    {
        X = x;
        Y = y;
    }
}
