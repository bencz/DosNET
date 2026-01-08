# Análise Detalhada do GC e Sistema de Alocação

## Status Atual

- **HelloWorld**: ✅ Funciona (não usa alocação)
- **TestNoAlloc**: ✅ Funciona (não usa alocação)
- **TestSimpleAlloc**: ❌ Não funciona (usa `new object()`)
- **TestAlloc**: ❌ Não funciona (usa arrays)

## Problemas Identificados

### 1. Layout de Memória do GC

O `__gc_alloc` adiciona 8 bytes de header internamente:
```asm
ADD EAX, 8  ; Adicionar header (8 bytes)
```

**Header do GC (8 bytes):**
- `+0`: Size (4 bytes)
- `+4`: TypeIndex (2 bytes)
- `+6`: Flags (1 byte)
- `+7`: Reserved (1 byte)

**Dados do objeto começam em +8**

### 2. Bug Corrigido: Cálculo de Tamanho de Arrays

O código original em `EmitNewArray` estava errado:
```csharp
_emitter.Add("EAX", "12"); // header + length field
```

Isso pedia 12 bytes extras, mas `__gc_alloc` já adiciona 8 bytes de header.
O correto é pedir apenas 8 bytes (VTable + Length):
```csharp
_emitter.Add("EAX", "8"); // VTable(4) + Length(4), SEM header GC
```

### 3. Fluxo de Alocação

#### Para objetos (`EmitNewObj`):
1. `MOV EAX, <instance_size>` - tamanho dos dados (inclui VTable)
2. `MOV EBX, <type_index>` - índice do tipo
3. `CALL __gc_alloc_typed`
4. `TEST EAX, EAX` / `JZ __throw_out_of_memory`
5. `MOV DWORD PTR [EAX], OFFSET __vtbl_xxx` - inicializa VTable

#### Para arrays (`EmitNewArray`):
1. `POP ECX` - length
2. Calcula: `EAX = length * element_size + 8` (VTable + Length)
3. `PUSH ECX` - salva length
4. `CALL __gc_alloc`
5. `POP ECX` - restaura length
6. `MOV DWORD PTR [EAX], OFFSET __vtbl_System_Array`
7. `MOV [EAX+4], ECX` - length

### 4. Problema Potencial: __program_end

O `__gc_init` usa `OFFSET __program_end` para calcular o início do heap:
```asm
MOV EAX, OFFSET __program_end
ADD EAX, 0Fh
AND EAX, 0FFFFFFF0h  ; Alinhar 16 bytes
MOV [__gc_heap_start], EAX
```

**Problema:** Quando CORLIB.OBJ e APP.OBJ são linkados, a ordem dos segmentos pode não ser a esperada. O `__program_end` está definido na aplicação, mas pode não estar no final real do executável.

### 5. Convenções de Chamada

#### `__gc_alloc`:
- **Input**: EAX = tamanho em bytes (sem header)
- **Output**: EAX = ponteiro para dados (após header), ou 0 se OOM
- **Preserva**: EBX, ECX, EDX (via PUSH/POP)

#### `__gc_alloc_typed`:
- **Input**: EAX = tamanho, EBX = type index
- **Output**: EAX = ponteiro para dados
- **Nota**: Chama `__gc_alloc` internamente

### 6. VTables

As VTables são geradas corretamente com `PUBLIC` para exportação:
```asm
PUBLIC __vtbl_MyClass
__vtbl_MyClass:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0
    DD OFFSET __System_Object_GetHashCode    ; Slot 1
    DD OFFSET __System_Object_ToString       ; Slot 2
    DD OFFSET __System_Object_Finalize       ; Slot 3
```

### 7. Inicialização do GC

O startup da aplicação chama `__gc_init`:
```asm
__start PROC
    MOV EAX, 65536      ; 64KB heap
    CALL __gc_init
    TEST EAX, EAX
    JZ __gc_init_failed_app
    CALL __Program_Main
    ...
```

## Hipóteses para o Problema

1. **Endereço de __program_end inválido**: O linker pode estar colocando `__program_end` em um local inesperado.

2. **Heap em região de memória protegida**: O endereço calculado pode estar em uma região que o HX DOS Extender não permite acessar.

3. **Problema na convenção de chamada**: Algum registrador pode estar sendo corrompido entre chamadas.

4. **Problema no construtor de Object**: O `Object..ctor` pode estar fazendo algo que causa crash.

## Próximos Passos

1. Verificar se `__gc_init` está retornando sucesso (EAX=1)
2. Verificar se o endereço do heap está válido
3. Testar alocação sem chamar construtor
4. Adicionar debug output em pontos críticos
