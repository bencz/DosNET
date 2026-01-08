using System;

class Point
{
    public int X;
    public int Y;
    
    public Point(int x, int y)
    {
        X = x;
        Y = y;
    }
    
    public int Sum()
    {
        return X + Y;
    }
}

class Program
{
    static void Main()
    {
        Point p = new Point(3, 4);
        int sum = p.Sum();
        Console.WriteLine(sum);
    }
}
