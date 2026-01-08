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
# PARTE 4: GARBAGE COLLECTOR (Continuacao)

## 4.2 Estrutura de Objetos no Heap (Continuacao)

```
Exemplo: String "Hello" (11 bytes de dados)

┌────────────────────────────────────────────────┐
│  +0: 00 00 00 1C  │ Size = 28 bytes            │
│  +4: 00 01        │ TypeIndex = 1 (String)     │
│  +6: 00           │ Flags = 0 (not marked)     │
│  +7: 00           │ Reserved                   │
├────────────────────────────────────────────────┤
│  +8: xx xx xx xx  │ VTable ptr (nao usado)     │
│  +12: 00 00 00 05 │ Length = 5                 │
│  +16: 48 65 6C 6C │ 'H' 'e' 'l' 'l'           │
│  +20: 6F 00 00 00 │ 'o' + padding              │
└────────────────────────────────────────────────┘

Exemplo: Instancia de classe Person

class Person {
    public string Name;  // +12 (ref)
    public int Age;      // +16 (value)
    public bool Active;  // +20 (value)
}

┌────────────────────────────────────────────────┐
│  +0: 00 00 00 18  │ Size = 24 bytes            │
│  +4: 00 05        │ TypeIndex = 5 (Person)     │
│  +6: 00           │ Flags                      │
│  +7: 00           │ Reserved                   │
├────────────────────────────────────────────────┤
│  +8: xx xx xx xx  │ VTable ptr → __vtbl_Person │
│  +12: xx xx xx xx │ Name (ponteiro p/ String)  │
│  +16: 00 00 00 1E │ Age = 30                   │
│  +20: 01 00 00 00 │ Active = true              │
└────────────────────────────────────────────────┘
```

## 4.3 Algoritmo Mark-and-Sweep

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    MARK-AND-SWEEP ALGORITHM                                  │
└─────────────────────────────────────────────────────────────────────────────┘

O GC executa em 4 fases:

FASE 1: CLEAR MARKS
───────────────────
    Percorre todo o heap zerando o bit "marked" de cada objeto.
    
    __gc_heap_start
    ┌─────────┬─────────┬─────────┬─────────┬─────────┐
    │ Obj A   │ Obj B   │ Obj C   │ Obj D   │ Obj E   │
    │ mark=0  │ mark=0  │ mark=0  │ mark=0  │ mark=0  │
    └─────────┴─────────┴─────────┴─────────┴─────────┘
    
    
FASE 2: MARK ROOTS
──────────────────
    Identifica todos os "roots" - ponteiros que ainda estao em uso:
    
    ┌─────────────────────────────────────────────────────────────────────┐
    │                           ROOTS                                      │
    │                                                                      │
    │  ┌──────────────┐   ┌──────────────┐   ┌──────────────┐            │
    │  │  STACK       │   │  STATIC      │   │  CPU         │            │
    │  │              │   │  FIELDS      │   │  REGISTERS   │            │
    │  │  Variaveis   │   │              │   │              │            │
    │  │  locais e    │   │  Campos      │   │  EAX, EBX,   │            │
    │  │  parametros  │   │  estaticos   │   │  etc (pode   │            │
    │  │  na pilha    │   │  de classes  │   │  ter refs)   │            │
    │  │              │   │              │   │              │            │
    │  └──────┬───────┘   └──────┬───────┘   └──────┬───────┘            │
    │         │                  │                  │                     │
    │         └──────────────────┼──────────────────┘                     │
    │                            │                                         │
    │                            ▼                                         │
    │              Para cada ponteiro encontrado:                         │
    │              - Verificar se aponta para o heap                      │
    │              - Se sim, marcar o objeto                              │
    └─────────────────────────────────────────────────────────────────────┘
    
    Apos marcar roots:
    
    __gc_heap_start
    ┌─────────┬─────────┬─────────┬─────────┬─────────┐
    │ Obj A   │ Obj B   │ Obj C   │ Obj D   │ Obj E   │
    │ mark=1  │ mark=0  │ mark=1  │ mark=0  │ mark=1  │
    └─────────┴─────────┴─────────┴─────────┴─────────┘
        ↑                   ↑                   ↑
        │                   │                   │
    Stack tem          Static tem          Stack tem
    ptr para A         ptr para C          ptr para E


FASE 3: MARK TRANSITIVE (Trace)
───────────────────────────────
    Para cada objeto marcado, marca recursivamente os objetos referenciados.
    
    Obj A tem campo que aponta para Obj B:
    ┌─────────┐
    │ Obj A   │──────────────────────────────────────┐
    │ mark=1  │                                      │
    └─────────┘                                      ▼
                                              ┌─────────┐
                                              │ Obj B   │
                                              │ mark=0→1│
                                              └─────────┘
    
    Resultado apos trace:
    
    ┌─────────┬─────────┬─────────┬─────────┬─────────┐
    │ Obj A   │ Obj B   │ Obj C   │ Obj D   │ Obj E   │
    │ mark=1  │ mark=1  │ mark=1  │ mark=0  │ mark=1  │
    └─────────┴─────────┴─────────┴─────────┴─────────┘
                                      ↑
                                      │
                                  GARBAGE!
                                  (nao alcancavel)


FASE 4: SWEEP AND COMPACT
─────────────────────────
    Remove objetos nao marcados e compacta o heap.
    
    Antes:
    ┌─────────┬─────────┬─────────┬─────────┬─────────┬────────────┐
    │ Obj A   │ Obj B   │ Obj C   │ Obj D   │ Obj E   │   FREE     │
    │ mark=1  │ mark=1  │ mark=1  │ mark=0  │ mark=1  │            │
    │ 24 bytes│ 16 bytes│ 32 bytes│ 20 bytes│ 28 bytes│            │
    └─────────┴─────────┴─────────┴─────────┴─────────┴────────────┘
    
    Depois (compactado):
    ┌─────────┬─────────┬─────────┬─────────┬────────────────────────┐
    │ Obj A   │ Obj B   │ Obj C   │ Obj E   │        FREE            │
    │ 24 bytes│ 16 bytes│ 32 bytes│ 28 bytes│    (20 bytes mais!)    │
    └─────────┴─────────┴─────────┴─────────┴────────────────────────┘
                                             ↑
                                     __gc_free_ptr
    
    Obj D foi removido, memoria recuperada!
```

## 4.4 Implementacao do GC em Assembly

```asm
; ============================================================
; GARBAGE COLLECTOR - Implementacao completa
; ============================================================

.DATA
    __gc_heap_start     DD 0        ; Inicio do heap
    __gc_heap_end       DD 0        ; Fim do heap
    __gc_free_ptr       DD 0        ; Proximo espaco livre
    __gc_stack_bottom   DD 0        ; Base da stack (para scan)
    __gc_collections    DD 0        ; Contador de coletas
    __gc_bytes_freed    DD 0        ; Bytes liberados na ultima coleta
    
    ; Tabela de roots estaticos (preenchida pelo compilador)
    __gc_static_roots_count DD 0
    __gc_static_roots       DD 256 DUP(0)

.CODE

; ============================================================
; __gc_init
; Inicializa o Garbage Collector
; 
; Input: EAX = tamanho do heap desejado
; Output: EAX = 1 se sucesso, 0 se falha
; ============================================================
__gc_init PROC
    PUSH EBX
    PUSH ECX
    
    ; Guardar tamanho desejado
    MOV ECX, EAX
    
    ; Em Flat Real Mode, podemos usar memoria acima de 1MB
    ; Verificar se Flat Real Mode esta ativo
    CALL __rt_is_flat_real_mode
    TEST EAX, EAX
    JZ .conventional_only
    
    ; Usar memoria estendida (acima de 1MB)
    MOV EAX, 100000h            ; 1MB
    JMP .setup_heap
    
.conventional_only:
    ; Fallback: usar memoria convencional
    ; Alocar apos o programa
    MOV EAX, OFFSET __program_end
    ADD EAX, 0Fh
    AND EAX, 0FFFFFFF0h         ; Alinhar 16 bytes
    
.setup_heap:
    MOV [__gc_heap_start], EAX
    MOV [__gc_free_ptr], EAX
    
    ; Calcular fim do heap
    ADD EAX, ECX
    MOV [__gc_heap_end], EAX
    
    ; Zerar estatisticas
    MOV DWORD PTR [__gc_collections], 0
    MOV DWORD PTR [__gc_bytes_freed], 0
    
    ; Salvar base da stack
    MOV [__gc_stack_bottom], ESP
    
    MOV EAX, 1                  ; Sucesso
    
    POP ECX
    POP EBX
    RET
__gc_init ENDP

; ============================================================
; __gc_alloc
; Aloca memoria no heap gerenciado
;
; Input: EAX = tamanho em bytes (sem header)
; Output: EAX = ponteiro para dados (apos header), ou 0 se OOM
; ============================================================
__gc_alloc PROC
    PUSH EBX
    PUSH ECX
    PUSH EDX
    
    ; Adicionar header (8 bytes)
    ADD EAX, 8
    
    ; Alinhar para 4 bytes
    ADD EAX, 3
    AND EAX, 0FFFFFFFCh
    
    MOV ECX, EAX                ; ECX = tamanho total
    
.try_alloc:
    ; Verificar se cabe
    MOV EBX, [__gc_free_ptr]
    MOV EAX, EBX
    ADD EAX, ECX
    
    CMP EAX, [__gc_heap_end]
    JBE .do_alloc
    
    ; Nao cabe - tentar GC
    PUSH ECX
    CALL __gc_collect
    POP ECX
    
    ; Tentar novamente
    MOV EBX, [__gc_free_ptr]
    MOV EAX, EBX
    ADD EAX, ECX
    
    CMP EAX, [__gc_heap_end]
    JBE .do_alloc
    
    ; Ainda nao cabe - Out of Memory!
    XOR EAX, EAX
    JMP .done
    
.do_alloc:
    ; Inicializar header
    MOV [EBX], ECX              ; +0: Size
    MOV WORD PTR [EBX+4], 0     ; +4: TypeIndex (sera setado depois)
    MOV WORD PTR [EBX+6], 0     ; +6: Flags = 0, Reserved = 0
    
    ; Avancar free pointer
    ADD [__gc_free_ptr], ECX
    
    ; Retornar ponteiro para dados (apos header)
    LEA EAX, [EBX+8]
    
.done:
    POP EDX
    POP ECX
    POP EBX
    RET
__gc_alloc ENDP

; ============================================================
; __gc_alloc_typed
; Aloca memoria com informacao de tipo
;
; Input: EAX = tamanho, EBX = type index
; Output: EAX = ponteiro para dados
; ============================================================
__gc_alloc_typed PROC
    PUSH EBX
    CALL __gc_alloc
    TEST EAX, EAX
    JZ .done
    
    ; Setar type index no header
    MOV EBX, [ESP]
    MOV [EAX-4], BX             ; TypeIndex em offset -4 do data
    
.done:
    POP EBX
    RET
__gc_alloc_typed ENDP

; ============================================================
; __gc_collect
; Executa coleta de lixo
;
; Output: EAX = bytes liberados
; ============================================================
__gc_collect PROC
    PUSHAD
    
    ; Incrementar contador
    INC DWORD PTR [__gc_collections]
    
    ; Salvar free_ptr para calcular bytes liberados
    MOV EAX, [__gc_free_ptr]
    PUSH EAX
    
    ; ==========================================
    ; FASE 1: Clear all marks
    ; ==========================================
    MOV ESI, [__gc_heap_start]
    
.clear_loop:
    CMP ESI, [__gc_free_ptr]
    JAE .clear_done
    
    ; Limpar bit de mark (bit 0 do byte flags)
    AND BYTE PTR [ESI+6], 0FEh
    
    ; Proximo objeto
    ADD ESI, [ESI]              ; ESI += size
    JMP .clear_loop
    
.clear_done:

    ; ==========================================
    ; FASE 2: Mark from roots
    ; ==========================================
    
    ; 2a: Scan stack
    MOV ESI, ESP
    ADD ESI, 32                 ; Pular registradores salvos
    
.scan_stack:
    CMP ESI, [__gc_stack_bottom]
    JAE .scan_statics
    
    ; Cada DWORD na stack pode ser um ponteiro
    MOV EAX, [ESI]
    CALL __gc_try_mark
    
    ADD ESI, 4
    JMP .scan_stack
    
.scan_statics:
    ; 2b: Scan static roots
    MOV ESI, OFFSET __gc_static_roots
    MOV ECX, [__gc_static_roots_count]
    
.scan_static_loop:
    JECXZ .mark_transitive
    
    ; Cada root e um ponteiro para um ponteiro
    MOV EAX, [ESI]              ; Endereco do campo estatico
    MOV EAX, [EAX]              ; Valor do campo (ponteiro)
    CALL __gc_try_mark
    
    ADD ESI, 4
    DEC ECX
    JMP .scan_static_loop
    
.mark_transitive:
    ; ==========================================
    ; FASE 3: Mark transitive (trace)
    ; ==========================================
    ; Repetir ate nenhum novo objeto ser marcado
    
    XOR EDI, EDI                ; EDI = flag "marcou algo novo"
    
    MOV ESI, [__gc_heap_start]
    
.trace_loop:
    CMP ESI, [__gc_free_ptr]
    JAE .trace_check
    
    ; Este objeto esta marcado?
    TEST BYTE PTR [ESI+6], 1
    JZ .trace_next
    
    ; Sim - marcar seus filhos
    ; Precisa saber quais campos sao referencias
    ; Usar TypeIndex para buscar info do tipo
    
    MOVZX EBX, WORD PTR [ESI+4] ; TypeIndex
    CALL __gc_mark_fields
    ; EAX = 1 se marcou algo novo
    OR EDI, EAX
    
.trace_next:
    ADD ESI, [ESI]
    JMP .trace_loop
    
.trace_check:
    ; Se marcou algo novo, repetir
    TEST EDI, EDI
    JNZ .mark_transitive
    
    ; ==========================================
    ; FASE 4: Sweep and compact
    ; ==========================================
    MOV ESI, [__gc_heap_start]  ; Source
    MOV EDI, ESI                 ; Destination
    
.sweep_loop:
    CMP ESI, [__gc_free_ptr]
    JAE .sweep_done
    
    ; Este objeto esta marcado?
    TEST BYTE PTR [ESI+6], 1
    JZ .sweep_skip              ; Nao - pular (garbage)
    
    ; Sim - manter objeto
    CMP ESI, EDI
    JE .sweep_no_move
    
    ; Mover objeto para nova posicao
    MOV ECX, [ESI]              ; Size
    PUSH ESI
    PUSH EDI
    
    ; TODO: Atualizar ponteiros que apontam para este objeto
    ; (Requer mais infraestrutura para tracking)
    
    REP MOVSB
    
    POP EDI
    POP ESI
    
    ADD EDI, [ESI]
    JMP .sweep_next
    
.sweep_no_move:
    ADD EDI, [ESI]
    JMP .sweep_next
    
.sweep_skip:
    ; Objeto e garbage - nao copiar
    
.sweep_next:
    ADD ESI, [ESI]
    JMP .sweep_loop
    
.sweep_done:
    ; Atualizar free pointer
    MOV [__gc_free_ptr], EDI
    
    ; Calcular bytes liberados
    POP EAX                     ; free_ptr antigo
    SUB EAX, EDI
    MOV [__gc_bytes_freed], EAX
    
    POPAD
    MOV EAX, [__gc_bytes_freed]
    RET
__gc_collect ENDP

; ============================================================
; __gc_try_mark
; Tenta marcar um possivel ponteiro
;
; Input: EAX = possivel ponteiro
; Output: EAX = 1 se marcou, 0 caso contrario
; ============================================================
__gc_try_mark PROC
    PUSH EBX
    
    ; Verificar se esta no range do heap
    CMP EAX, [__gc_heap_start]
    JB .not_pointer
    CMP EAX, [__gc_free_ptr]
    JAE .not_pointer
    
    ; Apontar para o header (dados - 8)
    SUB EAX, 8
    
    ; Verificar se e um inicio de objeto valido
    ; (simplificado - em producao, manter bitmap de objetos)
    
    ; Ja esta marcado?
    TEST BYTE PTR [EAX+6], 1
    JNZ .already_marked
    
    ; Marcar!
    OR BYTE PTR [EAX+6], 1
    
    MOV EAX, 1                  ; Marcou
    JMP .done
    
.already_marked:
.not_pointer:
    XOR EAX, EAX                ; Nao marcou
    
.done:
    POP EBX
    RET
__gc_try_mark ENDP

; ============================================================
; __gc_mark_fields
; Marca campos de referencia de um objeto
;
; Input: ESI = ponteiro para header do objeto
;        EBX = type index
; Output: EAX = 1 se marcou algo novo
; ============================================================
__gc_mark_fields PROC
    PUSH ECX
    PUSH EDX
    PUSH EDI
    
    XOR EDI, EDI                ; Flag "marcou algo"
    
    ; Buscar informacao do tipo na TypeDefTable
    ; TypeDefTable[EBX] contem info sobre campos
    
    MOV EAX, EBX
    SHL EAX, 5                  ; * 32 (tamanho de TypeDefEntry)
    ADD EAX, OFFSET __metadata_types
    
    ; EAX aponta para TypeDefEntry
    ; +20: FieldListStart
    ; +22: FieldCount
    
    MOVZX ECX, WORD PTR [EAX+22] ; FieldCount
    JECXZ .done
    
    MOVZX EDX, WORD PTR [EAX+20] ; FieldListStart
    
    ; Percorrer campos
.field_loop:
    PUSH ECX
    
    ; FieldDefEntry[EDX]
    MOV EAX, EDX
    SHL EAX, 4                  ; * 16 (tamanho de FieldDefEntry)
    ADD EAX, OFFSET __metadata_fields
    
    ; Verificar se campo e reference type
    ; +8: Flags (bit 0 = is reference)
    TEST BYTE PTR [EAX+8], 1
    JZ .next_field
    
    ; E reference - marcar o objeto referenciado
    ; +10: Offset do campo no objeto
    MOVZX EBX, WORD PTR [EAX+10]
    ADD EBX, ESI                ; Endereco do campo
    ADD EBX, 8                  ; Pular header
    
    MOV EAX, [EBX]              ; Valor do campo (ponteiro)
    TEST EAX, EAX
    JZ .next_field              ; null - ignorar
    
    CALL __gc_try_mark
    OR EDI, EAX
    
.next_field:
    INC EDX
    POP ECX
    DEC ECX
    JNZ .field_loop
    
.done:
    MOV EAX, EDI
    
    POP EDI
    POP EDX
    POP ECX
    RET
__gc_mark_fields ENDP

; ============================================================
; __gc_add_root
; Adiciona um root estatico
;
; Input: EAX = endereco do campo estatico (ponteiro para ponteiro)
; ============================================================
__gc_add_root PROC
    PUSH EBX
    
    MOV EBX, [__gc_static_roots_count]
    CMP EBX, 256
    JAE .full
    
    MOV [__gc_static_roots + EBX*4], EAX
    INC DWORD PTR [__gc_static_roots_count]
    
.full:
    POP EBX
    RET
__gc_add_root ENDP
```

## 4.5 Integracao do GC com o Compilador

O compilador gera chamadas ao GC automaticamente:

```csharp
// Codigo C#
var person = new Person();

// IL gerado
newobj instance void Person::.ctor()

// Assembly gerado pelo compilador
; Alocar memoria para Person
MOV EAX, 24                     ; Tamanho da instancia
MOV EBX, 5                      ; TypeIndex de Person
CALL __gc_alloc_typed
TEST EAX, EAX
JZ __throw_out_of_memory

; Inicializar VTable
MOV DWORD PTR [EAX], OFFSET __vtbl_Person

; Chamar construtor
PUSH EAX                        ; this
CALL __Person_ctor
ADD ESP, 4
```

---

# PARTE 5: CODE GENERATION - SELECAO DE INSTRUCOES

## 5.1 Sistema de Niveis de CPU

O compilador gera codigo diferente dependendo do nivel de CPU selecionado:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    INSTRUCTION SELECTION BY CPU LEVEL                        │
└─────────────────────────────────────────────────────────────────────────────┘

Opcao de linha de comando: --cpu=i386 | i486 | i586 | i686

┌──────────────────────────────────────────────────────────────────────────────┐
│  REGRA FUNDAMENTAL:                                                          │
│                                                                              │
│  Se --cpu=i386, NUNCA gera instrucoes de i486+                              │
│  Se --cpu=i486, pode gerar i386 e i486, mas NUNCA i586+                     │
│  Se --cpu=i586, pode gerar i386, i486, i586, mas NUNCA i686+                │
│  Se --cpu=i686, pode gerar todas as instrucoes ate i686                     │
│                                                                              │
│  A selecao SEMPRE usa a melhor instrucao DISPONIVEL no nivel escolhido      │
└──────────────────────────────────────────────────────────────────────────────┘
```

## 5.2 Exemplos de Selecao de Instrucoes

### 5.2.1 Byte Swap (Inverter ordem de bytes)

```
Operacao: Inverter bytes de um DWORD (ex: 0x12345678 → 0x78563412)

┌─────────────────────────────────────────────────────────────────────────────┐
│  --cpu=i386                                                                  │
│                                                                              │
│  ; BSWAP nao existe! Fazer manualmente                                      │
│  ; Input: EAX = valor                                                       │
│  ; Output: EAX = valor com bytes invertidos                                 │
│                                                                              │
│  ROL  AX, 8              ; Trocar bytes low word                            │
│  ROL  EAX, 16            ; Trocar words                                     │
│  ROL  AX, 8              ; Trocar bytes do que era high word                │
│                                                                              │
│  Ciclos: ~4                                                                  │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│  --cpu=i486 (ou superior)                                                    │
│                                                                              │
│  ; BSWAP disponivel!                                                        │
│  BSWAP EAX                                                                   │
│                                                                              │
│  Ciclos: 1                                                                   │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 5.2.2 Compare and Exchange (Atomico)

```
Operacao: Comparar EAX com [mem], se igual trocar [mem] por ECX

┌─────────────────────────────────────────────────────────────────────────────┐
│  --cpu=i386                                                                  │
│                                                                              │
│  ; CMPXCHG nao existe! Simular (nao e realmente atomico)                    │
│  CLI                      ; Desabilitar interrupcoes                        │
│  CMP  EAX, [EDI]                                                            │
│  JNE  .no_exchange                                                           │
│  MOV  [EDI], ECX                                                             │
│  .no_exchange:                                                               │
│  STI                      ; Reabilitar interrupcoes                         │
│                                                                              │
│  NOTA: Em DOS single-task, isso e suficiente                                │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│  --cpu=i486 (ou superior)                                                    │
│                                                                              │
│  ; CMPXCHG disponivel e atomico!                                            │
│  LOCK CMPXCHG [EDI], ECX                                                     │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 5.2.3 Conditional Move (Min/Max sem branch)

```
Operacao: EAX = min(EAX, EBX)

┌─────────────────────────────────────────────────────────────────────────────┐
│  --cpu=i386, i486, i586                                                      │
│                                                                              │
│  ; CMOVcc nao existe! Usar branch                                           │
│  CMP  EAX, EBX                                                               │
│  JLE  .done              ; if EAX <= EBX, ja e o minimo                     │
│  MOV  EAX, EBX           ; else EAX = EBX                                   │
│  .done:                                                                      │
│                                                                              │
│  PROBLEMA: Branch pode causar pipeline stall                                │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│  --cpu=i686                                                                  │
│                                                                              │
│  ; CMOV disponivel!                                                         │
│  CMP   EAX, EBX                                                              │
│  CMOVG EAX, EBX          ; if EAX > EBX, EAX = EBX                          │
│                                                                              │
│  VANTAGEM: Sem branch, sem pipeline stall                                   │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 5.2.4 Float Compare

```
Operacao: Comparar ST(0) com ST(1) e setar flags

┌─────────────────────────────────────────────────────────────────────────────┐
│  --cpu=i386, i486, i586                                                      │
│                                                                              │
│  ; FCOMI nao existe! Usar FCOM + FNSTSW + SAHF                              │
│  FCOM   ST(1)            ; Comparar                                         │
│  FNSTSW AX               ; Copiar status FPU para AX                        │
│  SAHF                    ; Copiar AH para flags                             │
│  ; Agora pode usar JA, JB, JE, etc                                          │
│                                                                              │
│  Ciclos: ~10+                                                                │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│  --cpu=i686                                                                  │
│                                                                              │
│  ; FCOMI disponivel!                                                        │
│  FCOMI ST, ST(1)         ; Compara e seta EFLAGS diretamente               │
│  ; Pode usar JA, JB, JE imediatamente                                       │
│                                                                              │
│  Ciclos: ~3                                                                  │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 5.3 Implementacao do InstructionSelector

```csharp
namespace MsilToDos.Backend.x86.CodeGen
{
    /// <summary>
    /// Seleciona as melhores instrucoes para o nivel de CPU alvo
    /// </summary>
    public class X86InstructionSelector
    {
        private readonly ICpuLevel _cpuLevel;
        private readonly X86InstructionEmitter _emitter;
        
        public X86InstructionSelector(ICpuLevel cpuLevel)
        {
            _cpuLevel = cpuLevel;
            _emitter = new X86InstructionEmitter();
        }
        
        /// <summary>
        /// Gera codigo para uma operacao do IR
        /// </summary>
        public void Select(IRInstruction ir, CodeBuffer buffer)
        {
            switch (ir.OpCode)
            {
                case IROpCode.Add:
                    SelectAdd(ir, buffer);
                    break;
                    
                case IROpCode.ByteSwap:
                    SelectByteSwap(ir, buffer);
                    break;
                    
                case IROpCode.Min:
                    SelectMin(ir, buffer);
                    break;
                    
                case IROpCode.FloatCompare:
                    SelectFloatCompare(ir, buffer);
                    break;
                    
                // ... mais casos
            }
        }
        
        private void SelectByteSwap(IRInstruction ir, CodeBuffer buffer)
        {
            // Tentar usar BSWAP (i486+)
            if (_cpuLevel.IsInstructionSupported("BSWAP"))
            {
                // i486+: usar BSWAP nativo
                buffer.Emit("BSWAP", ir.Dest);
            }
            else
            {
                // i386: sequencia manual
                var seq = _cpuLevel.GetOptimalSequence(Operation.ByteSwap32);
                foreach (var inst in seq.Instructions)
                {
                    buffer.EmitRaw(inst.Replace("EAX", ir.Dest.ToString()));
                }
            }
        }
        
        private void SelectMin(IRInstruction ir, CodeBuffer buffer)
        {
            // Tentar usar CMOVcc (i686+)
            if (_cpuLevel.IsInstructionSupported("CMOVG"))
            {
                // i686+: usar CMOV
                buffer.Emit("CMP", ir.Op1, ir.Op2);
                buffer.Emit("CMOVG", ir.Dest, ir.Op2);
            }
            else
            {
                // i386-i586: usar branch
                var label = buffer.CreateLabel();
                buffer.Emit("CMP", ir.Op1, ir.Op2);
                buffer.Emit("JLE", label);
                buffer.Emit("MOV", ir.Dest, ir.Op2);
                buffer.EmitLabel(label);
            }
        }
        
        private void SelectFloatCompare(IRInstruction ir, CodeBuffer buffer)
        {
            // Tentar usar FCOMI (i686+)
            if (_cpuLevel.IsInstructionSupported("FCOMI"))
            {
                // i686+: FCOMI direto
                buffer.Emit("FCOMI", "ST", ir.Op1);
            }
            else
            {
                // i386-i586: FCOM + FNSTSW + SAHF
                buffer.Emit("FCOM", ir.Op1);
                buffer.Emit("FNSTSW", "AX");
                buffer.Emit("SAHF");
            }
        }
        
        /// <summary>
        /// Valida que nenhuma instrucao invalida foi gerada
        /// </summary>
        public void Validate(CodeBuffer buffer)
        {
            foreach (var inst in buffer.Instructions)
            {
                if (!_cpuLevel.IsInstructionSupported(inst.Mnemonic))
                {
                    throw new InvalidOperationException(
                        $"Instruction '{inst.Mnemonic}' is not supported on {_cpuLevel.Name}. " +
                        $"This is a compiler bug!");
                }
            }
        }
    }
}
```

## 5.4 Tabela Completa de Selecao

| Operacao | i386 | i486 | i586 | i686 |
|----------|------|------|------|------|
| Byte Swap 32 | ROL+ROL+ROL | BSWAP | BSWAP | BSWAP |
| Compare-Exchange | CLI+CMP+MOV+STI | CMPXCHG | CMPXCHG | CMPXCHG |
| Exchange-Add | XCHG+ADD | XADD | XADD | XADD |
| Min/Max | CMP+Jcc+MOV | CMP+Jcc+MOV | CMP+Jcc+MOV | CMP+CMOVcc |
| Abs | CDQ+XOR+SUB | CDQ+XOR+SUB | CDQ+XOR+SUB | MOV+NEG+CMOVcc |
| Float Compare | FCOM+FNSTSW+SAHF | FCOM+FNSTSW+SAHF | FCOM+FNSTSW+SAHF | FCOMI |
| Read Timestamp | Loop counter | Loop counter | RDTSC | RDTSC |
| CPU ID | N/A | N/A | CPUID | CPUID |

---

# PARTE 6: EXTENSIBILIDADE - ADICIONANDO NOVOS BACKENDS

## 6.1 Como Adicionar um Novo Backend (Exemplo: IBM s390)

Para adicionar suporte a uma nova arquitetura:

### Passo 1: Criar projeto do backend

```
src/Backend.s390/
├── Backend.s390.csproj
├── S390Backend.cs              # Implementa IBackend
├── S390ArchitectureInfo.cs     # Descreve a arquitetura
├── CpuLevel/
│   └── ZArchLevel.cs           # Nivel de CPU
├── CodeGen/
│   ├── S390CodeGenerator.cs
│   ├── S390InstructionSelector.cs
│   ├── S390RegisterAllocator.cs
│   └── S390CallingConvention.cs
├── Runtime/
│   ├── S390RuntimeGenerator.cs
│   ├── S390GCRuntime.cs
│   └── S390StringRuntime.cs
└── Output/
    └── S390OutputGenerator.cs
```

### Passo 2: Implementar IBackend

```csharp
namespace MsilToDos.Backend.s390
{
    public class S390Backend : IBackend
    {
        public string Name => "s390";
        public string Description => "IBM System/390 and z/Architecture";
        
        public ArchitectureInfo ArchitectureInfo => new()
        {
            PointerSize = 4,             // 31-bit mode (ou 8 para 64-bit)
            Endianness = Endianness.Big, // Big-endian!
            GeneralPurposeRegisterCount = 16, // R0-R15
            FloatRegisterCount = 16,     // F0-F15
            StackGrowsDown = true,
            TypeSize = new Dictionary<PrimitiveType, int>
            {
                [PrimitiveType.Int32] = 4,
                [PrimitiveType.Int64] = 8,
                [PrimitiveType.Pointer] = 4, // 31-bit mode
                // ...
            },
            TypeAlignment = new Dictionary<PrimitiveType, int>
            {
                [PrimitiveType.Int32] = 4,
                [PrimitiveType.Int64] = 8,
                [PrimitiveType.Float64] = 8,
                // s390 tem requisitos de alinhamento mais rigorosos
            },
            Registers = S390Registers.All,
            CallingConventions = new[]
            {
                CallingConventionInfo.S390Standard,
            },
        };
        
        // ... resto da implementacao
    }
}
```

### Passo 3: Implementar Selecao de Instrucoes s390

```csharp
namespace MsilToDos.Backend.s390.CodeGen
{
    public class S390InstructionSelector : IInstructionSelector
    {
        public void Select(IRInstruction ir, CodeBuffer buffer)
        {
            switch (ir.OpCode)
            {
                case IROpCode.Add:
                    // s390 usa AR (Add Register) ou A (Add from memory)
                    if (ir.Op2.IsRegister)
                        buffer.Emit("AR", ir.Dest, ir.Op2);
                    else
                        buffer.Emit("A", ir.Dest, ir.Op2);
                    break;
                    
                case IROpCode.Load:
                    // s390 usa L (Load)
                    buffer.Emit("L", ir.Dest, ir.Op1);
                    break;
                    
                case IROpCode.Store:
                    // s390 usa ST (Store)
                    buffer.Emit("ST", ir.Op1, ir.Dest);
                    break;
                    
                case IROpCode.Call:
                    // s390 usa BALR (Branch and Link Register)
                    buffer.Emit("BALR", "R14", ir.Op1);
                    break;
                    
                case IROpCode.Return:
                    // s390 retorna com BR R14
                    buffer.Emit("BR", "R14");
                    break;
                    
                // ... mais instrucoes
            }
        }
    }
}
```

### Passo 4: Registrar o backend

```csharp
// Em CompilerDriver.cs ou via reflection
public class BackendRegistry
{
    private readonly Dictionary<string, IBackend> _backends = new();
    
    public BackendRegistry()
    {
        // Registrar backends disponiveis
        Register(new X86Backend());
        Register(new S390Backend());
        // Register(new ARMBackend());
    }
    
    public void Register(IBackend backend)
    {
        _backends[backend.Name.ToLower()] = backend;
    }
    
    public IBackend GetBackend(string name)
    {
        if (_backends.TryGetValue(name.ToLower(), out var backend))
            return backend;
        throw new ArgumentException($"Unknown backend: {name}");
    }
}
```

### Passo 5: Usar via linha de comando

```bash
# Compilar para x86 DOS
msiltodos --arch=x86 --cpu=i386 MyApp.dll

# Compilar para s390
msiltodos --arch=s390 MyApp.dll

# Listar backends disponiveis
msiltodos --list-backends
```

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
