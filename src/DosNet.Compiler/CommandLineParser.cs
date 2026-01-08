using DosNet.Core.Runtime;

namespace DosNet.Compiler;

/// <summary>
/// Parser de argumentos de linha de comando
/// </summary>
public static class CommandLineParser
{
    public static CompilerOptions Parse(string[] args)
    {
        var options = new CompilerOptions();
        
        for (int i = 0; i < args.Length; i++)
        {
            var arg = args[i];
            
            switch (arg)
            {
                case "-h":
                case "--help":
                    options.ShowHelp = true;
                    return options;
                
                case "--version":
                    options.ShowVersion = true;
                    return options;
                
                case "-v":
                case "--verbose":
                    options.Verbose = true;
                    break;
                
                case "-o":
                case "--output":
                    if (i + 1 >= args.Length)
                    {
                        Console.Error.WriteLine("error: -o requires an argument");
                        return null;
                    }
                    options.OutputFile = args[++i];
                    break;
                
                case "-nostdlib":
                    options.NoStdLib = true;
                    break;
                
                case "--corlib":
                    if (i + 1 >= args.Length)
                    {
                        Console.Error.WriteLine("error: --corlib requires an argument");
                        return null;
                    }
                    options.CorlibPath = args[++i];
                    break;
                
                case "--soft-float-only":
                    options.RuntimeOptions.SoftFloatOnly = true;
                    options.RuntimeOptions.FpuDetect = false;
                    break;
                
                case "--fpu-required":
                    options.RuntimeOptions.FpuRequired = true;
                    options.RuntimeOptions.FpuDetect = false;
                    break;
                
                case "--fpu-detect":
                    options.RuntimeOptions.FpuDetect = true;
                    break;
                
                case "--no-gc":
                    options.RuntimeOptions.EnableGC = false;
                    break;
                
                case "--no-reflection":
                    options.RuntimeOptions.EnableReflection = false;
                    break;
                
                case "--no-exceptions":
                    options.RuntimeOptions.EnableExceptions = false;
                    break;
                
                case "-O0":
                    options.OptimizationLevel = 0;
                    break;
                
                case "-O1":
                    options.OptimizationLevel = 1;
                    break;
                
                case "-O2":
                    options.OptimizationLevel = 2;
                    break;
                
                case "-O3":
                    options.OptimizationLevel = 3;
                    break;
                
                default:
                    if (arg.StartsWith("--cpu="))
                    {
                        var cpu = arg.Substring(6).ToLower();
                        options.RuntimeOptions.CpuLevel = cpu switch
                        {
                            "i386" or "386" => CpuLevel.I386,
                            "i486" or "486" => CpuLevel.I486,
                            "i586" or "586" or "pentium" => CpuLevel.I586,
                            _ => throw new ArgumentException($"Unknown CPU level: {cpu}")
                        };
                    }
                    else if (arg.StartsWith("--heap="))
                    {
                        var sizeStr = arg.Substring(7);
                        options.RuntimeOptions.HeapSize = ParseSize(sizeStr);
                    }
                    else if (arg.StartsWith("--stack="))
                    {
                        var sizeStr = arg.Substring(8);
                        options.RuntimeOptions.StackSize = ParseSize(sizeStr);
                    }
                    else if (arg.StartsWith("-"))
                    {
                        Console.Error.WriteLine($"error: Unknown option: {arg}");
                        return null;
                    }
                    else
                    {
                        // Arquivo de entrada
                        options.InputFile = arg;
                    }
                    break;
            }
        }
        
        return options;
    }
    
    private static int ParseSize(string sizeStr)
    {
        sizeStr = sizeStr.ToUpper();
        int multiplier = 1;
        
        if (sizeStr.EndsWith("K"))
        {
            multiplier = 1024;
            sizeStr = sizeStr.Substring(0, sizeStr.Length - 1);
        }
        else if (sizeStr.EndsWith("M"))
        {
            multiplier = 1024 * 1024;
            sizeStr = sizeStr.Substring(0, sizeStr.Length - 1);
        }
        
        return int.Parse(sizeStr) * multiplier;
    }
    
    public static void ShowHelp()
    {
        Console.WriteLine(@"DosNET Compiler - .NET to DOS Transpiler

USAGE:
    dosnetc [OPTIONS] <INPUT>

ARGUMENTS:
    <INPUT>                         Input assembly (.dll or .exe)

OPTIONS:
    -o, --output <FILE>             Output file (default: <input>.asm)
    -h, --help                      Show help
    --version                       Show version
    -v, --verbose                   Verbose output

CORLIB OPTIONS:
    -nostdlib                       Don't use standard library (for compiling corlib itself)
    --corlib <PATH>                 Path to custom corlib.dll

ARCHITECTURE OPTIONS:
    --cpu=<CPU>                     CPU level: i386 (default), i486, i586

FLOATING POINT:
    --fpu-detect                    Detect FPU at runtime (default)
    --fpu-required                  Require FPU, fail if not present
    --soft-float-only               Always use software float emulation

MEMORY:
    --heap=<SIZE>                   Heap size (default: 4M). Suffixes: K, M
    --stack=<SIZE>                  Stack size (default: 64K). Suffixes: K, M

RUNTIME FEATURES:
    --no-gc                         Disable garbage collector
    --no-reflection                 Disable reflection support
    --no-exceptions                 Disable exception handling

OPTIMIZATION:
    -O0                             No optimizations
    -O1                             Basic optimizations (default)
    -O2                             Aggressive optimizations
    -O3                             Maximum optimizations

EXAMPLES:
    # Basic compilation
    dosnetc MyApp.dll

    # Specify output file
    dosnetc -o game.asm Game.dll

    # Target i486 CPU
    dosnetc --cpu=i486 MyApp.dll

    # Compile corlib itself
    dosnetc -nostdlib corlib.dll

    # Software float only (for i386/i486 without FPU)
    dosnetc --soft-float-only Calculator.dll

    # Large heap
    dosnetc --heap=16M BigApp.dll
");
    }
    
    public static void ShowVersion()
    {
        Console.WriteLine("DosNET Compiler v0.1.0");
        Console.WriteLine("Target: x86 (i386/i486/i586)");
        Console.WriteLine("Output: MASM 6.x compatible assembly");
    }
}
