# PARTE 7: METADATA E REFLECTION

## 7.1 Estrutura de Metadata no Executavel

O executavel final contem tabelas de metadata para suportar reflection em runtime:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    METADATA SECTION LAYOUT                                   │
└─────────────────────────────────────────────────────────────────────────────┘

Offset   Size    Content
───────────────────────────────────────────────────────────────────────────────
0x0000   32      MetadataHeader
0x0020   var     TypeDefTable (array de TypeDefEntry)
var      var     MethodDefTable (array de MethodDefEntry)
var      var     FieldDefTable (array de FieldDefEntry)
var      var     PropertyDefTable (array de PropertyDefEntry)
var      var     GenericInstTable (instanciacoes de generics)
var      var     VTableTable (ponteiros para VTables)
var      var     InterfaceMapTable
var      var     StringHeap (nomes, strings literais)
var      var     BlobHeap (assinaturas, custom attributes)
───────────────────────────────────────────────────────────────────────────────
```

## 7.2 Estruturas de Dados

```csharp
// MetadataHeader - 32 bytes
[StructLayout(LayoutKind.Sequential, Pack = 1)]
public struct MetadataHeader
{
    public uint Magic;              // 0x544E4443 ("CDNT")
    public ushort MajorVersion;     // 1
    public ushort MinorVersion;     // 0
    public uint Flags;              // MetadataFlags
    
    public uint TypeCount;
    public uint MethodCount;
    public uint FieldCount;
    public uint PropertyCount;
    
    public uint TypeTableOffset;
    public uint StringHeapOffset;
    public uint StringHeapSize;
}

// TypeDefEntry - 32 bytes
[StructLayout(LayoutKind.Sequential, Pack = 1)]
public struct TypeDefEntry
{
    public uint NameOffset;         // Offset no StringHeap
    public uint NamespaceOffset;    // Offset no StringHeap
    public uint Flags;              // TypeFlags
    public uint BaseTypeIndex;      // Indice do tipo base (0xFFFFFFFF = nenhum)
    
    public ushort FieldListStart;   // Primeiro campo
    public ushort FieldCount;
    public ushort MethodListStart;  // Primeiro metodo
    public ushort MethodCount;
    
    public uint InstanceSize;       // Tamanho em bytes
    public uint VTableOffset;       // Offset da VTable no codigo
}

// MethodDefEntry - 24 bytes
[StructLayout(LayoutKind.Sequential, Pack = 1)]
public struct MethodDefEntry
{
    public uint NameOffset;
    public uint Flags;              // MethodFlags
    public uint DeclaringTypeIndex;
    public uint SignatureOffset;    // Assinatura no BlobHeap
    
    public ushort ParamCount;
    public ushort LocalCount;
    public uint CodeOffset;         // Offset no segmento de codigo
    public ushort VTableSlot;       // Slot na VTable (se virtual)
    public ushort Reserved;
}

// FieldDefEntry - 16 bytes
[StructLayout(LayoutKind.Sequential, Pack = 1)]
public struct FieldDefEntry
{
    public uint NameOffset;
    public uint Flags;              // FieldFlags
    public uint FieldTypeIndex;     // Tipo do campo
    public ushort Offset;           // Offset na instancia
    public ushort Size;             // Tamanho em bytes
}

// PropertyDefEntry - 16 bytes
[StructLayout(LayoutKind.Sequential, Pack = 1)]
public struct PropertyDefEntry
{
    public uint NameOffset;
    public uint DeclaringTypeIndex;
    public uint PropertyTypeIndex;
    public ushort GetterMethodIndex; // 0xFFFF = sem getter
    public ushort SetterMethodIndex; // 0xFFFF = sem setter
}
```

## 7.3 Reflection Runtime

```asm
; ============================================================
; REFLECTION RUNTIME
; ============================================================

; ============================================================
; __rt_type_get_type
; Type.GetType(string name)
;
; Input: EAX = ponteiro para nome do tipo (string)
; Output: EAX = ponteiro para TypeDefEntry, ou 0 se nao encontrado
; ============================================================
__rt_type_get_type PROC
    PUSH EBX
    PUSH ECX
    PUSH EDX
    PUSH ESI
    PUSH EDI
    
    MOV ESI, EAX                ; ESI = nome buscado
    
    ; Percorrer TypeDefTable
    MOV ECX, [__metadata_header + 8]  ; TypeCount
    MOV EDI, [__metadata_header + 20] ; TypeTableOffset
    ADD EDI, OFFSET __metadata_start
    
.search_loop:
    JECXZ .not_found
    
    ; Comparar nome
    MOV EAX, [EDI]              ; NameOffset
    ADD EAX, OFFSET __string_heap
    
    PUSH ECX
    PUSH EDI
    PUSH ESI
    PUSH EAX
    CALL __rt_strcmp
    ADD ESP, 8
    POP EDI
    POP ECX
    
    TEST EAX, EAX
    JZ .found                   ; Strings iguais!
    
    ADD EDI, 32                 ; Proximo TypeDefEntry
    DEC ECX
    JMP .search_loop
    
.found:
    MOV EAX, EDI
    JMP .done
    
.not_found:
    XOR EAX, EAX
    
.done:
    POP EDI
    POP ESI
    POP EDX
    POP ECX
    POP EBX
    RET
__rt_type_get_type ENDP

; ============================================================
; __rt_activator_create_instance
; Activator.CreateInstance(Type type)
;
; Input: EAX = ponteiro para TypeDefEntry
; Output: EAX = nova instancia, ou 0 se falha
; ============================================================
__rt_activator_create_instance PROC
    PUSH EBX
    PUSH ECX
    PUSH EDX
    
    MOV EBX, EAX                ; EBX = TypeDefEntry
    
    ; Obter tamanho da instancia
    MOV EAX, [EBX + 24]         ; InstanceSize
    
    ; Obter type index
    MOV EDX, EBX
    SUB EDX, OFFSET __metadata_types
    SHR EDX, 5                  ; / 32 = TypeIndex
    MOV ECX, EDX                ; ECX = TypeIndex
    
    ; Alocar memoria
    MOV EBX, ECX
    CALL __gc_alloc_typed
    TEST EAX, EAX
    JZ .done
    
    MOV EDX, EAX                ; EDX = instancia
    
    ; Inicializar VTable
    MOV EBX, [EBX + 28]         ; VTableOffset
    MOV [EAX], EBX
    
    ; Buscar e chamar construtor padrao
    ; (metodo .ctor sem parametros)
    PUSH EDX
    PUSH ECX                    ; TypeIndex
    CALL __rt_find_default_ctor
    ADD ESP, 4
    POP EDX
    
    TEST EAX, EAX
    JZ .no_ctor
    
    ; Chamar construtor
    PUSH EDX                    ; this
    CALL EAX                    ; Chamar .ctor
    ADD ESP, 4
    
.no_ctor:
    MOV EAX, EDX                ; Retornar instancia
    
.done:
    POP EDX
    POP ECX
    POP EBX
    RET
__rt_activator_create_instance ENDP

; ============================================================
; __rt_property_get_value
; PropertyInfo.GetValue(object obj)
;
; Input: EAX = ponteiro para PropertyDefEntry
;        EBX = objeto
; Output: EAX = valor (ou ponteiro para valor)
; ============================================================
__rt_property_get_value PROC
    PUSH ECX
    
    ; Obter getter method
    MOVZX ECX, WORD PTR [EAX + 12]  ; GetterMethodIndex
    CMP ECX, 0FFFFh
    JE .no_getter
    
    ; Calcular endereco do MethodDefEntry
    SHL ECX, 4                  ; * 16 (ou 24 se for 24 bytes)
    ADD ECX, OFFSET __metadata_methods
    
    ; Obter code offset
    MOV EAX, [ECX + 16]         ; CodeOffset
    ADD EAX, OFFSET __code_start
    
    ; Chamar getter
    PUSH EBX                    ; this
    CALL EAX
    ADD ESP, 4
    ; Resultado em EAX
    JMP .done
    
.no_getter:
    XOR EAX, EAX
    
.done:
    POP ECX
    RET
__rt_property_get_value ENDP
```

---

# PARTE 8: INTERFACE DE LINHA DE COMANDO

## 8.1 Sintaxe Completa

```
USAGE:
    msiltodos [OPTIONS] <INPUT>

ARGUMENTS:
    <INPUT>                         Input assembly (.dll or .exe)

OPTIONS:
    -o, --output <FILE>             Output file (default: <input>.asm)
    -h, --help                      Show help
    --version                       Show version

ARCHITECTURE OPTIONS:
    --arch <ARCH>                   Target architecture
                                    Values: x86 (default), s390, arm
    
    --cpu <CPU>                     CPU level (arch-specific)
                                    x86: i386 (default), i486, i586, i686
                                    s390: zarch
                                    arm: v7, v8

OUTPUT FORMAT:
    --format <FORMAT>               Output format
                                    x86: exe (default), com, masm, tasm, nasm, fasm
                                    s390: binary
                                    arm: elf, binary

FLOATING POINT:
    --fpu-detect                    Detect FPU at runtime (default)
    --fpu-required                  Require FPU, fail if not present
    --soft-float-only               Always use software float

MEMORY:
    --heap <SIZE>                   Heap size in bytes
                                    Default: 4194304 (4MB)
                                    Suffixes: K, M (e.g., 16M)
    
    --stack <SIZE>                  Stack size in bytes
                                    Default: 65536 (64KB)
    
    --flat-real                     Use Flat Real Mode (default for x86)
    --conventional-only             Use only conventional memory (<640KB)

RUNTIME FEATURES:
    --no-reflection                 Disable reflection support
    --no-gc                         Disable garbage collector
    --no-exceptions                 Disable exception handling
    --no-json                       Disable JSON serialization

OPTIMIZATION:
    -O0                             No optimizations
    -O1                             Basic optimizations (default)
    -O2                             Aggressive optimizations
    -O3                             Maximum optimizations
    
    --inline-threshold <N>          Inline methods smaller than N bytes
                                    Default: 32
    
    --no-devirt                     Disable devirtualization
    --no-inline                     Disable all inlining

DEBUG:
    -v, --verbose                   Verbose output
    -vv, --very-verbose             Very verbose output
    --emit-il-comments              Include IL as comments
    --emit-line-info                Include source line numbers
    --emit-debug-symbols            Generate debug symbols
    --dry-run                       Parse and analyze only, don't generate

INFORMATIONAL:
    --list-backends                 List available backends
    --list-cpu-levels               List CPU levels for current arch
    --list-formats                  List output formats
    --dump-metadata                 Dump metadata tables
    --dump-ir                       Dump intermediate representation

EXAMPLES:
    # Basic compilation for DOS
    msiltodos MyApp.dll
    
    # Specify output file
    msiltodos -o game.exe Game.dll
    
    # Target specific CPU
    msiltodos --cpu=i486 MyApp.dll
    
    # Generate NASM source
    msiltodos --format=nasm -o output.asm MyApp.dll
    
    # Maximum optimization
    msiltodos -O3 FastApp.dll
    
    # Minimal runtime (no reflection, no GC)
    msiltodos --no-reflection --no-gc TinyApp.dll
    
    # Software float only
    msiltodos --soft-float-only Calculator.dll
    
    # Large heap
    msiltodos --heap=16M BigApp.dll
    
    # Debug build
    msiltodos -O0 --emit-il-comments --emit-debug-symbols Debug.dll
    
    # Target IBM s390 (futuro)
    msiltodos --arch=s390 MainframeApp.dll
```

## 8.2 Exemplos de Uso

### Compilacao Basica

```bash
# Compilar HelloWorld.dll para DOS
$ msiltodos HelloWorld.dll

# Output:
# Reading assembly: HelloWorld.dll
# Types found: 1
# Methods found: 1
# Generating code for x86/i386...
# Runtime: GC enabled, Reflection enabled
# Writing output: HelloWorld.exe
# Done! (0.5s)
```

### Otimizacao Maxima

```bash
$ msiltodos -O3 --cpu=i686 FastGame.dll -o game.exe

# Output:
# Reading assembly: FastGame.dll
# Types found: 45
# Methods found: 312
# Optimization level: O3
# - Inlining: 89 methods inlined
# - Devirtualization: 23 calls devirtualized
# - Dead code elimination: 1,234 bytes removed
# - Constant folding: 156 expressions simplified
# Generating code for x86/i686...
# Using CMOVcc, FCOMI instructions
# Writing output: game.exe
# Done! (2.3s)
```

### Build Minimo

```bash
$ msiltodos --no-gc --no-reflection --no-exceptions --conventional-only Tiny.dll

# Output:
# Reading assembly: Tiny.dll
# Types found: 1
# Methods found: 2
# WARNING: GC disabled - manual memory management required
# WARNING: Reflection disabled - Type.GetType will fail
# Generating code for x86/i386...
# Writing output: Tiny.exe
# Size: 2,048 bytes (fits in .COM!)
# Done! (0.2s)
```

---

# PARTE 9: BCL - IMPLEMENTACOES COMPLETAS

## 9.1 System.Object

```csharp
using System.Runtime.CompilerServices;

namespace System
{
    /// <summary>
    /// Classe base de todos os tipos em .NET
    /// </summary>
    [AsmLayout(Size = 4, Alignment = 4)] // Apenas VTable pointer
    public class Object
    {
        [AsmImplementation(@"
            ; Object..ctor()
            ; Nada a fazer - objeto ja foi alocado e inicializado
            RET
        ")]
        public Object() { }
        
        [AsmImplementation(@"
            ; Object.ToString()
            ; Retorna nome do tipo
            MOV EAX, {THIS}
            MOV EAX, [EAX]          ; VTable
            MOV EAX, [EAX-4]        ; TypeDefEntry (armazenado antes da VTable)
            MOV EAX, [EAX]          ; NameOffset
            ADD EAX, OFFSET __string_heap
            ; EAX = ponteiro para nome do tipo
        ", Clobbers = "EAX")]
        public virtual string ToString()
        {
            return GetType().Name;
        }
        
        [AsmImplementation(@"
            ; Object.Equals(object)
            ; Comparacao de referencia por padrao
            MOV EAX, {THIS}
            CMP EAX, {ARG0}
            SETE AL
            MOVZX EAX, AL
        ", Clobbers = "EAX")]
        public virtual bool Equals(object? obj)
        {
            return this == obj;
        }
        
        [AsmImplementation(@"
            ; Object.GetHashCode()
            ; Usar endereco do objeto como hash (simples mas funcional)
            MOV EAX, {THIS}
            ; Espalhar bits para melhor distribuicao
            MOV EDX, EAX
            SHR EDX, 16
            XOR EAX, EDX
            IMUL EAX, 2654435761    ; Knuth's multiplicative hash
        ", Clobbers = "EAX,EDX")]
        public virtual int GetHashCode()
        {
            return 0; // Placeholder
        }
        
        [AsmImplementation(@"
            ; Object.GetType()
            ; Retorna Type do objeto
            MOV EAX, {THIS}
            MOV EAX, [EAX]          ; VTable
            MOV EAX, [EAX-4]        ; TypeDefEntry pointer
            ; TODO: Converter para System.Type
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_object_get_type")]
        public Type GetType()
        {
            return null!; // Placeholder
        }
        
        [AsmImplementation(@"
            ; Object.ReferenceEquals(object, object)
            MOV EAX, {ARG0}
            CMP EAX, {ARG1}
            SETE AL
            MOVZX EAX, AL
        ", Clobbers = "EAX")]
        public static bool ReferenceEquals(object? objA, object? objB)
        {
            return false;
        }
        
        // MemberwiseClone - protected, chamado por runtime
        [AsmImplementation(@"
            ; Object.MemberwiseClone()
            ; Clonar objeto byte a byte
            MOV ESI, {THIS}
            
            ; Obter tamanho do objeto
            MOV EAX, [ESI-8]        ; Size no header do GC
            SUB EAX, 8              ; Menos header
            
            ; Alocar novo objeto
            PUSH EAX
            CALL __gc_alloc
            ADD ESP, 4
            TEST EAX, EAX
            JZ .fail
            
            MOV EDI, EAX            ; Destino
            MOV ECX, [ESI-8]
            SUB ECX, 8
            PUSH EDI
            REP MOVSB               ; Copiar
            POP EAX                 ; Retornar clone
            RET
            
        .fail:
            XOR EAX, EAX
            RET
        ", Clobbers = "ALL")]
        protected object MemberwiseClone()
        {
            return null!;
        }
    }
}
```

## 9.2 System.String

```csharp
using System.Runtime.CompilerServices;

namespace System
{
    /// <summary>
    /// Representa texto como sequencia de caracteres Unicode.
    /// Strings sao imutaveis.
    /// 
    /// Layout em memoria:
    /// +0: VTable (4 bytes)
    /// +4: Length (4 bytes)
    /// +8: Chars[0..Length-1] (Length bytes, ASCII/null-terminated)
    /// </summary>
    [AsmLayout(Size = 8, Alignment = 4)] // VTable + Length (chars sao extra)
    public sealed class String : IComparable, IComparable<String>, IEquatable<String>
    {
        // Length armazenado inline
        private readonly int _length;
        
        // Construtor interno - strings sao criadas pelo runtime
        private String() { }
        
        [AsmImplementation(@"
            ; String.get_Length
            MOV EAX, {THIS}
            MOV EAX, [EAX+4]        ; Length em offset +4
        ", Clobbers = "EAX")]
        public int Length => _length;
        
        [AsmImplementation(@"
            ; String.get_Chars(int index)
            ; Retorna caractere no indice especificado
            MOV EAX, {THIS}
            MOV EDX, {ARG0}         ; index
            
            ; Bounds check
            CMP EDX, [EAX+4]        ; index < Length?
            JAE .out_of_range
            
            ; Obter caractere
            MOVZX EAX, BYTE PTR [EAX+8+EDX]
            RET
            
        .out_of_range:
            ; TODO: throw IndexOutOfRangeException
            XOR EAX, EAX
            RET
        ", Clobbers = "EAX,EDX")]
        public char this[int index] => '\0';
        
        [AsmImplementation(@"
            ; String.Concat(string, string)
            MOV ESI, {ARG0}         ; a
            MOV EDI, {ARG1}         ; b
            
            ; Handle nulls
            TEST ESI, ESI
            JZ .return_b
            TEST EDI, EDI
            JZ .return_a
            
            ; Calcular tamanho total
            MOV EAX, [ESI+4]        ; a.Length
            MOV EDX, [EDI+4]        ; b.Length
            ADD EAX, EDX            ; total length
            
            ; Alocar nova string
            LEA ECX, [EAX+8+1]      ; VTable + Length + chars + null
            PUSH EAX                ; salvar total length
            PUSH EDI
            PUSH ESI
            MOV EAX, ECX
            MOV EBX, 1              ; TypeIndex de String
            CALL __gc_alloc_typed
            POP ESI
            POP EDI
            POP ECX                 ; total length
            
            TEST EAX, EAX
            JZ .fail
            
            ; Inicializar
            MOV DWORD PTR [EAX], OFFSET __vtbl_String
            MOV [EAX+4], ECX        ; Length
            
            ; Copiar string a
            LEA EBX, [EAX+8]        ; destino
            PUSH EAX
            MOV ECX, [ESI+4]        ; a.Length
            LEA ESI, [ESI+8]        ; a.chars
            MOV EDI, EBX
            REP MOVSB
            
            ; Copiar string b
            MOV ESI, {ARG1}
            MOV ECX, [ESI+4]        ; b.Length
            LEA ESI, [ESI+8]
            REP MOVSB
            
            ; Null terminator
            MOV BYTE PTR [EDI], 0
            
            POP EAX                 ; retornar nova string
            RET
            
        .return_a:
            MOV EAX, ESI
            RET
        .return_b:
            MOV EAX, EDI
            RET
        .fail:
            XOR EAX, EAX
            RET
        ", IsRuntimeCall = true, RuntimeRoutine = "__rt_string_concat", Clobbers = "ALL")]
        public static string Concat(string? a, string? b)
        {
            return "";
        }
        
        [AsmImplementation(@"
            ; String.Equals(string)
            MOV ESI, {THIS}
            MOV EDI, {ARG0}
            
            ; Mesma referencia?
            CMP ESI, EDI
            JE .equal
            
            ; Um e null?
            TEST EDI, EDI
            JZ .not_equal
            
            ; Tamanhos diferentes?
            MOV ECX, [ESI+4]
            CMP ECX, [EDI+4]
            JNE .not_equal
            
            ; Comparar caracteres
            LEA ESI, [ESI+8]
            LEA EDI, [EDI+8]
            REPE CMPSB
            JNE .not_equal
            
        .equal:
            MOV EAX, 1
            RET
            
        .not_equal:
            XOR EAX, EAX
            RET
        ", Clobbers = "EAX,ECX,ESI,EDI")]
        public bool Equals(string? other)
        {
            return false;
        }
        
        public override bool Equals(object? obj)
        {
            if (obj is string s)
                return Equals(s);
            return false;
        }
        
        [AsmImplementation(@"
            ; String.GetHashCode()
            ; DJB2 hash
            MOV ESI, {THIS}
            MOV ECX, [ESI+4]        ; Length
            LEA ESI, [ESI+8]        ; chars
            
            MOV EAX, 5381           ; seed
            
        .hash_loop:
            JECXZ .done
            
            MOVZX EDX, BYTE PTR [ESI]
            SHL EAX, 5
            ADD EAX, EAX            ; EAX * 33
            XOR EAX, EDX
            
            INC ESI
            DEC ECX
            JMP .hash_loop
            
        .done:
        ", Clobbers = "EAX,ECX,EDX,ESI")]
        public override int GetHashCode()
        {
            return 0;
        }
        
        [AsmImplementation(@"
            ; String.Substring(int startIndex, int length)
            MOV ESI, {THIS}
            MOV EAX, {ARG0}         ; startIndex
            MOV ECX, {ARG1}         ; length
            
            ; Validar
            ADD EAX, ECX
            CMP EAX, [ESI+4]
            JA .out_of_range
            
            ; Alocar nova string
            LEA EAX, [ECX+8+1]
            PUSH ECX
            PUSH {ARG0}
            MOV EBX, 1
            CALL __gc_alloc_typed
            POP EDX                 ; startIndex
            POP ECX                 ; length
            
            TEST EAX, EAX
            JZ .fail
            
            ; Inicializar
            MOV DWORD PTR [EAX], OFFSET __vtbl_String
            MOV [EAX+4], ECX
            
            ; Copiar substring
            LEA EDI, [EAX+8]
            MOV ESI, {THIS}
            LEA ESI, [ESI+8+EDX]    ; src + startIndex
            PUSH EAX
            REP MOVSB
            MOV BYTE PTR [EDI], 0
            POP EAX
            RET
            
        .out_of_range:
        .fail:
            XOR EAX, EAX
            RET
        ", Clobbers = "ALL")]
        public string Substring(int startIndex, int length)
        {
            return "";
        }
        
        public string Substring(int startIndex)
        {
            return Substring(startIndex, Length - startIndex);
        }
        
        [AsmImplementation(@"
            ; String.IndexOf(char)
            MOV ESI, {THIS}
            MOV ECX, [ESI+4]        ; Length
            LEA ESI, [ESI+8]        ; chars
            MOV AL, {ARG0}          ; char to find
            XOR EDX, EDX            ; index
            
        .search:
            JECXZ .not_found
            CMP [ESI], AL
            JE .found
            INC ESI
            INC EDX
            DEC ECX
            JMP .search
            
        .found:
            MOV EAX, EDX
            RET
            
        .not_found:
            MOV EAX, -1
            RET
        ", Clobbers = "EAX,ECX,EDX,ESI")]
        public int IndexOf(char value)
        {
            return -1;
        }
        
        [AsmImplementation(@"
            ; String.ToUpper()
            MOV ESI, {THIS}
            MOV ECX, [ESI+4]        ; Length
            
            ; Alocar nova string
            LEA EAX, [ECX+8+1]
            PUSH ECX
            MOV EBX, 1
            CALL __gc_alloc_typed
            POP ECX
            
            TEST EAX, EAX
            JZ .fail
            
            MOV DWORD PTR [EAX], OFFSET __vtbl_String
            MOV [EAX+4], ECX
            
            LEA EDI, [EAX+8]
            MOV ESI, {THIS}
            LEA ESI, [ESI+8]
            PUSH EAX
            
        .convert:
            JECXZ .done
            LODSB
            CMP AL, 'a'
            JB .store
            CMP AL, 'z'
            JA .store
            SUB AL, 32              ; to upper
        .store:
            STOSB
            DEC ECX
            JMP .convert
            
        .done:
            MOV BYTE PTR [EDI], 0
            POP EAX
            RET
            
        .fail:
            XOR EAX, EAX
            RET
        ", Clobbers = "ALL")]
        public string ToUpper()
        {
            return "";
        }
        
        public string ToLower()
        {
            // Similar a ToUpper, mas ADD AL, 32
            return "";
        }
        
        [AsmImplementation(@"
            ; String.IsNullOrEmpty(string)
            MOV EAX, {ARG0}
            TEST EAX, EAX
            JZ .true
            CMP DWORD PTR [EAX+4], 0  ; Length == 0?
            JE .true
            XOR EAX, EAX              ; false
            RET
        .true:
            MOV EAX, 1
            RET
        ", Clobbers = "EAX")]
        public static bool IsNullOrEmpty(string? value)
        {
            return true;
        }
        
        public override string ToString()
        {
            return this;
        }
        
        public int CompareTo(string? other)
        {
            if (other == null) return 1;
            // Comparacao lexicografica
            int len = Length < other.Length ? Length : other.Length;
            for (int i = 0; i < len; i++)
            {
                int diff = this[i] - other[i];
                if (diff != 0) return diff;
            }
            return Length - other.Length;
        }
        
        public int CompareTo(object? obj)
        {
            if (obj == null) return 1;
            if (obj is string s) return CompareTo(s);
            throw new ArgumentException("Object must be a String");
        }
        
        // Operador de igualdade
        public static bool operator ==(string? a, string? b)
        {
            if (ReferenceEquals(a, b)) return true;
            if (a is null || b is null) return false;
            return a.Equals(b);
        }
        
        public static bool operator !=(string? a, string? b)
        {
            return !(a == b);
        }
    }
}
```

---

# PARTE 10: SAMPLES

## 10.1 Hello World

```csharp
// samples/HelloWorld/Program.cs
using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Hello, DOS World!");
        Console.WriteLine("Press any key to exit...");
        Console.ReadKey();
    }
}
```

## 10.2 Fibonacci com Int64

```csharp
// samples/Fibonacci/Program.cs
using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Fibonacci Sequence (64-bit):");
        Console.WriteLine();
        
        long a = 0, b = 1;
        
        for (int i = 0; i < 50; i++)
        {
            Console.Write(i);
            Console.Write(": ");
            Console.WriteLine(a);
            
            long temp = a + b;
            a = b;
            b = temp;
        }
    }
}
```

## 10.3 Matematica com Ponto Flutuante

```csharp
// samples/FloatMath/Program.cs
using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("=== Floating Point Demo ===");
        Console.WriteLine();
        
        double x = 0.5;
        
        Console.Write("x = ");
        Console.WriteLine(x);
        Console.WriteLine();
        
        Console.Write("sin(x) = ");
        Console.WriteLine(Math.Sin(x));
        
        Console.Write("cos(x) = ");
        Console.WriteLine(Math.Cos(x));
        
        Console.Write("tan(x) = ");
        Console.WriteLine(Math.Tan(x));
        
        Console.WriteLine();
        
        Console.Write("sqrt(x) = ");
        Console.WriteLine(Math.Sqrt(x));
        
        Console.Write("exp(x) = ");
        Console.WriteLine(Math.Exp(x));
        
        Console.Write("log(x) = ");
        Console.WriteLine(Math.Log(x));
        
        Console.WriteLine();
        Console.WriteLine("=== Constants ===");
        Console.Write("PI = ");
        Console.WriteLine(Math.PI);
        Console.Write("E = ");
        Console.WriteLine(Math.E);
    }
}
```

## 10.4 Lista Generica

```csharp
// samples/Generics/Program.cs
using System;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        Console.WriteLine("=== Generic List Demo ===");
        Console.WriteLine();
        
        // Lista de inteiros (monomorphized para int)
        var numbers = new List<int>();
        numbers.Add(10);
        numbers.Add(20);
        numbers.Add(30);
        numbers.Add(40);
        numbers.Add(50);
        
        Console.WriteLine("Numbers:");
        for (int i = 0; i < numbers.Count; i++)
        {
            Console.Write("  [");
            Console.Write(i);
            Console.Write("] = ");
            Console.WriteLine(numbers[i]);
        }
        
        Console.WriteLine();
        
        // Lista de strings (compartilha com outros ref types)
        var names = new List<string>();
        names.Add("Alice");
        names.Add("Bob");
        names.Add("Charlie");
        
        Console.WriteLine("Names:");
        for (int i = 0; i < names.Count; i++)
        {
            Console.Write("  ");
            Console.WriteLine(names[i]);
        }
        
        Console.WriteLine();
        Console.Write("Sum of numbers: ");
        Console.WriteLine(Sum(numbers));
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

## 10.5 JSON Serialization

```csharp
// samples/JsonDemo/Program.cs
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
        Console.WriteLine("=== JSON Serialization Demo ===");
        Console.WriteLine();
        
        // Criar objeto
        var person = new Person
        {
            Name = "John Doe",
            Age = 30,
            IsEmployed = true
        };
        
        // Serializar
        Console.WriteLine("Original object:");
        Console.Write("  Name: ");
        Console.WriteLine(person.Name);
        Console.Write("  Age: ");
        Console.WriteLine(person.Age);
        Console.Write("  Employed: ");
        Console.WriteLine(person.IsEmployed);
        Console.WriteLine();
        
        string json = JsonSerializer.Serialize(person);
        Console.WriteLine("JSON:");
        Console.WriteLine(json);
        Console.WriteLine();
        
        // Deserializar
        string inputJson = "{\"Name\":\"Jane\",\"Age\":25,\"IsEmployed\":false}";
        Console.WriteLine("Input JSON:");
        Console.WriteLine(inputJson);
        Console.WriteLine();
        
        var parsed = JsonSerializer.Deserialize<Person>(inputJson);
        Console.WriteLine("Parsed object:");
        Console.Write("  Name: ");
        Console.WriteLine(parsed.Name);
        Console.Write("  Age: ");
        Console.WriteLine(parsed.Age);
        Console.Write("  Employed: ");
        Console.WriteLine(parsed.IsEmployed);
    }
}
```

## 10.6 Reflection

```csharp
// samples/Reflection/Program.cs
using System;
using System.Reflection;

class MyClass
{
    public int Value { get; set; }
    public string Name { get; set; }
    
    public void Print()
    {
        Console.Write("Value=");
        Console.Write(Value);
        Console.Write(", Name=");
        Console.WriteLine(Name);
    }
}

class Program
{
    static void Main()
    {
        Console.WriteLine("=== Reflection Demo ===");
        Console.WriteLine();
        
        // Obter tipo
        Type type = typeof(MyClass);
        Console.Write("Type: ");
        Console.WriteLine(type.Name);
        Console.WriteLine();
        
        // Listar propriedades
        Console.WriteLine("Properties:");
        PropertyInfo[] props = type.GetProperties();
        for (int i = 0; i < props.Length; i++)
        {
            Console.Write("  - ");
            Console.WriteLine(props[i].Name);
        }
        Console.WriteLine();
        
        // Listar metodos
        Console.WriteLine("Methods:");
        MethodInfo[] methods = type.GetMethods();
        for (int i = 0; i < methods.Length; i++)
        {
            Console.Write("  - ");
            Console.WriteLine(methods[i].Name);
        }
        Console.WriteLine();
        
        // Criar instancia dinamicamente
        Console.WriteLine("Creating instance via Activator...");
        object obj = Activator.CreateInstance(type);
        
        // Setar propriedades via reflection
        PropertyInfo valueProp = type.GetProperty("Value");
        PropertyInfo nameProp = type.GetProperty("Name");
        
        valueProp.SetValue(obj, 42);
        nameProp.SetValue(obj, "Hello");
        
        // Chamar metodo
        Console.WriteLine("Calling Print():");
        MethodInfo printMethod = type.GetMethod("Print");
        printMethod.Invoke(obj, null);
    }
}
```

---

# PARTE 11: TESTES E VALIDACAO

## 11.1 Estrutura de Testes

```
tests/
├── Compiler.Tests/
│   ├── IL/
│   │   ├── ILReaderTests.cs
│   │   └── ILInstructionTests.cs
│   ├── Analysis/
│   │   ├── TypeHierarchyTests.cs
│   │   └── GenericAnalyzerTests.cs
│   ├── CodeGen/
│   │   ├── InstructionSelectionTests.cs
│   │   └── RegisterAllocationTests.cs
│   └── Integration/
│       ├── HelloWorldTests.cs
│       └── AllSamplesTests.cs
│
├── Runtime.Tests/
│   ├── GCTests.cs
│   ├── ReflectionTests.cs
│   └── JsonTests.cs
│
└── EndToEnd.Tests/
    └── DosBoxTests.cs  # Executa em DOSBox via automacao
```

## 11.2 Criterios de Aceitacao

1. **Todos os samples compilam sem erro**
2. **Todos os samples executam corretamente em DOSBox**
3. **GC recupera memoria corretamente**
4. **Reflection funciona para tipos e propriedades**
5. **JSON serializa/deserializa corretamente**
6. **Nenhuma instrucao invalida para o CPU level selecionado**

---

# APENDICE A: REFERENCIAS

- Intel 80386 Programmer's Reference Manual
- Intel 80387 Programmer's Reference Manual
- Intel 80486 Programmer's Reference Manual
- Intel Pentium Processor Family Developer's Manual
- ECMA-335: Common Language Infrastructure (CLI)
- MS-DOS Programmer's Reference
- Ralph Brown's Interrupt List
- IEEE 754-2008: Floating-Point Arithmetic

---

# APENDICE B: GLOSSARIO

| Termo | Definicao |
|-------|-----------|
| AOT | Ahead-Of-Time compilation |
| BCL | Base Class Library |
| CFG | Control Flow Graph |
| GC | Garbage Collector |
| IL | Intermediate Language |
| IR | Intermediate Representation |
| JIT | Just-In-Time compilation |
| Monomorphization | Geracao de codigo especializado para cada tipo generico |
| MSIL | Microsoft Intermediate Language |
| SSA | Static Single Assignment |
| VTable | Virtual Method Table |

---

# APENDICE C: LICENCA

MIT License

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software...

---

**FIM DA ESPECIFICACAO**
