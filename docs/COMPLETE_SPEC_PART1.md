# MSIL to DOS Transpiler - Especificacao Tecnica Completa

## Documento de Arquitetura e Implementacao

**Versao:** 1.0  
**Data:** Janeiro 2025  
**Status:** Especificacao para Implementacao

---

# PARTE 1: VISAO GERAL DO PROJETO

## 1.1 Introducao

Este documento especifica um **transpilador de MSIL (Microsoft Intermediate Language) para Assembly nativo**, permitindo que programas .NET sejam compilados para executaveis DOS e potencialmente outras arquiteturas.

### 1.1.1 Objetivos do Projeto

1. **Compilar C#/.NET para DOS** - Executaveis .COM e .EXE para MS-DOS
2. **Suporte completo a OOP** - Classes, heranca, interfaces, metodos virtuais
3. **Generics** - Via monomorphization para performance maxima
4. **Reflection** - Suporte a System.Reflection e System.Text.Json
5. **Garbage Collection** - Mark-and-sweep automatico
6. **Arquitetura extensivel** - Permitir adicionar novos backends (x86, s390, ARM, etc)

### 1.1.2 Nao-Objetivos (Fora do Escopo)

- Compilacao JIT (apenas AOT)
- Suporte a threads (DOS e single-threaded)
- async/await
- Interop COM
- PInvoke para DLLs Windows

---

## 1.2 Arquitetura de Alto Nivel

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              ENTRADA                                         │
│                                                                              │
│   ┌──────────────┐    ┌──────────────┐    ┌──────────────┐                 │
│   │  Seu App     │    │   BCL        │    │  Outras      │                 │
│   │  .NET        │    │   Custom     │    │  Libraries   │                 │
│   │  (.dll/.exe) │    │  (.dll)      │    │  (.dll)      │                 │
│   └──────┬───────┘    └──────┬───────┘    └──────┬───────┘                 │
│          │                   │                   │                          │
│          └───────────────────┼───────────────────┘                          │
│                              │                                               │
│                              ▼                                               │
└─────────────────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           TRANSPILER                                         │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                         FRONTEND (Comum)                               │ │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐   │ │
│  │  │ IL Reader   │─▶│ Type        │─▶│ Generic     │─▶│ IL          │   │ │
│  │  │             │  │ Analyzer    │  │ Processor   │  │ Optimizer   │   │ │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘   │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                              │                                               │
│                              ▼                                               │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                      IR (Intermediate Representation)                  │ │
│  │                                                                        │ │
│  │   Representacao independente de arquitetura do programa compilado     │ │
│  │   - Control Flow Graph (CFG)                                          │ │
│  │   - SSA Form (Static Single Assignment)                               │ │
│  │   - Type Information                                                  │ │
│  │   - Metadata Tables                                                   │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                              │                                               │
│                              ▼                                               │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                    BACKEND (Especifico por Arquitetura)                │ │
│  │                                                                        │ │
│  │  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐     │ │
│  │  │  x86 Backend     │  │  s390 Backend    │  │  ARM Backend     │     │ │
│  │  │  ┌────────────┐  │  │  ┌────────────┐  │  │  ┌────────────┐  │     │ │
│  │  │  │ i386       │  │  │  │ z/Arch     │  │  │  │ ARMv7      │  │     │ │
│  │  │  │ i486       │  │  │  │            │  │  │  │ ARMv8      │  │     │ │
│  │  │  │ i586       │  │  │  └────────────┘  │  │  └────────────┘  │     │ │
│  │  │  │ i686       │  │  │                  │  │                  │     │ │
│  │  │  └────────────┘  │  │                  │  │                  │     │ │
│  │  └──────────────────┘  └──────────────────┘  └──────────────────┘     │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                              │                                               │
│                              ▼                                               │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                      OUTPUT GENERATOR                                  │ │
│  │                                                                        │ │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐   │ │
│  │  │ DOS .EXE    │  │ DOS .COM    │  │ ELF         │  │ Raw Binary  │   │ │
│  │  │ Generator   │  │ Generator   │  │ Generator   │  │ Generator   │   │ │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘   │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              SAIDA                                           │
│                                                                              │
│   ┌───────────────────────────────────────────────────────────────────┐     │
│   │                    EXECUTAVEL FINAL (.EXE/.COM)                   │     │
│   │                                                                   │     │
│   │  ┌─────────────────────────────────────────────────────────────┐ │     │
│   │  │  DOS EXE Header (se .EXE)                                   │ │     │
│   │  │  - Signature (MZ)                                           │ │     │
│   │  │  - Load info                                                │ │     │
│   │  └─────────────────────────────────────────────────────────────┘ │     │
│   │  ┌─────────────────────────────────────────────────────────────┐ │     │
│   │  │  Metadata Section                                           │ │     │
│   │  │  - TypeDef table (tipos definidos)                         │ │     │
│   │  │  - MethodDef table (metodos)                               │ │     │
│   │  │  - FieldDef table (campos)                                 │ │     │
│   │  │  - PropertyDef table (propriedades)                        │ │     │
│   │  │  - GenericInst table (instanciacoes de generics)           │ │     │
│   │  │  - String heap (nomes, strings literais)                   │ │     │
│   │  └─────────────────────────────────────────────────────────────┘ │     │
│   │  ┌─────────────────────────────────────────────────────────────┐ │     │
│   │  │  VTables Section                                            │ │     │
│   │  │  - Virtual method dispatch tables                          │ │     │
│   │  │  - Interface method tables                                 │ │     │
│   │  │  - Interface maps                                          │ │     │
│   │  └─────────────────────────────────────────────────────────────┘ │     │
│   │  ┌─────────────────────────────────────────────────────────────┐ │     │
│   │  │  Code Section                                               │ │     │
│   │  │  - Startup code                                            │ │     │
│   │  │  - User methods (assembly nativo)                          │ │     │
│   │  │  - BCL methods                                             │ │     │
│   │  └─────────────────────────────────────────────────────────────┘ │     │
│   │  ┌─────────────────────────────────────────────────────────────┐ │     │
│   │  │  Runtime Section                                            │ │     │
│   │  │  - Garbage Collector                                       │ │     │
│   │  │  - Reflection runtime                                      │ │     │
│   │  │  - JSON serializer                                         │ │     │
│   │  │  - Exception handling                                      │ │     │
│   │  │  - Soft-float (se necessario)                              │ │     │
│   │  └─────────────────────────────────────────────────────────────┘ │     │
│   │  ┌─────────────────────────────────────────────────────────────┐ │     │
│   │  │  Data Section                                               │ │     │
│   │  │  - String literals                                         │ │     │
│   │  │  - Float/double constants                                  │ │     │
│   │  │  - Static fields                                           │ │     │
│   │  │  - Global variables                                        │ │     │
│   │  └─────────────────────────────────────────────────────────────┘ │     │
│   │  ┌─────────────────────────────────────────────────────────────┐ │     │
│   │  │  BSS Section (Uninitialized)                                │ │     │
│   │  │  - Heap space                                              │ │     │
│   │  │  - Stack space                                             │ │     │
│   │  └─────────────────────────────────────────────────────────────┘ │     │
│   └───────────────────────────────────────────────────────────────────┘     │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 1.3 Fluxo de Compilacao Detalhado

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         FLUXO DE COMPILACAO                                  │
└─────────────────────────────────────────────────────────────────────────────┘

FASE 1: LEITURA E PARSING
─────────────────────────
    Input.dll
        │
        ▼
    ┌─────────────────────────────────────┐
    │         IL READER                   │
    │                                     │
    │  Usa: System.Reflection.Metadata    │
    │  (biblioteca nativa do .NET)        │
    │                                     │
    │  Extrai:                            │
    │  - Assembly metadata                │
    │  - Type definitions                 │
    │  - Method definitions + IL code     │
    │  - Field definitions                │
    │  - Property definitions             │
    │  - Custom attributes                │
    │  - Generic parameters               │
    │  - References (outras assemblies)   │
    └─────────────────────────────────────┘
        │
        ▼

FASE 2: ANALISE
───────────────
    ┌─────────────────────────────────────┐
    │       TYPE HIERARCHY BUILDER        │
    │                                     │
    │  - Resolve hierarquia de heranca    │
    │  - Detecta interfaces implementadas │
    │  - Calcula layouts de objetos       │
    │  - Determina slots de VTable        │
    │  - Valida consistencia de tipos     │
    └─────────────────────────────────────┘
        │
        ▼
    ┌─────────────────────────────────────┐
    │       GENERIC ANALYZER              │
    │                                     │
    │  - Encontra todas instanciacoes     │
    │    de tipos genericos usadas        │
    │  - List<int>, List<string>, etc     │
    │  - Dictionary<K,V> combinations     │
    │  - Prepara para monomorphization    │
    └─────────────────────────────────────┘
        │
        ▼
    ┌─────────────────────────────────────┐
    │       CALL GRAPH BUILDER            │
    │                                     │
    │  - Mapeia todas as chamadas         │
    │  - Identifica metodos virtuais      │
    │  - Identifica candidatos a inline   │
    │  - Detecta recursao                 │
    │  - Dead code elimination prep       │
    └─────────────────────────────────────┘
        │
        ▼

FASE 3: PROCESSAMENTO DE GENERICS (Monomorphization)
────────────────────────────────────────────────────
    ┌─────────────────────────────────────┐
    │      GENERIC INSTANTIATOR           │
    │                                     │
    │  Para cada uso de generic:          │
    │  - List<int> -> gera __List_int     │
    │  - List<string> -> __List_string    │
    │  - Metodos genericos idem           │
    │                                     │
    │  Otimizacao:                        │
    │  - Reference types compartilham     │
    │    implementacao (todos sao ptrs)   │
    │  - Value types: especializados      │
    └─────────────────────────────────────┘
        │
        ▼

FASE 4: CONSTRUCAO DE METADATA
──────────────────────────────
    ┌─────────────────────────────────────┐
    │       METADATA BUILDER              │
    │                                     │
    │  Constroi tabelas binarias:         │
    │  - TypeDefTable                     │
    │  - MethodDefTable                   │
    │  - FieldDefTable                    │
    │  - PropertyDefTable                 │
    │  - StringHeap                       │
    │                                     │
    │  Estas tabelas serao embarcadas     │
    │  no executavel para reflection      │
    └─────────────────────────────────────┘
        │
        ▼
    ┌─────────────────────────────────────┐
    │       VTABLE BUILDER                │
    │                                     │
    │  Para cada tipo com virtuais:       │
    │  - Herda slots do tipo base         │
    │  - Override substitui ponteiro      │
    │  - New virtual adiciona slot        │
    │  - Calcula offset de cada metodo    │
    └─────────────────────────────────────┘
        │
        ▼
    ┌─────────────────────────────────────┐
    │    INTERFACE MAP BUILDER            │
    │                                     │
    │  Para cada tipo que implementa      │
    │  interfaces:                        │
    │  - Lista de interfaces              │
    │  - Mapeamento interface->impl       │
    │  - Suporte a dispatch em runtime    │
    └─────────────────────────────────────┘
        │
        ▼

FASE 5: GERACAO DE IR
─────────────────────
    ┌─────────────────────────────────────┐
    │       IR GENERATOR                  │
    │                                     │
    │  Converte IL para IR interno:       │
    │  - Control Flow Graph (CFG)         │
    │  - Basic Blocks                     │
    │  - Instrucoes em formato SSA        │
    │  - Independente de arquitetura      │
    └─────────────────────────────────────┘
        │
        ▼

FASE 6: OTIMIZACAO (Opcional, -O1/-O2)
──────────────────────────────────────
    ┌─────────────────────────────────────┐
    │       OPTIMIZER                     │
    │                                     │
    │  - Constant folding                 │
    │  - Dead code elimination            │
    │  - Inlining de metodos pequenos     │
    │  - Devirtualization                 │
    │  - Loop optimizations               │
    │  - Strength reduction               │
    └─────────────────────────────────────┘
        │
        ▼

FASE 7: CODE GENERATION (Backend-Specific)
──────────────────────────────────────────
    ┌─────────────────────────────────────┐
    │       BACKEND SELECTOR              │
    │                                     │
    │  Seleciona backend baseado em:      │
    │  --arch=x86 --cpu=i386              │
    │  --arch=s390                        │
    │  --arch=arm                         │
    └─────────────────────────────────────┘
        │
        ▼
    ┌─────────────────────────────────────┐
    │    ARCHITECTURE-SPECIFIC CODEGEN    │
    │                                     │
    │  - Instruction selection            │
    │  - Register allocation              │
    │  - Calling convention               │
    │  - Stack frame layout               │
    │  - Platform ABI compliance          │
    └─────────────────────────────────────┘
        │
        ▼

FASE 8: RUNTIME GENERATION
──────────────────────────
    ┌─────────────────────────────────────┐
    │      RUNTIME GENERATOR              │
    │                                     │
    │  Gera codigo do runtime:            │
    │  - Startup (init CPU, FPU, heap)    │
    │  - Garbage Collector                │
    │  - Reflection helpers               │
    │  - JSON serializer                  │
    │  - String operations                │
    │  - Math functions                   │
    │  - Exception handling               │
    │  - Soft-float (se sem FPU)          │
    └─────────────────────────────────────┘
        │
        ▼

FASE 9: LINKING E OUTPUT
────────────────────────
    ┌─────────────────────────────────────┐
    │       LINKER                        │
    │                                     │
    │  - Resolve todos os simbolos        │
    │  - Calcula enderecos finais         │
    │  - Aplica relocations               │
    │  - Ordena secoes                    │
    └─────────────────────────────────────┘
        │
        ▼
    ┌─────────────────────────────────────┐
    │     EXECUTABLE GENERATOR            │
    │                                     │
    │  Gera formato final:                │
    │  - DOS MZ .EXE                      │
    │  - DOS .COM                         │
    │  - Raw binary                       │
    │  - Assembly source (.asm)           │
    └─────────────────────────────────────┘
        │
        ▼
    Output.exe / Output.com / Output.asm
```

---

## 1.4 Requisitos de Sistema

### 1.4.1 Para Executar o Compilador (Desenvolvimento)

| Requisito | Especificacao |
|-----------|---------------|
| Runtime | .NET 8.0 SDK ou superior |
| OS | Windows 10+, Linux, macOS |
| RAM | 4GB minimo, 8GB recomendado |
| Disco | 500MB para SDK + projeto |

### 1.4.2 Para Executar Programas Compilados (Target)

#### Target: x86 DOS

| CPU | FPU | Suportado | Notas |
|-----|-----|-----------|-------|
| 8086/8088 | 8087 | **NAO** | Muito limitado (16-bit, 64KB) |
| 80286 | 80287 | **NAO** | Ainda 16-bit em modo real |
| **80386** | 80387 (opcional) | **SIM** | Target minimo! |
| 80386 + 80387 | Integrado | **SIM** | Com FPU externa |
| 80486SX | Nenhuma | **SIM** | Usa soft-float |
| 80486DX | Integrada | **SIM** | FPU nativa |
| Pentium+ | Integrada | **SIM** | Sempre tem FPU |

**Requisitos minimos para DOS:**
- CPU: Intel 80386 ou compativel
- RAM: 2MB minimo (1MB convencional + 1MB extended)
- DOS: MS-DOS 5.0+, FreeDOS 1.0+, ou DOSBox

**Requisitos recomendados:**
- CPU: 80486DX ou Pentium
- RAM: 4MB ou mais
- DOS: FreeDOS 1.3 ou DOSBox 0.74+

### 1.4.3 Compatibilidade Testada

- DOSBox 0.74
- DOSBox-X
- DOSBox Staging
- FreeDOS 1.3
- MS-DOS 6.22
- PC real 386/486/Pentium

---

## 1.5 Estrutura do Projeto

```
MsilToDos/
│
├── MsilToDos.sln                           # Visual Studio Solution
│
├── src/
│   │
│   ├── Core/                               # Nucleo compartilhado
│   │   ├── Core.csproj
│   │   ├── IR/                             # Intermediate Representation
│   │   │   ├── IRInstruction.cs
│   │   │   ├── IROpCode.cs
│   │   │   ├── BasicBlock.cs
│   │   │   ├── ControlFlowGraph.cs
│   │   │   └── SSABuilder.cs
│   │   ├── Types/                          # Sistema de tipos
│   │   │   ├── TypeSystem.cs
│   │   │   ├── TypeDef.cs
│   │   │   ├── MethodDef.cs
│   │   │   ├── FieldDef.cs
│   │   │   └── GenericInst.cs
│   │   └── Metadata/                       # Tabelas de metadata
│   │       ├── MetadataBuilder.cs
│   │       ├── StringHeap.cs
│   │       ├── BlobHeap.cs
│   │       └── Tables/
│   │           ├── TypeDefTable.cs
│   │           ├── MethodDefTable.cs
│   │           ├── FieldDefTable.cs
│   │           └── PropertyDefTable.cs
│   │
│   ├── Frontend/                           # Frontend (comum a todos backends)
│   │   ├── Frontend.csproj
│   │   ├── IL/
│   │   │   ├── AssemblyReader.cs           # Le .NET assemblies
│   │   │   ├── MethodBodyReader.cs         # Decodifica IL
│   │   │   ├── ILInstruction.cs
│   │   │   └── ILOpCodes.cs
│   │   ├── Analysis/
│   │   │   ├── TypeHierarchyBuilder.cs
│   │   │   ├── CallGraphBuilder.cs
│   │   │   ├── GenericAnalyzer.cs
│   │   │   ├── EscapeAnalyzer.cs
│   │   │   └── FlowAnalyzer.cs
│   │   ├── Generics/
│   │   │   ├── GenericInstantiator.cs      # Monomorphization
│   │   │   ├── GenericContext.cs
│   │   │   └── TypeSubstitution.cs
│   │   └── Transforms/
│   │       ├── ILToIRTransformer.cs
│   │       ├── Inliner.cs
│   │       ├── Devirtualizer.cs
│   │       └── ConstantFolder.cs
│   │
│   ├── Backend.Abstractions/               # Interfaces para backends
│   │   ├── Backend.Abstractions.csproj
│   │   ├── IBackend.cs                     # Interface principal
│   │   ├── ICodeGenerator.cs
│   │   ├── IRegisterAllocator.cs
│   │   ├── IInstructionSelector.cs
│   │   ├── ICallingConvention.cs
│   │   ├── IOutputGenerator.cs
│   │   ├── ArchitectureInfo.cs
│   │   ├── CpuFeatures.cs
│   │   └── TargetDescription.cs
│   │
│   ├── Backend.x86/                        # Backend x86 (DOS)
│   │   ├── Backend.x86.csproj
│   │   ├── X86Backend.cs                   # Implementa IBackend
│   │   ├── CpuLevel/                       # Niveis de CPU
│   │   │   ├── ICpuLevel.cs
│   │   │   ├── I386Level.cs                # Base: i386
│   │   │   ├── I486Level.cs                # Adiciona BSWAP, CMPXCHG
│   │   │   ├── I586Level.cs                # Adiciona RDTSC, CPUID
│   │   │   └── I686Level.cs                # Adiciona CMOVcc, FCOMI
│   │   ├── CodeGen/
│   │   │   ├── X86CodeGenerator.cs
│   │   │   ├── X86InstructionSelector.cs
│   │   │   ├── X86RegisterAllocator.cs
│   │   │   ├── X86CallingConvention.cs
│   │   │   └── X86InstructionEmitter.cs
│   │   ├── FPU/
│   │   │   ├── FpuDetector.cs              # Deteccao de FPU runtime
│   │   │   ├── X87CodeGen.cs               # Codigo x87
│   │   │   └── SoftFloatCodeGen.cs         # IEEE 754 em software
│   │   ├── Runtime/
│   │   │   ├── X86RuntimeGenerator.cs
│   │   │   ├── StartupCode.cs
│   │   │   ├── GCRuntime.cs
│   │   │   ├── ReflectionRuntime.cs
│   │   │   ├── JsonRuntime.cs
│   │   │   ├── StringRuntime.cs
│   │   │   ├── MathRuntime.cs
│   │   │   ├── Int64Runtime.cs             # Ops 64-bit em 32-bit
│   │   │   └── SoftFloatRuntime.cs
│   │   ├── Output/
│   │   │   ├── DosExeGenerator.cs
│   │   │   ├── DosComGenerator.cs
│   │   │   └── AsmSourceGenerator.cs
│   │   └── Syntax/
│   │       ├── MasmSyntax.cs
│   │       ├── TasmSyntax.cs
│   │       ├── NasmSyntax.cs
│   │       └── FasmSyntax.cs
│   │
│   ├── Backend.s390/                       # Backend IBM s390 (exemplo)
│   │   ├── Backend.s390.csproj
│   │   ├── S390Backend.cs
│   │   ├── CodeGen/
│   │   │   ├── S390CodeGenerator.cs
│   │   │   └── S390InstructionSelector.cs
│   │   └── Runtime/
│   │       └── S390RuntimeGenerator.cs
│   │
│   ├── Compiler/                           # CLI principal
│   │   ├── Compiler.csproj
│   │   ├── Program.cs
│   │   ├── CompilerOptions.cs
│   │   ├── CompilerDriver.cs
│   │   └── DiagnosticReporter.cs
│   │
│   └── BCL/                                # Base Class Library
│       ├── BCL.csproj
│       ├── Attributes/
│       │   ├── AsmImplementationAttribute.cs
│       │   ├── AsmIntrinsicAttribute.cs
│       │   └── AsmLayoutAttribute.cs
│       ├── System/
│       │   ├── Object.cs
│       │   ├── String.cs
│       │   ├── Console.cs
│       │   ├── Math.cs
│       │   ├── Array.cs
│       │   ├── Type.cs
│       │   ├── Activator.cs
│       │   ├── Exception.cs
│       │   ├── GC.cs
│       │   ├── Environment.cs
│       │   ├── Convert.cs
│       │   ├── Buffer.cs
│       │   ├── BitConverter.cs
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
│       │   │   ├── Decimal.cs
│       │   │   ├── IntPtr.cs
│       │   │   ├── UIntPtr.cs
│       │   │   └── Nullable.cs
│       │   │
│       │   ├── Collections/
│       │   │   ├── IEnumerable.cs
│       │   │   ├── IEnumerator.cs
│       │   │   ├── ICollection.cs
│       │   │   ├── IList.cs
│       │   │   ├── IDictionary.cs
│       │   │   └── Generic/
│       │   │       ├── List.cs
│       │   │       ├── Dictionary.cs
│       │   │       ├── Stack.cs
│       │   │       ├── Queue.cs
│       │   │       ├── HashSet.cs
│       │   │       ├── LinkedList.cs
│       │   │       ├── KeyValuePair.cs
│       │   │       └── Comparer.cs
│       │   │
│       │   ├── IO/
│       │   │   ├── Stream.cs
│       │   │   ├── MemoryStream.cs
│       │   │   ├── FileStream.cs
│       │   │   ├── File.cs
│       │   │   ├── Directory.cs
│       │   │   ├── Path.cs
│       │   │   ├── TextReader.cs
│       │   │   ├── TextWriter.cs
│       │   │   ├── StreamReader.cs
│       │   │   ├── StreamWriter.cs
│       │   │   └── BinaryReader.cs
│       │   │
│       │   └── Reflection/
│       │       ├── MemberInfo.cs
│       │       ├── MethodInfo.cs
│       │       ├── PropertyInfo.cs
│       │       ├── FieldInfo.cs
│       │       ├── ConstructorInfo.cs
│       │       └── ParameterInfo.cs
│       │
│       ├── System.Text/
│       │   ├── StringBuilder.cs
│       │   ├── Encoding.cs
│       │   └── ASCIIEncoding.cs
│       │
│       ├── System.Text.Json/
│       │   ├── JsonSerializer.cs
│       │   ├── JsonSerializerOptions.cs
│       │   ├── JsonElement.cs
│       │   ├── JsonDocument.cs
│       │   └── JsonValueKind.cs
│       │
│       └── System.Linq/
│           └── Enumerable.cs               # Subset de LINQ
│
├── samples/
│   ├── HelloWorld/
│   ├── Fibonacci/
│   ├── FloatMath/
│   ├── Generics/
│   ├── Reflection/
│   ├── JsonDemo/
│   ├── FileIO/
│   └── GameOfLife/
│
├── tests/
│   ├── Frontend.Tests/
│   ├── Backend.x86.Tests/
│   ├── Integration.Tests/
│   └── Samples.Tests/
│
└── docs/
    ├── Architecture.md
    ├── BCL-Reference.md
    ├── IL-Mapping.md
    ├── Backend-Development.md
    └── Runtime-Internals.md
```

---

# PARTE 2: SISTEMA DE BACKENDS EXTENSIVEL

## 2.1 Arquitetura de Plugins de Backend

O compilador usa uma arquitetura de plugins que permite adicionar novos backends (arquiteturas) sem modificar o codigo do frontend.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      BACKEND PLUGIN ARCHITECTURE                             │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                           FRONTEND                                           │
│                                                                              │
│   Produz: IR (Intermediate Representation)                                  │
│   - Independente de arquitetura                                             │
│   - CFG + SSA form                                                          │
│   - Type information                                                        │
│   - Metadata tables                                                         │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ IBackend interface
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        BACKEND ABSTRACTION LAYER                             │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                         IBackend                                       │ │
│  │  - Name: string                                                        │ │
│  │  - SupportedCpuLevels: ICpuLevel[]                                    │ │
│  │  - CreateCodeGenerator(options): ICodeGenerator                       │ │
│  │  - CreateRuntimeGenerator(options): IRuntimeGenerator                 │ │
│  │  - CreateOutputGenerator(format): IOutputGenerator                    │ │
│  │  - GetArchitectureInfo(): ArchitectureInfo                           │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                      ICodeGenerator                                    │ │
│  │  - GenerateMethod(MethodDef, IR): NativeCode                         │ │
│  │  - GenerateVTable(TypeDef): VTableData                               │ │
│  │  - GenerateInterfaceMap(TypeDef): InterfaceMapData                   │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                      ICpuLevel                                         │ │
│  │  - Name: string (e.g., "i386", "i486", "i586")                        │ │
│  │  - Features: CpuFeatures flags                                        │ │
│  │  - IsInstructionSupported(opcode): bool                              │ │
│  │  - GetOptimalInstruction(operation): Instruction                     │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                   ArchitectureInfo                                     │ │
│  │  - PointerSize: int (4 for 32-bit, 8 for 64-bit)                     │ │
│  │  - Endianness: Little/Big                                             │ │
│  │  - RegisterCount: int                                                 │ │
│  │  - HasFPU: bool                                                       │ │
│  │  - StackGrowsDown: bool                                               │ │
│  │  - AlignmentRequirements: Dictionary<TypeKind, int>                  │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
          ┌─────────────────────────┼─────────────────────────┐
          │                         │                         │
          ▼                         ▼                         ▼
┌─────────────────────┐ ┌─────────────────────┐ ┌─────────────────────┐
│    X86Backend       │ │    S390Backend      │ │    ARMBackend       │
│                     │ │                     │ │                     │
│ ┌─────────────────┐ │ │ ┌─────────────────┐ │ │ ┌─────────────────┐ │
│ │ i386Level       │ │ │ │ zArchLevel      │ │ │ │ ARMv7Level      │ │
│ │ i486Level       │ │ │ └─────────────────┘ │ │ │ ARMv8Level      │ │
│ │ i586Level       │ │ │                     │ │ └─────────────────┘ │
│ │ i686Level       │ │ │                     │ │                     │
│ └─────────────────┘ │ │                     │ │                     │
│                     │ │                     │ │                     │
│ Output formats:     │ │ Output formats:     │ │ Output formats:     │
│ - DOS .EXE          │ │ - z/OS module       │ │ - ELF               │
│ - DOS .COM          │ │ - Raw binary        │ │ - Raw binary        │
│ - MASM/TASM/NASM    │ │                     │ │                     │
└─────────────────────┘ └─────────────────────┘ └─────────────────────┘
```

## 2.2 Interfaces do Backend

### 2.2.1 IBackend

```csharp
namespace MsilToDos.Backend.Abstractions
{
    /// <summary>
    /// Interface principal que todo backend deve implementar.
    /// Um backend representa uma arquitetura de CPU completa.
    /// </summary>
    public interface IBackend
    {
        /// <summary>
        /// Nome do backend (ex: "x86", "s390", "arm")
        /// </summary>
        string Name { get; }
        
        /// <summary>
        /// Descricao legivel
        /// </summary>
        string Description { get; }
        
        /// <summary>
        /// Niveis de CPU suportados (ex: i386, i486, i586 para x86)
        /// </summary>
        IReadOnlyList<ICpuLevel> SupportedCpuLevels { get; }
        
        /// <summary>
        /// Informacoes sobre a arquitetura
        /// </summary>
        ArchitectureInfo ArchitectureInfo { get; }
        
        /// <summary>
        /// Formatos de saida suportados (EXE, COM, ELF, etc)
        /// </summary>
        IReadOnlyList<OutputFormat> SupportedOutputFormats { get; }
        
        /// <summary>
        /// Cria o gerador de codigo para este backend
        /// </summary>
        ICodeGenerator CreateCodeGenerator(CodeGenOptions options);
        
        /// <summary>
        /// Cria o gerador de runtime para este backend
        /// </summary>
        IRuntimeGenerator CreateRuntimeGenerator(RuntimeOptions options);
        
        /// <summary>
        /// Cria o gerador de output para o formato especificado
        /// </summary>
        IOutputGenerator CreateOutputGenerator(OutputFormat format, OutputOptions options);
        
        /// <summary>
        /// Valida se as opcoes sao suportadas por este backend
        /// </summary>
        ValidationResult ValidateOptions(CompilerOptions options);
    }
}
```

### 2.2.2 ICpuLevel

```csharp
namespace MsilToDos.Backend.Abstractions
{
    /// <summary>
    /// Representa um nivel especifico de CPU dentro de uma arquitetura.
    /// Por exemplo, i386, i486, i586 sao niveis diferentes de x86.
    /// </summary>
    public interface ICpuLevel
    {
        /// <summary>
        /// Nome do nivel (ex: "i386", "i486", "i586")
        /// </summary>
        string Name { get; }
        
        /// <summary>
        /// Nivel pai (ex: i486 herda de i386). Null se for o nivel base.
        /// </summary>
        ICpuLevel? Parent { get; }
        
        /// <summary>
        /// Features disponiveis neste nivel
        /// </summary>
        CpuFeatures Features { get; }
        
        /// <summary>
        /// Verifica se uma instrucao especifica e suportada
        /// </summary>
        bool IsInstructionSupported(string instruction);
        
        /// <summary>
        /// Retorna a melhor instrucao para uma operacao.
        /// Por exemplo, para "count leading zeros":
        /// - i386: loop manual
        /// - i586+: BSR + XOR
        /// - Pentium Pro+: LZCNT (se disponivel)
        /// </summary>
        InstructionSequence GetOptimalSequence(Operation operation);
        
        /// <summary>
        /// Retorna o gerador especializado de codigo para este nivel
        /// </summary>
        ILevelSpecificCodeGen GetSpecializedCodeGen();
    }
    
    /// <summary>
    /// Features de CPU como flags
    /// </summary>
    [Flags]
    public enum CpuFeatures : ulong
    {
        None = 0,
        
        // x86 features
        X86_386 = 1 << 0,           // 32-bit registers
        X86_FPU = 1 << 1,           // x87 FPU
        X86_486 = 1 << 2,           // BSWAP, CMPXCHG, XADD
        X86_CPUID = 1 << 3,         // CPUID instruction
        X86_RDTSC = 1 << 4,         // RDTSC instruction
        X86_CMOVcc = 1 << 5,        // Conditional moves
        X86_FCOMI = 1 << 6,         // FPU compare to EFLAGS
        X86_MMX = 1 << 7,
        X86_SSE = 1 << 8,
        X86_SSE2 = 1 << 9,
        
        // s390 features
        S390_ZARCH = 1 << 32,       // z/Architecture
        S390_DFP = 1 << 33,         // Decimal floating point
        S390_HFP = 1 << 34,         // Hexadecimal floating point
        
        // ARM features
        ARM_V7 = 1 << 48,
        ARM_V8 = 1 << 49,
        ARM_NEON = 1 << 50,
        ARM_VFP = 1 << 51,
    }
}
```

### 2.2.3 ArchitectureInfo

```csharp
namespace MsilToDos.Backend.Abstractions
{
    /// <summary>
    /// Informacoes estaticas sobre uma arquitetura de CPU
    /// </summary>
    public class ArchitectureInfo
    {
        /// <summary>
        /// Tamanho de ponteiro em bytes (4 para 32-bit, 8 para 64-bit)
        /// </summary>
        public int PointerSize { get; init; }
        
        /// <summary>
        /// Endianness da arquitetura
        /// </summary>
        public Endianness Endianness { get; init; }
        
        /// <summary>
        /// Numero de registradores de proposito geral
        /// </summary>
        public int GeneralPurposeRegisterCount { get; init; }
        
        /// <summary>
        /// Numero de registradores de ponto flutuante
        /// </summary>
        public int FloatRegisterCount { get; init; }
        
        /// <summary>
        /// Se a pilha cresce para baixo (maioria das arquiteturas)
        /// </summary>
        public bool StackGrowsDown { get; init; } = true;
        
        /// <summary>
        /// Alinhamento natural de cada tipo de dado
        /// </summary>
        public IReadOnlyDictionary<PrimitiveType, int> TypeAlignment { get; init; }
        
        /// <summary>
        /// Tamanho de cada tipo primitivo nesta arquitetura
        /// </summary>
        public IReadOnlyDictionary<PrimitiveType, int> TypeSize { get; init; }
        
        /// <summary>
        /// Registradores disponiveis
        /// </summary>
        public IReadOnlyList<RegisterInfo> Registers { get; init; }
        
        /// <summary>
        /// Calling conventions suportadas
        /// </summary>
        public IReadOnlyList<CallingConventionInfo> CallingConventions { get; init; }
    }
    
    public enum Endianness { Little, Big }
    
    public enum PrimitiveType
    {
        Int8, UInt8, Int16, UInt16, Int32, UInt32, Int64, UInt64,
        Float32, Float64, Pointer, NativeInt
    }
}
```

## 2.3 Implementacao do Backend x86

### 2.3.1 X86Backend.cs

```csharp
namespace MsilToDos.Backend.x86
{
    public class X86Backend : IBackend
    {
        public string Name => "x86";
        public string Description => "Intel x86 (32-bit) for DOS";
        
        private readonly List<ICpuLevel> _cpuLevels;
        
        public X86Backend()
        {
            // Hierarquia de niveis de CPU
            var i386 = new I386Level();
            var i486 = new I486Level(i386);
            var i586 = new I586Level(i486);
            var i686 = new I686Level(i586);
            
            _cpuLevels = new List<ICpuLevel> { i386, i486, i586, i686 };
        }
        
        public IReadOnlyList<ICpuLevel> SupportedCpuLevels => _cpuLevels;
        
        public ArchitectureInfo ArchitectureInfo => new()
        {
            PointerSize = 4,
            Endianness = Endianness.Little,
            GeneralPurposeRegisterCount = 8, // EAX, EBX, ECX, EDX, ESI, EDI, EBP, ESP
            FloatRegisterCount = 8, // ST(0)-ST(7)
            StackGrowsDown = true,
            TypeSize = new Dictionary<PrimitiveType, int>
            {
                [PrimitiveType.Int8] = 1,
                [PrimitiveType.UInt8] = 1,
                [PrimitiveType.Int16] = 2,
                [PrimitiveType.UInt16] = 2,
                [PrimitiveType.Int32] = 4,
                [PrimitiveType.UInt32] = 4,
                [PrimitiveType.Int64] = 8,
                [PrimitiveType.UInt64] = 8,
                [PrimitiveType.Float32] = 4,
                [PrimitiveType.Float64] = 8,
                [PrimitiveType.Pointer] = 4,
                [PrimitiveType.NativeInt] = 4,
            },
            TypeAlignment = new Dictionary<PrimitiveType, int>
            {
                [PrimitiveType.Int8] = 1,
                [PrimitiveType.Int16] = 2,
                [PrimitiveType.Int32] = 4,
                [PrimitiveType.Int64] = 4, // 4-byte aligned on 32-bit
                [PrimitiveType.Float32] = 4,
                [PrimitiveType.Float64] = 4,
                [PrimitiveType.Pointer] = 4,
            },
            Registers = X86Registers.All,
            CallingConventions = new[]
            {
                CallingConventionInfo.Cdecl,
                CallingConventionInfo.Stdcall,
                CallingConventionInfo.Fastcall,
            },
        };
        
        public IReadOnlyList<OutputFormat> SupportedOutputFormats => new[]
        {
            OutputFormat.DosExe,
            OutputFormat.DosCom,
            OutputFormat.AsmMasm,
            OutputFormat.AsmTasm,
            OutputFormat.AsmNasm,
            OutputFormat.AsmFasm,
            OutputFormat.RawBinary,
        };
        
        public ICodeGenerator CreateCodeGenerator(CodeGenOptions options)
        {
            var cpuLevel = GetCpuLevel(options.CpuLevel);
            return new X86CodeGenerator(cpuLevel, options);
        }
        
        public IRuntimeGenerator CreateRuntimeGenerator(RuntimeOptions options)
        {
            return new X86RuntimeGenerator(options);
        }
        
        public IOutputGenerator CreateOutputGenerator(OutputFormat format, OutputOptions options)
        {
            return format switch
            {
                OutputFormat.DosExe => new DosExeGenerator(options),
                OutputFormat.DosCom => new DosComGenerator(options),
                OutputFormat.AsmMasm => new AsmSourceGenerator(new MasmSyntax(), options),
                OutputFormat.AsmTasm => new AsmSourceGenerator(new TasmSyntax(), options),
                OutputFormat.AsmNasm => new AsmSourceGenerator(new NasmSyntax(), options),
                OutputFormat.AsmFasm => new AsmSourceGenerator(new FasmSyntax(), options),
                _ => throw new NotSupportedException($"Format {format} not supported")
            };
        }
        
        private ICpuLevel GetCpuLevel(string name)
        {
            return _cpuLevels.FirstOrDefault(l => l.Name.Equals(name, StringComparison.OrdinalIgnoreCase))
                ?? throw new ArgumentException($"Unknown CPU level: {name}");
        }
    }
}
```

### 2.3.2 Niveis de CPU (i386, i486, i586, i686)

```csharp
namespace MsilToDos.Backend.x86.CpuLevel
{
    /// <summary>
    /// Nivel base: Intel 80386
    /// Target minimo do compilador
    /// </summary>
    public class I386Level : ICpuLevel
    {
        public string Name => "i386";
        public ICpuLevel? Parent => null;
        
        public CpuFeatures Features => CpuFeatures.X86_386;
        
        // Instrucoes NAO disponiveis no i386 (adicionadas em CPUs posteriores)
        private static readonly HashSet<string> _unavailableInstructions = new(StringComparer.OrdinalIgnoreCase)
        {
            // i486+
            "BSWAP", "CMPXCHG", "XADD", "INVD", "INVLPG", "WBINVD",
            // i586+
            "CPUID", "RDTSC", "RDMSR", "WRMSR", "RSM", "CMPXCHG8B",
            // i686+
            "CMOVA", "CMOVAE", "CMOVB", "CMOVBE", "CMOVC", "CMOVE", "CMOVG",
            "CMOVGE", "CMOVL", "CMOVLE", "CMOVNA", "CMOVNAE", "CMOVNB",
            "CMOVNBE", "CMOVNC", "CMOVNE", "CMOVNG", "CMOVNGE", "CMOVNL",
            "CMOVNLE", "CMOVNO", "CMOVNP", "CMOVNS", "CMOVNZ", "CMOVO",
            "CMOVP", "CMOVPE", "CMOVPO", "CMOVS", "CMOVZ",
            "FCOMI", "FCOMIP", "FUCOMI", "FUCOMIP",
            "RDPMC", "UD2", "SYSENTER", "SYSEXIT",
        };
        
        public bool IsInstructionSupported(string instruction)
        {
            return !_unavailableInstructions.Contains(instruction);
        }
        
        public InstructionSequence GetOptimalSequence(Operation operation)
        {
            return operation switch
            {
                // Byte swap em i386: manual
                Operation.ByteSwap32 => new InstructionSequence(
                    "BSWAP_MANUAL",
                    // ROL EAX, 16; XCHG AL, AH; ROL EAX, 16; XCHG AL, AH
                    new[]
                    {
                        "ROL EAX, 16",
                        "XCHG AL, AH",
                        "ROL EAX, 16",
                        "XCHG AL, AH"
                    },
                    cycles: 4
                ),
                
                // Comparar e trocar: manual com loop
                Operation.CompareExchange => new InstructionSequence(
                    "CMPXCHG_MANUAL",
                    new[]
                    {
                        "CMP EAX, [EDI]",
                        "JNE .no_exchange",
                        "MOV [EDI], ECX",
                        ".no_exchange:"
                    },
                    cycles: 4
                ),
                
                _ => InstructionSequence.Default
            };
        }
        
        public ILevelSpecificCodeGen GetSpecializedCodeGen()
        {
            return new I386SpecificCodeGen();
        }
    }
    
    /// <summary>
    /// Intel 80486
    /// Adiciona: BSWAP, CMPXCHG, XADD
    /// FPU pode estar integrada (486DX) ou ausente (486SX)
    /// </summary>
    public class I486Level : ICpuLevel
    {
        public string Name => "i486";
        public ICpuLevel? Parent { get; }
        
        public CpuFeatures Features => CpuFeatures.X86_386 | CpuFeatures.X86_486;
        
        public I486Level(ICpuLevel parent)
        {
            Parent = parent;
        }
        
        private static readonly HashSet<string> _newInstructions = new(StringComparer.OrdinalIgnoreCase)
        {
            "BSWAP", "CMPXCHG", "XADD", "INVD", "INVLPG", "WBINVD"
        };
        
        private static readonly HashSet<string> _unavailableInstructions = new(StringComparer.OrdinalIgnoreCase)
        {
            // i586+
            "CPUID", "RDTSC", "RDMSR", "WRMSR", "RSM", "CMPXCHG8B",
            // i686+
            "CMOVA", "CMOVAE", /* ... etc ... */
        };
        
        public bool IsInstructionSupported(string instruction)
        {
            if (_newInstructions.Contains(instruction)) return true;
            if (_unavailableInstructions.Contains(instruction)) return false;
            return Parent?.IsInstructionSupported(instruction) ?? true;
        }
        
        public InstructionSequence GetOptimalSequence(Operation operation)
        {
            return operation switch
            {
                // BSWAP agora e nativo!
                Operation.ByteSwap32 => new InstructionSequence(
                    "BSWAP",
                    new[] { "BSWAP EAX" },
                    cycles: 1
                ),
                
                // CMPXCHG agora e nativo!
                Operation.CompareExchange => new InstructionSequence(
                    "CMPXCHG",
                    new[] { "CMPXCHG [EDI], ECX" },
                    cycles: 1
                ),
                
                // XADD agora e nativo!
                Operation.ExchangeAdd => new InstructionSequence(
                    "XADD",
                    new[] { "XADD [EDI], EAX" },
                    cycles: 1
                ),
                
                // Para outras operacoes, delegar ao pai
                _ => Parent?.GetOptimalSequence(operation) ?? InstructionSequence.Default
            };
        }
        
        public ILevelSpecificCodeGen GetSpecializedCodeGen()
        {
            return new I486SpecificCodeGen(Parent?.GetSpecializedCodeGen());
        }
    }
    
    /// <summary>
    /// Intel Pentium (i586)
    /// Adiciona: CPUID, RDTSC, CMPXCHG8B
    /// FPU sempre integrada
    /// </summary>
    public class I586Level : ICpuLevel
    {
        public string Name => "i586";
        public ICpuLevel? Parent { get; }
        
        public CpuFeatures Features => 
            CpuFeatures.X86_386 | CpuFeatures.X86_486 | 
            CpuFeatures.X86_CPUID | CpuFeatures.X86_RDTSC | CpuFeatures.X86_FPU;
        
        public I586Level(ICpuLevel parent)
        {
            Parent = parent;
        }
        
        private static readonly HashSet<string> _newInstructions = new(StringComparer.OrdinalIgnoreCase)
        {
            "CPUID", "RDTSC", "RDMSR", "WRMSR", "RSM", "CMPXCHG8B"
        };
        
        public bool IsInstructionSupported(string instruction)
        {
            if (_newInstructions.Contains(instruction)) return true;
            return Parent?.IsInstructionSupported(instruction) ?? true;
        }
        
        public InstructionSequence GetOptimalSequence(Operation operation)
        {
            return operation switch
            {
                // RDTSC para timing
                Operation.ReadTimestamp => new InstructionSequence(
                    "RDTSC",
                    new[] { "RDTSC" }, // Result in EDX:EAX
                    cycles: 1
                ),
                
                // CMPXCHG8B para atomics 64-bit
                Operation.CompareExchange64 => new InstructionSequence(
                    "CMPXCHG8B",
                    new[] { "CMPXCHG8B [EDI]" },
                    cycles: 1
                ),
                
                _ => Parent?.GetOptimalSequence(operation) ?? InstructionSequence.Default
            };
        }
        
        public ILevelSpecificCodeGen GetSpecializedCodeGen()
        {
            return new I586SpecificCodeGen(Parent?.GetSpecializedCodeGen());
        }
    }
    
    /// <summary>
    /// Intel Pentium Pro e superior (i686)
    /// Adiciona: CMOVcc (conditional move), FCOMI
    /// </summary>
    public class I686Level : ICpuLevel
    {
        public string Name => "i686";
        public ICpuLevel? Parent { get; }
        
        public CpuFeatures Features => 
            CpuFeatures.X86_386 | CpuFeatures.X86_486 | 
            CpuFeatures.X86_CPUID | CpuFeatures.X86_RDTSC | CpuFeatures.X86_FPU |
            CpuFeatures.X86_CMOVcc | CpuFeatures.X86_FCOMI;
        
        public I686Level(ICpuLevel parent)
        {
            Parent = parent;
        }
        
        private static readonly HashSet<string> _newInstructions = new(StringComparer.OrdinalIgnoreCase)
        {
            "CMOVA", "CMOVAE", "CMOVB", "CMOVBE", "CMOVC", "CMOVE", "CMOVG",
            "CMOVGE", "CMOVL", "CMOVLE", "CMOVNA", "CMOVNAE", "CMOVNB",
            "CMOVNBE", "CMOVNC", "CMOVNE", "CMOVNG", "CMOVNGE", "CMOVNL",
            "CMOVNLE", "CMOVNO", "CMOVNP", "CMOVNS", "CMOVNZ", "CMOVO",
            "CMOVP", "CMOVPE", "CMOVPO", "CMOVS", "CMOVZ",
            "FCOMI", "FCOMIP", "FUCOMI", "FUCOMIP",
        };
        
        public bool IsInstructionSupported(string instruction)
        {
            if (_newInstructions.Contains(instruction)) return true;
            return Parent?.IsInstructionSupported(instruction) ?? true;
        }
        
        public InstructionSequence GetOptimalSequence(Operation operation)
        {
            return operation switch
            {
                // Min/Max com CMOVcc (sem branch!)
                Operation.Min32 => new InstructionSequence(
                    "MIN_CMOV",
                    new[]
                    {
                        "CMP EAX, EBX",
                        "CMOVG EAX, EBX"  // if EAX > EBX, EAX = EBX
                    },
                    cycles: 2
                ),
                
                Operation.Max32 => new InstructionSequence(
                    "MAX_CMOV",
                    new[]
                    {
                        "CMP EAX, EBX",
                        "CMOVL EAX, EBX"  // if EAX < EBX, EAX = EBX
                    },
                    cycles: 2
                ),
                
                // Abs com CMOVcc
                Operation.Abs32 => new InstructionSequence(
                    "ABS_CMOV",
                    new[]
                    {
                        "MOV EBX, EAX",
                        "NEG EBX",
                        "CMOVS EAX, EBX"  // if result was negative, use negated
                    },
                    cycles: 3
                ),
                
                // Float compare direto para EFLAGS (sem FNSTSW)
                Operation.FloatCompare => new InstructionSequence(
                    "FCOMI",
                    new[] { "FCOMI ST, ST(1)" },
                    cycles: 1
                ),
                
                _ => Parent?.GetOptimalSequence(operation) ?? InstructionSequence.Default
            };
        }
        
        public ILevelSpecificCodeGen GetSpecializedCodeGen()
        {
            return new I686SpecificCodeGen(Parent?.GetSpecializedCodeGen());
        }
    }
}
```

---

Agora vou continuar com a Parte 2 da documentacao sobre Generics e GC:

