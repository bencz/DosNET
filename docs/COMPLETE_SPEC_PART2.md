# PARTE 2: SISTEMA DE GENERICS - ANALISE DETALHADA

## 2.1 O Problema dos Generics

Generics em .NET permitem codigo type-safe e reutilizavel:

```csharp
// Um unico codigo fonte...
public class List<T>
{
    private T[] _items;
    public void Add(T item) { ... }
    public T Get(int index) { ... }
}

// ...usado com diferentes tipos
List<int> numbers = new List<int>();
List<string> names = new List<string>();
List<Person> people = new List<Person>();
```

**O Desafio:** Como compilar isso para assembly nativo sem um JIT?

---

## 2.2 Duas Estrategias Principais

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ESTRATEGIA 1: MONOMORPHIZATION                            │
│                    (Como Rust, C++, Swift)                                   │
└─────────────────────────────────────────────────────────────────────────────┘

Ideia: Gerar codigo SEPARADO para cada combinacao de tipos usada.

Codigo fonte:                      Codigo gerado:
─────────────                      ──────────────
List<T>                    ───►    __List_int      (especializado para int)
                                   __List_string   (especializado para string)
                                   __List_Person   (especializado para Person)

┌─────────────────────────────────────────────────────────────────────────────┐
│  List<int>                                                                   │
│  ┌─────────────────────────────────────────────────────────────────────────┐│
│  │ __List_int_Add:                                                         ││
│  │     MOV ESI, [EBP+8]           ; this                                   ││
│  │     MOV EAX, [EBP+12]          ; value (int, 4 bytes)                   ││
│  │     ; ... codigo otimizado para int ...                                 ││
│  │     MOV [EDI], EAX             ; store direto, sem boxing              ││
│  └─────────────────────────────────────────────────────────────────────────┘│
│                                                                              │
│  VANTAGENS:                                                                  │
│  + Codigo otimizado para cada tipo                                          │
│  + Sem overhead de runtime                                                   │
│  + Operacoes inline (sem indirection)                                       │
│  + Sem boxing de value types                                                │
│  + Permite otimizacoes especificas (ex: SIMD para int[])                   │
│                                                                              │
│  DESVANTAGENS:                                                               │
│  - Code bloat (codigo duplicado)                                            │
│  - Compilacao mais lenta                                                     │
│  - Executavel maior                                                          │
│  - Mais uso de memoria de codigo                                            │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    ESTRATEGIA 2: TYPE ERASURE / DICTIONARY PASSING          │
│                    (Como Java, .NET JIT em alguns casos)                    │
└─────────────────────────────────────────────────────────────────────────────┘

Ideia: Gerar UM codigo que funciona para todos os tipos, passando
       informacao de tipo em runtime.

Codigo fonte:                      Codigo gerado:
─────────────                      ──────────────
List<T>                    ───►    __List_generic (unico!)
                                   + TypeInfo passado em runtime

┌─────────────────────────────────────────────────────────────────────────────┐
│  List<T> (generico)                                                          │
│  ┌─────────────────────────────────────────────────────────────────────────┐│
│  │ __List_generic_Add:                                                     ││
│  │     MOV ESI, [EBP+8]           ; this                                   ││
│  │     MOV EBX, [ESI+typeinfo]    ; carregar TypeInfo                      ││
│  │     MOV ECX, [EBX+size]        ; tamanho do elemento                    ││
│  │     ; ... codigo generico ...                                           ││
│  │     ; precisa de indirection para cada operacao                         ││
│  │     CALL [EBX+copy_func]       ; chamar funcao de copia                 ││
│  └─────────────────────────────────────────────────────────────────────────┘│
│                                                                              │
│  VANTAGENS:                                                                  │
│  + Codigo menor (nao duplicado)                                             │
│  + Compilacao mais rapida                                                    │
│  + Menos memoria de codigo                                                  │
│                                                                              │
│  DESVANTAGENS:                                                               │
│  - Overhead de runtime (indirection)                                        │
│  - Nao pode otimizar para tipo especifico                                   │
│  - Boxing necessario para value types                                       │
│  - Mais lento em runtime                                                     │
│  - Complexidade adicional (TypeInfo everywhere)                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2.3 Nossa Escolha: Monomorphization com Sharing

Para um compilador AOT (Ahead-Of-Time) targeting DOS, escolhemos:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                              │
│            MONOMORPHIZATION COM SHARING DE REFERENCE TYPES                  │
│                                                                              │
│  Combina o melhor dos dois mundos:                                          │
│                                                                              │
│  1. Value types: MONOMORPHIZATION COMPLETA                                  │
│     - List<int>, List<long>, List<float> = codigos separados               │
│     - Performance maxima, sem boxing                                        │
│                                                                              │
│  2. Reference types: CODIGO COMPARTILHADO                                   │
│     - List<string>, List<Person>, List<object> = mesmo codigo!             │
│     - Todos sao ponteiros de 4 bytes (no i386)                             │
│     - Reduz code bloat significativamente                                   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2.3.1 Por que isso funciona?

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    REFERENCE TYPES SAO TODOS PONTEIROS                       │
└─────────────────────────────────────────────────────────────────────────────┘

No nivel de assembly, TODOS os reference types sao apenas ponteiros:

    string          = ponteiro de 4 bytes  ───┐
    Person          = ponteiro de 4 bytes  ───┼──► MESMO TAMANHO!
    object          = ponteiro de 4 bytes  ───┤
    Exception       = ponteiro de 4 bytes  ───┤
    List<string>    = ponteiro de 4 bytes  ───┘

Portanto, o codigo de List<T> onde T e reference type:
- Sempre aloca 4 bytes por elemento
- Sempre copia 4 bytes
- Sempre compara 4 bytes

NAO PRECISA de codigo separado!

┌─────────────────────────────────────────────────────────────────────────────┐
│                    VALUE TYPES TEM TAMANHOS DIFERENTES                       │
└─────────────────────────────────────────────────────────────────────────────┘

Value types tem tamanhos variados:

    byte            = 1 byte   ───┐
    short           = 2 bytes  ───┼──► TAMANHOS DIFERENTES!
    int             = 4 bytes  ───┤
    long            = 8 bytes  ───┤
    float           = 4 bytes  ───┤
    double          = 8 bytes  ───┤
    MyStruct        = N bytes  ───┘

Portanto, o codigo de List<T> onde T e value type:
- Aloca sizeof(T) bytes por elemento
- Copia sizeof(T) bytes
- Operacoes aritmeticas dependem do tipo

PRECISA de codigo separado para cada tipo!
```

### 2.3.2 Diagrama de Sharing

```
                            List<T>
                               │
              ┌────────────────┴────────────────┐
              │                                 │
        VALUE TYPES                      REFERENCE TYPES
              │                                 │
    ┌─────────┼─────────┐                      │
    │         │         │                      │
 List<int> List<long> List<float>         List<object>
    │         │         │                 ┌────┼────┐
    ▼         ▼         ▼                 │    │    │
              │                           │    │    │
 SEPARADOS    │                     List<string> │ List<MyClass>
              │                           │    │    │
 __List_i32   │                           └────┼────┘
 __List_i64   │                                │
 __List_f32   │                                ▼
              │                                │
              │                          COMPARTILHADO
              │                                │
              │                          __List_ref
              │                      (unico para todos!)
              │
              │
    ┌─────────────────────────────────────────────────────────┐
    │  EXCECAO: Value types de MESMO TAMANHO podem compartilhar │
    │                                                          │
    │  int (4 bytes) e uint (4 bytes) e float (4 bytes)       │
    │  PODEM usar o mesmo codigo se nao houver operacoes      │
    │  aritmeticas no tipo generico!                          │
    │                                                          │
    │  Ex: List<T>.Add() apenas copia bytes                   │
    │      Pode compartilhar entre int/uint/float             │
    │                                                          │
    │  Mas: Comparer<T>.Compare() faz aritmetica              │
    │       PRECISA de codigo separado                        │
    └─────────────────────────────────────────────────────────┘
```

---

## 2.4 Implementacao Detalhada

### 2.4.1 Analise de Uso de Generics

```csharp
namespace MsilToDos.Frontend.Generics
{
    /// <summary>
    /// Analisa o programa para encontrar todas as instanciacoes de generics
    /// </summary>
    public class GenericUsageAnalyzer
    {
        private readonly HashSet<GenericInstantiation> _instantiations = new();
        
        /// <summary>
        /// Analisa uma assembly e encontra todos os usos de generics
        /// </summary>
        public GenericUsageReport Analyze(AssemblyDef assembly)
        {
            var report = new GenericUsageReport();
            
            foreach (var type in assembly.Types)
            {
                AnalyzeType(type, report);
            }
            
            return report;
        }
        
        private void AnalyzeType(TypeDef type, GenericUsageReport report)
        {
            // Analisar tipo base
            if (type.BaseType?.IsGenericInstance == true)
            {
                RecordInstantiation(type.BaseType, report);
            }
            
            // Analisar interfaces
            foreach (var iface in type.Interfaces)
            {
                if (iface.IsGenericInstance)
                {
                    RecordInstantiation(iface, report);
                }
            }
            
            // Analisar campos
            foreach (var field in type.Fields)
            {
                if (field.FieldType.IsGenericInstance)
                {
                    RecordInstantiation(field.FieldType, report);
                }
            }
            
            // Analisar metodos
            foreach (var method in type.Methods)
            {
                AnalyzeMethod(method, report);
            }
        }
        
        private void AnalyzeMethod(MethodDef method, GenericUsageReport report)
        {
            // Parametros
            foreach (var param in method.Parameters)
            {
                if (param.ParameterType.IsGenericInstance)
                {
                    RecordInstantiation(param.ParameterType, report);
                }
            }
            
            // Retorno
            if (method.ReturnType.IsGenericInstance)
            {
                RecordInstantiation(method.ReturnType, report);
            }
            
            // Variaveis locais
            foreach (var local in method.Body?.Variables ?? Enumerable.Empty<VariableDef>())
            {
                if (local.VariableType.IsGenericInstance)
                {
                    RecordInstantiation(local.VariableType, report);
                }
            }
            
            // Instrucoes IL
            foreach (var inst in method.Body?.Instructions ?? Enumerable.Empty<ILInstruction>())
            {
                switch (inst.OpCode)
                {
                    case ILOpCode.Newobj:
                    case ILOpCode.Call:
                    case ILOpCode.Callvirt:
                        if (inst.Operand is MethodRef methodRef && 
                            methodRef.DeclaringType.IsGenericInstance)
                        {
                            RecordInstantiation(methodRef.DeclaringType, report);
                        }
                        break;
                        
                    case ILOpCode.Newarr:
                    case ILOpCode.Ldtoken:
                        if (inst.Operand is TypeRef typeRef && 
                            typeRef.IsGenericInstance)
                        {
                            RecordInstantiation(typeRef, report);
                        }
                        break;
                }
            }
        }
        
        private void RecordInstantiation(TypeDef type, GenericUsageReport report)
        {
            var inst = new GenericInstantiation(
                type.GenericDefinition!,
                type.TypeArguments
            );
            
            if (_instantiations.Add(inst))
            {
                report.Instantiations.Add(inst);
                
                // Recursivamente analisar type arguments
                foreach (var arg in type.TypeArguments)
                {
                    if (arg.IsGenericInstance)
                    {
                        RecordInstantiation(arg, report);
                    }
                }
            }
        }
    }
    
    public class GenericUsageReport
    {
        public List<GenericInstantiation> Instantiations { get; } = new();
        
        public IEnumerable<GenericInstantiation> ValueTypeInstantiations =>
            Instantiations.Where(i => i.TypeArguments.Any(a => a.IsValueType));
            
        public IEnumerable<GenericInstantiation> ReferenceTypeInstantiations =>
            Instantiations.Where(i => i.TypeArguments.All(a => a.IsReferenceType));
    }
    
    public class GenericInstantiation : IEquatable<GenericInstantiation>
    {
        public TypeDef GenericDefinition { get; }
        public IReadOnlyList<TypeDef> TypeArguments { get; }
        
        public GenericInstantiation(TypeDef genericDef, IReadOnlyList<TypeDef> typeArgs)
        {
            GenericDefinition = genericDef;
            TypeArguments = typeArgs;
        }
        
        public bool Equals(GenericInstantiation? other)
        {
            if (other is null) return false;
            if (GenericDefinition != other.GenericDefinition) return false;
            if (TypeArguments.Count != other.TypeArguments.Count) return false;
            
            for (int i = 0; i < TypeArguments.Count; i++)
            {
                if (TypeArguments[i] != other.TypeArguments[i])
                    return false;
            }
            
            return true;
        }
        
        public override int GetHashCode()
        {
            var hash = GenericDefinition.GetHashCode();
            foreach (var arg in TypeArguments)
            {
                hash = HashCode.Combine(hash, arg.GetHashCode());
            }
            return hash;
        }
    }
}
```

### 2.4.2 Politica de Sharing

```csharp
namespace MsilToDos.Frontend.Generics
{
    /// <summary>
    /// Determina quais instanciacoes podem compartilhar codigo
    /// </summary>
    public class SharingPolicy
    {
        /// <summary>
        /// Agrupa instanciacoes que podem compartilhar codigo
        /// </summary>
        public List<SharingGroup> GroupInstantiations(IEnumerable<GenericInstantiation> instantiations)
        {
            var groups = new Dictionary<string, SharingGroup>();
            
            foreach (var inst in instantiations)
            {
                var canonicalKey = GetCanonicalKey(inst);
                
                if (!groups.TryGetValue(canonicalKey, out var group))
                {
                    group = new SharingGroup(canonicalKey);
                    groups[canonicalKey] = group;
                }
                
                group.Instantiations.Add(inst);
            }
            
            return groups.Values.ToList();
        }
        
        /// <summary>
        /// Gera chave canonica para sharing
        /// </summary>
        private string GetCanonicalKey(GenericInstantiation inst)
        {
            var sb = new StringBuilder();
            sb.Append(inst.GenericDefinition.FullName);
            sb.Append('<');
            
            for (int i = 0; i < inst.TypeArguments.Count; i++)
            {
                if (i > 0) sb.Append(',');
                sb.Append(GetCanonicalTypeName(inst.TypeArguments[i]));
            }
            
            sb.Append('>');
            return sb.ToString();
        }
        
        /// <summary>
        /// Gera nome canonico do tipo para sharing
        /// </summary>
        private string GetCanonicalTypeName(TypeDef type)
        {
            // Reference types: todos mapeiam para "__ref"
            if (type.IsReferenceType)
            {
                return "__ref";
            }
            
            // Value types: usar nome especifico
            return type.FullName switch
            {
                "System.Boolean" => "__bool",
                "System.Byte" => "__u8",
                "System.SByte" => "__i8",
                "System.Int16" => "__i16",
                "System.UInt16" => "__u16",
                "System.Int32" => "__i32",
                "System.UInt32" => "__u32",
                "System.Int64" => "__i64",
                "System.UInt64" => "__u64",
                "System.Single" => "__f32",
                "System.Double" => "__f64",
                "System.Char" => "__char",
                "System.IntPtr" => "__iptr",
                "System.UIntPtr" => "__uptr",
                _ => $"__{type.FullName.Replace('.', '_')}"
            };
        }
        
        /// <summary>
        /// Verifica se dois tipos podem compartilhar codigo em um contexto especifico
        /// </summary>
        public bool CanShare(TypeDef type1, TypeDef type2, GenericContext context)
        {
            // Reference types sempre compartilham
            if (type1.IsReferenceType && type2.IsReferenceType)
                return true;
            
            // Value types: dependende do contexto
            if (type1.IsValueType && type2.IsValueType)
            {
                // Se o contexto nao faz operacoes aritmeticas,
                // tipos do mesmo tamanho podem compartilhar
                if (!context.HasArithmeticOperations)
                {
                    return type1.Size == type2.Size && 
                           type1.Alignment == type2.Alignment;
                }
                
                // Com aritmetica, precisa ser exatamente o mesmo tipo
                return type1.Equals(type2);
            }
            
            // Mistura value/reference: nunca compartilha
            return false;
        }
    }
    
    public class SharingGroup
    {
        public string CanonicalKey { get; }
        public List<GenericInstantiation> Instantiations { get; } = new();
        
        public SharingGroup(string key)
        {
            CanonicalKey = key;
        }
        
        /// <summary>
        /// Nome do tipo/metodo gerado para este grupo
        /// </summary>
        public string GeneratedName => CanonicalKey
            .Replace('<', '_')
            .Replace('>', '_')
            .Replace(',', '_')
            .Replace("System.", "")
            .Replace(".", "_");
    }
    
    public class GenericContext
    {
        public bool HasArithmeticOperations { get; set; }
        public bool HasComparisonOperations { get; set; }
        public bool HasBoxingOperations { get; set; }
    }
}
```

### 2.4.3 Geracao de Codigo Especializado

```csharp
namespace MsilToDos.Frontend.Generics
{
    /// <summary>
    /// Gera codigo especializado para cada grupo de sharing
    /// </summary>
    public class SpecializedCodeGenerator
    {
        private readonly SharingPolicy _policy;
        
        public SpecializedCodeGenerator()
        {
            _policy = new SharingPolicy();
        }
        
        /// <summary>
        /// Gera tipos especializados para todas as instanciacoes
        /// </summary>
        public List<TypeDef> GenerateSpecializedTypes(GenericUsageReport report)
        {
            var groups = _policy.GroupInstantiations(report.Instantiations);
            var result = new List<TypeDef>();
            
            foreach (var group in groups)
            {
                var specializedType = GenerateForGroup(group);
                result.Add(specializedType);
            }
            
            return result;
        }
        
        private TypeDef GenerateForGroup(SharingGroup group)
        {
            // Pegar o primeiro como "representante"
            var representative = group.Instantiations[0];
            var genericDef = representative.GenericDefinition;
            
            var specialized = new TypeDef
            {
                Name = group.GeneratedName,
                Namespace = genericDef.Namespace,
                Flags = genericDef.Flags,
                IsSpecializedGeneric = true,
                OriginalGenericDef = genericDef,
                RepresentativeTypeArgs = representative.TypeArguments,
            };
            
            // Mapear type parameters para tipos concretos
            var typeMap = new Dictionary<GenericParameter, TypeDef>();
            for (int i = 0; i < genericDef.GenericParameters.Count; i++)
            {
                typeMap[genericDef.GenericParameters[i]] = representative.TypeArguments[i];
            }
            
            // Especializar campos
            foreach (var field in genericDef.Fields)
            {
                var specializedField = new FieldDef
                {
                    Name = field.Name,
                    Flags = field.Flags,
                    FieldType = SubstituteType(field.FieldType, typeMap),
                    DeclaringType = specialized,
                };
                specialized.Fields.Add(specializedField);
            }
            
            // Calcular layout
            CalculateLayout(specialized);
            
            // Especializar metodos
            foreach (var method in genericDef.Methods)
            {
                var specializedMethod = SpecializeMethod(method, typeMap, specialized);
                specialized.Methods.Add(specializedMethod);
            }
            
            return specialized;
        }
        
        private MethodDef SpecializeMethod(
            MethodDef method, 
            Dictionary<GenericParameter, TypeDef> typeMap,
            TypeDef declaringType)
        {
            var specialized = new MethodDef
            {
                Name = method.Name,
                Flags = method.Flags,
                DeclaringType = declaringType,
                ReturnType = SubstituteType(method.ReturnType, typeMap),
            };
            
            // Parametros
            foreach (var param in method.Parameters)
            {
                specialized.Parameters.Add(new ParameterDef
                {
                    Name = param.Name,
                    ParameterType = SubstituteType(param.ParameterType, typeMap),
                });
            }
            
            // Corpo do metodo
            if (method.Body != null)
            {
                specialized.Body = SpecializeMethodBody(method.Body, typeMap);
            }
            
            return specialized;
        }
        
        private MethodBody SpecializeMethodBody(
            MethodBody body, 
            Dictionary<GenericParameter, TypeDef> typeMap)
        {
            var specialized = new MethodBody();
            
            // Variaveis locais
            foreach (var local in body.Variables)
            {
                specialized.Variables.Add(new VariableDef
                {
                    Index = local.Index,
                    VariableType = SubstituteType(local.VariableType, typeMap),
                });
            }
            
            // Instrucoes
            foreach (var inst in body.Instructions)
            {
                var specializedInst = SpecializeInstruction(inst, typeMap);
                specialized.Instructions.Add(specializedInst);
            }
            
            return specialized;
        }
        
        private ILInstruction SpecializeInstruction(
            ILInstruction inst, 
            Dictionary<GenericParameter, TypeDef> typeMap)
        {
            var result = new ILInstruction
            {
                Offset = inst.Offset,
                OpCode = inst.OpCode,
            };
            
            // Substituir operandos que referenciam tipos genericos
            result.Operand = inst.Operand switch
            {
                TypeRef typeRef => SubstituteType(typeRef, typeMap),
                MethodRef methodRef => SubstituteMethod(methodRef, typeMap),
                FieldRef fieldRef => SubstituteField(fieldRef, typeMap),
                _ => inst.Operand
            };
            
            return result;
        }
        
        private TypeDef SubstituteType(TypeDef type, Dictionary<GenericParameter, TypeDef> typeMap)
        {
            // Se e um parametro generico, substituir
            if (type is GenericParameter gp && typeMap.TryGetValue(gp, out var substitute))
            {
                return substitute;
            }
            
            // Se e um tipo generico instanciado, recursivamente substituir
            if (type.IsGenericInstance)
            {
                var newArgs = type.TypeArguments
                    .Select(a => SubstituteType(a, typeMap))
                    .ToList();
                
                // Criar nova instanciacao
                return new TypeDef
                {
                    GenericDefinition = type.GenericDefinition,
                    TypeArguments = newArgs,
                    IsGenericInstance = true,
                };
            }
            
            // Se e array, substituir elemento
            if (type.IsArray)
            {
                return new ArrayTypeDef(SubstituteType(type.ElementType!, typeMap));
            }
            
            return type;
        }
        
        private void CalculateLayout(TypeDef type)
        {
            int offset = 0;
            
            // VTable pointer (se classe)
            if (!type.IsValueType)
            {
                offset = 4; // sizeof(void*)
            }
            
            foreach (var field in type.Fields)
            {
                if (field.IsStatic) continue;
                
                // Alinhamento
                int alignment = GetAlignment(field.FieldType);
                offset = (offset + alignment - 1) & ~(alignment - 1);
                
                field.Offset = offset;
                field.Size = GetSize(field.FieldType);
                offset += field.Size;
            }
            
            // Alinhar tamanho final
            type.InstanceSize = (offset + 3) & ~3; // Alinhar para 4 bytes
        }
        
        private int GetSize(TypeDef type)
        {
            if (type.IsReferenceType) return 4; // Ponteiro
            
            return type.FullName switch
            {
                "System.Boolean" => 1,
                "System.Byte" => 1,
                "System.SByte" => 1,
                "System.Int16" => 2,
                "System.UInt16" => 2,
                "System.Char" => 2,
                "System.Int32" => 4,
                "System.UInt32" => 4,
                "System.Single" => 4,
                "System.Int64" => 8,
                "System.UInt64" => 8,
                "System.Double" => 8,
                _ => type.InstanceSize
            };
        }
        
        private int GetAlignment(TypeDef type)
        {
            if (type.IsReferenceType) return 4;
            
            int size = GetSize(type);
            return Math.Min(size, 4); // Max 4-byte alignment no i386
        }
    }
}
```

---

## 2.5 Exemplo Completo de Monomorphization

### Entrada (C#)

```csharp
class Program
{
    static void Main()
    {
        var ints = new List<int>();
        var longs = new List<long>();
        var strings = new List<string>();
        var people = new List<Person>();
        
        ints.Add(1);
        longs.Add(100L);
        strings.Add("hello");
        people.Add(new Person());
    }
}

class Person { }
```

### Analise de Uso

```
GenericUsageReport:
  - List<int>      usado em Main
  - List<long>     usado em Main
  - List<string>   usado em Main
  - List<Person>   usado em Main
```

### Agrupamento por Sharing

```
SharingGroups:
  1. List<__i32>   [List<int>]           - value type 4 bytes
  2. List<__i64>   [List<long>]          - value type 8 bytes
  3. List<__ref>   [List<string>, List<Person>]  - ref types compartilham!
```

### Codigo Gerado

```asm
; ============================================================
; __List_i32 - Lista especializada para int (4 bytes)
; ============================================================

__List_i32_Add PROC
    ; this em [EBP+8], value em [EBP+12]
    MOV ESI, [EBP+8]            ; this
    MOV EAX, [EBP+12]           ; value (int, 4 bytes)
    
    ; Verificar capacidade
    MOV ECX, [ESI+8]            ; _count
    CMP ECX, [ESI+12]           ; _capacity
    JAE .grow
    
    ; Adicionar
    MOV EDI, [ESI+4]            ; _items (int[])
    MOV [EDI + ECX*4], EAX      ; _items[_count] = value
    INC DWORD PTR [ESI+8]       ; _count++
    RET
    
.grow:
    ; ... expandir array ...
    RET
__List_i32_Add ENDP

; ============================================================
; __List_i64 - Lista especializada para long (8 bytes)
; ============================================================

__List_i64_Add PROC
    MOV ESI, [EBP+8]
    MOV EAX, [EBP+12]           ; value low
    MOV EDX, [EBP+16]           ; value high
    
    MOV ECX, [ESI+8]
    CMP ECX, [ESI+12]
    JAE .grow
    
    MOV EDI, [ESI+4]
    MOV [EDI + ECX*8], EAX      ; store low
    MOV [EDI + ECX*8 + 4], EDX  ; store high
    INC DWORD PTR [ESI+8]
    RET
    
.grow:
    RET
__List_i64_Add ENDP

; ============================================================
; __List_ref - Lista compartilhada para TODOS os reference types!
; Funciona para string, Person, object, Exception, etc
; ============================================================

__List_ref_Add PROC
    MOV ESI, [EBP+8]
    MOV EAX, [EBP+12]           ; value (ponteiro, 4 bytes)
    
    MOV ECX, [ESI+8]
    CMP ECX, [ESI+12]
    JAE .grow
    
    MOV EDI, [ESI+4]
    MOV [EDI + ECX*4], EAX      ; todos os ref types sao 4 bytes!
    INC DWORD PTR [ESI+8]
    RET
    
.grow:
    RET
__List_ref_Add ENDP
```

### Chamadas no Main

```asm
__Program_Main:
    ; var ints = new List<int>();
    CALL __List_i32_ctor
    MOV [EBP-4], EAX
    
    ; var longs = new List<long>();
    CALL __List_i64_ctor
    MOV [EBP-8], EAX
    
    ; var strings = new List<string>();
    CALL __List_ref_ctor        ; ◄── Mesmo codigo!
    MOV [EBP-12], EAX
    
    ; var people = new List<Person>();
    CALL __List_ref_ctor        ; ◄── Mesmo codigo!
    MOV [EBP-16], EAX
    
    ; ints.Add(1);
    PUSH 1
    PUSH DWORD PTR [EBP-4]
    CALL __List_i32_Add
    
    ; longs.Add(100L);
    PUSH 0                      ; high
    PUSH 100                    ; low
    PUSH DWORD PTR [EBP-8]
    CALL __List_i64_Add
    
    ; strings.Add("hello");
    PUSH OFFSET __str_hello
    PUSH DWORD PTR [EBP-12]
    CALL __List_ref_Add         ; ◄── Mesmo codigo!
    
    ; people.Add(new Person());
    CALL __Person_ctor
    PUSH EAX
    PUSH DWORD PTR [EBP-16]
    CALL __List_ref_Add         ; ◄── Mesmo codigo!
    
    RET
```

---

## 2.6 Beneficios da Abordagem Escolhida

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         RESUMO DOS BENEFICIOS                                │
└─────────────────────────────────────────────────────────────────────────────┘

1. PERFORMANCE MAXIMA PARA VALUE TYPES
   - Sem boxing
   - Operacoes inline
   - Otimizacoes especificas

2. CODE BLOAT REDUZIDO
   - Reference types compartilham codigo
   - Em programas tipicos, maioria dos generics usa ref types
   - Economia significativa de memoria de codigo

3. SIMPLICIDADE DE IMPLEMENTACAO
   - Nao precisa de TypeInfo em runtime
   - Nao precisa de dictionary passing
   - Codigo mais direto e facil de debugar

4. COMPATIBILIDADE COM .NET SEMANTICS
   - Comportamento identico ao .NET JIT
   - Sem surpresas para o desenvolvedor

5. ADEQUADO PARA DOS
   - Memoria limitada = sharing importante
   - Performance critica = monomorphization importante
   - Sem JIT = tudo resolvido em compile time
```
