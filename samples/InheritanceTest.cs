using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Inheritance and Virtual Methods Test");
        
        // Teste de polimorfismo
        Animal[] animals = new Animal[3];
        animals[0] = new Dog("Rex");
        animals[1] = new Cat("Whiskers");
        animals[2] = new Dog("Buddy");
        
        for (int i = 0; i < 3; i++)
        {
            animals[i].Speak();
        }
        
        // Teste de override
        Console.WriteLine("Testing ToString override:");
        Dog dog = new Dog("Max");
        Console.WriteLine(dog.ToString());
    }
}

abstract class Animal
{
    protected string _name;
    
    public Animal(string name)
    {
        _name = name;
    }
    
    public abstract void Speak();
    
    public override string ToString()
    {
        return "Animal: " + _name;
    }
}

class Dog : Animal
{
    public Dog(string name) : base(name) { }
    
    public override void Speak()
    {
        Console.WriteLine(_name + " says: Woof!");
    }
    
    public override string ToString()
    {
        return "Dog: " + _name;
    }
}

class Cat : Animal
{
    public Cat(string name) : base(name) { }
    
    public override void Speak()
    {
        Console.WriteLine(_name + " says: Meow!");
    }
}
