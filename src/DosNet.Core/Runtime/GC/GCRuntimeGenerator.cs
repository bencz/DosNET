namespace DosNet.Core.Runtime.GC;

/// <summary>
/// Gera código assembly para o Garbage Collector mark-and-sweep.
/// </summary>
public class GCRuntimeGenerator
{
    /// <summary>
    /// Gera o código completo do GC para MASM
    /// </summary>
    public string Generate()
    {
        return @"; ============================================================
; GARBAGE COLLECTOR - Mark-and-Sweep
; Compatível com HX DOS Extender (32-bit protected mode)
; ============================================================

.DATA
    __gc_heap_start     DD 0        ; Início do heap
    __gc_heap_end       DD 0        ; Fim do heap
    __gc_free_ptr       DD 0        ; Próximo espaço livre
    __gc_stack_bottom   DD 0        ; Base da stack (para scan)
    __gc_collections    DD 0        ; Contador de coletas
    __gc_bytes_freed    DD 0        ; Bytes liberados na última coleta
    
    ; Tabela de roots estáticos (preenchida pelo compilador)
    __gc_static_roots_count DD 0
    __gc_static_roots       DD 256 DUP(0)

.CODE

; __program_end é definido na aplicação (não no CORLIB)
EXTRN __program_end:NEAR

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
    
    MOV ECX, EAX                ; ECX = tamanho desejado
    
    ; Usar memória após o programa
    MOV EAX, OFFSET __program_end
    ADD EAX, 0Fh
    AND EAX, 0FFFFFFF0h         ; Alinhar 16 bytes
    
    MOV [__gc_heap_start], EAX
    MOV [__gc_free_ptr], EAX
    
    ; Calcular fim do heap
    ADD EAX, ECX
    MOV [__gc_heap_end], EAX
    
    ; Zerar estatísticas
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
; Aloca memória no heap gerenciado
;
; Input: EAX = tamanho em bytes (sem header)
; Output: EAX = ponteiro para dados (após header), ou 0 se OOM
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
    
__gc_alloc_try:
    ; Verificar se cabe
    MOV EBX, [__gc_free_ptr]
    MOV EAX, EBX
    ADD EAX, ECX
    
    CMP EAX, [__gc_heap_end]
    JBE __gc_alloc_do
    
    ; Não cabe - tentar GC
    PUSH ECX
    CALL __gc_collect
    POP ECX
    
    ; Tentar novamente
    MOV EBX, [__gc_free_ptr]
    MOV EAX, EBX
    ADD EAX, ECX
    
    CMP EAX, [__gc_heap_end]
    JBE __gc_alloc_do
    
    ; Ainda não cabe - Out of Memory!
    XOR EAX, EAX
    JMP __gc_alloc_done
    
__gc_alloc_do:
    ; Inicializar header
    MOV [EBX], ECX              ; +0: Size
    MOV WORD PTR [EBX+4], 0     ; +4: TypeIndex (será setado depois)
    MOV WORD PTR [EBX+6], 0     ; +6: Flags = 0, Reserved = 0
    
    ; Avançar free pointer
    ADD [__gc_free_ptr], ECX
    
    ; Retornar ponteiro para dados (após header)
    LEA EAX, [EBX+8]
    
__gc_alloc_done:
    POP EDX
    POP ECX
    POP EBX
    RET
__gc_alloc ENDP

; ============================================================
; __gc_alloc_typed
; Aloca memória com informação de tipo
;
; Input: EAX = tamanho, EBX = type index
; Output: EAX = ponteiro para dados
; ============================================================
__gc_alloc_typed PROC
    PUSH EBX                    ; Salvar type index na stack
    CALL __gc_alloc
    POP EBX                     ; Restaurar type index
    TEST EAX, EAX
    JZ __gc_alloc_typed_done
    
    ; Setar type index no header
    MOV [EAX-4], BX             ; TypeIndex em offset -4 do data
    
__gc_alloc_typed_done:
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
    
__gc_clear_loop:
    CMP ESI, [__gc_free_ptr]
    JAE __gc_clear_done
    
    ; Limpar bit de mark (bit 0 do byte flags)
    AND BYTE PTR [ESI+6], 0FEh
    
    ; Próximo objeto
    ADD ESI, [ESI]              ; ESI += size
    JMP __gc_clear_loop
    
__gc_clear_done:

    ; ==========================================
    ; FASE 2: Mark from roots
    ; ==========================================
    
    ; 2a: Scan stack
    MOV ESI, ESP
    ADD ESI, 32                 ; Pular registradores salvos
    
__gc_scan_stack:
    CMP ESI, [__gc_stack_bottom]
    JAE __gc_scan_statics
    
    ; Cada DWORD na stack pode ser um ponteiro
    MOV EAX, [ESI]
    CALL __gc_try_mark
    
    ADD ESI, 4
    JMP __gc_scan_stack
    
__gc_scan_statics:
    ; 2b: Scan static roots
    MOV ESI, OFFSET __gc_static_roots
    MOV ECX, [__gc_static_roots_count]
    
__gc_scan_static_loop:
    JECXZ __gc_mark_transitive
    
    ; Cada root é um ponteiro para um ponteiro
    MOV EAX, [ESI]              ; Endereço do campo estático
    MOV EAX, [EAX]              ; Valor do campo (ponteiro)
    CALL __gc_try_mark
    
    ADD ESI, 4
    DEC ECX
    JMP __gc_scan_static_loop
    
__gc_mark_transitive:
    ; ==========================================
    ; FASE 3: Mark transitive (trace)
    ; ==========================================
    XOR EDI, EDI                ; EDI = flag ""marcou algo novo""
    
    MOV ESI, [__gc_heap_start]
    
__gc_trace_loop:
    CMP ESI, [__gc_free_ptr]
    JAE __gc_trace_check
    
    ; Este objeto está marcado?
    TEST BYTE PTR [ESI+6], 1
    JZ __gc_trace_next
    
    ; Sim - marcar seus filhos
    MOVZX EBX, WORD PTR [ESI+4] ; TypeIndex
    CALL __gc_mark_fields
    OR EDI, EAX
    
__gc_trace_next:
    ADD ESI, [ESI]
    JMP __gc_trace_loop
    
__gc_trace_check:
    ; Se marcou algo novo, repetir
    TEST EDI, EDI
    JNZ __gc_mark_transitive
    
    ; ==========================================
    ; FASE 4: Sweep and compact
    ; ==========================================
    MOV ESI, [__gc_heap_start]  ; Source
    MOV EDI, ESI                ; Destination
    
__gc_sweep_loop:
    CMP ESI, [__gc_free_ptr]
    JAE __gc_sweep_done
    
    ; Este objeto está marcado?
    TEST BYTE PTR [ESI+6], 1
    JZ __gc_sweep_skip          ; Não - pular (garbage)
    
    ; Sim - manter objeto
    CMP ESI, EDI
    JE __gc_sweep_no_move
    
    ; Mover objeto para nova posição
    MOV ECX, [ESI]              ; Size
    PUSH ESI
    PUSH EDI
    PUSH ECX
    
    ; Copiar objeto
    MOV ECX, [ESI]
    REP MOVSB
    
    POP ECX
    POP EDI
    POP ESI
    
    ADD EDI, ECX
    JMP __gc_sweep_next
    
__gc_sweep_no_move:
    ADD EDI, [ESI]
    JMP __gc_sweep_next
    
__gc_sweep_skip:
    ; Objeto é garbage - não copiar
    
__gc_sweep_next:
    ADD ESI, [ESI]
    JMP __gc_sweep_loop
    
__gc_sweep_done:
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
; Tenta marcar um possível ponteiro
;
; Input: EAX = possível ponteiro
; Output: EAX = 1 se marcou, 0 caso contrário
; ============================================================
__gc_try_mark PROC
    PUSH EBX
    
    ; Verificar se está no range do heap
    CMP EAX, [__gc_heap_start]
    JB __gc_try_mark_not
    CMP EAX, [__gc_free_ptr]
    JAE __gc_try_mark_not
    
    ; Apontar para o header (dados - 8)
    SUB EAX, 8
    
    ; Já está marcado?
    TEST BYTE PTR [EAX+6], 1
    JNZ __gc_try_mark_already
    
    ; Marcar!
    OR BYTE PTR [EAX+6], 1
    
    MOV EAX, 1                  ; Marcou
    JMP __gc_try_mark_done
    
__gc_try_mark_already:
__gc_try_mark_not:
    XOR EAX, EAX                ; Não marcou
    
__gc_try_mark_done:
    POP EBX
    RET
__gc_try_mark ENDP

; ============================================================
; __gc_mark_fields
; Marca campos de referência de um objeto
;
; Input: ESI = ponteiro para header do objeto
;        EBX = type index
; Output: EAX = 1 se marcou algo novo
; ============================================================
__gc_mark_fields PROC
    PUSH ECX
    PUSH EDX
    PUSH EDI
    
    XOR EDI, EDI                ; Flag ""marcou algo""
    
    ; Buscar informação do tipo na TypeDefTable
    MOV EAX, EBX
    SHL EAX, 5                  ; * 32 (tamanho de TypeDefEntry)
    ADD EAX, OFFSET __metadata_types
    
    ; EAX aponta para TypeDefEntry
    MOVZX ECX, WORD PTR [EAX+22] ; FieldCount
    JECXZ __gc_mark_fields_done
    
    MOVZX EDX, WORD PTR [EAX+20] ; FieldListStart
    
__gc_mark_field_loop:
    PUSH ECX
    
    ; FieldDefEntry[EDX]
    MOV EAX, EDX
    SHL EAX, 4                  ; * 16 (tamanho de FieldDefEntry)
    ADD EAX, OFFSET __metadata_fields
    
    ; Verificar se campo é reference type (bit 0 de Flags)
    TEST BYTE PTR [EAX+8], 1
    JZ __gc_mark_next_field
    
    ; É reference - marcar o objeto referenciado
    MOVZX EBX, WORD PTR [EAX+10]
    ADD EBX, ESI                ; Endereço do campo
    ADD EBX, 8                  ; Pular header
    
    MOV EAX, [EBX]              ; Valor do campo (ponteiro)
    TEST EAX, EAX
    JZ __gc_mark_next_field     ; null - ignorar
    
    CALL __gc_try_mark
    OR EDI, EAX
    
__gc_mark_next_field:
    INC EDX
    POP ECX
    DEC ECX
    JNZ __gc_mark_field_loop
    
__gc_mark_fields_done:
    MOV EAX, EDI
    
    POP EDI
    POP EDX
    POP ECX
    RET
__gc_mark_fields ENDP

; ============================================================
; __gc_add_root
; Adiciona um root estático
;
; Input: EAX = endereço do campo estático
; ============================================================
__gc_add_root PROC
    PUSH EBX
    
    MOV EBX, [__gc_static_roots_count]
    CMP EBX, 256
    JAE __gc_add_root_full
    
    MOV [__gc_static_roots + EBX*4], EAX
    INC DWORD PTR [__gc_static_roots_count]
    
__gc_add_root_full:
    POP EBX
    RET
__gc_add_root ENDP
";
    }
    
    /// <summary>
    /// Gera código de inicialização do GC para o startup
    /// </summary>
    public string GenerateInitCall(int heapSize)
    {
        return $@"    ; Inicializar GC
    MOV EAX, {heapSize}         ; Tamanho do heap
    CALL __gc_init
    TEST EAX, EAX
    JZ __gc_init_failed
";
    }
    
    /// <summary>
    /// Gera apenas o código do GC (sem seções .DATA/.CODE)
    /// </summary>
    public string GenerateCodeOnly()
    {
        // Extrair apenas a parte de código do Generate()
        var full = Generate();
        var codeStart = full.IndexOf(".CODE");
        if (codeStart >= 0)
        {
            return full.Substring(codeStart + 6); // Pular ".CODE\n"
        }
        return full;
    }
    
    /// <summary>
    /// Gera apenas os dados do GC (sem seção .DATA)
    /// </summary>
    public string GenerateDataOnly()
    {
        return @"    ; GC Runtime Data
    __gc_heap_start     DD 0
    __gc_heap_end       DD 0
    __gc_free_ptr       DD 0
    __gc_stack_bottom   DD 0
    __gc_collections    DD 0
    __gc_bytes_freed    DD 0
    __gc_static_roots_count DD 0
    __gc_static_roots   DD 256 DUP(0)
";
    }
}
