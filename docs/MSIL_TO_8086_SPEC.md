# MSIL to 8086 Assembly Transpiler

## Visao Geral do Projeto

Este projeto implementa um **transpilador de MSIL (Microsoft Intermediate Language) para Assembly 8086**, permitindo que programas .NET sejam executados em sistemas DOS/8086. O projeto inclui suporte completo para:

- Coprocessador matematico x87 (8087/80287/80387) OU emulacao de ponto flutuante em software
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
│  - Extrai custom attributes (Asm8086Implementation)              │
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
│  - Traduz cada instrucao IL para Assembly 8086                  │
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
│                   Assembly 8086 (.asm)                           │
│  Compativel com: MASM, TASM, NASM                               │
└─────────────────────────────────────────────────────────────────┘
```

---

## Estrutura de Diretorios

```
MsilTo8086/
├── MsilTo8086.sln
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
│   │   ├── Asm8086Generator.cs       # Gerador principal
│   │   ├── InstructionEmitter.cs     # Emite instrucoes 8086
│   │   ├── RegisterAllocator.cs      # Alocacao de registradores
│   │   ├── StackManager.cs           # Gerencia eval stack
│   │   └── X87Generator.cs           # Geracao de codigo FPU
│   ├── Runtime/
│   │   ├── GarbageCollector.cs       # GC mark-and-sweep
│   │   ├── ReflectionRuntime.cs      # Type.GetType, etc
│   │   ├── JsonSerializerRuntime.cs  # JSON serialize/deserialize
│   │   ├── StringRuntime.cs          # Operacoes de string
│   │   ├── MathRuntime.cs            # Math.Sin, Cos, etc
│   │   └── SoftFloatRuntime.cs       # Emulacao de FP
│   └── Optimization/
│       ├── Devirtualizer.cs          # Devirtualizacao
│       ├── Inliner.cs                # Inline de metodos
│       └── PeepholeOptimizer.cs      # Otimizacoes locais
├── BCL/
│   ├── BCL.csproj
│   ├── Attributes.cs                 # Asm8086Implementation, etc
│   ├── System/
│   │   ├── Object.cs
│   │   ├── String.cs
│   │   ├── Console.cs
│   │   ├── Math.cs
│   │   ├── Array.cs
│   │   ├── Exception.cs
│   │   └── ValueTypes.cs             # Int32, Boolean, etc
│   ├── System.Collections/
│   │   └── Generic/
│   │       ├── List.cs
│   │       └── Dictionary.cs
│   └── System.Text.Json/
│       └── JsonSerializer.cs
└── Samples/
    ├── HelloWorld/
    ├── Fibonacci/
    ├── LinkedList/
    └── JsonExample/
```

---

## Especificacao Detalhada dos Componentes

### 1. Custom Attributes para BCL

A BCL usa atributos especiais para informar ao transpilador como gerar codigo assembly:

```csharp
namespace System.Runtime.CompilerServices
{
    /// <summary>
    /// Marca um metodo com sua implementacao em Assembly 8086.
    /// O transpilador usa esse atributo para gerar o codigo correto.
    /// </summary>
    [AttributeUsage(AttributeTargets.Method | AttributeTargets.Constructor)]
    public class Asm8086ImplementationAttribute : Attribute
    {
        /// <summary>
        /// Codigo assembly 8086 que implementa este metodo.
        /// Marcadores especiais:
        ///   {ARG0}, {ARG1}, ... - Argumentos do metodo
        ///   {LOCAL0}, {LOCAL1}, ... - Variaveis locais
        ///   {RET} - Valor de retorno
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
        
        public Asm8086ImplementationAttribute(string assembly)
        {
            Assembly = assembly;
        }
    }
    
    /// <summary>
    /// Marca um metodo como intrinseco - substituido por instrucao(oes) direta(s)
    /// </summary>
    [AttributeUsage(AttributeTargets.Method)]
    public class Asm8086IntrinsicAttribute : Attribute
    {
        /// <summary>
        /// Instrucao ou sequencia de instrucoes
        /// Exemplo: "ADD AX, BX" ou "IMUL"
        /// </summary>
        public string Instructions { get; }
        
        public Asm8086IntrinsicAttribute(string instructions)
        {
            Instructions = instructions;
        }
    }
    
    /// <summary>
    /// Define tamanho de um tipo para o 8086 (16-bit)
    /// </summary>
    [AttributeUsage(AttributeTargets.Struct | AttributeTargets.Class)]
    public class Asm8086SizeAttribute : Attribute
    {
        public int Size { get; }
        public Asm8086SizeAttribute(int size) => Size = size;
    }
}
```

### 2. Exemplo de BCL - Console

```csharp
using System.Runtime.CompilerServices;

namespace System
{
    public static class Console
    {
        [Asm8086Implementation(@"
            ; Console.Write(string)
            ; {ARG0} = ponteiro para string (null-terminated)
            MOV SI, {ARG0}
        __cw_loop:
            LODSB
            OR AL, AL
            JZ __cw_done
            MOV AH, 02h
            MOV DL, AL
            INT 21h
            JMP __cw_loop
        __cw_done:
        ")]
        public static void Write(string? value) { }
        
        [Asm8086Implementation(@"
            ; Console.Write(int)
            MOV AX, {ARG0}
            CALL __rt_print_int
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_print_int")]
        public static void Write(int value) { }
        
        [Asm8086Implementation(@"
            ; Console.Write(char)
            MOV DL, {ARG0}
            MOV AH, 02h
            INT 21h
        ")]
        public static void Write(char value) { }
        
        [Asm8086Implementation(@"
            ; Console.WriteLine()
            MOV AH, 02h
            MOV DL, 13
            INT 21h
            MOV DL, 10
            INT 21h
        ")]
        public static void WriteLine() { }
        
        [Asm8086Implementation(@"
            ; Console.WriteLine(string)
            MOV SI, {ARG0}
        __cwl_loop:
            LODSB
            OR AL, AL
            JZ __cwl_newline
            MOV AH, 02h
            MOV DL, AL
            INT 21h
            JMP __cwl_loop
        __cwl_newline:
            MOV DL, 13
            INT 21h
            MOV DL, 10
            INT 21h
        ")]
        public static void WriteLine(string? value) { }
        
        [Asm8086Implementation(@"
            ; Console.WriteLine(int)
            MOV AX, {ARG0}
            CALL __rt_print_int
            MOV AH, 02h
            MOV DL, 13
            INT 21h
            MOV DL, 10
            INT 21h
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_print_int")]
        public static void WriteLine(int value) { }
        
        [Asm8086Implementation(@"
            ; Console.Read()
            MOV AH, 01h
            INT 21h
            XOR AH, AH
            ; resultado em AX
        ")]
        public static int Read() => 0;
        
        [Asm8086Implementation(@"
            ; Console.ReadKey() - sem echo
            MOV AH, 08h
            INT 21h
            XOR AH, AH
        ")]
        public static char ReadKey() => '\0';
        
        [Asm8086Implementation(@"
            ; Console.ReadLine()
            CALL __rt_read_line
            ; AX = ponteiro para buffer com string lida
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_read_line")]
        public static string? ReadLine() => null;
    }
}
```

### 3. Estruturas de Metadata

O binario gerado contem tabelas de metadata para suportar reflection:

```csharp
namespace MsilTo8086.Metadata
{
    /// <summary>
    /// Header das tabelas de metadata no binario
    /// Offset 0 do segmento de metadata
    /// </summary>
    public struct MetadataHeader
    {
        public ushort Magic;              // 0x8086
        public ushort Version;            // 1
        public ushort TypeCount;
        public ushort MethodCount;
        public ushort FieldCount;
        public ushort PropertyCount;
        public ushort GenericInstCount;
        public ushort VTableCount;
        public ushort InterfaceImplCount;
        public ushort StringHeapSize;
        // Offsets para cada tabela
        public ushort TypeTableOffset;
        public ushort MethodTableOffset;
        public ushort FieldTableOffset;
        public ushort PropertyTableOffset;
        public ushort StringHeapOffset;
    }
    
    /// <summary>
    /// Entrada na tabela de tipos (20 bytes cada)
    /// </summary>
    public struct TypeDefEntry
    {
        public ushort NameOffset;         // Offset no string heap
        public ushort NamespaceOffset;    // Offset no string heap
        public ushort Flags;              // TypeFlags
        public ushort BaseTypeIndex;      // 0xFFFF = sem base (Object)
        public ushort FieldListStart;     // Indice do primeiro campo
        public ushort FieldCount;
        public ushort MethodListStart;    // Indice do primeiro metodo
        public ushort MethodCount;
        public ushort InstanceSize;       // Tamanho em bytes
        public ushort VTableIndex;        // Indice na tabela de VTables
    }
    
    [Flags]
    public enum TypeFlags : ushort
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
        Serializable = 512
    }
    
    /// <summary>
    /// Entrada na tabela de metodos (16 bytes cada)
    /// </summary>
    public struct MethodDefEntry
    {
        public ushort NameOffset;
        public ushort Flags;              // MethodFlags
        public ushort DeclaringTypeIndex;
        public ushort SignatureOffset;    // Offset para assinatura
        public ushort ParamCount;
        public ushort LocalCount;
        public ushort CodeOffset;         // Offset no segmento de codigo
        public ushort VTableSlot;         // Slot na VTable (se virtual)
    }
    
    [Flags]
    public enum MethodFlags : ushort
    {
        None = 0,
        Public = 1,
        Private = 2,
        Static = 4,
        Virtual = 8,
        Abstract = 16,
        Final = 32,
        NewSlot = 64,
        HasGenericParams = 128,
        Intrinsic = 512
    }
    
    /// <summary>
    /// Entrada na tabela de campos (12 bytes cada)
    /// </summary>
    public struct FieldDefEntry
    {
        public ushort NameOffset;
        public ushort Flags;              // FieldFlags
        public ushort DeclaringTypeIndex;
        public ushort FieldTypeIndex;
        public ushort Offset;             // Offset na instancia
        public ushort Size;               // Tamanho em bytes
    }
    
    /// <summary>
    /// Entrada na tabela de propriedades (10 bytes cada)
    /// </summary>
    public struct PropertyDefEntry
    {
        public ushort NameOffset;
        public ushort DeclaringTypeIndex;
        public ushort PropertyTypeIndex;
        public ushort GetterMethodIndex;  // 0xFFFF = sem getter
        public ushort SetterMethodIndex;  // 0xFFFF = sem setter
    }
}
```

### 4. VTables e Virtual Dispatch

```
Layout de VTable no Assembly:

__vtbl_MyClass:
    DW OFFSET __Object_ToString      ; slot 0 - herdado
    DW OFFSET __Object_GetHashCode   ; slot 1 - herdado  
    DW OFFSET __Object_Equals        ; slot 2 - herdado
    DW OFFSET __MyClass_MyVirtual    ; slot 3 - novo
    DW OFFSET __MyClass_Override     ; slot 4 - override

Layout de Objeto na Memoria:

[Instancia de MyClass]
+0: DW __vtbl_MyClass    ; ponteiro para VTable
+2: DW field1            ; primeiro campo
+4: DW field2            ; segundo campo
...

Chamada Virtual:
    ; BX = ponteiro para objeto
    MOV SI, [BX]              ; SI = VTable pointer
    CALL WORD PTR [SI + 6]    ; Chamar slot 3 (offset = slot * 2)
```

### 5. Interface Dispatch

```
Interface Map Layout:

__imap_MyClass:
    DW 2                          ; numero de interfaces implementadas
    ; Interface 1
    DW __typedef_IDisposable      ; ponteiro para TypeDef
    DW 1                          ; numero de metodos
    DW OFFSET __MyClass_Dispose   ; implementacao
    ; Interface 2
    DW __typedef_IComparable
    DW 1
    DW OFFSET __MyClass_CompareTo

Chamada de Interface:
    ; BX = objeto, CX = interface index, DX = method index
    CALL __rt_interface_dispatch
```

### 6. Generics - Monomorphization

Quando o compilador encontra `List<int>`, gera uma versao especializada:

```csharp
// Codigo original
List<int> numbers = new List<int>();
numbers.Add(42);

// Gera tipo especializado
// __List_int com metodos especializados para int
```

```
Assembly gerado:

__List_int_vtbl:
    DW OFFSET __Object_ToString
    DW OFFSET __List_int_Add
    DW OFFSET __List_int_Get
    ...

__List_int_Add PROC
    ; Otimizado para int (2 bytes)
    ; Sem boxing, acesso direto
    ...
__List_int_Add ENDP
```

### 7. Garbage Collector

```
GC Strategy: Mark-and-Sweep com heap compacto

Heap Layout:
[__gc_heap_start]
+0: [Object 1 Header][Object 1 Data]
+N: [Object 2 Header][Object 2 Data]
...
[__gc_free_ptr] -> proximo espaco livre
[__gc_heap_end]

Object Header (4 bytes):
+0: DW size          ; tamanho total incluindo header
+2: DB type_lo       ; type index (low byte)
+3: DB flags         ; bit 0 = mark, bits 1-7 = type_hi

GC Phases:
1. Clear marks - limpa bit de mark de todos objetos
2. Mark roots - marca objetos alcancaveis (pilha, globais)
3. Mark transitive - marca objetos referenciados
4. Sweep - remove nao marcados, compacta heap
```

### 8. Mapeamento IL para 8086

| IL Instruction | 8086 Assembly |
|---------------|---------------|
| `ldc.i4 N` | `MOV AX, N` / `PUSH AX` |
| `ldc.i4.0` | `XOR AX, AX` / `PUSH AX` |
| `ldloc.0` | `MOV AX, [BP-2]` / `PUSH AX` |
| `stloc.0` | `POP AX` / `MOV [BP-2], AX` |
| `ldarg.0` | `MOV AX, [BP+4]` / `PUSH AX` |
| `add` | `POP BX` / `POP AX` / `ADD AX, BX` / `PUSH AX` |
| `sub` | `POP BX` / `POP AX` / `SUB AX, BX` / `PUSH AX` |
| `mul` | `POP BX` / `POP AX` / `IMUL BX` / `PUSH AX` |
| `div` | `POP BX` / `POP AX` / `CWD` / `IDIV BX` / `PUSH AX` |
| `and` | `POP BX` / `POP AX` / `AND AX, BX` / `PUSH AX` |
| `or` | `POP BX` / `POP AX` / `OR AX, BX` / `PUSH AX` |
| `xor` | `POP BX` / `POP AX` / `XOR AX, BX` / `PUSH AX` |
| `neg` | `POP AX` / `NEG AX` / `PUSH AX` |
| `not` | `POP AX` / `NOT AX` / `PUSH AX` |
| `ceq` | Compare + `SETE AL` / `MOVZX AX, AL` |
| `clt` | Compare + `SETL AL` / `MOVZX AX, AL` |
| `cgt` | Compare + `SETG AL` / `MOVZX AX, AL` |
| `br LABEL` | `JMP LABEL` |
| `brfalse LABEL` | `POP AX` / `OR AX, AX` / `JZ LABEL` |
| `brtrue LABEL` | `POP AX` / `OR AX, AX` / `JNZ LABEL` |
| `beq LABEL` | `POP BX` / `POP AX` / `CMP AX, BX` / `JE LABEL` |
| `blt LABEL` | `POP BX` / `POP AX` / `CMP AX, BX` / `JL LABEL` |
| `call METHOD` | `CALL __METHOD_LABEL` |
| `callvirt METHOD` | VTable dispatch |
| `ret` | `MOV SP, BP` / `POP BP` / `RET` |
| `newobj CTOR` | `CALL __rt_gc_alloc` + call constructor |
| `ldfld FIELD` | `POP BX` / `MOV AX, [BX+offset]` / `PUSH AX` |
| `stfld FIELD` | `POP AX` / `POP BX` / `MOV [BX+offset], AX` |
| `ldsfld FIELD` | `MOV AX, [__FIELD_LABEL]` / `PUSH AX` |
| `stsfld FIELD` | `POP AX` / `MOV [__FIELD_LABEL], AX` |
| `ldstr "..."` | `MOV AX, OFFSET __str_N` / `PUSH AX` |
| `dup` | `POP AX` / `PUSH AX` / `PUSH AX` |
| `pop` | `ADD SP, 2` |

### 9. Operacoes de Ponto Flutuante

**Modo x87 (com coprocessador):**

| IL | x87 Assembly |
|----|-------------|
| `ldc.r4 N` | `FLD DWORD PTR [__flt_N]` |
| `ldc.r8 N` | `FLD QWORD PTR [__dbl_N]` |
| `add` (float) | `FADDP ST(1), ST` |
| `sub` (float) | `FSUBP ST(1), ST` |
| `mul` (float) | `FMULP ST(1), ST` |
| `div` (float) | `FDIVP ST(1), ST` |
| `conv.r4` | `FILD WORD PTR [SP]` / `ADD SP, 2` |
| `conv.i4` | `FISTP WORD PTR [SP]` / `SUB SP, 2` |

**Modo Software Float (sem coprocessador):**

Usa formato fixed-point 16.16 ou biblioteca de emulacao IEEE 754.

```
; Adicao software float (fixed-point 8.8)
__soft_fadd PROC
    POP BX          ; segundo operando
    POP AX          ; primeiro operando
    ADD AX, BX
    PUSH AX
    RET
__soft_fadd ENDP

; Multiplicacao software float (fixed-point 8.8)
__soft_fmul PROC
    POP BX
    POP AX
    IMUL BX
    ; Resultado em DX:AX, shift right 8
    MOV AL, AH
    MOV AH, DL
    PUSH AX
    RET
__soft_fmul ENDP
```

### 10. JSON Serialization Runtime

```csharp
// Uso no codigo .NET
var obj = new Person { Name = "John", Age = 30 };
string json = JsonSerializer.Serialize(obj);
// Resultado: {"Name":"John","Age":30}

var person = JsonSerializer.Deserialize<Person>(json);
```

O runtime usa reflection para:
1. Obter propriedades do tipo via `Type.GetProperties()`
2. Ler valores via `PropertyInfo.GetValue()`
3. Escrever valores via `PropertyInfo.SetValue()`
4. Criar instancias via `Activator.CreateInstance()`

---

## Opcoes de Linha de Comando

```
msil8086 [options] <input.dll|input.exe>

Options:
  -o, --output <file>     Arquivo de saida (default: input.asm)
  -x87, --x87             Usar coprocessador x87 (default)
  -sf, --softfloat        Usar emulacao software de float
  --tiny                  Modelo TINY (.COM, 64KB total)
  --small                 Modelo SMALL (.EXE, default)
  --medium                Modelo MEDIUM (multiplos code segments)
  --compact               Modelo COMPACT (multiplos data segments)
  --large                 Modelo LARGE (multiplos code e data)
  --no-reflection         Desabilitar suporte a reflection
  --no-gc                 Desabilitar garbage collector
  --stack <size>          Tamanho da pilha (default: 4096)
  --heap <size>           Tamanho do heap (default: 16384)
  -v, --verbose           Output detalhado
  -h, --help              Mostrar ajuda

Exemplos:
  msil8086 MyApp.exe
  msil8086 --softfloat -o output.asm MyApp.dll
  msil8086 --tiny --no-gc HelloWorld.exe
```

---

## Output Assembly - Estrutura

```asm
; ============================================
; MSIL to 8086 Transpiler Output
; Source: MyApp.exe
; Generated: 2024-01-15
; ============================================

.MODEL SMALL
.8086
.8087                    ; Se usando x87

; ============================================
; DATA SEGMENT
; ============================================
.DATA

; String literals
__str_0 DB "Hello, World!", 0
__str_1 DB "Enter your name: ", 0

; Float constants (x87)
__flt_0 DD 3.14159
__dbl_0 DQ 2.71828

; Static fields
__MyClass_counter DW 0
__MyClass_name    DW 0

; Metadata tables (para reflection)
__metadata_header:
    DW 8086h              ; magic
    DW 1                  ; version
    ; ... resto do header

__metadata_types:
    ; TypeDefEntry para cada tipo
    
__metadata_methods:
    ; MethodDefEntry para cada metodo
    
__metadata_strings:
    ; String heap
    DB "MyClass", 0
    DB "Main", 0
    ; ...

; ============================================
; BSS SEGMENT (Uninitialized)  
; ============================================
.DATA?

__gc_heap   DB 16384 DUP(?)
__stack     DB 4096 DUP(?)
__temp_buf  DB 256 DUP(?)

; ============================================
; CODE SEGMENT
; ============================================
.CODE

; Entry point
__start:
    MOV AX, @DATA
    MOV DS, AX
    
    ; Inicializar runtime
    CALL __rt_init
    
    ; Chamar Main
    CALL __Program_Main
    
    ; Exit para DOS
    MOV AX, 4C00h
    INT 21h

; ============================================
; VTABLES
; ============================================

__vtbl_Object:
    DW OFFSET __Object_ToString
    DW OFFSET __Object_GetHashCode
    DW OFFSET __Object_Equals

__vtbl_MyClass:
    DW OFFSET __MyClass_ToString    ; override
    DW OFFSET __Object_GetHashCode
    DW OFFSET __Object_Equals
    DW OFFSET __MyClass_MyMethod

; ============================================
; USER METHODS
; ============================================

__Program_Main PROC
    PUSH BP
    MOV BP, SP
    SUB SP, 4             ; locals
    
    ; IL code traduzido...
    
    MOV SP, BP
    POP BP
    RET
__Program_Main ENDP

; ... mais metodos ...

; ============================================
; RUNTIME
; ============================================

INCLUDE runtime\gc.asm
INCLUDE runtime\reflection.asm
INCLUDE runtime\json.asm
INCLUDE runtime\string.asm
INCLUDE runtime\math.asm

; ============================================
END __start
```

---

## Dependencias do Projeto

### Compiler (C# .NET 8.0)
- `System.Reflection.Metadata` (built-in) - Leitura de assemblies
- Nenhuma dependencia externa necessaria!

### BCL (C# .NET 8.0)
- Projeto standalone, compilado separadamente
- Referenciado pelos projetos de usuario

---

## Como Usar

### 1. Compilar o Transpilador
```bash
cd Compiler
dotnet build -c Release
```

### 2. Compilar a BCL
```bash
cd BCL
dotnet build -c Release
```

### 3. Criar Programa de Teste
```csharp
// HelloWorld.cs
using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Hello from DOS!");
        
        int a = 10;
        int b = 20;
        Console.Write("Sum: ");
        Console.WriteLine(a + b);
    }
}
```

### 4. Compilar para IL
```bash
# Referenciar nossa BCL
dotnet build -r win-x86 HelloWorld.csproj
```

### 5. Transpilar para 8086
```bash
msil8086 HelloWorld.dll -o hello.asm
```

### 6. Montar com MASM/TASM
```bash
# MASM
ml /c hello.asm
link hello.obj

# TASM
tasm hello.asm
tlink hello.obj
```

### 7. Executar no DOS/DOSBox
```bash
dosbox hello.exe
```

---

## Exemplos de Programas

### Hello World
```csharp
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
class Program
{
    static void Main()
    {
        int n = 10;
        int a = 0, b = 1;
        
        for (int i = 0; i < n; i++)
        {
            Console.WriteLine(a);
            int temp = a + b;
            a = b;
            b = temp;
        }
    }
}
```

### Classe com Propriedades (Reflection/JSON)
```csharp
class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
}

class Program
{
    static void Main()
    {
        var person = new Person { Name = "John", Age = 30 };
        
        // Serializar para JSON
        string json = JsonSerializer.Serialize(person);
        Console.WriteLine(json);
        
        // Deserializar
        var p2 = JsonSerializer.Deserialize<Person>(json);
        Console.WriteLine(p2.Name);
    }
}
```

### Uso de Generics
```csharp
class Program
{
    static void Main()
    {
        var list = new List<int>();
        list.Add(10);
        list.Add(20);
        list.Add(30);
        
        for (int i = 0; i < list.Count; i++)
        {
            Console.WriteLine(list[i]);
        }
    }
}
```

### Heranca e Virtual Methods
```csharp
class Animal
{
    public virtual void Speak()
    {
        Console.WriteLine("...");
    }
}

class Dog : Animal
{
    public override void Speak()
    {
        Console.WriteLine("Woof!");
    }
}

class Cat : Animal
{
    public override void Speak()
    {
        Console.WriteLine("Meow!");
    }
}

class Program
{
    static void Main()
    {
        Animal[] animals = new Animal[2];
        animals[0] = new Dog();
        animals[1] = new Cat();
        
        for (int i = 0; i < 2; i++)
        {
            animals[i].Speak(); // Virtual dispatch!
        }
    }
}
```

---

## Limitacoes Conhecidas

1. **Memoria**: 8086 tem limite de 64KB por segmento
2. **Inteiros**: Int32/Int64 mapeiam para 16-bit (com possivel overflow)
3. **Threads**: Nao suportado (DOS e single-threaded)
4. **Exceptions**: Suporte basico (try/catch/finally)
5. **Async/Await**: Nao suportado
6. **LINQ**: Parcialmente suportado (sem expression trees)
7. **Delegates/Events**: Suporte basico
8. **Interop**: Apenas INT 21h (DOS) e INT 10h (BIOS video)

---

## Roadmap Futuro

- [ ] Suporte a protected memory (modo protegido 80286+)
- [ ] Otimizacao de tail calls
- [ ] Inline assembly em C# via atributos
- [ ] Debugger integrado
- [ ] Profiler para DOS
- [ ] Suporte a graficos (INT 10h, Mode 13h)
- [ ] Biblioteca de som (PC Speaker, Sound Blaster)

---

## Licenca

MIT License

---

## Creditos

Projeto conceitual desenvolvido por Claude (Anthropic) com especificacoes fornecidas pelo usuario.
