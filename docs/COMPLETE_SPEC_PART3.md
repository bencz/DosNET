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

