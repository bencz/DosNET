using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Interface Test");
        
        // Teste de interface
        IShape[] shapes = new IShape[3];
        shapes[0] = new Circle(5);
        shapes[1] = new Rectangle(4, 6);
        shapes[2] = new Circle(3);
        
        for (int i = 0; i < 3; i++)
        {
            Console.WriteLine("Area:");
            Console.WriteLine(shapes[i].GetArea());
        }
        
        // Teste de múltiplas interfaces
        Printer printer = new Printer();
        TestPrintable(printer);
        TestDisposable(printer);
    }
    
    static void TestPrintable(IPrintable p)
    {
        p.Print();
    }
    
    static void TestDisposable(IDisposable d)
    {
        d.Dispose();
    }
}

interface IShape
{
    int GetArea();
}

interface IPrintable
{
    void Print();
}

interface IDisposable
{
    void Dispose();
}

class Circle : IShape
{
    private int _radius;
    
    public Circle(int radius)
    {
        _radius = radius;
    }
    
    public int GetArea()
    {
        return 3 * _radius * _radius; // Aproximação de PI
    }
}

class Rectangle : IShape
{
    private int _width;
    private int _height;
    
    public Rectangle(int width, int height)
    {
        _width = width;
        _height = height;
    }
    
    public int GetArea()
    {
        return _width * _height;
    }
}

class Printer : IPrintable, IDisposable
{
    public void Print()
    {
        Console.WriteLine("Printing...");
    }
    
    public void Dispose()
    {
        Console.WriteLine("Disposed");
    }
}
