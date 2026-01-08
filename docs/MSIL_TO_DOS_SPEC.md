# MSIL to i386+ DOS Assembly Transpiler

## Especificacao Completa do Projeto

---

## 1. Visao Geral

### Target
```
┌─────────────────────────────────────────────────────────────────┐
│  TARGET MINIMO: Intel 80386 (1985)                              │
│                                                                  │
│  Suporte:                                                        │
│    - 80386 (DX/SX) - com ou sem 80387                          │
│    - 80486SX - sem FPU integrada                                │
│    - 80486DX - com FPU integrada                                │
│    - Pentium+ - sempre com FPU                                  │
│                                                                  │
│  Deteccao em Runtime:                                           │
│    - Se FPU presente: usa instrucoes x87 nativas               │
│    - Se FPU ausente: usa emulacao IEEE 754 em software         │
│                                                                  │
│  Ambiente: DOS (Real Mode ou Flat Real Mode)                    │
└─────────────────────────────────────────────────────────────────┘
```

### Features do i386 utilizadas
| Feature | Descricao | Uso no Projeto |
|---------|-----------|----------------|
| Registradores 32-bit | EAX, EBX, ECX, EDX, ESI, EDI, EBP, ESP | Tudo |
| Modos de enderecamento | [EBX+ESI*4+disp] | Arrays, objetos |
| IMUL reg,reg,imm | Multiplicacao em uma instrucao | Aritmetica |
| MOVZX/MOVSX | Extensao zero/sinal | Conversoes |
| SHL/SHR reg,imm | Shift com imediato | Bitwise |
| PUSH imm32 | Push de constante 32-bit | Constantes |
| SET** | Set byte condicional | Comparacoes |
| Flat Real Mode | Acesso a 4GB em modo real | Heap grande |

### Features NAO utilizadas (manter compatibilidade i386)
| Feature | CPU Minima | Status |
|---------|-----------|--------|
| BSWAP | i486 | Nao usado |
| CMPXCHG | i486 | Nao usado |
| XADD | i486 | Nao usado |
| CPUID | Pentium | Nao usado (deteccao alternativa) |
| RDTSC | Pentium | Nao usado |
| CMOVcc | Pentium Pro | Nao usado |

---

## 2. Arquitetura do Compilador

```
┌──────────────────────────────────────────────────────────────────┐
│                         INPUT                                     │
│                  .NET Assembly (.dll/.exe)                        │
└──────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                      IL READER                                    │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ System.Reflection.Metadata (built-in no .NET)              │  │
│  │ - TypeDefinitions                                          │  │
│  │ - MethodDefinitions + IL bytecode                          │  │
│  │ - FieldDefinitions                                         │  │
│  │ - PropertyDefinitions                                      │  │
│  │ - CustomAttributes (AsmImplementation, etc)                │  │
│  │ - GenericParameters                                        │  │
│  └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                   ANALYSIS PHASE                                  │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  │
│  │ Type Hierarchy  │  │ Generic Usage   │  │ Call Graph      │  │
│  │ - Base types    │  │ - Instantiations│  │ - Direct calls  │  │
│  │ - Interfaces    │  │ - Constraints   │  │ - Virtual calls │  │
│  │ - Virtual slots │  │ - Monomorphize  │  │ - Interface     │  │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                  METADATA BUILDER                                 │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ TypeDefTable    - Informacoes de tipo para reflection       │ │
│  │ MethodDefTable  - Metodos com ponteiros para codigo         │ │
│  │ FieldDefTable   - Campos com offsets                        │ │
│  │ PropertyDefTable- Propriedades (getter/setter)              │ │
│  │ VTableTable     - Virtual method dispatch                   │ │
│  │ InterfaceMap    - Interface method dispatch                 │ │
│  │ StringHeap      - Pool de strings                           │ │
│  │ GenericInstTable- Instanciacoes de generics                 │ │
│  └─────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                   CODE GENERATOR                                  │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ Para cada metodo:                                           │ │
│  │   1. Gerar prologo (stack frame)                           │ │
│  │   2. Para cada instrucao IL:                               │ │
│  │      - Mapear para instrucoes i386                         │ │
│  │      - Operacoes float: x87 OU soft-float (flag global)    │ │
│  │   3. Gerar epilogo                                         │ │
│  │                                                             │ │
│  │ Calling Convention: cdecl (caller cleans stack)            │ │
│  │ - Argumentos: pushed right-to-left                         │ │
│  │ - Retorno int: EAX (32-bit) ou EDX:EAX (64-bit)           │ │
│  │ - Retorno float: ST(0)                                     │ │
│  └─────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                  RUNTIME GENERATOR                                │
│  ┌────────────────┐ ┌────────────────┐ ┌────────────────┐       │
│  │ Startup        │ │ GC             │ │ Reflection     │       │
│  │ - CPU detect   │ │ - Mark/Sweep   │ │ - GetType      │       │
│  │ - FPU detect   │ │ - Alloc        │ │ - GetProps     │       │
│  │ - Flat Real    │ │ - Collect      │ │ - GetValue     │       │
│  │ - Init heap    │ │ - Compact      │ │ - SetValue     │       │
│  └────────────────┘ └────────────────┘ └────────────────┘       │
│  ┌────────────────┐ ┌────────────────┐ ┌────────────────┐       │
│  │ Soft Float     │ │ JSON           │ │ Strings        │       │
│  │ - IEEE 754     │ │ - Serialize    │ │ - Concat       │       │
│  │ - Add/Sub/Mul  │ │ - Deserialize  │ │ - Compare      │       │
│  │ - Div/Sqrt     │ │ - Parse        │ │ - Format       │       │
│  │ - Conv         │ │ - Stringify    │ │ - Substring    │       │
│  └────────────────┘ └────────────────┘ └────────────────┘       │
└──────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│                        OUTPUT                                     │
│                  Assembly i386 (.asm)                             │
│            Compativel: MASM 6+, TASM 5+, NASM, FASM              │
└──────────────────────────────────────────────────────────────────┘
```

---

## 3. Estrutura de Diretorios

```
MsilToDos/
│
├── MsilToDos.sln                       # Solution Visual Studio
│
├── src/
│   ├── Compiler/                       # Projeto principal do compilador
│   │   ├── Compiler.csproj
│   │   ├── Program.cs                  # Entry point CLI
│   │   ├── CompilerOptions.cs          # Opcoes de compilacao
│   │   │
│   │   ├── IL/                         # Leitura de IL
│   │   │   ├── AssemblyReader.cs       # Le assembly .NET
│   │   │   ├── MethodBodyReader.cs     # Decodifica IL bytecode
│   │   │   ├── ILInstruction.cs        # Representacao de instrucao
│   │   │   └── OpCodes.cs              # Enum de opcodes IL
│   │   │
│   │   ├── Analysis/                   # Analise semantica
│   │   │   ├── TypeHierarchyBuilder.cs # Hierarquia de tipos
│   │   │   ├── CallGraphBuilder.cs     # Grafo de chamadas
│   │   │   ├── GenericAnalyzer.cs      # Analise de generics
│   │   │   ├── EscapeAnalyzer.cs       # Stack vs heap allocation
│   │   │   └── FlowAnalyzer.cs         # Control flow
│   │   │
│   │   ├── Metadata/                   # Tabelas de metadata
│   │   │   ├── MetadataBuilder.cs      # Builder principal
│   │   │   ├── Tables/
│   │   │   │   ├── TypeDefTable.cs
│   │   │   │   ├── MethodDefTable.cs
│   │   │   │   ├── FieldDefTable.cs
│   │   │   │   ├── PropertyDefTable.cs
│   │   │   │   └── StringHeap.cs
│   │   │   ├── VTableBuilder.cs        # Virtual dispatch
│   │   │   ├── InterfaceMapBuilder.cs  # Interface dispatch
│   │   │   └── GenericInstantiator.cs  # Monomorphization
│   │   │
│   │   ├── CodeGen/                    # Geracao de codigo
│   │   │   ├── AssemblyGenerator.cs    # Coordena geracao
│   │   │   ├── MethodCompiler.cs       # IL -> i386 por metodo
│   │   │   ├── InstructionEmitter.cs   # Emite instrucoes
│   │   │   ├── Emitters/               # Emissores especializados
│   │   │   │   ├── ArithmeticEmitter.cs
│   │   │   │   ├── ComparisonEmitter.cs
│   │   │   │   ├── BranchEmitter.cs
│   │   │   │   ├── CallEmitter.cs
│   │   │   │   ├── LoadStoreEmitter.cs
│   │   │   │   ├── ConversionEmitter.cs
│   │   │   │   ├── ObjectEmitter.cs
│   │   │   │   └── ArrayEmitter.cs
│   │   │   ├── FpuEmitter.cs           # Codigo x87
│   │   │   ├── SoftFloatEmitter.cs     # Codigo soft-float
│   │   │   ├── RegisterAllocator.cs    # Alocacao de regs
│   │   │   └── StackManager.cs         # Eval stack
│   │   │
│   │   ├── Runtime/                    # Geracao de runtime
│   │   │   ├── RuntimeGenerator.cs     # Coordena runtime
│   │   │   ├── StartupGenerator.cs     # Codigo de inicializacao
│   │   │   ├── GCGenerator.cs          # Garbage collector
│   │   │   ├── ReflectionGenerator.cs  # Reflection runtime
│   │   │   ├── JsonGenerator.cs        # JSON serializer
│   │   │   ├── StringGenerator.cs      # String operations
│   │   │   ├── MathGenerator.cs        # Math functions
│   │   │   ├── ArrayGenerator.cs       # Array operations
│   │   │   ├── ExceptionGenerator.cs   # Exception handling
│   │   │   ├── SoftFloatGenerator.cs   # IEEE 754 emulation
│   │   │   └── DosInterrupts.cs        # INT 21h wrappers
│   │   │
│   │   ├── Optimization/               # Otimizacoes
│   │   │   ├── Inliner.cs
│   │   │   ├── Devirtualizer.cs
│   │   │   ├── ConstantFolder.cs
│   │   │   ├── DeadCodeEliminator.cs
│   │   │   └── PeepholeOptimizer.cs
│   │   │
│   │   └── Output/                     # Escrita de output
│   │       ├── AsmWriter.cs            # Writer base
│   │       ├── MasmWriter.cs           # Sintaxe MASM
│   │       ├── TasmWriter.cs           # Sintaxe TASM
│   │       ├── NasmWriter.cs           # Sintaxe NASM
│   │       └── FasmWriter.cs           # Sintaxe FASM
│   │
│   └── BCL/                            # Base Class Library
│       ├── BCL.csproj
│       │
│       ├── Attributes/                 # Atributos especiais
│       │   ├── AsmImplementationAttribute.cs
│       │   ├── AsmIntrinsicAttribute.cs
│       │   └── AsmLayoutAttribute.cs
│       │
│       ├── System/
│       │   ├── Object.cs
│       │   ├── String.cs
│       │   ├── Console.cs
│       │   ├── Math.cs
│       │   ├── Array.cs
│       │   ├── Exception.cs
│       │   ├── Type.cs
│       │   ├── Activator.cs
│       │   ├── Convert.cs
│       │   ├── Environment.cs
│       │   ├── GC.cs
│       │   ├── Buffer.cs
│       │   │
│       │   ├── ValueTypes/
│       │   │   ├── Boolean.cs
│       │   │   ├── Char.cs
│       │   │   ├── Byte.cs
│       │   │   ├── SByte.cs
│       │   │   ├── Int16.cs
│       │   │   ├── UInt16.cs
│       │   │   ├── Int32.cs
│       │   │   ├── UInt32.cs
│       │   │   ├── Int64.cs
│       │   │   ├── UInt64.cs
│       │   │   ├── Single.cs
│       │   │   ├── Double.cs
│       │   │   ├── IntPtr.cs
│       │   │   └── Enum.cs
│       │   │
│       │   ├── Collections/
│       │   │   ├── IEnumerable.cs
│       │   │   ├── IEnumerator.cs
│       │   │   ├── ICollection.cs
│       │   │   ├── IList.cs
│       │   │   └── Generic/
│       │   │       ├── List.cs
│       │   │       ├── Dictionary.cs
│       │   │       ├── Stack.cs
│       │   │       ├── Queue.cs
│       │   │       ├── HashSet.cs
│       │   │       ├── KeyValuePair.cs
│       │   │       ├── IEnumerable_T.cs
│       │   │       └── IComparer_T.cs
│       │   │
│       │   ├── IO/
│       │   │   ├── Stream.cs
│       │   │   ├── MemoryStream.cs
│       │   │   ├── File.cs
│       │   │   ├── Path.cs
│       │   │   ├── TextReader.cs
│       │   │   ├── TextWriter.cs
│       │   │   ├── StreamReader.cs
│       │   │   └── StreamWriter.cs
│       │   │
│       │   └── Reflection/
│       │       ├── MemberInfo.cs
│       │       ├── MethodInfo.cs
│       │       ├── PropertyInfo.cs
│       │       ├── FieldInfo.cs
│       │       └── ParameterInfo.cs
│       │
│       ├── System.Text/
│       │   ├── StringBuilder.cs
│       │   ├── Encoding.cs
│       │   └── ASCIIEncoding.cs
│       │
│       └── System.Text.Json/
│           ├── JsonSerializer.cs
│           ├── JsonSerializerOptions.cs
│           ├── JsonElement.cs
│           ├── JsonValueKind.cs
│           └── Serialization/
│               ├── JsonConverter.cs
│               └── JsonNamingPolicy.cs
│
├── samples/                            # Programas de exemplo
│   ├── HelloWorld/
│   │   └── Program.cs
│   ├── Fibonacci/
│   │   └── Program.cs
│   ├── FloatMath/
│   │   └── Program.cs
│   ├── Generics/
│   │   └── Program.cs
│   ├── Reflection/
│   │   └── Program.cs
│   ├── JsonDemo/
│   │   └── Program.cs
│   ├── FileIO/
│   │   └── Program.cs
│   └── GameOfLife/
│       └── Program.cs
│
├── tests/
│   ├── Compiler.Tests/
│   │   └── ...
│   └── Runtime.Tests/
│       └── ...
│
└── docs/
    ├── Architecture.md
    ├── BCL-Reference.md
    ├── IL-Mapping.md
    └── Runtime-Internals.md
```

---

## 4. Atributos da BCL

### AsmImplementationAttribute

```csharp
using System;

namespace System.Runtime.CompilerServices
{
    /// <summary>
    /// Marca um metodo com implementacao em Assembly i386.
    /// O compilador substitui chamadas ao metodo pelo assembly fornecido.
    /// </summary>
    /// <example>
    /// [AsmImplementation(@"
    ///     MOV EAX, {ARG0}
    ///     ADD EAX, {ARG1}
    /// ")]
    /// public static int Add(int a, int b) => 0;
    /// </example>
    [AttributeUsage(AttributeTargets.Method | AttributeTargets.Constructor, AllowMultiple = false)]
    public sealed class AsmImplementationAttribute : Attribute
    {
        /// <summary>
        /// Codigo assembly i386.
        /// 
        /// Placeholders suportados:
        /// - {ARG0}, {ARG1}, ... : Argumentos (substitui por [EBP+offset])
        /// - {ARG0_HI}          : Parte alta de argumento 64-bit
        /// - {LOCAL0}, {LOCAL1} : Variaveis locais
        /// - {THIS}             : Ponteiro this (instancia)
        /// - {RETVAL}           : Local para valor de retorno
        /// 
        /// Labels locais devem comecar com ponto: .loop, .done, .exit
        /// 
        /// Registradores disponiveis: EAX, EBX, ECX, EDX, ESI, EDI
        /// EBP e ESP sao reservados para stack frame
        /// </summary>
        public string Assembly { get; }
        
        /// <summary>
        /// Codigo alternativo para quando x87 FPU NAO esta disponivel.
        /// Se null, usa o Assembly principal (que deve ser soft-float).
        /// </summary>
        public string? NoFpuAssembly { get; set; }
        
        /// <summary>
        /// Se true, gera CALL para rotina de runtime ao inves de inline.
        /// Usar para codigo grande ou que precisa de estado.
        /// </summary>
        public bool IsRuntimeCall { get; set; }
        
        /// <summary>
        /// Nome da rotina de runtime quando IsRuntimeCall = true.
        /// </summary>
        public string? RuntimeRoutine { get; set; }
        
        /// <summary>
        /// Convenção de chamada.
        /// </summary>
        public CallingConvention Convention { get; set; } = CallingConvention.Cdecl;
        
        /// <summary>
        /// Registradores modificados (para otimizador saber o que salvar).
        /// Exemplo: "EAX,ECX,EDX" ou "ALL"
        /// </summary>
        public string Clobbers { get; set; } = "EAX";
        
        /// <summary>
        /// Se true, este metodo usa FPU x87.
        /// O compilador ira gerar codigo alternativo se FPU nao disponivel.
        /// </summary>
        public bool UsesFpu { get; set; }
        
        public AsmImplementationAttribute(string assembly)
        {
            Assembly = assembly ?? throw new ArgumentNullException(nameof(assembly));
        }
    }
    
    /// <summary>
    /// Metodo intrinseco - mapeado diretamente para uma instrucao.
    /// Mais eficiente que AsmImplementation para instrucoes simples.
    /// </summary>
    /// <example>
    /// [AsmIntrinsic("BSF EAX, {ARG0}")] // Bit Scan Forward
    /// public static int BitScanForward(int value) => 0;
    /// </example>
    [AttributeUsage(AttributeTargets.Method, AllowMultiple = false)]
    public sealed class AsmIntrinsicAttribute : Attribute
    {
        public string Instruction { get; }
        public string? NoFpuInstruction { get; set; }
        
        public AsmIntrinsicAttribute(string instruction)
        {
            Instruction = instruction ?? throw new ArgumentNullException(nameof(instruction));
        }
    }
    
    /// <summary>
    /// Define layout de memoria do tipo.
    /// </summary>
    [AttributeUsage(AttributeTargets.Struct | AttributeTargets.Class, AllowMultiple = false)]
    public sealed class AsmLayoutAttribute : Attribute
    {
        /// <summary>
        /// Tamanho total em bytes.
        /// </summary>
        public int Size { get; }
        
        /// <summary>
        /// Alinhamento em bytes (1, 2, 4, 8, 16).
        /// Default: 4 para 32-bit
        /// </summary>
        public int Alignment { get; set; } = 4;
        
        public AsmLayoutAttribute(int size)
        {
            Size = size;
        }
    }
    
    public enum CallingConvention
    {
        /// <summary>
        /// Caller limpa pilha. Args right-to-left.
        /// Retorno em EAX ou EDX:EAX.
        /// </summary>
        Cdecl,
        
        /// <summary>
        /// Callee limpa pilha com RET n. Args right-to-left.
        /// Usado por Win32 API.
        /// </summary>
        Stdcall,
        
        /// <summary>
        /// Primeiros 2 args em ECX, EDX. Resto na pilha.
        /// Mais rapido para funcoes com poucos args.
        /// </summary>
        Fastcall
    }
}
```

---

## 5. BCL - Exemplos de Implementacao

### System.Console

```csharp
using System.Runtime.CompilerServices;

namespace System
{
    public static class Console
    {
        // ============================================================
        // WRITE - Sem newline
        // ============================================================
        
        [AsmImplementation(@"
            ; Console.Write(string)
            MOV ESI, {ARG0}         ; ESI = ponteiro para string
            TEST ESI, ESI           ; null check
            JZ .done
        .loop:
            LODSB                   ; AL = [ESI], ESI++
            TEST AL, AL             ; null terminator?
            JZ .done
            MOV DL, AL
            MOV AH, 02h             ; DOS: write char
            INT 21h
            JMP .loop
        .done:
        ", Clobbers = "EAX,EDX,ESI")]
        public static void Write(string? value) { }
        
        [AsmImplementation(@"
            ; Console.Write(int)
            MOV EAX, {ARG0}
            CALL __rt_print_int32
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_print_int32")]
        public static void Write(int value) { }
        
        [AsmImplementation(@"
            ; Console.Write(uint)
            MOV EAX, {ARG0}
            CALL __rt_print_uint32
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_print_uint32")]
        public static void Write(uint value) { }
        
        [AsmImplementation(@"
            ; Console.Write(long)
            MOV EAX, {ARG0}         ; low dword
            MOV EDX, {ARG0_HI}      ; high dword
            CALL __rt_print_int64
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_print_int64")]
        public static void Write(long value) { }
        
        [AsmImplementation(@"
            ; Console.Write(char)
            MOV DL, {ARG0}
            MOV AH, 02h
            INT 21h
        ", Clobbers = "EAX,EDX")]
        public static void Write(char value) { }
        
        [AsmImplementation(@"
            ; Console.Write(bool)
            MOV EAX, {ARG0}
            TEST EAX, EAX
            JZ .false
            MOV ESI, OFFSET __str_True
            JMP .print
        .false:
            MOV ESI, OFFSET __str_False
        .print:
            CALL __rt_print_str
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_print_str", Clobbers = "EAX,ESI")]
        public static void Write(bool value) { }
        
        // Float com x87
        [AsmImplementation(@"
            ; Console.Write(float) - x87
            FLD DWORD PTR {ARG0}
            CALL __rt_print_float
        ", UsesFpu = true, IsRuntimeCall = true, RuntimeRoutine = "__rt_print_float",
        NoFpuAssembly = @"
            ; Console.Write(float) - soft
            MOV EAX, {ARG0}
            CALL __rt_print_float_soft
        ")]
        public static void Write(float value) { }
        
        [AsmImplementation(@"
            ; Console.Write(double) - x87
            FLD QWORD PTR {ARG0}
            CALL __rt_print_double
        ", UsesFpu = true, IsRuntimeCall = true, RuntimeRoutine = "__rt_print_double",
        NoFpuAssembly = @"
            ; Console.Write(double) - soft
            MOV EAX, {ARG0}
            MOV EDX, {ARG0_HI}
            CALL __rt_print_double_soft
        ")]
        public static void Write(double value) { }
        
        // ============================================================
        // WRITELINE - Com newline
        // ============================================================
        
        [AsmImplementation(@"
            ; Console.WriteLine()
            MOV AH, 02h
            MOV DL, 13              ; CR
            INT 21h
            MOV DL, 10              ; LF
            INT 21h
        ", Clobbers = "EAX,EDX")]
        public static void WriteLine() { }
        
        [AsmImplementation(@"
            ; Console.WriteLine(string)
            MOV ESI, {ARG0}
            TEST ESI, ESI
            JZ .newline
        .loop:
            LODSB
            TEST AL, AL
            JZ .newline
            MOV DL, AL
            MOV AH, 02h
            INT 21h
            JMP .loop
        .newline:
            MOV DL, 13
            INT 21h
            MOV DL, 10
            INT 21h
        ", Clobbers = "EAX,EDX,ESI")]
        public static void WriteLine(string? value) { }
        
        [AsmImplementation(@"
            ; Console.WriteLine(int)
            MOV EAX, {ARG0}
            CALL __rt_print_int32
            CALL __rt_newline
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_print_int32")]
        public static void WriteLine(int value) { }
        
        [AsmImplementation(@"
            ; Console.WriteLine(long)
            MOV EAX, {ARG0}
            MOV EDX, {ARG0_HI}
            CALL __rt_print_int64
            CALL __rt_newline
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_print_int64")]
        public static void WriteLine(long value) { }
        
        [AsmImplementation(@"
            ; Console.WriteLine(char)
            MOV DL, {ARG0}
            MOV AH, 02h
            INT 21h
            MOV DL, 13
            INT 21h
            MOV DL, 10
            INT 21h
        ", Clobbers = "EAX,EDX")]
        public static void WriteLine(char value) { }
        
        [AsmImplementation(@"
            ; Console.WriteLine(bool)
            MOV EAX, {ARG0}
            TEST EAX, EAX
            JZ .false
            MOV ESI, OFFSET __str_True
            JMP .print
        .false:
            MOV ESI, OFFSET __str_False
        .print:
            CALL __rt_print_str
            CALL __rt_newline
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_print_str", Clobbers = "EAX,ESI")]
        public static void WriteLine(bool value) { }
        
        [AsmImplementation(@"
            ; Console.WriteLine(float)
            FLD DWORD PTR {ARG0}
            CALL __rt_print_float
            CALL __rt_newline
        ", UsesFpu = true, IsRuntimeCall = true, RuntimeRoutine = "__rt_print_float",
        NoFpuAssembly = @"
            MOV EAX, {ARG0}
            CALL __rt_print_float_soft
            CALL __rt_newline
        ")]
        public static void WriteLine(float value) { }
        
        [AsmImplementation(@"
            ; Console.WriteLine(double)
            FLD QWORD PTR {ARG0}
            CALL __rt_print_double
            CALL __rt_newline
        ", UsesFpu = true, IsRuntimeCall = true, RuntimeRoutine = "__rt_print_double",
        NoFpuAssembly = @"
            MOV EAX, {ARG0}
            MOV EDX, {ARG0_HI}
            CALL __rt_print_double_soft
            CALL __rt_newline
        ")]
        public static void WriteLine(double value) { }
        
        // ============================================================
        // READ
        // ============================================================
        
        [AsmImplementation(@"
            ; Console.Read() - le char com echo
            MOV AH, 01h
            INT 21h
            MOVZX EAX, AL
        ", Clobbers = "EAX")]
        public static int Read() => 0;
        
        [AsmImplementation(@"
            ; Console.ReadKey() - le char sem echo
            MOV AH, 08h
            INT 21h
            MOVZX EAX, AL
        ", Clobbers = "EAX")]
        public static ConsoleKeyInfo ReadKey() => default;
        
        [AsmImplementation(@"
            ; Console.ReadKey(bool) - intercept
            MOV AH, 08h
            INT 21h
            MOVZX EAX, AL
            ; Se {ARG0} == false, fazer echo
            CMP DWORD PTR {ARG0}, 0
            JNE .done
            MOV DL, AL
            MOV AH, 02h
            INT 21h
        .done:
        ", Clobbers = "EAX,EDX")]
        public static ConsoleKeyInfo ReadKey(bool intercept) => default;
        
        [AsmImplementation(@"
            ; Console.ReadLine()
            CALL __rt_read_line
            ; EAX = ponteiro para string alocada
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_read_line")]
        public static string? ReadLine() => null;
        
        // ============================================================
        // CURSOR & SCREEN
        // ============================================================
        
        [AsmImplementation(@"
            ; Console.Clear()
            MOV AX, 0003h           ; Set mode 3 (80x25 text, clears screen)
            INT 10h
        ", Clobbers = "EAX")]
        public static void Clear() { }
        
        [AsmImplementation(@"
            ; Console.SetCursorPosition(int left, int top)
            MOV DL, {ARG0}          ; column
            MOV DH, {ARG1}          ; row
            XOR BH, BH              ; page 0
            MOV AH, 02h             ; set cursor position
            INT 10h
        ", Clobbers = "EAX,EBX,EDX")]
        public static void SetCursorPosition(int left, int top) { }
        
        [AsmImplementation(@"
            ; Console.get_CursorLeft
            MOV AH, 03h             ; get cursor position
            XOR BH, BH
            INT 10h
            MOVZX EAX, DL           ; column in DL
        ", Clobbers = "EAX,EBX,ECX,EDX")]
        public static int CursorLeft => 0;
        
        [AsmImplementation(@"
            ; Console.get_CursorTop
            MOV AH, 03h
            XOR BH, BH
            INT 10h
            MOVZX EAX, DH           ; row in DH
        ", Clobbers = "EAX,EBX,ECX,EDX")]
        public static int CursorTop => 0;
        
        [AsmImplementation(@"
            ; Console.get_KeyAvailable
            MOV AH, 0Bh             ; check keyboard status
            INT 21h
            MOVZX EAX, AL           ; AL = FF if key available, 0 if not
            NEG EAX                 ; convert to 0/1
            SBB EAX, EAX
            NEG EAX
        ", Clobbers = "EAX")]
        public static bool KeyAvailable => false;
        
        [AsmImplementation(@"
            ; Console.Beep()
            MOV DL, 07h             ; BEL character
            MOV AH, 02h
            INT 21h
        ", Clobbers = "EAX,EDX")]
        public static void Beep() { }
        
        // ============================================================
        // COLORS (bonus)
        // ============================================================
        
        [AsmImplementation(@"
            ; Console.set_ForegroundColor
            MOV AL, {ARG0}
            AND AL, 0Fh
            MOV [__console_attr], AL
        ")]
        public static ConsoleColor ForegroundColor { set { } }
        
        [AsmImplementation(@"
            ; Console.set_BackgroundColor  
            MOV AL, {ARG0}
            SHL AL, 4
            AND BYTE PTR [__console_attr], 0Fh
            OR [__console_attr], AL
        ")]
        public static ConsoleColor BackgroundColor { set { } }
        
        [AsmImplementation(@"
            ; Console.ResetColor
            MOV BYTE PTR [__console_attr], 07h  ; light gray on black
        ")]
        public static void ResetColor() { }
    }
    
    public struct ConsoleKeyInfo
    {
        public char KeyChar;
        public ConsoleKey Key;
        public ConsoleModifiers Modifiers;
    }
    
    public enum ConsoleKey
    {
        None = 0,
        Backspace = 8,
        Tab = 9,
        Enter = 13,
        Escape = 27,
        Spacebar = 32,
        // ... etc
    }
    
    public enum ConsoleColor
    {
        Black = 0, DarkBlue = 1, DarkGreen = 2, DarkCyan = 3,
        DarkRed = 4, DarkMagenta = 5, DarkYellow = 6, Gray = 7,
        DarkGray = 8, Blue = 9, Green = 10, Cyan = 11,
        Red = 12, Magenta = 13, Yellow = 14, White = 15
    }
    
    [Flags]
    public enum ConsoleModifiers
    {
        None = 0, Alt = 1, Shift = 2, Control = 4
    }
}
```

### System.Math

```csharp
using System.Runtime.CompilerServices;

namespace System
{
    public static class Math
    {
        public const double PI = 3.14159265358979323846;
        public const double E = 2.7182818284590452354;
        
        // ============================================================
        // BASIC OPERATIONS
        // ============================================================
        
        [AsmIntrinsic("FABS")]
        [AsmImplementation(@"
            FLD QWORD PTR {ARG0}
            FABS
            FSTP QWORD PTR {RETVAL}
        ", UsesFpu = true, NoFpuAssembly = @"
            MOV EAX, {ARG0_HI}
            AND EAX, 7FFFFFFFh      ; clear sign bit
            MOV {RETVAL_HI}, EAX
            MOV EAX, {ARG0}
            MOV {RETVAL}, EAX
        ")]
        public static double Abs(double value) => 0;
        
        [AsmImplementation(@"
            ; Math.Abs(int)
            MOV EAX, {ARG0}
            CDQ                     ; EDX = sign extension
            XOR EAX, EDX            ; flip bits if negative
            SUB EAX, EDX            ; add 1 if was negative
        ", Clobbers = "EAX,EDX")]
        public static int Abs(int value) => 0;
        
        [AsmImplementation(@"
            ; Math.Min(int, int)
            MOV EAX, {ARG0}
            MOV EDX, {ARG1}
            CMP EAX, EDX
            JLE .done
            MOV EAX, EDX
        .done:
        ", Clobbers = "EAX,EDX")]
        public static int Min(int val1, int val2) => 0;
        
        [AsmImplementation(@"
            ; Math.Max(int, int)
            MOV EAX, {ARG0}
            MOV EDX, {ARG1}
            CMP EAX, EDX
            JGE .done
            MOV EAX, EDX
        .done:
        ", Clobbers = "EAX,EDX")]
        public static int Max(int val1, int val2) => 0;
        
        [AsmImplementation(@"
            ; Math.Sign(int)
            MOV EAX, {ARG0}
            CDQ                     ; EDX = -1 if negative, 0 otherwise
            TEST EAX, EAX
            SETNZ AL                ; AL = 1 if non-zero
            MOVZX EAX, AL
            OR EAX, EDX             ; combine: -1, 0, or 1
        ", Clobbers = "EAX,EDX")]
        public static int Sign(int value) => 0;
        
        [AsmImplementation(@"
            ; Math.Clamp(int, int, int)
            MOV EAX, {ARG0}         ; value
            MOV ECX, {ARG1}         ; min
            MOV EDX, {ARG2}         ; max
            CMP EAX, ECX
            JGE .check_max
            MOV EAX, ECX
            JMP .done
        .check_max:
            CMP EAX, EDX
            JLE .done
            MOV EAX, EDX
        .done:
        ", Clobbers = "EAX,ECX,EDX")]
        public static int Clamp(int value, int min, int max) => 0;
        
        // ============================================================
        // FPU TRIGONOMETRIC
        // ============================================================
        
        [AsmImplementation(@"
            ; Math.Sin(double) - x87
            FLD QWORD PTR {ARG0}
            FSIN
            FSTP QWORD PTR {RETVAL}
        ", UsesFpu = true, NoFpuAssembly = @"
            PUSH {ARG0_HI}
            PUSH {ARG0}
            CALL __rt_sin_soft
            ADD ESP, 8
            MOV {RETVAL}, EAX
            MOV {RETVAL_HI}, EDX
        ")]
        public static double Sin(double a) => 0;
        
        [AsmImplementation(@"
            ; Math.Cos(double) - x87
            FLD QWORD PTR {ARG0}
            FCOS
            FSTP QWORD PTR {RETVAL}
        ", UsesFpu = true, NoFpuAssembly = @"
            PUSH {ARG0_HI}
            PUSH {ARG0}
            CALL __rt_cos_soft
            ADD ESP, 8
            MOV {RETVAL}, EAX
            MOV {RETVAL_HI}, EDX
        ")]
        public static double Cos(double a) => 0;
        
        [AsmImplementation(@"
            ; Math.Tan(double) - x87
            FLD QWORD PTR {ARG0}
            FPTAN
            FSTP ST(0)              ; pop the 1.0
            FSTP QWORD PTR {RETVAL}
        ", UsesFpu = true)]
        public static double Tan(double a) => 0;
        
        [AsmImplementation(@"
            ; Math.Atan(double) - x87
            FLD QWORD PTR {ARG0}
            FLD1
            FPATAN
            FSTP QWORD PTR {RETVAL}
        ", UsesFpu = true)]
        public static double Atan(double a) => 0;
        
        [AsmImplementation(@"
            ; Math.Atan2(double y, double x) - x87
            FLD QWORD PTR {ARG0}    ; y
            FLD QWORD PTR {ARG1}    ; x
            FPATAN                  ; atan2(y,x)
            FSTP QWORD PTR {RETVAL}
        ", UsesFpu = true)]
        public static double Atan2(double y, double x) => 0;
        
        // ============================================================
        // FPU EXPONENTIAL & LOGARITHMIC
        // ============================================================
        
        [AsmImplementation(@"
            ; Math.Sqrt(double) - x87
            FLD QWORD PTR {ARG0}
            FSQRT
            FSTP QWORD PTR {RETVAL}
        ", UsesFpu = true, NoFpuAssembly = @"
            PUSH {ARG0_HI}
            PUSH {ARG0}
            CALL __rt_sqrt_soft
            ADD ESP, 8
            MOV {RETVAL}, EAX
            MOV {RETVAL_HI}, EDX
        ")]
        public static double Sqrt(double d) => 0;
        
        [AsmImplementation(@"
            ; Math.Log(double) - x87 natural log
            FLDLN2                  ; load ln(2)
            FLD QWORD PTR {ARG0}
            FYL2X                   ; ST(1) * log2(ST(0))
            FSTP QWORD PTR {RETVAL}
        ", UsesFpu = true)]
        public static double Log(double d) => 0;
        
        [AsmImplementation(@"
            ; Math.Log10(double) - x87
            FLDLG2                  ; load log10(2)
            FLD QWORD PTR {ARG0}
            FYL2X
            FSTP QWORD PTR {RETVAL}
        ", UsesFpu = true)]
        public static double Log10(double d) => 0;
        
        [AsmImplementation(@"
            ; Math.Exp(double) - x87: e^x
            FLD QWORD PTR {ARG0}
            FLDL2E                  ; log2(e)
            FMULP ST(1), ST         ; x * log2(e)
            ; 2^(x*log2(e)) = e^x
            FLD ST(0)
            FRNDINT                 ; integer part
            FSUB ST(1), ST          ; fractional part
            FXCH
            F2XM1                   ; 2^frac - 1
            FLD1
            FADDP ST(1), ST         ; 2^frac
            FSCALE                  ; * 2^int
            FSTP ST(1)
            FSTP QWORD PTR {RETVAL}
        ", UsesFpu = true)]
        public static double Exp(double d) => 0;
        
        [AsmImplementation(@"
            ; Math.Pow(double x, double y) - x87
            ; x^y = 2^(y * log2(x))
            FLD QWORD PTR {ARG1}    ; y
            FLD QWORD PTR {ARG0}    ; x
            FYL2X                   ; y * log2(x)
            FLD ST(0)
            FRNDINT
            FSUB ST(1), ST
            FXCH
            F2XM1
            FLD1
            FADDP ST(1), ST
            FSCALE
            FSTP ST(1)
            FSTP QWORD PTR {RETVAL}
        ", UsesFpu = true)]
        public static double Pow(double x, double y) => 0;
        
        // ============================================================
        // FPU ROUNDING
        // ============================================================
        
        [AsmImplementation(@"
            ; Math.Floor(double) - x87
            FLD QWORD PTR {ARG0}
            ; Save control word and set rounding to -infinity
            FNSTCW [__fpu_cw_temp]
            MOV AX, [__fpu_cw_temp]
            AND AX, 0F3FFh
            OR AX, 0400h            ; round toward -infinity
            MOV [__fpu_cw_temp2], AX
            FLDCW [__fpu_cw_temp2]
            FRNDINT
            FLDCW [__fpu_cw_temp]   ; restore
            FSTP QWORD PTR {RETVAL}
        ", UsesFpu = true)]
        public static double Floor(double d) => 0;
        
        [AsmImplementation(@"
            ; Math.Ceiling(double) - x87
            FLD QWORD PTR {ARG0}
            FNSTCW [__fpu_cw_temp]
            MOV AX, [__fpu_cw_temp]
            AND AX, 0F3FFh
            OR AX, 0800h            ; round toward +infinity
            MOV [__fpu_cw_temp2], AX
            FLDCW [__fpu_cw_temp2]
            FRNDINT
            FLDCW [__fpu_cw_temp]
            FSTP QWORD PTR {RETVAL}
        ", UsesFpu = true)]
        public static double Ceiling(double d) => 0;
        
        [AsmImplementation(@"
            ; Math.Round(double) - x87 (round to nearest even)
            FLD QWORD PTR {ARG0}
            FRNDINT                 ; default is round to nearest
            FSTP QWORD PTR {RETVAL}
        ", UsesFpu = true)]
        public static double Round(double d) => 0;
        
        [AsmImplementation(@"
            ; Math.Truncate(double) - x87
            FLD QWORD PTR {ARG0}
            FNSTCW [__fpu_cw_temp]
            MOV AX, [__fpu_cw_temp]
            OR AX, 0C00h            ; round toward zero (truncate)
            MOV [__fpu_cw_temp2], AX
            FLDCW [__fpu_cw_temp2]
            FRNDINT
            FLDCW [__fpu_cw_temp]
            FSTP QWORD PTR {RETVAL}
        ", UsesFpu = true)]
        public static double Truncate(double d) => 0;
    }
}
```

---

## 6. Mapeamento IL para i386

### Instrucoes de Load/Store

| IL | i386 Assembly | Stack Effect |
|----|---------------|--------------|
| `ldc.i4 N` | `PUSH N` | +1 |
| `ldc.i4.0` | `PUSH 0` | +1 |
| `ldc.i4.1` | `PUSH 1` | +1 |
| `ldc.i4.m1` | `PUSH -1` | +1 |
| `ldc.i4.s N` | `PUSH N` (sign extended) | +1 |
| `ldc.i8 N` | `PUSH high(N)` / `PUSH low(N)` | +2 |
| `ldc.r4 N` | `PUSH dword [__flt_N]` | +1 |
| `ldc.r8 N` | `PUSH dword [__dbl_N+4]` / `PUSH dword [__dbl_N]` | +2 |
| `ldnull` | `PUSH 0` | +1 |
| `ldstr "..."` | `PUSH OFFSET __str_N` | +1 |
| `ldloc.0` | `PUSH dword [EBP-4]` | +1 |
| `ldloc.1` | `PUSH dword [EBP-8]` | +1 |
| `ldloc.s N` | `PUSH dword [EBP-4*(N+1)]` | +1 |
| `stloc.0` | `POP dword [EBP-4]` | -1 |
| `stloc.1` | `POP dword [EBP-8]` | -1 |
| `stloc.s N` | `POP dword [EBP-4*(N+1)]` | -1 |
| `ldarg.0` | `PUSH dword [EBP+8]` | +1 |
| `ldarg.1` | `PUSH dword [EBP+12]` | +1 |
| `ldarg.s N` | `PUSH dword [EBP+8+4*N]` | +1 |
| `starg.s N` | `POP dword [EBP+8+4*N]` | -1 |

### Instrucoes Aritmeticas

| IL | i386 Assembly | Stack Effect |
|----|---------------|--------------|
| `add` | `POP EBX` / `ADD [ESP], EBX` | -1 |
| `sub` | `POP EBX` / `SUB [ESP], EBX` | -1 |
| `mul` | `POP EBX` / `POP EAX` / `IMUL EBX` / `PUSH EAX` | -1 |
| `div` | `POP EBX` / `POP EAX` / `CDQ` / `IDIV EBX` / `PUSH EAX` | -1 |
| `div.un` | `POP EBX` / `POP EAX` / `XOR EDX,EDX` / `DIV EBX` / `PUSH EAX` | -1 |
| `rem` | `POP EBX` / `POP EAX` / `CDQ` / `IDIV EBX` / `PUSH EDX` | -1 |
| `rem.un` | `POP EBX` / `POP EAX` / `XOR EDX,EDX` / `DIV EBX` / `PUSH EDX` | -1 |
| `neg` | `NEG dword [ESP]` | 0 |
| `and` | `POP EAX` / `AND [ESP], EAX` | -1 |
| `or` | `POP EAX` / `OR [ESP], EAX` | -1 |
| `xor` | `POP EAX` / `XOR [ESP], EAX` | -1 |
| `not` | `NOT dword [ESP]` | 0 |
| `shl` | `POP ECX` / `SHL dword [ESP], CL` | -1 |
| `shr` | `POP ECX` / `SAR dword [ESP], CL` | -1 |
| `shr.un` | `POP ECX` / `SHR dword [ESP], CL` | -1 |

### Instrucoes de Comparacao

| IL | i386 Assembly | Stack Effect |
|----|---------------|--------------|
| `ceq` | `POP EBX` / `POP EAX` / `CMP EAX,EBX` / `SETE AL` / `MOVZX EAX,AL` / `PUSH EAX` | -1 |
| `cgt` | `...` / `SETG AL` / `...` | -1 |
| `cgt.un` | `...` / `SETA AL` / `...` | -1 |
| `clt` | `...` / `SETL AL` / `...` | -1 |
| `clt.un` | `...` / `SETB AL` / `...` | -1 |

### Instrucoes de Branch

| IL | i386 Assembly | Stack Effect |
|----|---------------|--------------|
| `br TARGET` | `JMP TARGET` | 0 |
| `br.s TARGET` | `JMP TARGET` | 0 |
| `brfalse TARGET` | `POP EAX` / `TEST EAX,EAX` / `JZ TARGET` | -1 |
| `brtrue TARGET` | `POP EAX` / `TEST EAX,EAX` / `JNZ TARGET` | -1 |
| `beq TARGET` | `POP EBX` / `POP EAX` / `CMP EAX,EBX` / `JE TARGET` | -2 |
| `bne.un TARGET` | `...` / `JNE TARGET` | -2 |
| `blt TARGET` | `...` / `JL TARGET` | -2 |
| `blt.un TARGET` | `...` / `JB TARGET` | -2 |
| `ble TARGET` | `...` / `JLE TARGET` | -2 |
| `ble.un TARGET` | `...` / `JBE TARGET` | -2 |
| `bgt TARGET` | `...` / `JG TARGET` | -2 |
| `bgt.un TARGET` | `...` / `JA TARGET` | -2 |
| `bge TARGET` | `...` / `JGE TARGET` | -2 |
| `bge.un TARGET` | `...` / `JAE TARGET` | -2 |

### Instrucoes de Chamada

| IL | i386 Assembly | Stack Effect |
|----|---------------|--------------|
| `call METHOD` | args pushed / `CALL __method` / `ADD ESP, N` / `PUSH EAX` (se retorna) | varies |
| `callvirt METHOD` | `MOV EAX, [ESP+this_offset]` / `MOV EAX, [EAX]` / `CALL [EAX+slot*4]` / ... | varies |
| `ret` | `MOV ESP, EBP` / `POP EBP` / `RET` | all |
| `ret` (com valor) | `POP EAX` / `MOV ESP, EBP` / `POP EBP` / `RET` | all |

### Instrucoes de Objeto

| IL | i386 Assembly | Stack Effect |
|----|---------------|--------------|
| `newobj CTOR` | `PUSH size` / `CALL __gc_alloc` / `ADD ESP,4` / init vtable / `PUSH EAX` / call ctor | +1 |
| `ldfld FIELD` | `POP ESI` / `PUSH dword [ESI+offset]` | 0 |
| `stfld FIELD` | `POP EAX` / `POP ESI` / `MOV [ESI+offset], EAX` | -2 |
| `ldsfld FIELD` | `PUSH dword [__field]` | +1 |
| `stsfld FIELD` | `POP dword [__field]` | -1 |
| `ldflda FIELD` | `POP ESI` / `LEA EAX, [ESI+offset]` / `PUSH EAX` | 0 |
| `ldsflda FIELD` | `PUSH OFFSET __field` | +1 |

### Instrucoes de Array

| IL | i386 Assembly | Stack Effect |
|----|---------------|--------------|
| `newarr TYPE` | `POP ECX` / `PUSH size` / `PUSH ECX` / `CALL __gc_alloc_array` / `ADD ESP,8` / `PUSH EAX` | 0 |
| `ldlen` | `POP ESI` / `PUSH dword [ESI-4]` | 0 |
| `ldelem.i4` | `POP EBX` / `POP ESI` / `PUSH dword [ESI+EBX*4]` | -1 |
| `stelem.i4` | `POP EAX` / `POP EBX` / `POP ESI` / `MOV [ESI+EBX*4], EAX` | -3 |
| `ldelema TYPE` | `POP EBX` / `POP ESI` / `LEA EAX, [ESI+EBX*size]` / `PUSH EAX` | -1 |

### Instrucoes de Conversao

| IL | i386 Assembly | Stack Effect |
|----|---------------|--------------|
| `conv.i1` | `POP EAX` / `MOVSX EAX, AL` / `PUSH EAX` | 0 |
| `conv.i2` | `POP EAX` / `MOVSX EAX, AX` / `PUSH EAX` | 0 |
| `conv.i4` | (nop para 32-bit) | 0 |
| `conv.u1` | `POP EAX` / `MOVZX EAX, AL` / `PUSH EAX` | 0 |
| `conv.u2` | `POP EAX` / `MOVZX EAX, AX` / `PUSH EAX` | 0 |
| `conv.u4` | (nop para 32-bit) | 0 |
| `conv.i8` | `POP EAX` / `CDQ` / `PUSH EDX` / `PUSH EAX` | +1 |
| `conv.u8` | `POP EAX` / `XOR EDX, EDX` / `PUSH EDX` / `PUSH EAX` | +1 |
| `conv.r4` | x87: `FILD dword [ESP]` / `FSTP dword [ESP]` | 0 |
| `conv.r8` | x87: `FILD dword [ESP]` / `SUB ESP, 4` / `FSTP qword [ESP]` | +1 |

### Instrucoes de Pilha

| IL | i386 Assembly | Stack Effect |
|----|---------------|--------------|
| `dup` | `PUSH dword [ESP]` | +1 |
| `pop` | `ADD ESP, 4` | -1 |
| `nop` | `NOP` | 0 |

---

## 7. Operacoes Float - Dual Mode

O compilador gera codigo que funciona com ou sem FPU:

### Variavel Global de Modo

```asm
; Definido em runtime init
__has_fpu DB 0          ; 0 = soft float, 1 = x87

; Macros de despacho (ou codigo gerado inline)
```

### Exemplo: Adicao de Float

```asm
; Versao com branching (mais lento, menor codigo)
add_float:
    CMP BYTE PTR [__has_fpu], 0
    JE .soft
    ; x87 path
    FLD DWORD PTR [ESP+4]
    FADD DWORD PTR [ESP+8]
    FSTP DWORD PTR [ESP+12]
    RET
.soft:
    ; soft float path
    PUSH DWORD PTR [ESP+8]
    PUSH DWORD PTR [ESP+8]
    CALL __soft_fadd
    ADD ESP, 8
    MOV [ESP+12], EAX
    RET
```

### Alternativa: Duas versoes do programa

O compilador pode gerar:
1. `program.asm` - versao com x87 (default)
2. `program_nofpu.asm` - versao com soft-float

Ou um unico executavel com dispatcher no startup.

---

## 8. Runtime - Codigo de Startup

```asm
; ============================================================
; STARTUP CODE
; ============================================================

.386
.MODEL FLAT

.DATA
__has_fpu       DB 0
__heap_start    DD 0
__heap_ptr      DD 0
__heap_end      DD 0
__stack_top     DD 0

.CODE

; Entry point
__start:
    ; Setup segment registers
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX
    
    ; Save stack top for GC
    MOV [__stack_top], ESP
    
    ; Detect CPU (ensure i386+)
    CALL __detect_cpu
    TEST EAX, EAX
    JZ __cpu_error
    
    ; Detect FPU
    CALL __detect_fpu
    MOV [__has_fpu], AL
    
    ; Enter Flat Real Mode (optional, for >1MB heap)
    CALL __enter_flat_real
    
    ; Initialize heap
    CALL __gc_init
    
    ; Initialize FPU if present
    CMP BYTE PTR [__has_fpu], 0
    JE .no_fpu_init
    FINIT
.no_fpu_init:
    
    ; Call user's Main()
    CALL __Program_Main
    
    ; Exit to DOS
    MOV AX, 4C00h
    INT 21h

; ============================================================
; CPU Detection (ensure 386+)
; ============================================================
__detect_cpu PROC
    ; Try to modify FLAGS bits 12-13 (IOPL)
    ; This only works on 386+
    PUSHFD
    POP EAX
    MOV ECX, EAX
    XOR EAX, 3000h      ; flip IOPL bits
    PUSH EAX
    POPFD
    PUSHFD
    POP EAX
    XOR EAX, ECX
    JZ .not_386
    
    ; Restore flags
    PUSH ECX
    POPFD
    
    MOV EAX, 1          ; Success
    RET
    
.not_386:
    XOR EAX, EAX        ; Fail
    RET
__detect_cpu ENDP

; ============================================================
; FPU Detection
; ============================================================
__detect_fpu PROC
    ; Method: try to read FPU status word
    FNINIT
    
    ; Create test location
    PUSH 0
    MOV EBP, ESP
    
    FNSTCW [EBP]
    MOV AX, [EBP]
    CMP AX, 037Fh       ; Default control word
    JNE .no_fpu
    
    ; Additional test: try an operation
    FLD1
    FLDZ
    FDIVP ST(1), ST     ; 1/0 = infinity
    FSTSW AX
    TEST AX, 04h        ; Zero divide exception
    JZ .no_fpu          ; Should be set
    
    ; Clean up FPU stack
    FSTP ST(0)
    
    ADD ESP, 4
    MOV EAX, 1          ; FPU present
    RET
    
.no_fpu:
    ADD ESP, 4
    XOR EAX, EAX        ; No FPU
    RET
__detect_fpu ENDP

; ============================================================
; Flat Real Mode Setup
; ============================================================
__enter_flat_real PROC
    CLI
    
    ; Setup GDT
    LGDT FWORD PTR [__gdt_ptr]
    
    ; Enter protected mode briefly
    MOV EAX, CR0
    OR AL, 1
    MOV CR0, EAX
    JMP SHORT $+2       ; Clear prefetch
    
    ; Load segment with 4GB limit
    MOV BX, 08h
    MOV DS, BX
    MOV ES, BX
    MOV FS, BX
    MOV GS, BX
    
    ; Back to real mode
    AND AL, 0FEh
    MOV CR0, EAX
    JMP SHORT $+2
    
    ; Restore segment values (keeps 4GB limit!)
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX
    
    STI
    RET
__enter_flat_real ENDP

; GDT for Flat Real Mode
ALIGN 8
__gdt:
    DQ 0                    ; Null descriptor
    ; Flat data segment: base=0, limit=4GB, 32-bit
    DW 0FFFFh               ; Limit 0-15
    DW 0                    ; Base 0-15
    DB 0                    ; Base 16-23
    DB 92h                  ; Access: present, ring 0, data, writable
    DB 0CFh                 ; Flags: 4KB granularity, 32-bit, limit 16-19
    DB 0                    ; Base 24-31
__gdt_end:

__gdt_ptr:
    DW __gdt_end - __gdt - 1
    DD OFFSET __gdt

__cpu_error:
    ; Print error and exit
    MOV DX, OFFSET __msg_cpu_error
    MOV AH, 09h
    INT 21h
    MOV AX, 4CFFh
    INT 21h

__msg_cpu_error DB 'Error: Requires 80386 or higher$'
```

---

## 9. Garbage Collector

```asm
; ============================================================
; GARBAGE COLLECTOR - Mark and Sweep
; ============================================================

; Object header (8 bytes):
;   +0: DD size (including header)
;   +4: DW type_index
;   +6: DB flags (bit 0 = marked)
;   +7: DB reserved

; ============================================================
; __gc_init - Initialize heap
; ============================================================
__gc_init PROC
    ; Use memory after program
    ; In Flat Real Mode, can use memory above 1MB
    MOV EAX, 100000h        ; 1MB mark
    MOV [__heap_start], EAX
    MOV [__heap_ptr], EAX
    
    ; Default 4MB heap
    ADD EAX, 400000h
    MOV [__heap_end], EAX
    
    RET
__gc_init ENDP

; ============================================================
; __gc_alloc - Allocate memory
; Input: EAX = size in bytes (not including header)
; Output: EAX = pointer to data (after header), or 0 if OOM
; ============================================================
__gc_alloc PROC
    PUSH EBX
    PUSH ECX
    
    ; Add header size
    ADD EAX, 8
    
    ; Align to 4 bytes
    ADD EAX, 3
    AND EAX, 0FFFFFFFCh
    
    MOV ECX, EAX            ; ECX = total size
    
    ; Check if fits
    MOV EBX, [__heap_ptr]
    ADD EAX, EBX
    CMP EAX, [__heap_end]
    JBE .fits
    
    ; Try GC
    PUSH ECX
    CALL __gc_collect
    POP ECX
    
    ; Try again
    MOV EBX, [__heap_ptr]
    MOV EAX, ECX
    ADD EAX, EBX
    CMP EAX, [__heap_end]
    JBE .fits
    
    ; Out of memory
    XOR EAX, EAX
    JMP .done
    
.fits:
    ; Write header
    MOV [EBX], ECX          ; size
    MOV DWORD PTR [EBX+4], 0 ; type/flags
    
    ; Advance heap pointer
    ADD [__heap_ptr], ECX
    
    ; Return pointer to data
    LEA EAX, [EBX+8]
    
.done:
    POP ECX
    POP EBX
    RET
__gc_alloc ENDP

; ============================================================
; __gc_alloc_typed - Allocate with type info
; Input: EAX = size, EBX = type index
; Output: EAX = pointer
; ============================================================
__gc_alloc_typed PROC
    PUSH EBX
    CALL __gc_alloc
    TEST EAX, EAX
    JZ .done
    
    ; Set type in header
    MOV EBX, [ESP]
    MOV [EAX-4], BX         ; type_index at offset +4 from header
    
.done:
    POP EBX
    RET
__gc_alloc_typed ENDP

; ============================================================
; __gc_collect - Run garbage collection
; ============================================================
__gc_collect PROC
    PUSHAD
    
    ; Phase 1: Clear all marks
    MOV ESI, [__heap_start]
.clear_loop:
    CMP ESI, [__heap_ptr]
    JAE .clear_done
    AND BYTE PTR [ESI+6], 0FEh  ; Clear mark bit
    ADD ESI, [ESI]              ; Next object
    JMP .clear_loop
.clear_done:
    
    ; Phase 2: Mark from roots
    ; 2a: Stack
    MOV ESI, ESP
.mark_stack:
    CMP ESI, [__stack_top]
    JAE .mark_statics
    MOV EAX, [ESI]
    CALL __gc_try_mark
    ADD ESI, 4
    JMP .mark_stack
    
    ; 2b: Static fields
.mark_statics:
    MOV ESI, OFFSET __static_roots_start
    MOV ECX, [__static_roots_count]
.mark_static_loop:
    JECXZ .sweep
    MOV EAX, [ESI]
    CALL __gc_try_mark
    ADD ESI, 4
    DEC ECX
    JMP .mark_static_loop
    
    ; Phase 3: Sweep
.sweep:
    MOV ESI, [__heap_start]     ; source
    MOV EDI, ESI                 ; destination
    
.sweep_loop:
    CMP ESI, [__heap_ptr]
    JAE .sweep_done
    
    TEST BYTE PTR [ESI+6], 1    ; Marked?
    JZ .skip_object
    
    ; Keep object - copy if needed
    CMP ESI, EDI
    JE .no_copy
    
    MOV ECX, [ESI]              ; size
    PUSH ESI
    PUSH EDI
    REP MOVSB
    POP EDI
    POP ESI
    
    ADD EDI, [ESI]
    JMP .next_object
    
.no_copy:
    ADD EDI, [ESI]
    JMP .next_object
    
.skip_object:
    ; Object is garbage
    
.next_object:
    ADD ESI, [ESI]
    JMP .sweep_loop
    
.sweep_done:
    MOV [__heap_ptr], EDI
    
    POPAD
    RET
__gc_collect ENDP

; ============================================================
; __gc_try_mark - Try to mark a potential pointer
; Input: EAX = potential pointer
; ============================================================
__gc_try_mark PROC
    ; Check if in heap range
    CMP EAX, [__heap_start]
    JB .not_pointer
    CMP EAX, [__heap_ptr]
    JAE .not_pointer
    
    ; Get to header
    SUB EAX, 8
    
    ; Already marked?
    TEST BYTE PTR [EAX+6], 1
    JNZ .not_pointer
    
    ; Mark it
    OR BYTE PTR [EAX+6], 1
    
    ; Recursively mark fields
    PUSH EBX
    PUSH ECX
    PUSH ESI
    
    MOV ECX, [EAX]              ; size
    SUB ECX, 8                  ; minus header
    SHR ECX, 2                  ; in dwords
    LEA ESI, [EAX+8]            ; data start
    
.mark_fields:
    JECXZ .mark_done
    PUSH ECX
    MOV EAX, [ESI]
    CALL __gc_try_mark          ; recursive
    POP ECX
    ADD ESI, 4
    DEC ECX
    JMP .mark_fields
    
.mark_done:
    POP ESI
    POP ECX
    POP EBX
    
.not_pointer:
    RET
__gc_try_mark ENDP

; Static roots
__static_roots_start:
    ; Filled by compiler with addresses of static reference fields
__static_roots_count DD 0
```

---

## 10. Opcoes de Linha de Comando

```
msiltodos [options] <input.dll|input.exe>

OPTIONS:

  Input/Output:
    -o, --output <file>       Output assembly file (default: <input>.asm)
    -f, --format <fmt>        Output format: masm, tasm, nasm, fasm (default: masm)
    
  Target:
    --i386                    Target i386 (default, minimum requirement)
    --i486                    Allow i486 instructions (BSWAP, CMPXCHG, XADD)
    --pentium                 Allow Pentium instructions (RDTSC, CPUID)
    
  Floating Point:
    --fpu-detect              Detect FPU at runtime (default)
    --fpu-required            Require x87 FPU, fail if not present
    --soft-float-only         Always use software float (no FPU code)
    
  Memory:
    --flat-real               Use Flat Real Mode for >1MB heap (default)
    --conventional-only       Use only conventional memory (<640KB)
    --heap <size>             Heap size in bytes (default: 4194304 = 4MB)
    --stack <size>            Stack size in bytes (default: 65536 = 64KB)
    
  Features:
    --no-reflection           Disable reflection support
    --no-gc                   Disable garbage collection (manual memory)
    --no-exceptions           Disable exception handling
    --no-generics             Disable generics (fail if used)
    
  Optimization:
    -O0                       No optimizations
    -O1                       Basic optimizations (default)
    -O2                       Aggressive optimizations
    --inline-threshold <n>    Inline methods smaller than n IL bytes (default: 32)
    --no-devirt               Disable devirtualization
    
  Debug:
    -v, --verbose             Verbose output
    --emit-il-comments        Include IL as comments in output
    --emit-line-numbers       Include source line numbers
    --debug-info              Generate debug information
    
  Help:
    -h, --help                Show this help
    --version                 Show version

EXAMPLES:

  Basic compilation:
    msiltodos MyApp.exe
    
  With specific output:
    msiltodos -o game.asm -f nasm Game.dll
    
  For i486 with more optimizations:
    msiltodos --i486 -O2 FastApp.exe
    
  Software float only:
    msiltodos --soft-float-only Calculator.dll
    
  Minimal runtime:
    msiltodos --no-reflection --no-gc --conventional-only TinyApp.exe
```

---

## 11. Exemplos de Programas

### Hello World

```csharp
using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Hello, DOS World!");
    }
}
```

### Fibonacci

```csharp
using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Fibonacci sequence:");
        
        long a = 0, b = 1;
        for (int i = 0; i < 40; i++)
        {
            Console.WriteLine(a);
            long temp = a + b;
            a = b;
            b = temp;
        }
    }
}
```

### Float Math

```csharp
using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Math functions demo:");
        Console.WriteLine();
        
        double x = 0.5;
        
        Console.Write("x = ");
        Console.WriteLine(x);
        
        Console.Write("Sin(x) = ");
        Console.WriteLine(Math.Sin(x));
        
        Console.Write("Cos(x) = ");
        Console.WriteLine(Math.Cos(x));
        
        Console.Write("Sqrt(x) = ");
        Console.WriteLine(Math.Sqrt(x));
        
        Console.Write("Exp(x) = ");
        Console.WriteLine(Math.Exp(x));
        
        Console.Write("Log(x) = ");
        Console.WriteLine(Math.Log(x));
        
        Console.WriteLine();
        Console.WriteLine("PI = " + Math.PI);
        Console.WriteLine("E = " + Math.E);
    }
}
```

### Generic List

```csharp
using System;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        var numbers = new List<int>();
        
        for (int i = 1; i <= 10; i++)
        {
            numbers.Add(i * i);
        }
        
        Console.WriteLine("Squares from 1 to 10:");
        for (int i = 0; i < numbers.Count; i++)
        {
            Console.WriteLine(numbers[i]);
        }
        
        Console.WriteLine();
        Console.WriteLine("Sum: " + Sum(numbers));
    }
    
    static int Sum(List<int> list)
    {
        int total = 0;
        for (int i = 0; i < list.Count; i++)
        {
            total += list[i];
        }
        return total;
    }
}
```

### JSON Serialization

```csharp
using System;
using System.Text.Json;

class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
    public bool IsEmployed { get; set; }
}

class Program
{
    static void Main()
    {
        // Create object
        var person = new Person
        {
            Name = "John Doe",
            Age = 30,
            IsEmployed = true
        };
        
        // Serialize to JSON
        string json = JsonSerializer.Serialize(person);
        Console.WriteLine("Serialized:");
        Console.WriteLine(json);
        Console.WriteLine();
        
        // Deserialize back
        string input = "{\"Name\":\"Jane\",\"Age\":25,\"IsEmployed\":false}";
        Console.WriteLine("Input JSON:");
        Console.WriteLine(input);
        Console.WriteLine();
        
        var parsed = JsonSerializer.Deserialize<Person>(input);
        Console.WriteLine("Deserialized:");
        Console.Write("Name: ");
        Console.WriteLine(parsed.Name);
        Console.Write("Age: ");
        Console.WriteLine(parsed.Age);
        Console.Write("Employed: ");
        Console.WriteLine(parsed.IsEmployed);
    }
}
```

### Reflection

```csharp
using System;
using System.Reflection;

class MyClass
{
    public int Value { get; set; }
    public string Name { get; set; }
    
    public void Print()
    {
        Console.WriteLine("Value: " + Value);
        Console.WriteLine("Name: " + Name);
    }
}

class Program
{
    static void Main()
    {
        // Get type info
        Type type = typeof(MyClass);
        Console.WriteLine("Type: " + type.Name);
        Console.WriteLine();
        
        // List properties
        Console.WriteLine("Properties:");
        PropertyInfo[] props = type.GetProperties();
        for (int i = 0; i < props.Length; i++)
        {
            Console.WriteLine("  " + props[i].Name);
        }
        Console.WriteLine();
        
        // Create instance dynamically
        object obj = Activator.CreateInstance(type);
        
        // Set properties via reflection
        PropertyInfo valueProp = type.GetProperty("Value");
        PropertyInfo nameProp = type.GetProperty("Name");
        
        valueProp.SetValue(obj, 42);
        nameProp.SetValue(obj, "Hello");
        
        // Call method
        MethodInfo printMethod = type.GetMethod("Print");
        printMethod.Invoke(obj, null);
    }
}
```

---

## 12. Requisitos de Sistema

### Para rodar o Compilador (desenvolvimento)
- .NET 8.0 SDK
- Windows, Linux, ou macOS

### Para rodar o programa compilado
- **Minimo:** 80386 + 2MB RAM + DOS 5.0
- **Recomendado:** 80486DX + 4MB RAM + FreeDOS/DOSBox
- **Ideal:** Pentium + 16MB RAM + DOSBox 0.74+

### Compatibilidade testada
- DOSBox 0.74 e SVN
- DOSBox-X
- FreeDOS 1.3
- MS-DOS 6.22
- PC real 486/Pentium

---

## 13. Licenca

MIT License

```
Copyright (c) 2024

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 14. Creditos e Referencias

- Intel 80386 Programmer's Reference Manual
- Intel 80387 Programmer's Reference Manual
- ECMA-335: Common Language Infrastructure (CLI)
- MS-DOS Programmer's Reference
- Ralph Brown's Interrupt List
- IEEE 754 Floating Point Standard
