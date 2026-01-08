namespace DosNet.Compiler;

/// <summary>
/// Entry point do DosNET Compiler
/// </summary>
public class Program
{
    public static int Main(string[] args)
    {
        var options = CommandLineParser.Parse(args);
        
        if (options == null)
            return 1;
        
        if (options.ShowHelp)
        {
            CommandLineParser.ShowHelp();
            return 0;
        }
        
        if (options.ShowVersion)
        {
            CommandLineParser.ShowVersion();
            return 0;
        }
        
        if (string.IsNullOrEmpty(options.InputFile))
        {
            Console.Error.WriteLine("error: No input file specified");
            Console.Error.WriteLine("Use --help for usage information");
            return 1;
        }
        
        // Banner
        Console.WriteLine($"DosNET Compiler v{GetVersion()}");
        Console.WriteLine($"Target: x86/{options.RuntimeOptions.CpuLevel}");
        Console.WriteLine();
        
        // Compilar
        var compiler = new Compiler(options);
        return compiler.Compile();
    }
    
    private static string GetVersion() => "0.1.0";
}