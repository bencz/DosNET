# MSIL to i386 Real Mode Assembly Transpiler

## Mudanca de Arquitetura: 8086 -> i386

### Justificativa

O 8086 puro apresenta limitacoes severas para um runtime .NET completo:

| Limitacao 8086 | Impacto | Solucao i386 |
|----------------|---------|--------------|
| Segmentos 64KB | Runtime nao cabe | Flat Real Mode = 4GB |
| Registradores 16-bit | Aritmetica 32-bit lenta | EAX, EBX, ECX, EDX nativos |
| Sem IMUL reg,reg,imm | Multiplicacao complexa | `IMUL EAX, EBX, 100` |
| Sem SHL reg, imm | Precisa CL | `SHL EAX, 5` direto |
| Ponteiros segmentados | Codigo complexo | Ponteiros 32-bit lineares |
| Sem MOVZX/MOVSX | Extensao manual | `MOVZX EAX, BL` |
| Sem BSF/BSR | Bit scan manual | Instrucoes nativas |
| Sem PUSH imm | Precisa MOV+PUSH | `PUSH 12345678h` |

### Target Final

```
┌─────────────────────────────────────────────────────────────┐
│  TARGET: i386+ em Flat Real Mode (Unreal Mode)              │
│                                                              │
│  - Compativel com DOS (INT 21h funciona)                    │
│  - Registradores 32-bit (EAX, EBX, ECX, EDX, ESI, EDI)     │
│  - Acesso linear a 4GB de memoria                           │
│  - Instrucoes i386 completas                                │
│  - Ainda roda em DOSBox, FreeDOS, MS-DOS com himem          │
│                                                              │
│  Requisito minimo: 80386 ou superior                        │
│  (Qualquer PC de 1990+ serve)                               │
└─────────────────────────────────────────────────────────────┘
```

---

## Visao Geral do Projeto

Este projeto implementa um **transpilador de MSIL (Microsoft Intermediate Language) para Assembly i386**, permitindo que programas .NET sejam executados em sistemas DOS. O projeto inclui suporte completo para:

- Coprocessador matematico x87 (387+) OU emulacao de ponto flutuante em software
- Registradores 32-bit para performance otima
- Flat Real Mode para acesso a memoria alem de 1MB
- VTables para metodos virtuais e interfaces
- Generics via monomorphization
- Reflection em runtime
- Serializacao JSON (System.Text.Json compativel)
- Garbage Collector mark-and-sweep
- BCL (Base Class Library) customizada para DOS

---

## Arquitetura do Sistema

```
┌─────────────────────────────────────────────────────────────────┐
│                        INPUT                                     │
│                   .NET Assembly (.dll/.exe)                      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    FASE 1: IL Reader                             │
│  - Usa System.Reflection.Metadata (nativo do .NET)              │
│  - Le tipos, metodos, campos, propriedades                       │
│  - Decodifica bytecode IL                                        │
│  - Extrai custom attributes (Asm386Implementation)               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                 FASE 2: Metadata Builder                         │
│  - Constroi tabelas de tipos (TypeDef)                          │
│  - Constroi tabelas de metodos (MethodDef)                      │
│  - Constroi tabelas de campos (FieldDef)                        │
│  - Constroi tabelas de propriedades (PropertyDef)               │
│  - Processa generics (monomorphization)                          │
│  - Constroi VTables para tipos com metodos virtuais             │
│  - Constroi Interface Maps para dispatch de interface           │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                 FASE 3: Code Generator                           │
│  - Traduz cada instrucao IL para Assembly i386                  │
│  - Usa registradores 32-bit (EAX, EBX, ECX, EDX, ESI, EDI)     │
│  - Gerencia pilha de avaliacao                                   │
│  - Gera prologo/epilogo de metodos                              │
│  - Processa chamadas virtuais via VTable                        │
│  - Processa chamadas de interface via Interface Map             │
│  - Gera codigo x87 OU chamadas para soft-float                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                 FASE 4: Runtime Generator                        │
│  - Flat Real Mode setup                                          │
│  - Garbage Collector (mark-and-sweep)                           │
│  - Reflection runtime                                            │
│  - JSON Serializer runtime                                       │
│  - String/IO runtime                                             │
│  - Soft-float runtime (se nao usar x87)                         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        OUTPUT                                    │
│                   Assembly i386 (.asm)                           │
│  Compativel com: MASM 6.x, TASM 5.x, NASM, FASM                │
└─────────────────────────────────────────────────────────────────┘
```

---

## Estrutura de Diretorios

```
MsilTo386/
├── MsilTo386.sln
├── Compiler/
│   ├── Compiler.csproj
│   ├── Program.cs                    # Entry point CLI
│   ├── CompilerOptions.cs            # Opcoes de compilacao
│   ├── IL/
│   │   ├── ILReader.cs               # Leitor de assemblies .NET
│   │   ├── ILInstruction.cs          # Estrutura de instrucao IL
│   │   └── ILOpCode.cs               # Enum de opcodes IL
│   ├── Metadata/
│   │   ├── MetadataBuilder.cs        # Construtor de tabelas
│   │   ├── MetadataStructures.cs     # TypeDef, MethodDef, etc
│   │   ├── VTableBuilder.cs          # Construtor de VTables
│   │   ├── InterfaceDispatch.cs      # Interface method tables
│   │   └── GenericsProcessor.cs      # Monomorphization
│   ├── Analysis/
│   │   ├── TypeAnalyzer.cs           # Analise de hierarquia
│   │   ├── FlowAnalyzer.cs           # Analise de fluxo
│   │   └── EscapeAnalyzer.cs         # Stack vs Heap allocation
│   ├── CodeGen/
│   │   ├── I386Generator.cs          # Gerador principal
│   │   ├── InstructionEmitter.cs     # Emite instrucoes i386
│   │   ├── RegisterAllocator.cs      # Alocacao de registradores
│   │   ├── StackManager.cs           # Gerencia eval stack
│   │   ├── X87Generator.cs           # Geracao de codigo FPU
│   │   └── CallingConventions.cs     # cdecl, stdcall, fastcall
│   ├── Runtime/
│   │   ├── FlatRealMode.cs           # Setup do Unreal Mode
│   │   ├── GarbageCollector.cs       # GC mark-and-sweep
│   │   ├── ReflectionRuntime.cs      # Type.GetType, etc
│   │   ├── JsonSerializerRuntime.cs  # JSON serialize/deserialize
│   │   ├── StringRuntime.cs          # Operacoes de string
│   │   ├── MathRuntime.cs            # Math.Sin, Cos, etc
│   │   ├── SoftFloatRuntime.cs       # Emulacao IEEE 754
│   │   └── ExceptionRuntime.cs       # try/catch/finally
│   └── Optimization/
│       ├── Devirtualizer.cs          # Devirtualizacao
│       ├── Inliner.cs                # Inline de metodos
│       ├── RegisterOptimizer.cs      # Evitar spills
│       └── PeepholeOptimizer.cs      # Otimizacoes locais
├── BCL/
│   ├── BCL.csproj
│   ├── Attributes.cs                 # Asm386Implementation, etc
│   ├── System/
│   │   ├── Object.cs
│   │   ├── String.cs
│   │   ├── Console.cs
│   │   ├── Math.cs
│   │   ├── Array.cs
│   │   ├── Exception.cs
│   │   ├── Int32.cs
│   │   ├── Int64.cs                  # 64-bit nativo!
│   │   ├── Single.cs
│   │   ├── Double.cs
│   │   └── Boolean.cs
│   ├── System.Collections/
│   │   └── Generic/
│   │       ├── List.cs
│   │       ├── Dictionary.cs
│   │       └── Stack.cs
│   ├── System.Text/
│   │   └── StringBuilder.cs
│   └── System.Text.Json/
│       └── JsonSerializer.cs
└── Samples/
    ├── HelloWorld/
    ├── Fibonacci/
    ├── LinkedList/
    ├── JsonExample/
    └── GameOfLife/
```

---

## Especificacao Detalhada dos Componentes

### 1. Custom Attributes para BCL

A BCL usa atributos especiais para informar ao transpilador como gerar codigo assembly:

```csharp
namespace System.Runtime.CompilerServices
{
    /// <summary>
    /// Marca um metodo com sua implementacao em Assembly i386.
    /// O transpilador usa esse atributo para gerar o codigo correto.
    /// </summary>
    [AttributeUsage(AttributeTargets.Method | AttributeTargets.Constructor)]
    public class Asm386ImplementationAttribute : Attribute
    {
        /// <summary>
        /// Codigo assembly i386 que implementa este metodo.
        /// Marcadores especiais:
        ///   {ARG0}, {ARG1}, ... - Argumentos do metodo (32-bit)
        ///   {LOCAL0}, {LOCAL1}, ... - Variaveis locais
        ///   {RET} - Valor de retorno (EAX ou EDX:EAX para 64-bit)
        ///   {THIS} - Referencia this (para metodos de instancia)
        /// </summary>
        public string Assembly { get; }
        
        /// <summary>
        /// Se true, o codigo chama uma rotina de runtime
        /// </summary>
        public bool IsRuntimeCall { get; set; }
        
        /// <summary>
        /// Nome da rotina de runtime a ser chamada
        /// </summary>
        public string? RuntimeRoutine { get; set; }
        
        /// <summary>
        /// Se o metodo usa o FPU x87
        /// </summary>
        public bool UsesX87 { get; set; }
        
        /// <summary>
        /// Codigo alternativo para quando nao ha FPU (software float)
        /// </summary>
        public string? SoftFloatAssembly { get; set; }
        
        /// <summary>
        /// Calling convention: cdecl (default), stdcall, fastcall
        /// </summary>
        public CallingConvention Convention { get; set; } = CallingConvention.Cdecl;
        
        public Asm386ImplementationAttribute(string assembly)
        {
            Assembly = assembly;
        }
    }
    
    /// <summary>
    /// Marca um metodo como intrinseco - substituido por instrucao(oes) direta(s)
    /// </summary>
    [AttributeUsage(AttributeTargets.Method)]
    public class Asm386IntrinsicAttribute : Attribute
    {
        /// <summary>
        /// Instrucao ou sequencia de instrucoes
        /// Exemplo: "IMUL EAX, EBX" ou "BSF EAX, EBX"
        /// </summary>
        public string Instructions { get; }
        
        public Asm386IntrinsicAttribute(string instructions)
        {
            Instructions = instructions;
        }
    }
    
    /// <summary>
    /// Define tamanho de um tipo para o i386
    /// </summary>
    [AttributeUsage(AttributeTargets.Struct | AttributeTargets.Class)]
    public class Asm386LayoutAttribute : Attribute
    {
        public int Size { get; }
        public int Alignment { get; set; } = 4; // Default 4-byte alignment
        
        public Asm386LayoutAttribute(int size) => Size = size;
    }
    
    public enum CallingConvention
    {
        Cdecl,      // Caller cleans stack, args right-to-left
        Stdcall,    // Callee cleans stack, args right-to-left
        Fastcall    // First 2 args in ECX, EDX
    }
}
```

### 2. Exemplo de BCL - Console (i386)

```csharp
using System.Runtime.CompilerServices;

namespace System
{
    public static class Console
    {
        [Asm386Implementation(@"
            ; Console.Write(string)
            ; {ARG0} = ponteiro para string (null-terminated)
            MOV ESI, {ARG0}
            TEST ESI, ESI
            JZ .done
        .loop:
            LODSB
            TEST AL, AL
            JZ .done
            MOV AH, 02h
            MOV DL, AL
            INT 21h
            JMP .loop
        .done:
        ")]
        public static void Write(string? value) { }
        
        [Asm386Implementation(@"
            ; Console.Write(int) - 32-bit nativo!
            MOV EAX, {ARG0}
            CALL __rt_print_int32
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_print_int32")]
        public static void Write(int value) { }
        
        [Asm386Implementation(@"
            ; Console.Write(long) - 64-bit em EDX:EAX
            MOV EAX, {ARG0}       ; low 32 bits
            MOV EDX, {ARG0_HI}    ; high 32 bits
            CALL __rt_print_int64
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_print_int64")]
        public static void Write(long value) { }
        
        [Asm386Implementation(@"
            ; Console.Write(char)
            MOV DL, {ARG0}
            MOV AH, 02h
            INT 21h
        ")]
        public static void Write(char value) { }
        
        [Asm386Implementation(@"
            ; Console.Write(float) - x87
            FLD DWORD PTR {ARG0}
            CALL __rt_print_float
        ", UsesX87 = true, IsRuntimeCall = true, RuntimeRoutine = "__rt_print_float",
        SoftFloatAssembly = @"
            MOV EAX, {ARG0}
            CALL __rt_print_float_soft
        ")]
        public static void Write(float value) { }
        
        [Asm386Implementation(@"
            ; Console.Write(double) - x87
            FLD QWORD PTR {ARG0}
            CALL __rt_print_double
        ", UsesX87 = true, IsRuntimeCall = true, RuntimeRoutine = "__rt_print_double",
        SoftFloatAssembly = @"
            MOV EAX, {ARG0}
            MOV EDX, {ARG0_HI}
            CALL __rt_print_double_soft
        ")]
        public static void Write(double value) { }
        
        [Asm386Implementation(@"
            ; Console.WriteLine()
            MOV AH, 02h
            MOV DL, 13
            INT 21h
            MOV DL, 10
            INT 21h
        ")]
        public static void WriteLine() { }
        
        [Asm386Implementation(@"
            ; Console.WriteLine(string)
            MOV ESI, {ARG0}
            TEST ESI, ESI
            JZ .newline
        .loop:
            LODSB
            TEST AL, AL
            JZ .newline
            MOV AH, 02h
            MOV DL, AL
            INT 21h
            JMP .loop
        .newline:
            MOV DL, 13
            INT 21h
            MOV DL, 10
            INT 21h
        ")]
        public static void WriteLine(string? value) { }
        
        [Asm386Implementation(@"
            ; Console.WriteLine(int)
            MOV EAX, {ARG0}
            CALL __rt_print_int32
            MOV AH, 02h
            MOV DL, 13
            INT 21h
            MOV DL, 10
            INT 21h
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_print_int32")]
        public static void WriteLine(int value) { }
        
        [Asm386Implementation(@"
            ; Console.Read()
            MOV AH, 01h
            INT 21h
            MOVZX EAX, AL
        ")]
        public static int Read() => 0;
        
        [Asm386Implementation(@"
            ; Console.ReadKey() - sem echo
            MOV AH, 08h
            INT 21h
            MOVZX EAX, AL
        ")]
        public static char ReadKey() => '\0';
        
        [Asm386Implementation(@"
            ; Console.ReadLine()
            CALL __rt_read_line
            ; EAX = ponteiro para buffer com string lida
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_read_line")]
        public static string? ReadLine() => null;
        
        // Cores do console (bonus!)
        [Asm386Implementation(@"
            ; Console.SetForegroundColor
            MOV EAX, {ARG0}
            MOV [__console_fg_color], AL
        ")]
        public static void SetForegroundColor(ConsoleColor color) { }
        
        [Asm386Implementation(@"
            ; Console.SetCursorPosition
            MOV DH, {ARG1}      ; row
            MOV DL, {ARG0}      ; column
            MOV AH, 02h
            XOR BH, BH
            INT 10h
        ")]
        public static void SetCursorPosition(int left, int top) { }
        
        [Asm386Implementation(@"
            ; Console.Clear
            MOV AX, 0003h       ; Mode 3 = 80x25 text
            INT 10h
        ")]
        public static void Clear() { }
    }
    
    public enum ConsoleColor
    {
        Black = 0, DarkBlue = 1, DarkGreen = 2, DarkCyan = 3,
        DarkRed = 4, DarkMagenta = 5, DarkYellow = 6, Gray = 7,
        DarkGray = 8, Blue = 9, Green = 10, Cyan = 11,
        Red = 12, Magenta = 13, Yellow = 14, White = 15
    }
}
```

### 3. Flat Real Mode Setup

```csharp
namespace MsilTo386.Runtime
{
    /// <summary>
    /// Gera codigo para entrar em Flat Real Mode (Unreal Mode)
    /// Permite acesso a 4GB de memoria linear em modo real
    /// </summary>
    public class FlatRealModeGenerator
    {
        public string Generate()
        {
            return @"
; =============================================
; FLAT REAL MODE (UNREAL MODE) SETUP
; Permite acesso a 4GB em modo real DOS
; =============================================

.386P                           ; Habilitar instrucoes privilegiadas

; GDT para Flat Real Mode
ALIGN 8
__gdt_start:
    ; Null descriptor
    DQ 0
    
    ; Flat data descriptor (4GB limit)
    DW 0FFFFh                   ; Limit 0-15
    DW 0                        ; Base 0-15
    DB 0                        ; Base 16-23
    DB 10010010b                ; Access: Present, Ring 0, Data, Writable
    DB 11001111b                ; Flags: 4KB granularity, 32-bit, Limit 16-19
    DB 0                        ; Base 24-31
    
__gdt_end:

__gdt_ptr:
    DW __gdt_end - __gdt_start - 1  ; Limit
    DD __gdt_start                   ; Base

; =============================================
; __rt_enter_flat_real
; Entra em Flat Real Mode
; Chamado uma vez na inicializacao
; =============================================
__rt_enter_flat_real PROC
    CLI                         ; Desabilitar interrupcoes
    
    ; Salvar registradores de segmento
    PUSH DS
    PUSH ES
    PUSH FS
    PUSH GS
    
    ; Carregar GDT
    LGDT FWORD PTR [__gdt_ptr]
    
    ; Entrar em protected mode momentaneamente
    MOV EAX, CR0
    OR AL, 1
    MOV CR0, EAX
    
    ; Flush pipeline
    JMP SHORT $+2
    
    ; Carregar seletores com limite de 4GB
    MOV BX, 08h                 ; Seletor do flat descriptor
    MOV DS, BX
    MOV ES, BX
    MOV FS, BX
    MOV GS, BX
    
    ; Voltar para real mode
    AND AL, 0FEh
    MOV CR0, EAX
    
    ; Flush pipeline novamente
    JMP SHORT $+2
    
    ; Restaurar segmentos (mantem limite de 4GB!)
    POP GS
    POP FS
    POP ES
    POP DS
    
    STI                         ; Reabilitar interrupcoes
    
    ; Agora podemos acessar memoria alem de 1MB!
    ; Exemplo: MOV EAX, [ESI + 100000h]
    
    RET
__rt_enter_flat_real ENDP

; =============================================
; Verificar se estamos em 386+
; =============================================
__rt_check_386 PROC
    PUSHFD
    POP EAX
    MOV ECX, EAX
    XOR EAX, 40000h             ; Flip AC bit
    PUSH EAX
    POPFD
    PUSHFD
    POP EAX
    XOR EAX, ECX
    JZ .not_386
    
    ; Restaurar flags
    PUSH ECX
    POPFD
    
    MOV EAX, 1                  ; OK
    RET
    
.not_386:
    PUSH ECX
    POPFD
    XOR EAX, EAX                ; Falha
    RET
__rt_check_386 ENDP
";
        }
    }
}
```

### 4. Estruturas de Metadata (32-bit)

```csharp
namespace MsilTo386.Metadata
{
    /// <summary>
    /// Header das tabelas de metadata no binario
    /// Offset 0 do segmento de metadata
    /// </summary>
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct MetadataHeader
    {
        public uint Magic;              // 0x80386NET
        public ushort Version;          // 1
        public ushort Flags;            // MetadataFlags
        public uint TypeCount;
        public uint MethodCount;
        public uint FieldCount;
        public uint PropertyCount;
        public uint GenericInstCount;
        public uint VTableCount;
        public uint InterfaceImplCount;
        public uint StringHeapSize;
        // Offsets para cada tabela (32-bit para suportar >64KB)
        public uint TypeTableOffset;
        public uint MethodTableOffset;
        public uint FieldTableOffset;
        public uint PropertyTableOffset;
        public uint StringHeapOffset;
        public uint CodeSectionOffset;
        public uint DataSectionOffset;
    }
    
    [Flags]
    public enum MetadataFlags : ushort
    {
        None = 0,
        HasReflection = 1,
        HasGenerics = 2,
        HasExceptions = 4,
        UsesX87 = 8,
        UsesSoftFloat = 16,
        FlatRealMode = 32
    }
    
    /// <summary>
    /// Entrada na tabela de tipos (32 bytes cada)
    /// </summary>
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct TypeDefEntry
    {
        public uint NameOffset;         // Offset no string heap
        public uint NamespaceOffset;    // Offset no string heap
        public uint Flags;              // TypeFlags
        public uint BaseTypeIndex;      // 0xFFFFFFFF = sem base
        public uint FieldListStart;     // Indice do primeiro campo
        public uint FieldCount;
        public uint MethodListStart;    // Indice do primeiro metodo
        public uint MethodCount;
        public uint InstanceSize;       // Tamanho em bytes
        public uint VTableOffset;       // Offset da VTable no codigo
    }
    
    [Flags]
    public enum TypeFlags : uint
    {
        None = 0,
        Public = 1,
        Sealed = 2,
        Abstract = 4,
        Interface = 8,
        ValueType = 16,
        Enum = 32,
        Delegate = 64,
        HasGenericParams = 128,
        IsGenericInst = 256,
        Serializable = 512,
        HasFinalizer = 1024
    }
    
    /// <summary>
    /// Entrada na tabela de metodos (28 bytes cada)
    /// </summary>
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct MethodDefEntry
    {
        public uint NameOffset;
        public uint Flags;              // MethodFlags
        public uint DeclaringTypeIndex;
        public uint SignatureOffset;    // Offset para assinatura
        public ushort ParamCount;
        public ushort LocalCount;
        public uint CodeOffset;         // Offset no segmento de codigo
        public ushort VTableSlot;       // Slot na VTable (se virtual)
        public ushort StackSize;        // Tamanho maximo da pilha
    }
    
    /// <summary>
    /// Entrada na tabela de campos (20 bytes cada)
    /// </summary>
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct FieldDefEntry
    {
        public uint NameOffset;
        public uint Flags;              // FieldFlags
        public uint DeclaringTypeIndex;
        public uint FieldTypeIndex;
        public uint Offset;             // Offset na instancia
        public uint Size;               // Tamanho em bytes
    }
}
```

### 5. VTables (32-bit)

```
Layout de VTable no Assembly i386:

ALIGN 4
__vtbl_MyClass:
    DD OFFSET __Object_ToString      ; slot 0 - herdado
    DD OFFSET __Object_GetHashCode   ; slot 1 - herdado  
    DD OFFSET __Object_Equals        ; slot 2 - herdado
    DD OFFSET __MyClass_MyVirtual    ; slot 3 - novo
    DD OFFSET __MyClass_Override     ; slot 4 - override

Layout de Objeto na Memoria (32-bit aligned):

[Instancia de MyClass]
+0:  DD __vtbl_MyClass    ; ponteiro para VTable (32-bit)
+4:  DD field1            ; primeiro campo
+8:  DD field2            ; segundo campo
+12: ...

Chamada Virtual (muito mais simples que 8086!):
    ; ESI = ponteiro para objeto
    MOV EAX, [ESI]              ; EAX = VTable pointer
    CALL DWORD PTR [EAX + 12]   ; Chamar slot 3 (offset = slot * 4)
```

### 6. Mapeamento IL para i386

| IL Instruction | i386 Assembly | Notas |
|---------------|---------------|-------|
| `ldc.i4 N` | `PUSH N` | Push imediato 32-bit! |
| `ldc.i4.0` | `PUSH 0` | Simples |
| `ldc.i8 N` | `PUSH high` / `PUSH low` | 64-bit em 2 pushes |
| `ldloc.0` | `PUSH DWORD PTR [EBP-4]` | Acesso direto |
| `stloc.0` | `POP DWORD PTR [EBP-4]` | Acesso direto |
| `ldarg.0` | `PUSH DWORD PTR [EBP+8]` | Acesso direto |
| `add` | `POP EBX` / `POP EAX` / `ADD EAX, EBX` / `PUSH EAX` | 32-bit nativo |
| `add` (otimizado) | `POP EAX` / `ADD [ESP], EAX` | Evita pop+push |
| `sub` | `POP EBX` / `POP EAX` / `SUB EAX, EBX` / `PUSH EAX` | 32-bit nativo |
| `mul` | `POP EBX` / `POP EAX` / `IMUL EAX, EBX` / `PUSH EAX` | IMUL reg,reg! |
| `div` | `POP EBX` / `POP EAX` / `CDQ` / `IDIV EBX` / `PUSH EAX` | CDQ para 64-bit |
| `shl` | `POP ECX` / `POP EAX` / `SHL EAX, CL` / `PUSH EAX` | |
| `shl` (const) | `POP EAX` / `SHL EAX, N` / `PUSH EAX` | SHL imediato! |
| `ceq` | `POP EBX` / `POP EAX` / `CMP EAX, EBX` / `SETE AL` / `MOVZX EAX, AL` / `PUSH EAX` | SETE + MOVZX |
| `clt` | Similar com `SETL` | |
| `cgt` | Similar com `SETG` | |
| `br LABEL` | `JMP LABEL` | |
| `brfalse LABEL` | `POP EAX` / `TEST EAX, EAX` / `JZ LABEL` | TEST mais rapido |
| `brtrue LABEL` | `POP EAX` / `TEST EAX, EAX` / `JNZ LABEL` | |
| `beq LABEL` | `POP EBX` / `POP EAX` / `CMP EAX, EBX` / `JE LABEL` | |
| `call METHOD` | `CALL __METHOD_LABEL` | |
| `callvirt METHOD` | VTable dispatch | Ver acima |
| `ret` | `MOV ESP, EBP` / `POP EBP` / `RET` | |
| `ret N` (stdcall) | `MOV ESP, EBP` / `POP EBP` / `RET N` | Limpa pilha |
| `newobj CTOR` | `PUSH size` / `CALL __gc_alloc` / `PUSH EAX` / `CALL ctor` | |
| `ldfld FIELD` | `POP ESI` / `PUSH DWORD PTR [ESI+offset]` | Acesso direto |
| `stfld FIELD` | `POP EAX` / `POP ESI` / `MOV [ESI+offset], EAX` | |
| `ldsfld FIELD` | `PUSH DWORD PTR [__FIELD_LABEL]` | |
| `stsfld FIELD` | `POP DWORD PTR [__FIELD_LABEL]` | |
| `ldstr "..."` | `PUSH OFFSET __str_N` | |
| `dup` | `PUSH DWORD PTR [ESP]` | Sem pop+push+push! |
| `pop` | `ADD ESP, 4` | |
| `ldlen` | `POP ESI` / `PUSH DWORD PTR [ESI-4]` | Length antes do array |
| `ldelem.i4` | `POP EBX` / `POP ESI` / `PUSH DWORD PTR [ESI+EBX*4]` | Scaled index! |
| `stelem.i4` | `POP EAX` / `POP EBX` / `POP ESI` / `MOV [ESI+EBX*4], EAX` | |

### 7. Operacoes 64-bit

```asm
; IL: ldc.i8 0x123456789ABCDEF0
PUSH 12345678h          ; High DWORD
PUSH 9ABCDEF0h          ; Low DWORD

; IL: add (long)
; Stack: [low1][high1][low2][high2]
POP EBX                 ; high2
POP EAX                 ; low2
POP EDX                 ; high1
ADD [ESP], EAX          ; low1 += low2
ADC EDX, EBX            ; high1 += high2 + carry
PUSH EDX                ; resultado high

; IL: mul (long) - mais complexo, usa runtime
CALL __rt_mul64

; IL: div (long) - usa runtime
CALL __rt_div64
```

### 8. Operacoes de Ponto Flutuante (x87)

```asm
; IL: ldc.r4 3.14
FLD DWORD PTR [__flt_pi]

; IL: ldc.r8 2.71828
FLD QWORD PTR [__dbl_e]

; IL: add (float/double)
FADDP ST(1), ST

; IL: sub (float/double)
FSUBP ST(1), ST

; IL: mul (float/double)
FMULP ST(1), ST

; IL: div (float/double)
FDIVP ST(1), ST

; IL: conv.r4 (int -> float)
FILD DWORD PTR [ESP]
ADD ESP, 4
SUB ESP, 4
FSTP DWORD PTR [ESP]

; IL: conv.i4 (float -> int)
; Requer controle de arredondamento
FNSTCW [__fpu_cw]
MOV AX, [__fpu_cw]
OR AX, 0C00h            ; Truncate mode
MOV [__fpu_cw_trunc], AX
FLDCW [__fpu_cw_trunc]
FISTP DWORD PTR [ESP]
FLDCW [__fpu_cw]        ; Restaurar

; Funcoes matematicas (usando x87)
; Math.Sin
FSIN

; Math.Cos  
FCOS

; Math.Sqrt
FSQRT

; Math.Abs
FABS

; Math.Log
FYL2X                   ; y * log2(x)
; Precisa ajuste para ln

; Math.Pow - mais complexo
CALL __rt_pow
```

### 9. Software Float (IEEE 754)

Para sistemas sem x87 (raro em i386, mas possivel):

```csharp
namespace MsilTo386.Runtime
{
    /// <summary>
    /// Emulacao IEEE 754 32-bit em software
    /// Muito mais eficiente que no 8086 gracas a registradores 32-bit
    /// </summary>
    public class SoftFloatRuntimeGenerator
    {
        public string Generate()
        {
            return @"
; =============================================
; IEEE 754 Single-Precision Software Float
; Layout: [1 sign][8 exponent][23 mantissa]
; =============================================

; Adicao de floats IEEE 754
; Input: EAX = float1, EBX = float2
; Output: EAX = resultado
__soft_fadd PROC
    PUSH ECX
    PUSH EDX
    PUSH ESI
    PUSH EDI
    
    ; Extrair componentes de EAX
    MOV ECX, EAX
    SHR ECX, 23
    AND ECX, 0FFh           ; ECX = exp1
    MOV ESI, EAX
    AND ESI, 007FFFFFh      ; ESI = mantissa1
    OR ESI, 00800000h       ; Adicionar bit implicito
    TEST EAX, 80000000h
    JZ .pos1
    NEG ESI
.pos1:
    
    ; Extrair componentes de EBX
    MOV EDX, EBX
    SHR EDX, 23
    AND EDX, 0FFh           ; EDX = exp2
    MOV EDI, EBX
    AND EDI, 007FFFFFh      ; EDI = mantissa2
    OR EDI, 00800000h
    TEST EBX, 80000000h
    JZ .pos2
    NEG EDI
.pos2:
    
    ; Alinhar expoentes
    CMP ECX, EDX
    JE .aligned
    JG .shift2
    
    ; Shift mantissa1
    MOV EAX, EDX
    SUB EAX, ECX
    CMP EAX, 24
    JGE .use_b              ; float1 muito pequeno
    SAR ESI, CL
    MOV ECX, EDX
    JMP .aligned
    
.shift2:
    MOV EAX, ECX
    SUB EAX, EDX
    CMP EAX, 24
    JGE .use_a              ; float2 muito pequeno
    XCHG ECX, EAX
    SAR EDI, CL
    MOV ECX, EAX
    JMP .aligned
    
.use_a:
    ; Resultado e float1
    MOV EAX, [ESP+16]       ; Original EAX
    JMP .done
    
.use_b:
    MOV EAX, EBX
    JMP .done
    
.aligned:
    ; Somar mantissas
    ADD ESI, EDI
    
    ; Normalizar
    TEST ESI, ESI
    JZ .zero
    JS .negative
    
    ; Positivo - encontrar bit mais significativo
    BSR EAX, ESI
    SUB EAX, 23
    JZ .normalized
    JG .shift_right
    
    ; Shift left
    NEG EAX
    SHL ESI, CL
    SUB ECX, EAX
    JMP .normalized
    
.shift_right:
    SHR ESI, CL
    ADD ECX, EAX
    JMP .normalized
    
.negative:
    NEG ESI
    BSR EAX, ESI
    SUB EAX, 23
    ; ... similar ao positivo, mas com sign bit
    
.normalized:
    ; Montar resultado
    AND ESI, 007FFFFFh      ; Remover bit implicito
    SHL ECX, 23
    OR EAX, ESI
    OR EAX, ECX
    JMP .done
    
.zero:
    XOR EAX, EAX
    
.done:
    POP EDI
    POP ESI
    POP EDX
    POP ECX
    RET
__soft_fadd ENDP

; Multiplicacao IEEE 754
__soft_fmul PROC
    ; ... implementacao similar
    ; Mais simples: multiplica mantissas, soma expoentes
    RET
__soft_fmul ENDP

; Divisao IEEE 754
__soft_fdiv PROC
    ; ... divide mantissas, subtrai expoentes
    RET
__soft_fdiv ENDP

; Conversao int -> float
__soft_itof PROC
    ; Input: EAX = int32
    ; Output: EAX = float
    TEST EAX, EAX
    JZ .zero
    
    MOV ECX, EAX
    JS .negative
    
    BSR EDX, EAX            ; Encontrar bit mais significativo
    MOV CL, DL
    SUB CL, 23
    JLE .shift_left
    SHR EAX, CL
    JMP .build
.shift_left:
    NEG CL
    SHL EAX, CL
.build:
    ADD EDX, 127            ; Bias do expoente
    AND EAX, 007FFFFFh
    SHL EDX, 23
    OR EAX, EDX
    RET
    
.negative:
    NEG EAX
    ; ... mesmo processo, adiciona sign bit
    RET
    
.zero:
    RET
__soft_itof ENDP
";
        }
    }
}
```

### 10. Garbage Collector (i386)

```asm
; =============================================
; GARBAGE COLLECTOR - i386 Version
; Mark-and-Sweep com heap em memoria alta
; (acessivel via Flat Real Mode)
; =============================================

.DATA
__gc_heap_start   DD 0          
__gc_heap_end     DD 0          
__gc_free_ptr     DD 0          
__gc_heap_size    DD 1048576    ; 1MB default!
__gc_collections  DD 0

.CODE

; =============================================
; __gc_init
; Inicializa o GC com heap em memoria alta
; =============================================
__gc_init PROC
    ; Usar memoria apos o primeiro 1MB
    ; (acessivel em Flat Real Mode)
    MOV EAX, 100000h            ; 1MB
    MOV [__gc_heap_start], EAX
    MOV [__gc_free_ptr], EAX
    
    ADD EAX, [__gc_heap_size]
    MOV [__gc_heap_end], EAX
    
    RET
__gc_init ENDP

; =============================================
; __gc_alloc
; Aloca memoria no heap gerenciado
; Input: EAX = tamanho em bytes
; Output: EAX = ponteiro ou 0 se OOM
; =============================================
__gc_alloc PROC
    PUSH EBX
    PUSH ECX
    
    ; Adicionar header (8 bytes: size + type/flags)
    ADD EAX, 8
    
    ; Alinhar para 4 bytes
    ADD EAX, 3
    AND EAX, 0FFFFFFFCh
    
    MOV ECX, EAX                ; ECX = tamanho total
    
    ; Verificar espaco
    MOV EBX, [__gc_free_ptr]
    ADD EAX, EBX
    CMP EAX, [__gc_heap_end]
    JBE .ok
    
    ; Tentar GC
    PUSH ECX
    CALL __gc_collect
    POP ECX
    
    ; Tentar novamente
    MOV EBX, [__gc_free_ptr]
    MOV EAX, ECX
    ADD EAX, EBX
    CMP EAX, [__gc_heap_end]
    JBE .ok
    
    ; OOM
    XOR EAX, EAX
    JMP .done
    
.ok:
    ; Header
    MOV [EBX], ECX              ; size
    MOV DWORD PTR [EBX+4], 0    ; type/flags
    
    ; Avancar free pointer
    ADD [__gc_free_ptr], ECX
    
    ; Retornar ponteiro para dados
    LEA EAX, [EBX+8]
    
.done:
    POP ECX
    POP EBX
    RET
__gc_alloc ENDP

; =============================================
; __gc_collect
; Executa coleta de lixo
; =============================================
__gc_collect PROC
    PUSHAD
    
    INC DWORD PTR [__gc_collections]
    
    ; Fase 1: Clear marks
    MOV ESI, [__gc_heap_start]
.clear_loop:
    CMP ESI, [__gc_free_ptr]
    JAE .clear_done
    AND BYTE PTR [ESI+7], 0FEh  ; Clear mark bit
    ADD ESI, [ESI]              ; Next object
    JMP .clear_loop
.clear_done:
    
    ; Fase 2: Mark roots (stack)
    MOV ESI, EBP
.mark_stack:
    CMP ESI, [__stack_top]
    JAE .mark_globals
    
    MOV EAX, [ESI]
    CALL __gc_try_mark
    
    ADD ESI, 4
    JMP .mark_stack
    
.mark_globals:
    ; Marcar campos estaticos
    MOV ESI, OFFSET __static_roots
    MOV ECX, [__static_root_count]
.mark_global_loop:
    JECXZ .sweep
    
    MOV EAX, [ESI]
    CALL __gc_try_mark
    
    ADD ESI, 4
    DEC ECX
    JMP .mark_global_loop
    
.sweep:
    ; Fase 3: Sweep
    CALL __gc_sweep
    
    POPAD
    RET
__gc_collect ENDP

; =============================================
; __gc_try_mark
; Tenta marcar um ponteiro
; Input: EAX = possivel ponteiro
; =============================================
__gc_try_mark PROC
    ; Verificar range
    CMP EAX, [__gc_heap_start]
    JB .not_ptr
    CMP EAX, [__gc_free_ptr]
    JAE .not_ptr
    
    ; Voltar para header
    SUB EAX, 8
    
    ; Ja marcado?
    TEST BYTE PTR [EAX+7], 1
    JNZ .not_ptr
    
    ; Marcar
    OR BYTE PTR [EAX+7], 1
    
    ; Marcar filhos (simplificado: percorre todo objeto)
    PUSH ESI
    PUSH ECX
    
    MOV ECX, [EAX]              ; size
    SUB ECX, 8                  ; menos header
    SHR ECX, 2                  ; em dwords
    LEA ESI, [EAX+8]            ; inicio dos dados
    
.mark_children:
    JECXZ .mark_done
    
    PUSH ECX
    MOV EAX, [ESI]
    CALL __gc_try_mark          ; Recursivo
    POP ECX
    
    ADD ESI, 4
    DEC ECX
    JMP .mark_children
    
.mark_done:
    POP ECX
    POP ESI
    
.not_ptr:
    RET
__gc_try_mark ENDP

; =============================================
; __gc_sweep
; Remove objetos nao marcados
; =============================================
__gc_sweep PROC
    MOV ESI, [__gc_heap_start]  ; source
    MOV EDI, ESI                 ; dest
    
.sweep_loop:
    CMP ESI, [__gc_free_ptr]
    JAE .sweep_done
    
    TEST BYTE PTR [ESI+7], 1    ; marked?
    JZ .skip
    
    ; Mover se necessario
    CMP ESI, EDI
    JE .no_move
    
    MOV ECX, [ESI]
    PUSH ESI
    REP MOVSB
    POP ESI
    SUB EDI, [ESI]              ; Ajustar EDI (REP avancou)
    
.no_move:
    ADD EDI, [ESI]
    
.skip:
    ADD ESI, [ESI]
    JMP .sweep_loop
    
.sweep_done:
    MOV [__gc_free_ptr], EDI
    RET
__gc_sweep ENDP
```

### 11. JSON Serialization (i386)

O runtime de JSON e similar ao da versao 8086, mas muito mais eficiente com registradores 32-bit:

```asm
; =============================================
; JSON Serializer - i386 Version
; =============================================

__json_serialize PROC
    ; Input: ESI = objeto, EDI = TypeDef
    ; Output: EAX = ponteiro para string JSON
    
    PUSH EBX
    PUSH ECX
    PUSH EDX
    
    ; Alocar buffer
    PUSH 4096
    CALL __gc_alloc
    ADD ESP, 4
    MOV EBX, EAX                ; EBX = buffer
    
    MOV BYTE PTR [EBX], '{'
    INC EBX
    
    ; Obter propriedades
    PUSH EDI
    CALL __rt_get_properties
    ADD ESP, 4
    ; EAX = array, ECX = count
    
    MOV EDX, EAX                ; EDX = prop array
    XOR EBP, EBP                ; EBP = first flag
    
.prop_loop:
    JECXZ .done
    
    ; Virgula
    TEST EBP, EBP
    JZ .no_comma
    MOV BYTE PTR [EBX], ','
    INC EBX
.no_comma:
    INC EBP
    
    ; Nome da propriedade
    MOV BYTE PTR [EBX], '"'
    INC EBX
    
    MOV EAX, [EDX]              ; PropertyDef
    MOV EAX, [EAX]              ; name offset
    ADD EAX, OFFSET __strings
    
    ; Copiar nome
.copy_name:
    MOV AL, [EAX]
    TEST AL, AL
    JZ .name_done
    MOV [EBX], AL
    INC EAX
    INC EBX
    JMP .copy_name
    
.name_done:
    MOV WORD PTR [EBX], '":' ; '":'
    ADD EBX, 2
    
    ; Obter valor
    MOV EAX, [EDX]              ; PropertyDef
    PUSH ESI                    ; objeto
    PUSH EAX                    ; PropertyDef
    CALL __prop_get_value
    ADD ESP, 8
    ; EAX = valor
    
    ; Serializar valor
    ; ... (baseado no tipo)
    
    ADD EDX, 4
    DEC ECX
    JMP .prop_loop
    
.done:
    MOV BYTE PTR [EBX], '}'
    MOV BYTE PTR [EBX+1], 0
    
    ; Retornar inicio do buffer
    ; ... calcular
    
    POP EDX
    POP ECX
    POP EBX
    RET
__json_serialize ENDP
```

---

## Opcoes de Linha de Comando

```
msil386 [options] <input.dll|input.exe>

Options:
  -o, --output <file>     Arquivo de saida (default: input.asm)
  
  Target:
  --i386                  Target i386 (default)
  --i486                  Target i486 (adiciona BSWAP, XADD, etc)
  --i586                  Target Pentium (adiciona RDTSC, etc)
  
  Float:
  -x87, --x87             Usar coprocessador x87 (default)
  -sf, --softfloat        Usar emulacao software de float
  
  Memory:
  --flat-real             Usar Flat Real Mode (default, recomendado)
  --real-mode             Modo real puro (limitado a 1MB)
  --heap <size>           Tamanho do heap (default: 1048576 = 1MB)
  
  Runtime:
  --no-reflection         Desabilitar suporte a reflection
  --no-gc                 Desabilitar garbage collector
  --no-exceptions         Desabilitar try/catch/finally
  
  Optimization:
  -O0                     Sem otimizacoes
  -O1                     Otimizacoes basicas (default)
  -O2                     Otimizacoes agressivas
  --inline-threshold <n>  Threshold para inlining (default: 32)
  
  Output:
  --masm                  Sintaxe MASM (default)
  --tasm                  Sintaxe TASM
  --nasm                  Sintaxe NASM
  --fasm                  Sintaxe FASM
  
  Debug:
  -v, --verbose           Output detalhado
  --emit-comments         Incluir IL como comentarios
  --emit-debug-info       Gerar informacoes de debug
  
  -h, --help              Mostrar ajuda

Exemplos:
  msil386 MyApp.exe
  msil386 --softfloat -o output.asm MyApp.dll
  msil386 --i486 --heap 4194304 BigApp.exe
  msil386 --nasm -O2 FastApp.dll
```

---

## Comparacao: 8086 vs i386

| Aspecto | 8086 | i386 |
|---------|------|------|
| Registradores | 16-bit (AX, BX, CX, DX) | 32-bit (EAX, EBX, ECX, EDX) |
| Memoria max | 1MB (segmentado) | 4GB (Flat Real Mode) |
| Int32 | 2 registradores | 1 registrador |
| Int64 | 4 registradores | 2 registradores |
| Multiplicacao | MUL (16x16=32) | IMUL reg,reg (32x32=32) |
| SHL/SHR | Precisa CL | Imediato ate 31 |
| Push imediato | Nao | PUSH imm32 |
| MOVZX/MOVSX | Nao | Sim |
| Scaled index | Nao | [EBX+ESI*4] |
| BSF/BSR | Nao | Sim |
| Soft-float | Muito lento | Razoavel |
| GC heap max | ~50KB | 16MB+ |

---

## Requisitos de Sistema

### Minimo
- CPU: 80386 ou superior
- RAM: 1MB conventional + 1MB extended
- DOS: MS-DOS 5.0+, FreeDOS, DOSBox

### Recomendado  
- CPU: 80486 ou Pentium
- RAM: 4MB+
- DOS: FreeDOS ou DOSBox 0.74+

---

## Exemplos de Programas

### Hello World
```csharp
class Program
{
    static void Main()
    {
        Console.WriteLine("Hello from i386 DOS!");
    }
}
```

### Fibonacci com Int64
```csharp
class Program
{
    static void Main()
    {
        long a = 0, b = 1;
        
        for (int i = 0; i < 50; i++)  // Pode ir ate 50 com long!
        {
            Console.WriteLine(a);
            long temp = a + b;
            a = b;
            b = temp;
        }
    }
}
```

### Uso de Float
```csharp
class Program
{
    static void Main()
    {
        double pi = 3.14159265358979;
        double radius = 5.0;
        
        double area = pi * radius * radius;
        double circumference = 2 * pi * radius;
        
        Console.Write("Area: ");
        Console.WriteLine(area);
        Console.Write("Circumference: ");
        Console.WriteLine(circumference);
    }
}
```

### Game of Life (demonstra performance)
```csharp
class GameOfLife
{
    const int Width = 80;
    const int Height = 25;
    bool[,] grid = new bool[Width, Height];
    bool[,] next = new bool[Width, Height];
    
    static void Main()
    {
        var game = new GameOfLife();
        game.Randomize();
        
        while (true)
        {
            game.Draw();
            game.Step();
            
            if (Console.KeyAvailable)
                break;
        }
    }
    
    void Step()
    {
        for (int y = 0; y < Height; y++)
        {
            for (int x = 0; x < Width; x++)
            {
                int neighbors = CountNeighbors(x, y);
                next[x, y] = neighbors == 3 || (grid[x, y] && neighbors == 2);
            }
        }
        
        // Swap
        var temp = grid;
        grid = next;
        next = temp;
    }
    
    // ...
}
```

---

## Roadmap

- [x] Target i386 em Flat Real Mode
- [x] Registradores 32-bit
- [x] Instrucoes i386 completas
- [ ] Target i486 (BSWAP, CMPXCHG)
- [ ] Target Pentium (RDTSC, CMOVcc)
- [ ] DPMI support (modo protegido)
- [ ] Suporte a graficos Mode 13h (VGA 320x200)
- [ ] Suporte a Sound Blaster
- [ ] Network (packet driver)
- [ ] Mouse support

---

## Licenca

MIT License

---

## Creditos

Projeto conceitual desenvolvido por Claude (Anthropic) com especificacoes fornecidas pelo usuario.
