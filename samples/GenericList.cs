using System;

class Program
{
    static void Main()
    {
        // Teste com List<int>
        var numbers = new SimpleList<int>();
        numbers.Add(10);
        numbers.Add(20);
        numbers.Add(30);
        
        Console.WriteLine("Numbers:");
        for (int i = 0; i < numbers.Count; i++)
        {
            Console.WriteLine(numbers.Get(i));
        }
        
        // Teste com List<string>
        var names = new SimpleList<string>();
        names.Add("Alice");
        names.Add("Bob");
        names.Add("Charlie");
        
        Console.WriteLine("Names:");
        for (int i = 0; i < names.Count; i++)
        {
            Console.WriteLine(names.Get(i));
        }
    }
}

class SimpleList<T>
{
    private T[] _items;
    private int _count;
    
    public SimpleList()
    {
        _items = new T[4];
        _count = 0;
    }
    
    public int Count => _count;
    
    public void Add(T item)
    {
        if (_count >= _items.Length)
        {
            // Expandir array
            var newItems = new T[_items.Length * 2];
            Array.Copy(_items, newItems, _count);
            _items = newItems;
        }
        _items[_count++] = item;
    }
    
    public T Get(int index)
    {
        if (index < 0 || index >= _count)
            throw new IndexOutOfRangeException();
        return _items[index];
    }
}
