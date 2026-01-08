using System;

class Program
{
    static void Main()
    {
        int n = 10;
        int result = Fib(n);
        Console.WriteLine(result);
    }
    
    static int Fib(int n)
    {
        if (n <= 1)
            return n;
        return Fib(n - 1) + Fib(n - 2);
    }
}
