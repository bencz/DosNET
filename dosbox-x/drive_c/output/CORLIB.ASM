; ============================================================
; DosNET CoreLib - Base Class Library
; ============================================================

.386
.MODEL FLAT, C

; ============================================================
; DATA SECTION
; ============================================================
.DATA

    __crlf DB 13, 10, 0
    __null_string DD 0

    ; String Literals
    __str_0 DD 34
    __str_0_data DB 'Nullable object must have a value.', 0
    __str_1 DD 0
    __str_1_data DB 0
    __str_2 DD 5
    __str_2_data DB 'False', 0
    __str_3 DD 4
    __str_3_data DB 'True', 0
    __str_4 DD 19
    __str_4_data DB 'Exception of type ', 39, 0
    __str_5 DD 13
    __str_5_data DB 39, ' was thrown.', 0
    __str_6 DD 2
    __str_6_data DB ': ', 0
    __str_7 DD 53
    __str_7_data DB 'Object reference not set to an instance of an object.', 0
    __str_8 DD 62
    __str_8_data DB 'Operation is not valid due to the current state of the object.', 0
    __str_9 DD 46
    __str_9_data DB 'Value does not fall within the expected range.', 0
    __str_10 DD 21
    __str_10_data DB 'Value cannot be null.', 0
    __str_11 DD 38
    __str_11_data DB 'Value cannot be null. Parameter name: ', 0
    __str_12 DD 56
    __str_12_data DB 'Specified argument was out of the range of valid values.', 0
    __str_13 DD 73
    __str_13_data DB 'Specified argument was out of the range of valid values. Parameter name: ', 0
    __str_14 DD 42
    __str_14_data DB 'Index was outside the bounds of the array.', 0
    __str_15 DD 61
    __str_15_data DB 'Insufficient memory to continue the execution of the program.', 0
    __str_16 DD 45
    __str_16_data DB 'Arithmetic operation resulted in an overflow.', 0
    __str_17 DD 28
    __str_17_data DB 'Attempted to divide by zero.', 0
    __str_18 DD 34
    __str_18_data DB 'Specified method is not supported.', 0
    __str_19 DD 43
    __str_19_data DB 'The method or operation is not implemented.', 0
    __str_20 DD 1
    __str_20_data DB '0', 0
    __str_21 DD 1
    __str_21_data DB '.', 0

    ; Static Fields
    __static_System_AttributeTargets_Assembly DD 0  ; AttributeTargets.Assembly
    __static_System_AttributeTargets_Module DD 0  ; AttributeTargets.Module
    __static_System_AttributeTargets_Class DD 0  ; AttributeTargets.Class
    __static_System_AttributeTargets_Struct DD 0  ; AttributeTargets.Struct
    __static_System_AttributeTargets_Enum DD 0  ; AttributeTargets.Enum
    __static_System_AttributeTargets_Constructor DD 0  ; AttributeTargets.Constructor
    __static_System_AttributeTargets_Method DD 0  ; AttributeTargets.Method
    __static_System_AttributeTargets_Property DD 0  ; AttributeTargets.Property
    __static_System_AttributeTargets_Field DD 0  ; AttributeTargets.Field
    __static_System_AttributeTargets_Event DD 0  ; AttributeTargets.Event
    __static_System_AttributeTargets_Interface DD 0  ; AttributeTargets.Interface
    __static_System_AttributeTargets_Parameter DD 0  ; AttributeTargets.Parameter
    __static_System_AttributeTargets_Delegate DD 0  ; AttributeTargets.Delegate
    __static_System_AttributeTargets_ReturnValue DD 0  ; AttributeTargets.ReturnValue
    __static_System_AttributeTargets_GenericParameter DD 0  ; AttributeTargets.GenericParameter
    __static_System_AttributeTargets_All DD 0  ; AttributeTargets.All
    __static_System_ConsoleKey_None DD 0  ; ConsoleKey.None
    __static_System_ConsoleKey_Backspace DD 0  ; ConsoleKey.Backspace
    __static_System_ConsoleKey_Tab DD 0  ; ConsoleKey.Tab
    __static_System_ConsoleKey_Enter DD 0  ; ConsoleKey.Enter
    __static_System_ConsoleKey_Escape DD 0  ; ConsoleKey.Escape
    __static_System_ConsoleKey_Spacebar DD 0  ; ConsoleKey.Spacebar
    __static_System_SByte_MinValue DD 0  ; SByte.MinValue
    __static_System_SByte_MaxValue DD 0  ; SByte.MaxValue
    __static_System_Byte_MinValue DD 0  ; Byte.MinValue
    __static_System_Byte_MaxValue DD 0  ; Byte.MaxValue
    __static_System_Int16_MinValue DD 0  ; Int16.MinValue
    __static_System_Int16_MaxValue DD 0  ; Int16.MaxValue
    __static_System_UInt16_MinValue DD 0  ; UInt16.MinValue
    __static_System_UInt16_MaxValue DD 0  ; UInt16.MaxValue
    __static_System_Int32_MinValue DD 0  ; Int32.MinValue
    __static_System_Int32_MaxValue DD 0  ; Int32.MaxValue
    __static_System_UInt32_MinValue DD 0  ; UInt32.MinValue
    __static_System_UInt32_MaxValue DD 0  ; UInt32.MaxValue
    __static_System_Int64_MinValue DD 0  ; Int64.MinValue
    __static_System_Int64_MaxValue DD 0  ; Int64.MaxValue
    __static_System_UInt64_MinValue DD 0  ; UInt64.MinValue
    __static_System_UInt64_MaxValue DD 0  ; UInt64.MaxValue
    __static_System_Single_MinValue DD 0  ; Single.MinValue
    __static_System_Single_MaxValue DD 0  ; Single.MaxValue
    __static_System_Single_Epsilon DD 0  ; Single.Epsilon
    __static_System_Single_NaN DD 0  ; Single.NaN
    __static_System_Single_PositiveInfinity DD 0  ; Single.PositiveInfinity
    __static_System_Single_NegativeInfinity DD 0  ; Single.NegativeInfinity
    __static_System_Double_MinValue DD 0  ; Double.MinValue
    __static_System_Double_MaxValue DD 0  ; Double.MaxValue
    __static_System_Double_Epsilon DD 0  ; Double.Epsilon
    __static_System_Double_NaN DD 0  ; Double.NaN
    __static_System_Double_PositiveInfinity DD 0  ; Double.PositiveInfinity
    __static_System_Double_NegativeInfinity DD 0  ; Double.NegativeInfinity
    __static_System_IntPtr_Zero DD 0  ; IntPtr.Zero
    __static_System_UIntPtr_Zero DD 0  ; UIntPtr.Zero
    __static_System_String_Empty DD 0  ; String.Empty
    __static_TypeFlags_None DD 0  ; TypeFlags.None
    __static_TypeFlags_ValueType DD 0  ; TypeFlags.ValueType
    __static_TypeFlags_Interface DD 0  ; TypeFlags.Interface
    __static_TypeFlags_Enum DD 0  ; TypeFlags.Enum
    __static_TypeFlags_Array DD 0  ; TypeFlags.Array


    ; GC Runtime Data
    __gc_heap_start     DD 0
    __gc_heap_end       DD 0
    __gc_free_ptr       DD 0
    __gc_stack_bottom   DD 0
    __gc_collections    DD 0
    __gc_bytes_freed    DD 0
    __gc_static_roots_count DD 0
    __gc_static_roots   DD 256 DUP(0)

    ; SoftFloat Constants
    __sf_sign_mask      DD 80000000h
    __sf_exp_mask       DD 7F800000h
    __sf_mant_mask      DD 007FFFFFh
    __sf_exp_bias       DD 127
    __sf_implicit_bit   DD 00800000h
    __sf_d_sign_mask_hi DD 80000000h
    __sf_d_exp_mask_hi  DD 7FF00000h
    __sf_d_mant_mask_hi DD 000FFFFFh
    __sf_d_exp_bias     DD 1023

    ; Exception Runtime Data
    __current_exception  DD 0
    __exception_handler  DD 0
    __msg_unhandled      DB 'Unhandled exception', 13, 10, '$'
    __msg_invalid_cast   DB 'InvalidCastException', 13, 10, '$'
    __msg_null_ref       DB 'NullReferenceException', 13, 10, '$'
    __msg_index_range    DB 'IndexOutOfRangeException', 13, 10, '$'

    ; GC Timer Data
    __gc_old_timer_handler  DD 0
    __gc_timer_counter      DD 0
    __gc_timer_threshold    DD 18
    __gc_in_collection      DD 0
    __gc_alloc_counter      DD 0

; ============================================================
; BSS SECTION (Uninitialized Data)
; ============================================================
.DATA?



.CODE

; ============================================================
; RUNTIME CODE (GC, Exceptions, I/O)
; ============================================================


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
    PUSH EBX
    PUSH ECX
    MOV ECX, EBX                ; Salvar type index
    CALL __gc_alloc
    TEST EAX, EAX
    JZ __gc_alloc_typed_done
    
    ; Setar type index no header
    MOV [EAX-4], CX             ; TypeIndex em offset -4 do data
    
__gc_alloc_typed_done:
    POP ECX
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
    XOR EDI, EDI                ; EDI = flag "marcou algo novo"
    
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
    
    XOR EDI, EDI                ; Flag "marcou algo"
    
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



; ============================================================
; __soft_fadd
; Adição de floats IEEE 754 single-precision
;
; Input: EAX = float1, EBX = float2
; Output: EAX = resultado
; ============================================================
__soft_fadd PROC
    PUSH ECX
    PUSH EDX
    PUSH ESI
    PUSH EDI
    PUSH EBP
    
    ; Extrair componentes de EAX (float1)
    MOV ECX, EAX
    SHR ECX, 23
    AND ECX, 0FFh               ; ECX = exp1
    MOV ESI, EAX
    AND ESI, 007FFFFFh          ; ESI = mantissa1
    OR ESI, 00800000h           ; Adicionar bit implícito
    TEST EAX, 80000000h
    JZ __sf_fadd_pos1
    NEG ESI
__sf_fadd_pos1:
    
    ; Extrair componentes de EBX (float2)
    MOV EDX, EBX
    SHR EDX, 23
    AND EDX, 0FFh               ; EDX = exp2
    MOV EDI, EBX
    AND EDI, 007FFFFFh          ; EDI = mantissa2
    OR EDI, 00800000h
    TEST EBX, 80000000h
    JZ __sf_fadd_pos2
    NEG EDI
__sf_fadd_pos2:
    
    ; Alinhar expoentes
    CMP ECX, EDX
    JE __sf_fadd_aligned
    JG __sf_fadd_shift2
    
    ; Shift mantissa1 (exp1 < exp2)
    MOV EBP, EDX
    SUB EBP, ECX                ; diff = exp2 - exp1
    CMP EBP, 24
    JAE __sf_fadd_return_b      ; float1 é insignificante
    PUSH ECX
    MOV ECX, EBP                ; CL = diff (low byte of EBP)
    SAR ESI, CL                 ; mantissa1 >>= diff
    POP ECX
    MOV ECX, EDX                ; exp = exp2
    JMP __sf_fadd_aligned
    
__sf_fadd_shift2:
    ; Shift mantissa2 (exp2 < exp1)
    MOV EBP, ECX
    SUB EBP, EDX                ; diff = exp1 - exp2
    CMP EBP, 24
    JAE __sf_fadd_return_a      ; float2 é insignificante
    PUSH ECX
    MOV ECX, EBP                ; CL = diff (low byte of EBP)
    SAR EDI, CL                 ; mantissa2 >>= diff
    POP ECX
    
__sf_fadd_aligned:
    ; Somar mantissas
    ADD ESI, EDI
    
    ; Verificar zero
    TEST ESI, ESI
    JZ __sf_fadd_zero
    
    ; Determinar sinal do resultado
    XOR EBP, EBP                ; EBP = sign (0 = positivo)
    TEST ESI, ESI
    JNS __sf_fadd_normalize
    NEG ESI
    MOV EBP, 80000000h
    
__sf_fadd_normalize:
    ; Normalizar resultado
    ; Encontrar bit mais significativo
    BSR EDX, ESI                ; EDX = posição do MSB
    CMP EDX, 23
    JE __sf_fadd_pack           ; Já normalizado
    JG __sf_fadd_shift_right
    
    ; Shift left (underflow de mantissa)
    MOV EAX, 23
    SUB EAX, EDX
    SUB ECX, EAX                ; Ajustar expoente
    PUSH ECX
    MOV CL, AL
    SHL ESI, CL
    POP ECX
    JMP __sf_fadd_pack
    
__sf_fadd_shift_right:
    ; Shift right (overflow de mantissa)
    MOV EAX, EDX
    SUB EAX, 23
    ADD ECX, EAX                ; Ajustar expoente
    PUSH ECX
    MOV CL, AL
    SHR ESI, CL
    POP ECX
    
__sf_fadd_pack:
    ; Verificar overflow/underflow de expoente
    CMP ECX, 255
    JAE __sf_fadd_overflow
    TEST ECX, ECX
    JZ __sf_fadd_underflow
    
    ; Montar resultado
    AND ESI, 007FFFFFh          ; Remover bit implícito
    SHL ECX, 23
    OR ESI, ECX
    OR ESI, EBP
    MOV EAX, ESI
    JMP __sf_fadd_done
    
__sf_fadd_zero:
    XOR EAX, EAX
    JMP __sf_fadd_done
    
__sf_fadd_return_a:
    ; Retornar float1
    JMP __sf_fadd_done
    
__sf_fadd_return_b:
    MOV EAX, EBX
    JMP __sf_fadd_done
    
__sf_fadd_overflow:
    ; Retornar infinito
    MOV EAX, 7F800000h
    OR EAX, EBP
    JMP __sf_fadd_done
    
__sf_fadd_underflow:
    ; Retornar zero
    MOV EAX, EBP
    
__sf_fadd_done:
    POP EBP
    POP EDI
    POP ESI
    POP EDX
    POP ECX
    RET
__soft_fadd ENDP

; ============================================================
; __soft_fsub
; Subtração de floats IEEE 754
;
; Input: EAX = float1, EBX = float2
; Output: EAX = float1 - float2
; ============================================================
__soft_fsub PROC
    ; Inverter sinal de float2 e chamar fadd
    XOR EBX, 80000000h
    JMP __soft_fadd
__soft_fsub ENDP

; ============================================================
; __soft_fmul
; Multiplicação de floats IEEE 754
;
; Input: EAX = float1, EBX = float2
; Output: EAX = float1 * float2
; ============================================================
__soft_fmul PROC
    PUSH ECX
    PUSH EDX
    PUSH ESI
    PUSH EDI
    PUSH EBP
    
    ; Calcular sinal do resultado
    MOV EBP, EAX
    XOR EBP, EBX
    AND EBP, 80000000h          ; EBP = sign
    
    ; Extrair expoentes
    MOV ECX, EAX
    SHR ECX, 23
    AND ECX, 0FFh               ; ECX = exp1
    
    MOV EDX, EBX
    SHR EDX, 23
    AND EDX, 0FFh               ; EDX = exp2
    
    ; Verificar zeros
    TEST ECX, ECX
    JZ __sf_fmul_zero
    TEST EDX, EDX
    JZ __sf_fmul_zero
    
    ; Calcular novo expoente
    ADD ECX, EDX
    SUB ECX, 127                ; Remover bias extra
    
    ; Extrair mantissas com bit implícito
    MOV ESI, EAX
    AND ESI, 007FFFFFh
    OR ESI, 00800000h           ; ESI = mant1
    
    MOV EDI, EBX
    AND EDI, 007FFFFFh
    OR EDI, 00800000h           ; EDI = mant2
    
    ; Multiplicar mantissas (24-bit x 24-bit = 48-bit)
    ; Usar multiplicação em partes
    MOV EAX, ESI
    MUL EDI                     ; EDX:EAX = mant1 * mant2
    
    ; Normalizar (resultado em bits 46:23 ou 47:24)
    TEST EDX, 00800000h         ; Bit 47 set?
    JZ __sf_fmul_no_shift
    
    ; Shift right 1
    SHRD EAX, EDX, 1
    SHR EDX, 1
    INC ECX
    
__sf_fmul_no_shift:
    ; Pegar bits 46:24 do resultado
    SHRD EAX, EDX, 23
    AND EAX, 007FFFFFh
    
    ; Verificar overflow/underflow
    CMP ECX, 255
    JAE __sf_fmul_overflow
    CMP ECX, 0
    JLE __sf_fmul_underflow
    
    ; Montar resultado
    SHL ECX, 23
    OR EAX, ECX
    OR EAX, EBP
    JMP __sf_fmul_done
    
__sf_fmul_zero:
    MOV EAX, EBP                ; Zero com sinal
    JMP __sf_fmul_done
    
__sf_fmul_overflow:
    MOV EAX, 7F800000h          ; Infinito
    OR EAX, EBP
    JMP __sf_fmul_done
    
__sf_fmul_underflow:
    MOV EAX, EBP                ; Zero
    
__sf_fmul_done:
    POP EBP
    POP EDI
    POP ESI
    POP EDX
    POP ECX
    RET
__soft_fmul ENDP

; ============================================================
; __soft_fdiv
; Divisão de floats IEEE 754
;
; Input: EAX = float1, EBX = float2
; Output: EAX = float1 / float2
; ============================================================
__soft_fdiv PROC
    PUSH ECX
    PUSH EDX
    PUSH ESI
    PUSH EDI
    PUSH EBP
    
    ; Calcular sinal do resultado
    MOV EBP, EAX
    XOR EBP, EBX
    AND EBP, 80000000h
    
    ; Verificar divisão por zero
    MOV EDX, EBX
    AND EDX, 7FFFFFFFh
    TEST EDX, EDX
    JZ __sf_fdiv_inf            ; Divisão por zero = infinito
    
    ; Extrair expoentes
    MOV ECX, EAX
    SHR ECX, 23
    AND ECX, 0FFh
    
    MOV EDX, EBX
    SHR EDX, 23
    AND EDX, 0FFh
    
    ; Verificar zero no numerador
    TEST ECX, ECX
    JZ __sf_fdiv_zero
    
    ; Calcular novo expoente
    SUB ECX, EDX
    ADD ECX, 127                ; Adicionar bias
    
    ; Extrair mantissas
    MOV ESI, EAX
    AND ESI, 007FFFFFh
    OR ESI, 00800000h
    
    MOV EDI, EBX
    AND EDI, 007FFFFFh
    OR EDI, 00800000h
    
    ; Divisão: (mant1 << 24) / mant2
    XOR EDX, EDX
    MOV EAX, ESI
    SHL EAX, 1                  ; Shift para mais precisão
    RCL EDX, 1
    
    ; Divisão 32-bit
    DIV EDI
    
    ; Normalizar
    TEST EAX, 01000000h
    JZ __sf_fdiv_shift_left
    SHR EAX, 1
    INC ECX
    JMP __sf_fdiv_pack
    
__sf_fdiv_shift_left:
    TEST EAX, 00800000h
    JNZ __sf_fdiv_pack
    SHL EAX, 1
    DEC ECX
    JMP __sf_fdiv_shift_left
    
__sf_fdiv_pack:
    AND EAX, 007FFFFFh
    
    ; Verificar overflow/underflow
    CMP ECX, 255
    JAE __sf_fdiv_overflow
    CMP ECX, 0
    JLE __sf_fdiv_underflow
    
    SHL ECX, 23
    OR EAX, ECX
    OR EAX, EBP
    JMP __sf_fdiv_done
    
__sf_fdiv_zero:
    MOV EAX, EBP
    JMP __sf_fdiv_done
    
__sf_fdiv_inf:
    MOV EAX, 7F800000h
    OR EAX, EBP
    JMP __sf_fdiv_done
    
__sf_fdiv_overflow:
    MOV EAX, 7F800000h
    OR EAX, EBP
    JMP __sf_fdiv_done
    
__sf_fdiv_underflow:
    MOV EAX, EBP
    
__sf_fdiv_done:
    POP EBP
    POP EDI
    POP ESI
    POP EDX
    POP ECX
    RET
__soft_fdiv ENDP

; ============================================================
; __soft_fcmp
; Comparação de floats IEEE 754
;
; Input: EAX = float1, EBX = float2
; Output: Flags setadas (ZF, SF, CF)
;         EAX = -1 se float1 < float2
;         EAX = 0 se float1 == float2
;         EAX = 1 se float1 > float2
; ============================================================
__soft_fcmp PROC
    PUSH ECX
    PUSH EDX
    
    ; Tratar como signed integers funciona para floats positivos
    ; Para negativos, precisamos inverter a comparação
    
    MOV ECX, EAX
    MOV EDX, EBX
    
    ; Ambos negativos?
    TEST ECX, 80000000h
    JZ __sf_fcmp_a_pos
    TEST EDX, 80000000h
    JZ __sf_fcmp_diff_sign
    
    ; Ambos negativos - inverter comparação
    XCHG ECX, EDX
    JMP __sf_fcmp_compare
    
__sf_fcmp_a_pos:
    TEST EDX, 80000000h
    JNZ __sf_fcmp_a_greater     ; a positivo, b negativo
    
__sf_fcmp_compare:
    CMP ECX, EDX
    JE __sf_fcmp_equal
    JG __sf_fcmp_a_greater
    
    ; a < b
    MOV EAX, -1
    JMP __sf_fcmp_done
    
__sf_fcmp_equal:
    XOR EAX, EAX
    JMP __sf_fcmp_done
    
__sf_fcmp_a_greater:
    MOV EAX, 1
    JMP __sf_fcmp_done
    
__sf_fcmp_diff_sign:
    ; a negativo, b positivo
    MOV EAX, -1
    
__sf_fcmp_done:
    POP EDX
    POP ECX
    RET
__soft_fcmp ENDP

; ============================================================
; __soft_i2f
; Conversão int32 -> float32
;
; Input: EAX = int32
; Output: EAX = float32
; ============================================================
__soft_i2f PROC
    PUSH ECX
    PUSH EDX
    
    ; Verificar zero
    TEST EAX, EAX
    JZ __sf_i2f_done
    
    ; Salvar sinal
    XOR EDX, EDX
    TEST EAX, EAX
    JNS __sf_i2f_pos
    NEG EAX
    MOV EDX, 80000000h
    
__sf_i2f_pos:
    ; Encontrar MSB
    BSR ECX, EAX                ; ECX = posição do MSB
    
    ; Calcular expoente
    ADD ECX, 127                ; bias
    
    ; Shift mantissa para posição correta
    PUSH ECX
    MOV ECX, 23
    CMP ECX, [ESP]
    SUB ECX, [ESP-4]
    ADD ESP, 4
    
    ; Se precisamos shift left ou right
    POP ECX
    PUSH ECX
    CMP ECX, 150                ; 127 + 23
    JG __sf_i2f_shift_right
    
    ; Shift left
    MOV ECX, 150
    SUB ECX, [ESP]
    SHL EAX, CL
    JMP __sf_i2f_pack
    
__sf_i2f_shift_right:
    MOV ECX, [ESP]
    SUB ECX, 150
    SHR EAX, CL
    
__sf_i2f_pack:
    POP ECX
    AND EAX, 007FFFFFh          ; Remover bit implícito
    SHL ECX, 23
    OR EAX, ECX
    OR EAX, EDX                 ; Adicionar sinal
    
__sf_i2f_done:
    POP EDX
    POP ECX
    RET
__soft_i2f ENDP

; ============================================================
; __soft_f2i
; Conversão float32 -> int32 (truncate)
;
; Input: EAX = float32
; Output: EAX = int32
; ============================================================
__soft_f2i PROC
    PUSH ECX
    PUSH EDX
    
    ; Salvar sinal
    MOV EDX, EAX
    AND EDX, 80000000h
    
    ; Extrair expoente
    MOV ECX, EAX
    SHR ECX, 23
    AND ECX, 0FFh
    
    ; Verificar zero ou muito pequeno
    CMP ECX, 127
    JB __sf_f2i_zero
    
    ; Verificar overflow
    CMP ECX, 158                ; 127 + 31
    JAE __sf_f2i_overflow
    
    ; Extrair mantissa com bit implícito
    AND EAX, 007FFFFFh
    OR EAX, 00800000h
    
    ; Calcular shift
    SUB ECX, 150                ; 127 + 23
    
    ; Shift para posição correta
    TEST ECX, ECX
    JS __sf_f2i_shift_right
    
    ; Shift left
    SHL EAX, CL
    JMP __sf_f2i_sign
    
__sf_f2i_shift_right:
    NEG ECX
    SHR EAX, CL
    
__sf_f2i_sign:
    ; Aplicar sinal
    TEST EDX, EDX
    JZ __sf_f2i_done
    NEG EAX
    JMP __sf_f2i_done
    
__sf_f2i_zero:
    XOR EAX, EAX
    JMP __sf_f2i_done
    
__sf_f2i_overflow:
    ; Retornar MAX_INT ou MIN_INT
    TEST EDX, EDX
    JZ __sf_f2i_max
    MOV EAX, 80000000h          ; MIN_INT
    JMP __sf_f2i_done
__sf_f2i_max:
    MOV EAX, 7FFFFFFFh          ; MAX_INT
    
__sf_f2i_done:
    POP EDX
    POP ECX
    RET
__soft_f2i ENDP



; ============================================================
; GC Timer Stubs (modo protegido 32-bit)
; Timer automático não suportado - usar GC.Collect() manual
; ============================================================

PUBLIC __gc_install_timer
__gc_install_timer PROC
    ; Stub - timer não suportado em modo protegido
    RET
__gc_install_timer ENDP

PUBLIC __gc_uninstall_timer
__gc_uninstall_timer PROC
    ; Stub - timer não suportado em modo protegido
    RET
__gc_uninstall_timer ENDP

PUBLIC __gc_notify_alloc
__gc_notify_alloc PROC
    INC DWORD PTR [__gc_alloc_counter]
    RET
__gc_notify_alloc ENDP



; ============================================================
; __throw_exception
; Lança uma exceção
;
; Input: EAX = ponteiro para objeto de exceção
; ============================================================
PUBLIC __throw_exception
__throw_exception PROC
    MOV [__current_exception], EAX
    
    ; Verificar se há handler registrado
    MOV EBX, [__exception_handler]
    TEST EBX, EBX
    JZ __unhandled_exception
    
    ; Restaurar contexto do handler
    MOV ESP, [EBX]          ; Restaurar ESP
    MOV EBP, [EBX+4]        ; Restaurar EBP
    JMP DWORD PTR [EBX+8]   ; Saltar para handler
    
__throw_exception ENDP

; ============================================================
; __rethrow_exception
; Relança a exceção atual
; ============================================================
PUBLIC __rethrow_exception
__rethrow_exception PROC
    MOV EAX, [__current_exception]
    JMP __throw_exception
__rethrow_exception ENDP

; ============================================================
; __unhandled_exception
; Chamado quando não há handler para a exceção
; ============================================================
PUBLIC __unhandled_exception
__unhandled_exception PROC
    MOV EDX, OFFSET __msg_unhandled
    MOV AH, 09h
    INT 21h
    
    PUSH 1
    CALL __exit
__unhandled_exception ENDP

; ============================================================
; __throw_null_reference
; Lança NullReferenceException
; ============================================================
PUBLIC __throw_null_reference
__throw_null_reference PROC
    MOV EDX, OFFSET __msg_null_ref
    MOV AH, 09h
    INT 21h
    
    PUSH 1
    CALL __exit
__throw_null_reference ENDP

; ============================================================
; __throw_invalid_cast
; Lança InvalidCastException
; ============================================================
PUBLIC __throw_invalid_cast
__throw_invalid_cast PROC
    MOV EDX, OFFSET __msg_invalid_cast
    MOV AH, 09h
    INT 21h
    
    PUSH 1
    CALL __exit
__throw_invalid_cast ENDP

; ============================================================
; __throw_index_out_of_range
; Lança IndexOutOfRangeException
; ============================================================
PUBLIC __throw_index_out_of_range
__throw_index_out_of_range PROC
    MOV EDX, OFFSET __msg_index_range
    MOV AH, 09h
    INT 21h
    
    PUSH 1
    CALL __exit
__throw_index_out_of_range ENDP

; ============================================================
; __push_exception_handler
; Registra um handler de exceção
;
; Input: EAX = endereço do bloco de handler (ESP, EBP, handler addr)
; ============================================================
PUBLIC __push_exception_handler
__push_exception_handler PROC
    ; Salvar handler anterior
    MOV EBX, [__exception_handler]
    MOV [EAX+12], EBX
    
    ; Registrar novo handler
    MOV [__exception_handler], EAX
    RET
__push_exception_handler ENDP

; ============================================================
; __pop_exception_handler
; Remove o handler de exceção atual
; ============================================================
PUBLIC __pop_exception_handler
__pop_exception_handler PROC
    MOV EAX, [__exception_handler]
    TEST EAX, EAX
    JZ __pop_handler_done
    
    ; Restaurar handler anterior
    MOV EBX, [EAX+12]
    MOV [__exception_handler], EBX
    
__pop_handler_done:
    RET
__pop_exception_handler ENDP

; ============================================================
; __get_current_exception
; Retorna a exceção atual
;
; Output: EAX = ponteiro para exceção
; ============================================================
PUBLIC __get_current_exception
__get_current_exception PROC
    MOV EAX, [__current_exception]
    RET
__get_current_exception ENDP

; ============================================================
; __throw_out_of_memory
; Lança OutOfMemoryException
; ============================================================
PUBLIC __throw_out_of_memory
__throw_out_of_memory PROC
    MOV AX, 4C02h
    INT 21h
__throw_out_of_memory ENDP

; ============================================================
; __exit
; Termina o programa
; Input: [ESP+4] = código de saída
; ============================================================
PUBLIC __exit
__exit PROC
    MOV EAX, [ESP+4]
    MOV AH, 4Ch
    INT 21h
__exit ENDP



; __write - escreve no arquivo/stdout
; Input: [ESP+4]=handle, [ESP+8]=buffer, [ESP+12]=count
; Output: EAX = bytes escritos ou -1 em erro
PUBLIC __write
__write PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ECX
    PUSH EDX
    
    MOV EBX, [EBP+8]        ; handle
    MOV EDX, [EBP+12]       ; buffer
    MOV ECX, [EBP+16]       ; count
    MOV AH, 40h             ; DOS write file
    INT 21h
    JC __write_error
    MOVZX EAX, AX
    JMP __write_done
__write_error:
    MOV EAX, -1
__write_done:
    POP EDX
    POP ECX
    POP EBX
    POP EBP
    RET
__write ENDP

; _read - lê do arquivo/stdin
; Input: [ESP+4]=handle, [ESP+8]=buffer, [ESP+12]=count
; Output: EAX = bytes lidos ou -1 em erro
PUBLIC __read
__read PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ECX
    PUSH EDX
    
    MOV EBX, [EBP+8]        ; handle
    MOV EDX, [EBP+12]       ; buffer
    MOV ECX, [EBP+16]       ; count
    MOV AH, 3Fh             ; DOS read file
    INT 21h
    JC __read_error
    MOVZX EAX, AX
    JMP __read_done
__read_error:
    MOV EAX, -1
__read_done:
    POP EDX
    POP ECX
    POP EBX
    POP EBP
    RET
__read ENDP

; _getch - lê um caractere sem echo
; Output: EAX = caractere lido
PUBLIC __getch
__getch PROC
    MOV AH, 08h             ; DOS read char no echo
    INT 21h
    MOVZX EAX, AL
    RET
__getch ENDP

; _kbhit - verifica se há tecla pressionada
; Output: EAX = 0 se não, != 0 se sim
PUBLIC __kbhit
__kbhit PROC
    MOV AH, 0Bh             ; DOS check keyboard status
    INT 21h
    MOVZX EAX, AL
    RET
__kbhit ENDP

; _putch - escreve um caractere
; Input: [ESP+4] = caractere
PUBLIC __putch
__putch PROC
    MOV EAX, [ESP+4]
    MOV DL, AL
    MOV AH, 02h             ; DOS write char
    INT 21h
    RET
__putch ENDP


PUBLIC __program_end
__program_end:

; ============================================================
; VTABLES
; ============================================================

; VTable for Microsoft.CodeAnalysis.EmbeddedAttribute
__vtbl_Microsoft_CodeAnalysis_EmbeddedAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Runtime.CompilerServices.RefSafetyRulesAttribute
__vtbl_System_Runtime_CompilerServices_RefSafetyRulesAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Array
__vtbl_System_Array:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Asm386ImplementationAttribute
__vtbl_System_Asm386ImplementationAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Asm386IntrinsicAttribute
__vtbl_System_Asm386IntrinsicAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Asm386LayoutAttribute
__vtbl_System_Asm386LayoutAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.AttributeUsageAttribute
__vtbl_System_AttributeUsageAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Attribute
__vtbl_System_Attribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.AttributeTargets
__vtbl_System_AttributeTargets:
    DD OFFSET __System_Enum_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Enum_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Enum_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.FlagsAttribute
__vtbl_System_FlagsAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Delegate
__vtbl_System_Delegate:
    DD OFFSET __System_Delegate_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Delegate_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.MulticastDelegate
__vtbl_System_MulticastDelegate:
    DD OFFSET __System_Delegate_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Delegate_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Nullable`1
__vtbl_System_Nullable_1:
    DD OFFSET __System_Nullable_1_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Nullable_1_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Nullable_1_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Action
__vtbl_System_Action:
    DD OFFSET __System_Delegate_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Delegate_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Action_Invoke  ; Slot 4: Invoke

; VTable for System.Action`1
__vtbl_System_Action_1:
    DD OFFSET __System_Delegate_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Delegate_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Action_1_Invoke_T0  ; Slot 4: Invoke

; VTable for System.Action`2
__vtbl_System_Action_2:
    DD OFFSET __System_Delegate_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Delegate_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Action_2_Invoke_T0_T1  ; Slot 4: Invoke

; VTable for System.Func`1
__vtbl_System_Func_1:
    DD OFFSET __System_Delegate_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Delegate_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Func_1_Invoke  ; Slot 4: Invoke

; VTable for System.Func`2
__vtbl_System_Func_2:
    DD OFFSET __System_Delegate_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Delegate_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Func_2_Invoke_T0  ; Slot 4: Invoke

; VTable for System.Func`3
__vtbl_System_Func_3:
    DD OFFSET __System_Delegate_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Delegate_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Func_3_Invoke_T0_T1  ; Slot 4: Invoke

; VTable for System.Predicate`1
__vtbl_System_Predicate_1:
    DD OFFSET __System_Delegate_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Delegate_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Predicate_1_Invoke_T0  ; Slot 4: Invoke

; VTable for System.Console
__vtbl_System_Console:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.ConsoleKeyInfo
__vtbl_System_ConsoleKeyInfo:
    DD OFFSET __System_ValueType_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_ValueType_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_ValueType_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.ConsoleKey
__vtbl_System_ConsoleKey:
    DD OFFSET __System_Enum_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Enum_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Enum_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Enum
__vtbl_System_Enum:
    DD OFFSET __System_Enum_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Enum_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Enum_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Exception
__vtbl_System_Exception:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Exception_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Exception_get_Message  ; Slot 4: get_Message

; VTable for System.SystemException
__vtbl_System_SystemException:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Exception_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Exception_get_Message  ; Slot 4: get_Message

; VTable for System.NullReferenceException
__vtbl_System_NullReferenceException:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Exception_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Exception_get_Message  ; Slot 4: get_Message

; VTable for System.InvalidOperationException
__vtbl_System_InvalidOperationException:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Exception_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Exception_get_Message  ; Slot 4: get_Message

; VTable for System.ArgumentException
__vtbl_System_ArgumentException:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Exception_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Exception_get_Message  ; Slot 4: get_Message

; VTable for System.ArgumentNullException
__vtbl_System_ArgumentNullException:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Exception_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Exception_get_Message  ; Slot 4: get_Message

; VTable for System.ArgumentOutOfRangeException
__vtbl_System_ArgumentOutOfRangeException:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Exception_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Exception_get_Message  ; Slot 4: get_Message

; VTable for System.IndexOutOfRangeException
__vtbl_System_IndexOutOfRangeException:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Exception_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Exception_get_Message  ; Slot 4: get_Message

; VTable for System.OutOfMemoryException
__vtbl_System_OutOfMemoryException:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Exception_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Exception_get_Message  ; Slot 4: get_Message

; VTable for System.OverflowException
__vtbl_System_OverflowException:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Exception_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Exception_get_Message  ; Slot 4: get_Message

; VTable for System.DivideByZeroException
__vtbl_System_DivideByZeroException:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Exception_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Exception_get_Message  ; Slot 4: get_Message

; VTable for System.NotSupportedException
__vtbl_System_NotSupportedException:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Exception_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Exception_get_Message  ; Slot 4: get_Message

; VTable for System.NotImplementedException
__vtbl_System_NotImplementedException:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Exception_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Exception_get_Message  ; Slot 4: get_Message

; VTable for System.Object
__vtbl_System_Object:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Boolean
__vtbl_System_Boolean:
    DD OFFSET __System_Boolean_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Boolean_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Boolean_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Char
__vtbl_System_Char:
    DD OFFSET __System_Char_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Char_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Char_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.SByte
__vtbl_System_SByte:
    DD OFFSET __System_SByte_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_SByte_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_SByte_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Byte
__vtbl_System_Byte:
    DD OFFSET __System_Byte_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Byte_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Byte_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Int16
__vtbl_System_Int16:
    DD OFFSET __System_Int16_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Int16_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Int16_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.UInt16
__vtbl_System_UInt16:
    DD OFFSET __System_UInt16_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_UInt16_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_UInt16_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Int32
__vtbl_System_Int32:
    DD OFFSET __System_Int32_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Int32_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Int32_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.UInt32
__vtbl_System_UInt32:
    DD OFFSET __System_UInt32_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_UInt32_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_UInt32_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Int64
__vtbl_System_Int64:
    DD OFFSET __System_Int64_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Int64_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Int64_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.UInt64
__vtbl_System_UInt64:
    DD OFFSET __System_UInt64_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_UInt64_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_UInt64_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Single
__vtbl_System_Single:
    DD OFFSET __System_Single_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Single_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Single_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Double
__vtbl_System_Double:
    DD OFFSET __System_Double_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Double_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Double_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.IntPtr
__vtbl_System_IntPtr:
    DD OFFSET __System_IntPtr_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_IntPtr_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_IntPtr_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.UIntPtr
__vtbl_System_UIntPtr:
    DD OFFSET __System_UIntPtr_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_UIntPtr_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_UIntPtr_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Void
__vtbl_System_Void:
    DD OFFSET __System_ValueType_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_ValueType_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_ValueType_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.RuntimeHelpers
__vtbl_System_RuntimeHelpers:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.RuntimeTypeHandle
__vtbl_System_RuntimeTypeHandle:
    DD OFFSET __System_ValueType_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_ValueType_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_ValueType_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.String
__vtbl_System_String:
    DD OFFSET __System_String_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_String_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_String_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Type
__vtbl_System_Type:
    DD OFFSET __System_Type_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Type_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Type_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_Type_get_Name  ; Slot 4: get_Name
    DD OFFSET __System_Type_get_Namespace  ; Slot 5: get_Namespace
    DD OFFSET __System_Type_get_FullName  ; Slot 6: get_FullName
    DD OFFSET __System_Type_get_BaseType  ; Slot 7: get_BaseType
    DD OFFSET __System_Type_get_IsValueType  ; Slot 8: get_IsValueType
    DD OFFSET __System_Type_get_IsClass  ; Slot 9: get_IsClass
    DD OFFSET __System_Type_get_IsInterface  ; Slot 10: get_IsInterface
    DD OFFSET __System_Type_get_IsEnum  ; Slot 11: get_IsEnum
    DD OFFSET __System_Type_get_IsArray  ; Slot 12: get_IsArray

; VTable for System.RuntimeType
__vtbl_System_RuntimeType:
    DD OFFSET __System_Type_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Type_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Type_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __System_RuntimeType_get_Name  ; Slot 4: get_Name
    DD OFFSET __System_RuntimeType_get_Namespace  ; Slot 5: get_Namespace
    DD OFFSET __System_RuntimeType_get_FullName  ; Slot 6: get_FullName
    DD OFFSET __System_RuntimeType_get_BaseType  ; Slot 7: get_BaseType
    DD OFFSET __System_RuntimeType_get_IsValueType  ; Slot 8: get_IsValueType
    DD OFFSET __System_RuntimeType_get_IsClass  ; Slot 9: get_IsClass
    DD OFFSET __System_RuntimeType_get_IsInterface  ; Slot 10: get_IsInterface
    DD OFFSET __System_RuntimeType_get_IsEnum  ; Slot 11: get_IsEnum
    DD OFFSET __System_RuntimeType_get_IsArray  ; Slot 12: get_IsArray

; VTable for System.ValueType
__vtbl_System_ValueType:
    DD OFFSET __System_ValueType_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_ValueType_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_ValueType_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Diagnostics.CodeAnalysis.SetsRequiredMembersAttribute
__vtbl_System_Diagnostics_CodeAnalysis_SetsRequiredMembersAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Runtime.InteropServices.OutAttribute
__vtbl_System_Runtime_InteropServices_OutAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Runtime.InteropServices.InAttribute
__vtbl_System_Runtime_InteropServices_InAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Runtime.CompilerServices.CompilerGeneratedAttribute
__vtbl_System_Runtime_CompilerServices_CompilerGeneratedAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Runtime.CompilerServices.CallerMemberNameAttribute
__vtbl_System_Runtime_CompilerServices_CallerMemberNameAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Runtime.CompilerServices.CallerFilePathAttribute
__vtbl_System_Runtime_CompilerServices_CallerFilePathAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Runtime.CompilerServices.CallerLineNumberAttribute
__vtbl_System_Runtime_CompilerServices_CallerLineNumberAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Runtime.CompilerServices.IsExternalInit
__vtbl_System_Runtime_CompilerServices_IsExternalInit:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Runtime.CompilerServices.RequiredMemberAttribute
__vtbl_System_Runtime_CompilerServices_RequiredMemberAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Runtime.CompilerServices.CompilerFeatureRequiredAttribute
__vtbl_System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Runtime.CompilerServices.NullableContextAttribute
__vtbl_System_Runtime_CompilerServices_NullableContextAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Runtime.CompilerServices.NullableAttribute
__vtbl_System_Runtime_CompilerServices_NullableAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for System.Reflection.DefaultMemberAttribute
__vtbl_System_Reflection_DefaultMemberAttribute:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for TypeFlags
__vtbl_TypeFlags:
    DD OFFSET __System_Enum_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Enum_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Enum_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize


; ============================================================
; METADATA TABLES
; ============================================================

; Metadata Header
__metadata_header:
    DD 080386E4Eh           ; Magic (0x80386NET)
    DW 1                    ; MajorVersion
    DW 0                    ; MinorVersion
    DD 0                    ; Flags
    DD 73       ; TypeCount
    DD 273     ; MethodCount
    DD 110      ; FieldCount
    DD 0                    ; PropertyCount
    DD OFFSET __metadata_types    ; TypeTableOffset
    DD OFFSET __metadata_methods  ; MethodTableOffset
    DD OFFSET __metadata_fields   ; FieldTableOffset
    DD OFFSET __string_heap       ; StringHeapOffset

; Type Definition Table
__metadata_types:
    ; Type: Microsoft.CodeAnalysis.EmbeddedAttribute
    DD 0         ; NameOffset
    DD 18           ; NamespaceOffset
    DD 4098   ; Flags
    DD 7      ; BaseTypeIndex
    DD 0         ; FieldListStart
    DD 0  ; FieldCount
    DD 0        ; MethodListStart
    DD 1 ; MethodCount
    DD 0  ; InstanceSize
    DD OFFSET __vtbl_Microsoft_CodeAnalysis_EmbeddedAttribute ; VTableOffset
    ; Type: System.Runtime.CompilerServices.RefSafetyRulesAttribute
    DD 41         ; NameOffset
    DD 65           ; NamespaceOffset
    DD 4098   ; Flags
    DD 7      ; BaseTypeIndex
    DD 0         ; FieldListStart
    DD 1  ; FieldCount
    DD 1        ; MethodListStart
    DD 1 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_Runtime_CompilerServices_RefSafetyRulesAttribute ; VTableOffset
    ; Type: System.Array
    DD 97         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4101   ; Flags
    DD 37      ; BaseTypeIndex
    DD 1         ; FieldListStart
    DD 1  ; FieldCount
    DD 2        ; MethodListStart
    DD 9 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_Array ; VTableOffset
    ; Type: System.Asm386ImplementationAttribute
    DD 110         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 2         ; FieldListStart
    DD 2  ; FieldCount
    DD 11        ; MethodListStart
    DD 4 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_Asm386ImplementationAttribute ; VTableOffset
    ; Type: System.Asm386IntrinsicAttribute
    DD 140         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 4         ; FieldListStart
    DD 1  ; FieldCount
    DD 15        ; MethodListStart
    DD 2 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_Asm386IntrinsicAttribute ; VTableOffset
    ; Type: System.Asm386LayoutAttribute
    DD 165         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 5         ; FieldListStart
    DD 2  ; FieldCount
    DD 17        ; MethodListStart
    DD 5 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_Asm386LayoutAttribute ; VTableOffset
    ; Type: System.AttributeUsageAttribute
    DD 187         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 7         ; FieldListStart
    DD 3  ; FieldCount
    DD 22        ; MethodListStart
    DD 6 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_AttributeUsageAttribute ; VTableOffset
    ; Type: System.Attribute
    DD 211         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4101   ; Flags
    DD 37      ; BaseTypeIndex
    DD 10         ; FieldListStart
    DD 0  ; FieldCount
    DD 28        ; MethodListStart
    DD 1 ; MethodCount
    DD 0  ; InstanceSize
    DD OFFSET __vtbl_System_Attribute ; VTableOffset
    ; Type: System.AttributeTargets
    DD 221         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 3   ; Flags
    DD 23      ; BaseTypeIndex
    DD 10         ; FieldListStart
    DD 17  ; FieldCount
    DD 29        ; MethodListStart
    DD 0 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_AttributeTargets ; VTableOffset
    ; Type: System.FlagsAttribute
    DD 238         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 27         ; FieldListStart
    DD 0  ; FieldCount
    DD 29        ; MethodListStart
    DD 1 ; MethodCount
    DD 0  ; InstanceSize
    DD OFFSET __vtbl_System_FlagsAttribute ; VTableOffset
    ; Type: System.Delegate
    DD 253         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4101   ; Flags
    DD 37      ; BaseTypeIndex
    DD 27         ; FieldListStart
    DD 2  ; FieldCount
    DD 30        ; MethodListStart
    DD 4 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_Delegate ; VTableOffset
    ; Type: System.MulticastDelegate
    DD 262         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4101   ; Flags
    DD 10      ; BaseTypeIndex
    DD 29         ; FieldListStart
    DD 1  ; FieldCount
    DD 34        ; MethodListStart
    DD 1 ; MethodCount
    DD 12  ; InstanceSize
    DD OFFSET __vtbl_System_MulticastDelegate ; VTableOffset
    ; Type: System.Nullable`1
    DD 280         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 30         ; FieldListStart
    DD 2  ; FieldCount
    DD 35        ; MethodListStart
    DD 8 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_Nullable_1 ; VTableOffset
    ; Type: System.Action
    DD 291         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 3   ; Flags
    DD 11      ; BaseTypeIndex
    DD 32         ; FieldListStart
    DD 0  ; FieldCount
    DD 43        ; MethodListStart
    DD 2 ; MethodCount
    DD 12  ; InstanceSize
    DD OFFSET __vtbl_System_Action ; VTableOffset
    ; Type: System.Action`1
    DD 298         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 3   ; Flags
    DD 11      ; BaseTypeIndex
    DD 32         ; FieldListStart
    DD 0  ; FieldCount
    DD 45        ; MethodListStart
    DD 2 ; MethodCount
    DD 12  ; InstanceSize
    DD OFFSET __vtbl_System_Action_1 ; VTableOffset
    ; Type: System.Action`2
    DD 307         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 3   ; Flags
    DD 11      ; BaseTypeIndex
    DD 32         ; FieldListStart
    DD 0  ; FieldCount
    DD 47        ; MethodListStart
    DD 2 ; MethodCount
    DD 12  ; InstanceSize
    DD OFFSET __vtbl_System_Action_2 ; VTableOffset
    ; Type: System.Func`1
    DD 316         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 3   ; Flags
    DD 11      ; BaseTypeIndex
    DD 32         ; FieldListStart
    DD 0  ; FieldCount
    DD 49        ; MethodListStart
    DD 2 ; MethodCount
    DD 12  ; InstanceSize
    DD OFFSET __vtbl_System_Func_1 ; VTableOffset
    ; Type: System.Func`2
    DD 323         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 3   ; Flags
    DD 11      ; BaseTypeIndex
    DD 32         ; FieldListStart
    DD 0  ; FieldCount
    DD 51        ; MethodListStart
    DD 2 ; MethodCount
    DD 12  ; InstanceSize
    DD OFFSET __vtbl_System_Func_2 ; VTableOffset
    ; Type: System.Func`3
    DD 330         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 3   ; Flags
    DD 11      ; BaseTypeIndex
    DD 32         ; FieldListStart
    DD 0  ; FieldCount
    DD 53        ; MethodListStart
    DD 2 ; MethodCount
    DD 12  ; InstanceSize
    DD OFFSET __vtbl_System_Func_3 ; VTableOffset
    ; Type: System.Predicate`1
    DD 337         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 3   ; Flags
    DD 11      ; BaseTypeIndex
    DD 32         ; FieldListStart
    DD 0  ; FieldCount
    DD 55        ; MethodListStart
    DD 2 ; MethodCount
    DD 12  ; InstanceSize
    DD OFFSET __vtbl_System_Predicate_1 ; VTableOffset
    ; Type: System.Console
    DD 349         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4103   ; Flags
    DD 37      ; BaseTypeIndex
    DD 32         ; FieldListStart
    DD 0  ; FieldCount
    DD 57        ; MethodListStart
    DD 17 ; MethodCount
    DD 0  ; InstanceSize
    DD OFFSET __vtbl_System_Console ; VTableOffset
    ; Type: System.ConsoleKeyInfo
    DD 357         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 32         ; FieldListStart
    DD 5  ; FieldCount
    DD 74        ; MethodListStart
    DD 0 ; MethodCount
    DD 12  ; InstanceSize
    DD OFFSET __vtbl_System_ConsoleKeyInfo ; VTableOffset
    ; Type: System.ConsoleKey
    DD 372         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 3   ; Flags
    DD 23      ; BaseTypeIndex
    DD 37         ; FieldListStart
    DD 7  ; FieldCount
    DD 74        ; MethodListStart
    DD 0 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_ConsoleKey ; VTableOffset
    ; Type: System.Enum
    DD 383         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4101   ; Flags
    DD 58      ; BaseTypeIndex
    DD 44         ; FieldListStart
    DD 0  ; FieldCount
    DD 74        ; MethodListStart
    DD 4 ; MethodCount
    DD 0  ; InstanceSize
    DD OFFSET __vtbl_System_Enum ; VTableOffset
    ; Type: System.Exception
    DD 388         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4097   ; Flags
    DD 37      ; BaseTypeIndex
    DD 44         ; FieldListStart
    DD 2  ; FieldCount
    DD 78        ; MethodListStart
    DD 6 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_Exception ; VTableOffset
    ; Type: System.SystemException
    DD 398         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4097   ; Flags
    DD 24      ; BaseTypeIndex
    DD 46         ; FieldListStart
    DD 0  ; FieldCount
    DD 84        ; MethodListStart
    DD 3 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_SystemException ; VTableOffset
    ; Type: System.NullReferenceException
    DD 414         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4097   ; Flags
    DD 25      ; BaseTypeIndex
    DD 46         ; FieldListStart
    DD 0  ; FieldCount
    DD 87        ; MethodListStart
    DD 2 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_NullReferenceException ; VTableOffset
    ; Type: System.InvalidOperationException
    DD 437         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4097   ; Flags
    DD 25      ; BaseTypeIndex
    DD 46         ; FieldListStart
    DD 0  ; FieldCount
    DD 89        ; MethodListStart
    DD 2 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_InvalidOperationException ; VTableOffset
    ; Type: System.ArgumentException
    DD 463         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4097   ; Flags
    DD 25      ; BaseTypeIndex
    DD 46         ; FieldListStart
    DD 0  ; FieldCount
    DD 91        ; MethodListStart
    DD 2 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_ArgumentException ; VTableOffset
    ; Type: System.ArgumentNullException
    DD 481         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4097   ; Flags
    DD 28      ; BaseTypeIndex
    DD 46         ; FieldListStart
    DD 0  ; FieldCount
    DD 93        ; MethodListStart
    DD 2 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_ArgumentNullException ; VTableOffset
    ; Type: System.ArgumentOutOfRangeException
    DD 503         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4097   ; Flags
    DD 28      ; BaseTypeIndex
    DD 46         ; FieldListStart
    DD 0  ; FieldCount
    DD 95        ; MethodListStart
    DD 2 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_ArgumentOutOfRangeException ; VTableOffset
    ; Type: System.IndexOutOfRangeException
    DD 531         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4097   ; Flags
    DD 25      ; BaseTypeIndex
    DD 46         ; FieldListStart
    DD 0  ; FieldCount
    DD 97        ; MethodListStart
    DD 2 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_IndexOutOfRangeException ; VTableOffset
    ; Type: System.OutOfMemoryException
    DD 556         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4097   ; Flags
    DD 25      ; BaseTypeIndex
    DD 46         ; FieldListStart
    DD 0  ; FieldCount
    DD 99        ; MethodListStart
    DD 2 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_OutOfMemoryException ; VTableOffset
    ; Type: System.OverflowException
    DD 577         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4097   ; Flags
    DD 25      ; BaseTypeIndex
    DD 46         ; FieldListStart
    DD 0  ; FieldCount
    DD 101        ; MethodListStart
    DD 2 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_OverflowException ; VTableOffset
    ; Type: System.DivideByZeroException
    DD 595         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4097   ; Flags
    DD 25      ; BaseTypeIndex
    DD 46         ; FieldListStart
    DD 0  ; FieldCount
    DD 103        ; MethodListStart
    DD 2 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_DivideByZeroException ; VTableOffset
    ; Type: System.NotSupportedException
    DD 617         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4097   ; Flags
    DD 25      ; BaseTypeIndex
    DD 46         ; FieldListStart
    DD 0  ; FieldCount
    DD 105        ; MethodListStart
    DD 2 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_NotSupportedException ; VTableOffset
    ; Type: System.NotImplementedException
    DD 639         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4097   ; Flags
    DD 25      ; BaseTypeIndex
    DD 46         ; FieldListStart
    DD 0  ; FieldCount
    DD 107        ; MethodListStart
    DD 2 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_NotImplementedException ; VTableOffset
    ; Type: System.Object
    DD 663         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4097   ; Flags
    DD 4294967295      ; BaseTypeIndex
    DD 46         ; FieldListStart
    DD 0  ; FieldCount
    DD 109        ; MethodListStart
    DD 9 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_Object ; VTableOffset
    ; Type: System.Boolean
    DD 670         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 46         ; FieldListStart
    DD 1  ; FieldCount
    DD 118        ; MethodListStart
    DD 3 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_Boolean ; VTableOffset
    ; Type: System.Char
    DD 678         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 47         ; FieldListStart
    DD 1  ; FieldCount
    DD 121        ; MethodListStart
    DD 11 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_Char ; VTableOffset
    ; Type: System.SByte
    DD 683         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 48         ; FieldListStart
    DD 3  ; FieldCount
    DD 132        ; MethodListStart
    DD 3 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_SByte ; VTableOffset
    ; Type: System.Byte
    DD 689         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 51         ; FieldListStart
    DD 3  ; FieldCount
    DD 135        ; MethodListStart
    DD 3 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_Byte ; VTableOffset
    ; Type: System.Int16
    DD 694         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 54         ; FieldListStart
    DD 3  ; FieldCount
    DD 138        ; MethodListStart
    DD 3 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_Int16 ; VTableOffset
    ; Type: System.UInt16
    DD 700         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 57         ; FieldListStart
    DD 3  ; FieldCount
    DD 141        ; MethodListStart
    DD 3 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_UInt16 ; VTableOffset
    ; Type: System.Int32
    DD 707         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 60         ; FieldListStart
    DD 3  ; FieldCount
    DD 144        ; MethodListStart
    DD 4 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_Int32 ; VTableOffset
    ; Type: System.UInt32
    DD 713         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 63         ; FieldListStart
    DD 3  ; FieldCount
    DD 148        ; MethodListStart
    DD 3 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_UInt32 ; VTableOffset
    ; Type: System.Int64
    DD 720         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 66         ; FieldListStart
    DD 3  ; FieldCount
    DD 151        ; MethodListStart
    DD 3 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_Int64 ; VTableOffset
    ; Type: System.UInt64
    DD 726         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 69         ; FieldListStart
    DD 3  ; FieldCount
    DD 154        ; MethodListStart
    DD 3 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_UInt64 ; VTableOffset
    ; Type: System.Single
    DD 733         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 72         ; FieldListStart
    DD 7  ; FieldCount
    DD 157        ; MethodListStart
    DD 5 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_Single ; VTableOffset
    ; Type: System.Double
    DD 740         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 79         ; FieldListStart
    DD 7  ; FieldCount
    DD 162        ; MethodListStart
    DD 5 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_Double ; VTableOffset
    ; Type: System.IntPtr
    DD 747         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 86         ; FieldListStart
    DD 2  ; FieldCount
    DD 167        ; MethodListStart
    DD 9 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_IntPtr ; VTableOffset
    ; Type: System.UIntPtr
    DD 754         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 88         ; FieldListStart
    DD 2  ; FieldCount
    DD 176        ; MethodListStart
    DD 9 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_UIntPtr ; VTableOffset
    ; Type: System.Void
    DD 762         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 90         ; FieldListStart
    DD 0  ; FieldCount
    DD 185        ; MethodListStart
    DD 0 ; MethodCount
    DD 0  ; InstanceSize
    DD OFFSET __vtbl_System_Void ; VTableOffset
    ; Type: System.RuntimeHelpers
    DD 767         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4103   ; Flags
    DD 37      ; BaseTypeIndex
    DD 90         ; FieldListStart
    DD 0  ; FieldCount
    DD 185        ; MethodListStart
    DD 23 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_RuntimeHelpers ; VTableOffset
    ; Type: System.RuntimeTypeHandle
    DD 782         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 58      ; BaseTypeIndex
    DD 90         ; FieldListStart
    DD 1  ; FieldCount
    DD 208        ; MethodListStart
    DD 1 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_RuntimeTypeHandle ; VTableOffset
    ; Type: System.String
    DD 800         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4099   ; Flags
    DD 37      ; BaseTypeIndex
    DD 91         ; FieldListStart
    DD 3  ; FieldCount
    DD 209        ; MethodListStart
    DD 16 ; MethodCount
    DD 12  ; InstanceSize
    DD OFFSET __vtbl_System_String ; VTableOffset
    ; Type: System.Type
    DD 807         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4101   ; Flags
    DD 37      ; BaseTypeIndex
    DD 94         ; FieldListStart
    DD 0  ; FieldCount
    DD 225        ; MethodListStart
    DD 16 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_Type ; VTableOffset
    ; Type: System.RuntimeType
    DD 812         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4098   ; Flags
    DD 56      ; BaseTypeIndex
    DD 94         ; FieldListStart
    DD 5  ; FieldCount
    DD 241        ; MethodListStart
    DD 11 ; MethodCount
    DD 24  ; InstanceSize
    DD OFFSET __vtbl_System_RuntimeType ; VTableOffset
    ; Type: System.ValueType
    DD 824         ; NameOffset
    DD 103           ; NamespaceOffset
    DD 4101   ; Flags
    DD 37      ; BaseTypeIndex
    DD 99         ; FieldListStart
    DD 0  ; FieldCount
    DD 252        ; MethodListStart
    DD 4 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_ValueType ; VTableOffset
    ; Type: System.Diagnostics.CodeAnalysis.SetsRequiredMembersAttribute
    DD 834         ; NameOffset
    DD 863           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 99         ; FieldListStart
    DD 0  ; FieldCount
    DD 256        ; MethodListStart
    DD 1 ; MethodCount
    DD 0  ; InstanceSize
    DD OFFSET __vtbl_System_Diagnostics_CodeAnalysis_SetsRequiredMembersAttribute ; VTableOffset
    ; Type: System.Runtime.InteropServices.OutAttribute
    DD 895         ; NameOffset
    DD 908           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 99         ; FieldListStart
    DD 0  ; FieldCount
    DD 257        ; MethodListStart
    DD 1 ; MethodCount
    DD 0  ; InstanceSize
    DD OFFSET __vtbl_System_Runtime_InteropServices_OutAttribute ; VTableOffset
    ; Type: System.Runtime.InteropServices.InAttribute
    DD 939         ; NameOffset
    DD 908           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 99         ; FieldListStart
    DD 0  ; FieldCount
    DD 258        ; MethodListStart
    DD 1 ; MethodCount
    DD 0  ; InstanceSize
    DD OFFSET __vtbl_System_Runtime_InteropServices_InAttribute ; VTableOffset
    ; Type: System.Runtime.CompilerServices.CompilerGeneratedAttribute
    DD 951         ; NameOffset
    DD 65           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 99         ; FieldListStart
    DD 0  ; FieldCount
    DD 259        ; MethodListStart
    DD 1 ; MethodCount
    DD 0  ; InstanceSize
    DD OFFSET __vtbl_System_Runtime_CompilerServices_CompilerGeneratedAttribute ; VTableOffset
    ; Type: System.Runtime.CompilerServices.CallerMemberNameAttribute
    DD 978         ; NameOffset
    DD 65           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 99         ; FieldListStart
    DD 0  ; FieldCount
    DD 260        ; MethodListStart
    DD 1 ; MethodCount
    DD 0  ; InstanceSize
    DD OFFSET __vtbl_System_Runtime_CompilerServices_CallerMemberNameAttribute ; VTableOffset
    ; Type: System.Runtime.CompilerServices.CallerFilePathAttribute
    DD 1004         ; NameOffset
    DD 65           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 99         ; FieldListStart
    DD 0  ; FieldCount
    DD 261        ; MethodListStart
    DD 1 ; MethodCount
    DD 0  ; InstanceSize
    DD OFFSET __vtbl_System_Runtime_CompilerServices_CallerFilePathAttribute ; VTableOffset
    ; Type: System.Runtime.CompilerServices.CallerLineNumberAttribute
    DD 1028         ; NameOffset
    DD 65           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 99         ; FieldListStart
    DD 0  ; FieldCount
    DD 262        ; MethodListStart
    DD 1 ; MethodCount
    DD 0  ; InstanceSize
    DD OFFSET __vtbl_System_Runtime_CompilerServices_CallerLineNumberAttribute ; VTableOffset
    ; Type: System.Runtime.CompilerServices.IsExternalInit
    DD 1054         ; NameOffset
    DD 65           ; NamespaceOffset
    DD 4103   ; Flags
    DD 37      ; BaseTypeIndex
    DD 99         ; FieldListStart
    DD 0  ; FieldCount
    DD 263        ; MethodListStart
    DD 0 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_Runtime_CompilerServices_IsExternalInit ; VTableOffset
    ; Type: System.Runtime.CompilerServices.RequiredMemberAttribute
    DD 1069         ; NameOffset
    DD 65           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 99         ; FieldListStart
    DD 0  ; FieldCount
    DD 263        ; MethodListStart
    DD 1 ; MethodCount
    DD 0  ; InstanceSize
    DD OFFSET __vtbl_System_Runtime_CompilerServices_RequiredMemberAttribute ; VTableOffset
    ; Type: System.Runtime.CompilerServices.CompilerFeatureRequiredAttribute
    DD 1093         ; NameOffset
    DD 65           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 99         ; FieldListStart
    DD 2  ; FieldCount
    DD 264        ; MethodListStart
    DD 4 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute ; VTableOffset
    ; Type: System.Runtime.CompilerServices.NullableContextAttribute
    DD 1126         ; NameOffset
    DD 65           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 101         ; FieldListStart
    DD 1  ; FieldCount
    DD 268        ; MethodListStart
    DD 1 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_Runtime_CompilerServices_NullableContextAttribute ; VTableOffset
    ; Type: System.Runtime.CompilerServices.NullableAttribute
    DD 1151         ; NameOffset
    DD 65           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 102         ; FieldListStart
    DD 1  ; FieldCount
    DD 269        ; MethodListStart
    DD 2 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_Runtime_CompilerServices_NullableAttribute ; VTableOffset
    ; Type: System.Reflection.DefaultMemberAttribute
    DD 1169         ; NameOffset
    DD 1192           ; NamespaceOffset
    DD 4099   ; Flags
    DD 7      ; BaseTypeIndex
    DD 103         ; FieldListStart
    DD 1  ; FieldCount
    DD 271        ; MethodListStart
    DD 2 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_System_Reflection_DefaultMemberAttribute ; VTableOffset
    ; Type: TypeFlags
    DD 1210         ; NameOffset
    DD 1220           ; NamespaceOffset
    DD 3   ; Flags
    DD 23      ; BaseTypeIndex
    DD 104         ; FieldListStart
    DD 6  ; FieldCount
    DD 273        ; MethodListStart
    DD 0 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_TypeFlags ; VTableOffset

; Method Definition Table
__metadata_methods:
    ; Method: EmbeddedAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __Microsoft_CodeAnalysis_EmbeddedAttribute__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: RefSafetyRulesAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 1 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Runtime_CompilerServices_RefSafetyRulesAttribute__ctor_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Array.get_Length
    DD 1227         ; NameOffset
    DD 517 ; Flags
    DD 2 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Array_get_Length ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Array.GetLength
    DD 1238         ; NameOffset
    DD 5 ; Flags
    DD 2 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 2     ; LocalCount
    DD OFFSET __System_Array_GetLength_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Array.get_Rank
    DD 1248         ; NameOffset
    DD 517 ; Flags
    DD 2 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Array_get_Rank ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Array.Copy
    DD 1257         ; NameOffset
    DD 21 ; Flags
    DD 2 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 3 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Array_Copy_Array_Array_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Array.Copy
    DD 1257         ; NameOffset
    DD 21 ; Flags
    DD 2 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 5 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Array_Copy_Array_Int32_Array_Int32_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Array.Clear
    DD 1262         ; NameOffset
    DD 21 ; Flags
    DD 2 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 3 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Array_Clear_Array_Int32_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Array.IndexOf
    DD 1268         ; NameOffset
    DD 21 ; Flags
    DD 2 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Array_IndexOf_Array_Object ; CodeOffset
    DW 65535 ; VTableSlot
    DW 4    ; StackSize
    ; Method: Array.IndexOf
    DD 1268         ; NameOffset
    DD 21 ; Flags
    DD 2 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 4 ; ParamCount
    DW 4     ; LocalCount
    DD OFFSET __System_Array_IndexOf_Array_Object_Int32_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 3    ; StackSize
    ; Method: Array..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 2 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Array__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Asm386ImplementationAttribute.get_Assembly
    DD 1276         ; NameOffset
    DD 517 ; Flags
    DD 3 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Asm386ImplementationAttribute_get_Assembly ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Asm386ImplementationAttribute.get_SoftFloatAssembly
    DD 1289         ; NameOffset
    DD 517 ; Flags
    DD 3 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Asm386ImplementationAttribute_get_SoftFloatAssembly ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Asm386ImplementationAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 3 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Asm386ImplementationAttribute__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Asm386ImplementationAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 3 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Asm386ImplementationAttribute__ctor_String_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Asm386IntrinsicAttribute.get_IntrinsicName
    DD 1311         ; NameOffset
    DD 517 ; Flags
    DD 4 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Asm386IntrinsicAttribute_get_IntrinsicName ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Asm386IntrinsicAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 4 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Asm386IntrinsicAttribute__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Asm386LayoutAttribute.get_Size
    DD 1329         ; NameOffset
    DD 517 ; Flags
    DD 5 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Asm386LayoutAttribute_get_Size ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Asm386LayoutAttribute.set_Size
    DD 1338         ; NameOffset
    DD 517 ; Flags
    DD 5 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Asm386LayoutAttribute_set_Size_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Asm386LayoutAttribute.get_Alignment
    DD 1347         ; NameOffset
    DD 517 ; Flags
    DD 5 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Asm386LayoutAttribute_get_Alignment ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Asm386LayoutAttribute.set_Alignment
    DD 1361         ; NameOffset
    DD 517 ; Flags
    DD 5 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Asm386LayoutAttribute_set_Alignment_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Asm386LayoutAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 5 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Asm386LayoutAttribute__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: AttributeUsageAttribute.get_ValidOn
    DD 1375         ; NameOffset
    DD 517 ; Flags
    DD 6 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_AttributeUsageAttribute_get_ValidOn ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: AttributeUsageAttribute.get_AllowMultiple
    DD 1387         ; NameOffset
    DD 517 ; Flags
    DD 6 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_AttributeUsageAttribute_get_AllowMultiple ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: AttributeUsageAttribute.set_AllowMultiple
    DD 1405         ; NameOffset
    DD 517 ; Flags
    DD 6 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_AttributeUsageAttribute_set_AllowMultiple_Boolean ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: AttributeUsageAttribute.get_Inherited
    DD 1423         ; NameOffset
    DD 517 ; Flags
    DD 6 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_AttributeUsageAttribute_get_Inherited ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: AttributeUsageAttribute.set_Inherited
    DD 1437         ; NameOffset
    DD 517 ; Flags
    DD 6 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_AttributeUsageAttribute_set_Inherited_Boolean ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: AttributeUsageAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 6 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_AttributeUsageAttribute__ctor_AttributeTargets ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Attribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 7 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Attribute__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: FlagsAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 9 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_FlagsAttribute__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Delegate.get_Target
    DD 1451         ; NameOffset
    DD 517 ; Flags
    DD 10 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Delegate_get_Target ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Delegate.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 10 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 3     ; LocalCount
    DD OFFSET __System_Delegate_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Delegate.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 10 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Delegate_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Delegate..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 10 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Delegate__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: MulticastDelegate..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 11 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_MulticastDelegate__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Nullable`1.get_HasValue
    DD 1481         ; NameOffset
    DD 517 ; Flags
    DD 12 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Nullable_1_get_HasValue ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Nullable`1.get_Value
    DD 1494         ; NameOffset
    DD 517 ; Flags
    DD 12 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Nullable_1_get_Value ; CodeOffset
    DW 65535 ; VTableSlot
    DW 1    ; StackSize
    ; Method: Nullable`1..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 12 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Nullable_1__ctor_T0 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Nullable`1.GetValueOrDefault
    DD 1504         ; NameOffset
    DD 5 ; Flags
    DD 12 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Nullable_1_GetValueOrDefault ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Nullable`1.GetValueOrDefault
    DD 1504         ; NameOffset
    DD 5 ; Flags
    DD 12 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Nullable_1_GetValueOrDefault_T0 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Nullable`1.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 12 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 4     ; LocalCount
    DD OFFSET __System_Nullable_1_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Nullable`1.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 12 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Nullable_1_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 1    ; StackSize
    ; Method: Nullable`1.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 12 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Nullable_1_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 1    ; StackSize
    ; Method: Action..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 13 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Action__ctor_Object_IntPtr ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Action.Invoke
    DD 1531         ; NameOffset
    DD 293 ; Flags
    DD 13 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Action_Invoke ; CodeOffset
    DW 4 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Action`1..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 14 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Action_1__ctor_Object_IntPtr ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Action`1.Invoke
    DD 1531         ; NameOffset
    DD 293 ; Flags
    DD 14 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Action_1_Invoke_T0 ; CodeOffset
    DW 4 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Action`2..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 15 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Action_2__ctor_Object_IntPtr ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Action`2.Invoke
    DD 1531         ; NameOffset
    DD 293 ; Flags
    DD 15 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Action_2_Invoke_T0_T1 ; CodeOffset
    DW 4 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Func`1..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 16 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Func_1__ctor_Object_IntPtr ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Func`1.Invoke
    DD 1531         ; NameOffset
    DD 293 ; Flags
    DD 16 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Func_1_Invoke ; CodeOffset
    DW 4 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Func`2..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 17 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Func_2__ctor_Object_IntPtr ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Func`2.Invoke
    DD 1531         ; NameOffset
    DD 293 ; Flags
    DD 17 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Func_2_Invoke_T0 ; CodeOffset
    DW 4 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Func`3..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 18 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Func_3__ctor_Object_IntPtr ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Func`3.Invoke
    DD 1531         ; NameOffset
    DD 293 ; Flags
    DD 18 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Func_3_Invoke_T0_T1 ; CodeOffset
    DW 4 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Predicate`1..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 19 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Predicate_1__ctor_Object_IntPtr ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Predicate`1.Invoke
    DD 1531         ; NameOffset
    DD 293 ; Flags
    DD 19 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Predicate_1_Invoke_T0 ; CodeOffset
    DW 4 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Console.Write
    DD 1538         ; NameOffset
    DD 21 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Console_Write_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Console.WriteLine
    DD 1544         ; NameOffset
    DD 21 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Console_WriteLine_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Console.WriteLine
    DD 1544         ; NameOffset
    DD 21 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Console_WriteLine ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Console.Write
    DD 1538         ; NameOffset
    DD 21 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Console_Write_Char ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Console.Write
    DD 1538         ; NameOffset
    DD 21 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Console_Write_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Console.WriteLine
    DD 1544         ; NameOffset
    DD 21 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Console_WriteLine_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Console.Write
    DD 1538         ; NameOffset
    DD 21 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Console_Write_Int64 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Console.WriteLine
    DD 1544         ; NameOffset
    DD 21 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Console_WriteLine_Int64 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Console.Write
    DD 1538         ; NameOffset
    DD 21 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Console_Write_Boolean ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Console.WriteLine
    DD 1544         ; NameOffset
    DD 21 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Console_WriteLine_Boolean ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Console.Write
    DD 1538         ; NameOffset
    DD 21 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Console_Write_Object ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Console.WriteLine
    DD 1544         ; NameOffset
    DD 21 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Console_WriteLine_Object ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Console.Read
    DD 1554         ; NameOffset
    DD 21 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Console_Read ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Console.ReadLine
    DD 1559         ; NameOffset
    DD 21 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Console_ReadLine ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Console.ReadKey
    DD 1568         ; NameOffset
    DD 21 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Console_ReadKey ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Console.CheckKeyAvailable
    DD 1576         ; NameOffset
    DD 21 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Console_CheckKeyAvailable ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Console.get_KeyAvailable
    DD 1594         ; NameOffset
    DD 533 ; Flags
    DD 20 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Console_get_KeyAvailable ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Enum.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 23 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Enum_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 1    ; StackSize
    ; Method: Enum.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 23 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Enum_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Enum.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 23 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Enum_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 1    ; StackSize
    ; Method: Enum..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 23 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Enum__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Exception..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 24 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Exception__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Exception..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 24 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Exception__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Exception..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 24 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Exception__ctor_String_Exception ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Exception.get_Message
    DD 1611         ; NameOffset
    DD 805 ; Flags
    DD 24 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Exception_get_Message ; CodeOffset
    DW 4 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Exception.get_InnerException
    DD 1623         ; NameOffset
    DD 517 ; Flags
    DD 24 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Exception_get_InnerException ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Exception.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 24 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Exception_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 3    ; StackSize
    ; Method: SystemException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 25 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_SystemException__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: SystemException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 25 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_SystemException__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: SystemException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 25 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_SystemException__ctor_String_Exception ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: NullReferenceException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 26 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_NullReferenceException__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: NullReferenceException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 26 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_NullReferenceException__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: InvalidOperationException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 27 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_InvalidOperationException__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: InvalidOperationException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 27 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_InvalidOperationException__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: ArgumentException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 28 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_ArgumentException__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: ArgumentException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 28 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_ArgumentException__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: ArgumentNullException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 29 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_ArgumentNullException__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: ArgumentNullException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 29 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_ArgumentNullException__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: ArgumentOutOfRangeException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 30 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_ArgumentOutOfRangeException__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: ArgumentOutOfRangeException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 30 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_ArgumentOutOfRangeException__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: IndexOutOfRangeException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 31 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_IndexOutOfRangeException__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: IndexOutOfRangeException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 31 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_IndexOutOfRangeException__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: OutOfMemoryException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 32 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_OutOfMemoryException__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: OutOfMemoryException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 32 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_OutOfMemoryException__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: OverflowException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 33 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_OverflowException__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: OverflowException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 33 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_OverflowException__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: DivideByZeroException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 34 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_DivideByZeroException__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: DivideByZeroException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 34 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_DivideByZeroException__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: NotSupportedException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 35 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_NotSupportedException__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: NotSupportedException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 35 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_NotSupportedException__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: NotImplementedException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 36 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_NotImplementedException__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: NotImplementedException..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 36 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_NotImplementedException__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Object.Equals
    DD 1462         ; NameOffset
    DD 293 ; Flags
    DD 37 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Object_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Object.GetHashCode
    DD 1469         ; NameOffset
    DD 293 ; Flags
    DD 37 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Object_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 1    ; StackSize
    ; Method: Object.ToString
    DD 1522         ; NameOffset
    DD 293 ; Flags
    DD 37 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Object_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 1    ; StackSize
    ; Method: Object.GetType
    DD 1642         ; NameOffset
    DD 5 ; Flags
    DD 37 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Object_GetType ; CodeOffset
    DW 65535 ; VTableSlot
    DW 1    ; StackSize
    ; Method: Object.Finalize
    DD 1650         ; NameOffset
    DD 293 ; Flags
    DD 37 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Object_Finalize ; CodeOffset
    DW 3 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Object.MemberwiseClone
    DD 1659         ; NameOffset
    DD 5 ; Flags
    DD 37 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Object_MemberwiseClone ; CodeOffset
    DW 65535 ; VTableSlot
    DW 1    ; StackSize
    ; Method: Object.Equals
    DD 1462         ; NameOffset
    DD 21 ; Flags
    DD 37 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 3     ; LocalCount
    DD OFFSET __System_Object_Equals_Object_Object ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Object.ReferenceEquals
    DD 1675         ; NameOffset
    DD 21 ; Flags
    DD 37 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Object_ReferenceEquals_Object_Object ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Object..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 37 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Object__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Boolean.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 38 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Boolean_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Boolean.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 38 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Boolean_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Boolean.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 38 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Boolean_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Char.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 39 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Char_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Char.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 39 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Char_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Char.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 39 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Char_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Char.IsWhiteSpace
    DD 1691         ; NameOffset
    DD 21 ; Flags
    DD 39 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Char_IsWhiteSpace_Char ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Char.IsDigit
    DD 1704         ; NameOffset
    DD 21 ; Flags
    DD 39 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Char_IsDigit_Char ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Char.IsLetter
    DD 1712         ; NameOffset
    DD 21 ; Flags
    DD 39 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Char_IsLetter_Char ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Char.IsLetterOrDigit
    DD 1721         ; NameOffset
    DD 21 ; Flags
    DD 39 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Char_IsLetterOrDigit_Char ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Char.IsUpper
    DD 1737         ; NameOffset
    DD 21 ; Flags
    DD 39 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Char_IsUpper_Char ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Char.IsLower
    DD 1745         ; NameOffset
    DD 21 ; Flags
    DD 39 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Char_IsLower_Char ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Char.ToUpper
    DD 1753         ; NameOffset
    DD 21 ; Flags
    DD 39 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Char_ToUpper_Char ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Char.ToLower
    DD 1761         ; NameOffset
    DD 21 ; Flags
    DD 39 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Char_ToLower_Char ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: SByte.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 40 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_SByte_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 8    ; StackSize
    ; Method: SByte.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 40 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_SByte_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 8    ; StackSize
    ; Method: SByte.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 40 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_SByte_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Byte.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 41 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Byte_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Byte.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 41 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Byte_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Byte.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 41 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Byte_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Int16.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 42 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Int16_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Int16.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 42 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Int16_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Int16.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 42 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Int16_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: UInt16.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 43 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_UInt16_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 8    ; StackSize
    ; Method: UInt16.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 43 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_UInt16_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 8    ; StackSize
    ; Method: UInt16.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 43 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_UInt16_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Int32.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 44 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Int32_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Int32.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 44 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Int32_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Int32.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 44 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Int32_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Int32.Parse
    DD 1769         ; NameOffset
    DD 21 ; Flags
    DD 44 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Int32_Parse_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: UInt32.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 45 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_UInt32_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 8    ; StackSize
    ; Method: UInt32.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 45 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_UInt32_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 8    ; StackSize
    ; Method: UInt32.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 45 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_UInt32_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Int64.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 46 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Int64_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Int64.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 46 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Int64_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Int64.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 46 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Int64_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: UInt64.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 47 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_UInt64_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 8    ; StackSize
    ; Method: UInt64.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 47 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_UInt64_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 8    ; StackSize
    ; Method: UInt64.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 47 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_UInt64_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Single.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 48 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Single_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Single.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 48 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Single_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Single.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 48 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Single_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Single.IsNaN
    DD 1775         ; NameOffset
    DD 21 ; Flags
    DD 48 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Single_IsNaN_Single ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Single.IsInfinity
    DD 1781         ; NameOffset
    DD 21 ; Flags
    DD 48 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Single_IsInfinity_Single ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Double.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 49 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Double_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Double.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 49 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 2     ; LocalCount
    DD OFFSET __System_Double_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 3    ; StackSize
    ; Method: Double.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 49 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Double_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Double.IsNaN
    DD 1775         ; NameOffset
    DD 21 ; Flags
    DD 49 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Double_IsNaN_Double ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Double.IsInfinity
    DD 1781         ; NameOffset
    DD 21 ; Flags
    DD 49 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Double_IsInfinity_Double ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: IntPtr.get_Size
    DD 1329         ; NameOffset
    DD 533 ; Flags
    DD 50 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_IntPtr_get_Size ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: IntPtr..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 50 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_IntPtr__ctor_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: IntPtr.ToInt32
    DD 1792         ; NameOffset
    DD 5 ; Flags
    DD 50 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_IntPtr_ToInt32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: IntPtr.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 50 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_IntPtr_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 8    ; StackSize
    ; Method: IntPtr.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 50 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_IntPtr_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 8    ; StackSize
    ; Method: IntPtr.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 50 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_IntPtr_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: IntPtr.op_Equality
    DD 1800         ; NameOffset
    DD 533 ; Flags
    DD 50 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_IntPtr_op_Equality_IntPtr_IntPtr ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: IntPtr.op_Inequality
    DD 1812         ; NameOffset
    DD 533 ; Flags
    DD 50 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_IntPtr_op_Inequality_IntPtr_IntPtr ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: IntPtr..cctor
    DD 1826         ; NameOffset
    DD 530 ; Flags
    DD 50 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_IntPtr__cctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: UIntPtr.get_Size
    DD 1329         ; NameOffset
    DD 533 ; Flags
    DD 51 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_UIntPtr_get_Size ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: UIntPtr..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 51 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_UIntPtr__ctor_UInt32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: UIntPtr.ToUInt32
    DD 1833         ; NameOffset
    DD 5 ; Flags
    DD 51 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_UIntPtr_ToUInt32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: UIntPtr.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 51 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_UIntPtr_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 8    ; StackSize
    ; Method: UIntPtr.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 51 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_UIntPtr_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 8    ; StackSize
    ; Method: UIntPtr.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 51 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_UIntPtr_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: UIntPtr.op_Equality
    DD 1800         ; NameOffset
    DD 533 ; Flags
    DD 51 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_UIntPtr_op_Equality_UIntPtr_UIntPtr ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: UIntPtr.op_Inequality
    DD 1812         ; NameOffset
    DD 533 ; Flags
    DD 51 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_UIntPtr_op_Inequality_UIntPtr_UIntPtr ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: UIntPtr..cctor
    DD 1826         ; NameOffset
    DD 530 ; Flags
    DD 51 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_UIntPtr__cctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: RuntimeHelpers.GetHashCode
    DD 1469         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_GetHashCode_Object ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.GetTypeHandle
    DD 1842         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_GetTypeHandle_Object ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.GetTypeFromHandle
    DD 1856         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_GetTypeFromHandle_RuntimeTypeHandle ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.MemberwiseClone
    DD 1659         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_MemberwiseClone_Object ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.ValueTypeEquals
    DD 1874         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_ValueTypeEquals_Object_Object ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.ValueTypeGetHashCode
    DD 1890         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_ValueTypeGetHashCode_Object ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.GetCharAt
    DD 1911         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_GetCharAt_String_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.StringEquals
    DD 1921         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_StringEquals_String_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.StringGetHashCode
    DD 1934         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_StringGetHashCode_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.CopyCharsToString
    DD 1952         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_CopyCharsToString_String_Char__ ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.StringConcat
    DD 1970         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_StringConcat_String_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.CharToString
    DD 1983         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_CharToString_Char ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.Int32ToString
    DD 1996         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 12     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_Int32ToString_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 5    ; StackSize
    ; Method: RuntimeHelpers.UInt32ToString
    DD 2010         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 8     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_UInt32ToString_UInt32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 5    ; StackSize
    ; Method: RuntimeHelpers.Int64ToString
    DD 2025         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_Int64ToString_Int64 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.UInt64ToString
    DD 2039         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_UInt64ToString_UInt64 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.SingleToString
    DD 2054         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_SingleToString_Single ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.DoubleToString
    DD 2069         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_DoubleToString_Double ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.SingleToInt32Bits
    DD 2084         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_SingleToInt32Bits_Single ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.DoubleToInt64Bits
    DD 2102         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_DoubleToInt64Bits_Double ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.ParseInt32
    DD 2120         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_ParseInt32_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.ArrayClear
    DD 2131         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 3 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_ArrayClear_Array_Int32_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeHelpers.ArrayGetValue
    DD 2142         ; NameOffset
    DD 21 ; Flags
    DD 53 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeHelpers_ArrayGetValue_Array_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 0    ; StackSize
    ; Method: RuntimeTypeHandle.get_Value
    DD 1494         ; NameOffset
    DD 517 ; Flags
    DD 54 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeTypeHandle_get_Value ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: String.get_Length
    DD 1227         ; NameOffset
    DD 517 ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_String_get_Length ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: String..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_String__ctor_Char__ ; CodeOffset
    DW 65535 ; VTableSlot
    DW 3    ; StackSize
    ; Method: String.get_Item
    DD 2156         ; NameOffset
    DD 517 ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 2     ; LocalCount
    DD OFFSET __System_String_get_Item_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: String.IsNullOrEmpty
    DD 2165         ; NameOffset
    DD 21 ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_String_IsNullOrEmpty_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: String.IsNullOrWhiteSpace
    DD 2179         ; NameOffset
    DD 21 ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 5     ; LocalCount
    DD OFFSET __System_String_IsNullOrWhiteSpace_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: String.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 3     ; LocalCount
    DD OFFSET __System_String_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: String.Equals
    DD 1462         ; NameOffset
    DD 5 ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_String_Equals_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: String.Equals
    DD 1462         ; NameOffset
    DD 21 ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 4     ; LocalCount
    DD OFFSET __System_String_Equals_String_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: String.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_String_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 1    ; StackSize
    ; Method: String.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_String_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 1    ; StackSize
    ; Method: String.Concat
    DD 2198         ; NameOffset
    DD 21 ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 3     ; LocalCount
    DD OFFSET __System_String_Concat_String_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: String.Concat
    DD 2198         ; NameOffset
    DD 21 ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 3 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_String_Concat_String_String_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: String.Concat
    DD 2198         ; NameOffset
    DD 21 ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 4 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_String_Concat_String_String_String_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 3    ; StackSize
    ; Method: String.op_Equality
    DD 1800         ; NameOffset
    DD 533 ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_String_op_Equality_String_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: String.op_Inequality
    DD 1812         ; NameOffset
    DD 533 ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_String_op_Inequality_String_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: String..cctor
    DD 1826         ; NameOffset
    DD 530 ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_String__cctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Type.get_Name
    DD 2205         ; NameOffset
    DD 869 ; Flags
    DD 56 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Type_get_Name ; CodeOffset
    DW 4 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Type.get_Namespace
    DD 2214         ; NameOffset
    DD 869 ; Flags
    DD 56 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Type_get_Namespace ; CodeOffset
    DW 5 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Type.get_FullName
    DD 2228         ; NameOffset
    DD 869 ; Flags
    DD 56 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Type_get_FullName ; CodeOffset
    DW 6 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Type.get_BaseType
    DD 2241         ; NameOffset
    DD 869 ; Flags
    DD 56 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Type_get_BaseType ; CodeOffset
    DW 7 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Type.get_IsValueType
    DD 2254         ; NameOffset
    DD 869 ; Flags
    DD 56 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Type_get_IsValueType ; CodeOffset
    DW 8 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Type.get_IsClass
    DD 2270         ; NameOffset
    DD 869 ; Flags
    DD 56 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Type_get_IsClass ; CodeOffset
    DW 9 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Type.get_IsInterface
    DD 2282         ; NameOffset
    DD 869 ; Flags
    DD 56 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Type_get_IsInterface ; CodeOffset
    DW 10 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Type.get_IsEnum
    DD 2298         ; NameOffset
    DD 869 ; Flags
    DD 56 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Type_get_IsEnum ; CodeOffset
    DW 11 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Type.get_IsArray
    DD 2309         ; NameOffset
    DD 869 ; Flags
    DD 56 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Type_get_IsArray ; CodeOffset
    DW 12 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Type.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 56 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Type_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 1    ; StackSize
    ; Method: Type.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 56 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 3     ; LocalCount
    DD OFFSET __System_Type_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Type.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 56 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Type_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 1    ; StackSize
    ; Method: Type.op_Equality
    DD 1800         ; NameOffset
    DD 533 ; Flags
    DD 56 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 3     ; LocalCount
    DD OFFSET __System_Type_op_Equality_Type_Type ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Type.op_Inequality
    DD 1812         ; NameOffset
    DD 533 ; Flags
    DD 56 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Type_op_Inequality_Type_Type ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Type.GetType
    DD 1642         ; NameOffset
    DD 21 ; Flags
    DD 56 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_Type_GetType_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 1    ; StackSize
    ; Method: Type..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 56 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Type__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: RuntimeType..ctor
    DD 1221         ; NameOffset
    DD 515 ; Flags
    DD 57 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 5 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeType__ctor_Int32_String_String_RuntimeType_TypeFlags ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: RuntimeType.get_Name
    DD 2205         ; NameOffset
    DD 549 ; Flags
    DD 57 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeType_get_Name ; CodeOffset
    DW 4 ; VTableSlot
    DW 8    ; StackSize
    ; Method: RuntimeType.get_Namespace
    DD 2214         ; NameOffset
    DD 549 ; Flags
    DD 57 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeType_get_Namespace ; CodeOffset
    DW 5 ; VTableSlot
    DW 8    ; StackSize
    ; Method: RuntimeType.get_FullName
    DD 2228         ; NameOffset
    DD 549 ; Flags
    DD 57 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeType_get_FullName ; CodeOffset
    DW 6 ; VTableSlot
    DW 8    ; StackSize
    ; Method: RuntimeType.get_BaseType
    DD 2241         ; NameOffset
    DD 549 ; Flags
    DD 57 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeType_get_BaseType ; CodeOffset
    DW 7 ; VTableSlot
    DW 8    ; StackSize
    ; Method: RuntimeType.get_IsValueType
    DD 2254         ; NameOffset
    DD 549 ; Flags
    DD 57 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeType_get_IsValueType ; CodeOffset
    DW 8 ; VTableSlot
    DW 8    ; StackSize
    ; Method: RuntimeType.get_IsClass
    DD 2270         ; NameOffset
    DD 549 ; Flags
    DD 57 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeType_get_IsClass ; CodeOffset
    DW 9 ; VTableSlot
    DW 8    ; StackSize
    ; Method: RuntimeType.get_IsInterface
    DD 2282         ; NameOffset
    DD 549 ; Flags
    DD 57 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeType_get_IsInterface ; CodeOffset
    DW 10 ; VTableSlot
    DW 8    ; StackSize
    ; Method: RuntimeType.get_IsEnum
    DD 2298         ; NameOffset
    DD 549 ; Flags
    DD 57 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeType_get_IsEnum ; CodeOffset
    DW 11 ; VTableSlot
    DW 8    ; StackSize
    ; Method: RuntimeType.get_IsArray
    DD 2309         ; NameOffset
    DD 549 ; Flags
    DD 57 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_RuntimeType_get_IsArray ; CodeOffset
    DW 12 ; VTableSlot
    DW 8    ; StackSize
    ; Method: RuntimeType.GetType
    DD 1642         ; NameOffset
    DD 19 ; Flags
    DD 57 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_RuntimeType_GetType_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 1    ; StackSize
    ; Method: ValueType.Equals
    DD 1462         ; NameOffset
    DD 37 ; Flags
    DD 58 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 3     ; LocalCount
    DD OFFSET __System_ValueType_Equals_Object ; CodeOffset
    DW 0 ; VTableSlot
    DW 2    ; StackSize
    ; Method: ValueType.GetHashCode
    DD 1469         ; NameOffset
    DD 37 ; Flags
    DD 58 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_ValueType_GetHashCode ; CodeOffset
    DW 1 ; VTableSlot
    DW 1    ; StackSize
    ; Method: ValueType.ToString
    DD 1522         ; NameOffset
    DD 37 ; Flags
    DD 58 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __System_ValueType_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 1    ; StackSize
    ; Method: ValueType..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 58 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_ValueType__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: SetsRequiredMembersAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 59 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Diagnostics_CodeAnalysis_SetsRequiredMembersAttribute__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: OutAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 60 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Runtime_InteropServices_OutAttribute__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: InAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 61 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Runtime_InteropServices_InAttribute__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: CompilerGeneratedAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 62 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Runtime_CompilerServices_CompilerGeneratedAttribute__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: CallerMemberNameAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 63 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Runtime_CompilerServices_CallerMemberNameAttribute__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: CallerFilePathAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 64 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Runtime_CompilerServices_CallerFilePathAttribute__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: CallerLineNumberAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 65 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Runtime_CompilerServices_CallerLineNumberAttribute__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: RequiredMemberAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 67 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Runtime_CompilerServices_RequiredMemberAttribute__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: CompilerFeatureRequiredAttribute.get_FeatureName
    DD 2321         ; NameOffset
    DD 517 ; Flags
    DD 68 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_get_FeatureName ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: CompilerFeatureRequiredAttribute.get_IsOptional
    DD 2337         ; NameOffset
    DD 517 ; Flags
    DD 68 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_get_IsOptional ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: CompilerFeatureRequiredAttribute.set_IsOptional
    DD 2352         ; NameOffset
    DD 517 ; Flags
    DD 68 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_set_IsOptional_Boolean ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: CompilerFeatureRequiredAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 68 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: NullableContextAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 69 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Runtime_CompilerServices_NullableContextAttribute__ctor_Byte ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: NullableAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 70 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Runtime_CompilerServices_NullableAttribute__ctor_Byte ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: NullableAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 70 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Runtime_CompilerServices_NullableAttribute__ctor_Byte__ ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: DefaultMemberAttribute.get_MemberName
    DD 2367         ; NameOffset
    DD 517 ; Flags
    DD 71 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Reflection_DefaultMemberAttribute_get_MemberName ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: DefaultMemberAttribute..ctor
    DD 1221         ; NameOffset
    DD 517 ; Flags
    DD 71 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __System_Reflection_DefaultMemberAttribute__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize

; Field Definition Table
__metadata_fields:
    ; Field: RefSafetyRulesAttribute.Version
    DD 2382         ; NameOffset
    DD 37  ; Flags
    DD 1 ; DeclaringTypeIndex
    DD 7     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: Array._length
    DD 2390         ; NameOffset
    DD 35  ; Flags
    DD 2 ; DeclaringTypeIndex
    DD 7     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: Asm386ImplementationAttribute.<Assembly>k__BackingField
    DD 2398         ; NameOffset
    DD 34  ; Flags
    DD 3 ; DeclaringTypeIndex
    DD 16     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: Asm386ImplementationAttribute.<SoftFloatAssembly>k__BackingField
    DD 2424         ; NameOffset
    DD 34  ; Flags
    DD 3 ; DeclaringTypeIndex
    DD 16     ; FieldTypeIndex
    DW 4       ; Offset
    DW 4         ; Size
    ; Field: Asm386IntrinsicAttribute.<IntrinsicName>k__BackingField
    DD 2459         ; NameOffset
    DD 34  ; Flags
    DD 4 ; DeclaringTypeIndex
    DD 16     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: Asm386LayoutAttribute.<Size>k__BackingField
    DD 2490         ; NameOffset
    DD 2  ; Flags
    DD 5 ; DeclaringTypeIndex
    DD 7     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: Asm386LayoutAttribute.<Alignment>k__BackingField
    DD 2512         ; NameOffset
    DD 2  ; Flags
    DD 5 ; DeclaringTypeIndex
    DD 7     ; FieldTypeIndex
    DW 4       ; Offset
    DW 4         ; Size
    ; Field: AttributeUsageAttribute.<ValidOn>k__BackingField
    DD 2539         ; NameOffset
    DD 34  ; Flags
    DD 6 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: AttributeUsageAttribute.<AllowMultiple>k__BackingField
    DD 2564         ; NameOffset
    DD 2  ; Flags
    DD 6 ; DeclaringTypeIndex
    DD 1     ; FieldTypeIndex
    DW 4       ; Offset
    DW 1         ; Size
    ; Field: AttributeUsageAttribute.<Inherited>k__BackingField
    DD 2595         ; NameOffset
    DD 2  ; Flags
    DD 6 ; DeclaringTypeIndex
    DD 1     ; FieldTypeIndex
    DW 5       ; Offset
    DW 1         ; Size
    ; Field: AttributeTargets.value__
    DD 2622         ; NameOffset
    DD 5  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 7     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: AttributeTargets.Assembly
    DD 2630         ; NameOffset
    DD 85  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: AttributeTargets.Module
    DD 2639         ; NameOffset
    DD 85  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: AttributeTargets.Class
    DD 2646         ; NameOffset
    DD 85  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: AttributeTargets.Struct
    DD 2652         ; NameOffset
    DD 85  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: AttributeTargets.Enum
    DD 383         ; NameOffset
    DD 85  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: AttributeTargets.Constructor
    DD 2659         ; NameOffset
    DD 85  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: AttributeTargets.Method
    DD 2671         ; NameOffset
    DD 85  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: AttributeTargets.Property
    DD 2678         ; NameOffset
    DD 85  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: AttributeTargets.Field
    DD 2687         ; NameOffset
    DD 85  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: AttributeTargets.Event
    DD 2693         ; NameOffset
    DD 85  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: AttributeTargets.Interface
    DD 2699         ; NameOffset
    DD 85  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: AttributeTargets.Parameter
    DD 2709         ; NameOffset
    DD 85  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: AttributeTargets.Delegate
    DD 253         ; NameOffset
    DD 85  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: AttributeTargets.ReturnValue
    DD 2719         ; NameOffset
    DD 85  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: AttributeTargets.GenericParameter
    DD 2731         ; NameOffset
    DD 85  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: AttributeTargets.All
    DD 2748         ; NameOffset
    DD 85  ; Flags
    DD 8 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Delegate._target
    DD 2752         ; NameOffset
    DD 3  ; Flags
    DD 10 ; DeclaringTypeIndex
    DD 15     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: Delegate._methodPtr
    DD 2760         ; NameOffset
    DD 3  ; Flags
    DD 10 ; DeclaringTypeIndex
    DD 13     ; FieldTypeIndex
    DW 4       ; Offset
    DW 4         ; Size
    ; Field: MulticastDelegate._prev
    DD 2771         ; NameOffset
    DD 3  ; Flags
    DD 11 ; DeclaringTypeIndex
    DD 11     ; FieldTypeIndex
    DW 8       ; Offset
    DW 4         ; Size
    ; Field: Nullable`1._hasValue
    DD 2777         ; NameOffset
    DD 34  ; Flags
    DD 12 ; DeclaringTypeIndex
    DD 1     ; FieldTypeIndex
    DW 0       ; Offset
    DW 1         ; Size
    ; Field: Nullable`1._value
    DD 2787         ; NameOffset
    DD 34  ; Flags
    DD 12 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 4       ; Offset
    DW 4         ; Size
    ; Field: ConsoleKeyInfo.KeyChar
    DD 2794         ; NameOffset
    DD 5  ; Flags
    DD 21 ; DeclaringTypeIndex
    DD 2     ; FieldTypeIndex
    DW 0       ; Offset
    DW 2         ; Size
    ; Field: ConsoleKeyInfo.Key
    DD 2802         ; NameOffset
    DD 5  ; Flags
    DD 21 ; DeclaringTypeIndex
    DD 22     ; FieldTypeIndex
    DW 4       ; Offset
    DW 4         ; Size
    ; Field: ConsoleKeyInfo.Shift
    DD 2806         ; NameOffset
    DD 5  ; Flags
    DD 21 ; DeclaringTypeIndex
    DD 1     ; FieldTypeIndex
    DW 8       ; Offset
    DW 1         ; Size
    ; Field: ConsoleKeyInfo.Alt
    DD 2812         ; NameOffset
    DD 5  ; Flags
    DD 21 ; DeclaringTypeIndex
    DD 1     ; FieldTypeIndex
    DW 9       ; Offset
    DW 1         ; Size
    ; Field: ConsoleKeyInfo.Control
    DD 2816         ; NameOffset
    DD 5  ; Flags
    DD 21 ; DeclaringTypeIndex
    DD 1     ; FieldTypeIndex
    DW 10       ; Offset
    DW 1         ; Size
    ; Field: ConsoleKey.value__
    DD 2622         ; NameOffset
    DD 5  ; Flags
    DD 22 ; DeclaringTypeIndex
    DD 7     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: ConsoleKey.None
    DD 2824         ; NameOffset
    DD 85  ; Flags
    DD 22 ; DeclaringTypeIndex
    DD 22     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: ConsoleKey.Backspace
    DD 2829         ; NameOffset
    DD 85  ; Flags
    DD 22 ; DeclaringTypeIndex
    DD 22     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: ConsoleKey.Tab
    DD 2839         ; NameOffset
    DD 85  ; Flags
    DD 22 ; DeclaringTypeIndex
    DD 22     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: ConsoleKey.Enter
    DD 2843         ; NameOffset
    DD 85  ; Flags
    DD 22 ; DeclaringTypeIndex
    DD 22     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: ConsoleKey.Escape
    DD 2849         ; NameOffset
    DD 85  ; Flags
    DD 22 ; DeclaringTypeIndex
    DD 22     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: ConsoleKey.Spacebar
    DD 2856         ; NameOffset
    DD 85  ; Flags
    DD 22 ; DeclaringTypeIndex
    DD 22     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Exception._message
    DD 2865         ; NameOffset
    DD 34  ; Flags
    DD 24 ; DeclaringTypeIndex
    DD 16     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: Exception._innerException
    DD 2874         ; NameOffset
    DD 34  ; Flags
    DD 24 ; DeclaringTypeIndex
    DD 24     ; FieldTypeIndex
    DW 4       ; Offset
    DW 4         ; Size
    ; Field: Boolean._value
    DD 2787         ; NameOffset
    DD 35  ; Flags
    DD 38 ; DeclaringTypeIndex
    DD 1     ; FieldTypeIndex
    DW 0       ; Offset
    DW 1         ; Size
    ; Field: Char._value
    DD 2787         ; NameOffset
    DD 35  ; Flags
    DD 39 ; DeclaringTypeIndex
    DD 2     ; FieldTypeIndex
    DW 0       ; Offset
    DW 2         ; Size
    ; Field: SByte._value
    DD 2787         ; NameOffset
    DD 35  ; Flags
    DD 40 ; DeclaringTypeIndex
    DD 3     ; FieldTypeIndex
    DW 0       ; Offset
    DW 1         ; Size
    ; Field: SByte.MinValue
    DD 2890         ; NameOffset
    DD 85  ; Flags
    DD 40 ; DeclaringTypeIndex
    DD 3     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: SByte.MaxValue
    DD 2899         ; NameOffset
    DD 85  ; Flags
    DD 40 ; DeclaringTypeIndex
    DD 3     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Byte._value
    DD 2787         ; NameOffset
    DD 35  ; Flags
    DD 41 ; DeclaringTypeIndex
    DD 4     ; FieldTypeIndex
    DW 0       ; Offset
    DW 1         ; Size
    ; Field: Byte.MinValue
    DD 2890         ; NameOffset
    DD 85  ; Flags
    DD 41 ; DeclaringTypeIndex
    DD 4     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Byte.MaxValue
    DD 2899         ; NameOffset
    DD 85  ; Flags
    DD 41 ; DeclaringTypeIndex
    DD 4     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Int16._value
    DD 2787         ; NameOffset
    DD 35  ; Flags
    DD 42 ; DeclaringTypeIndex
    DD 5     ; FieldTypeIndex
    DW 0       ; Offset
    DW 2         ; Size
    ; Field: Int16.MinValue
    DD 2890         ; NameOffset
    DD 85  ; Flags
    DD 42 ; DeclaringTypeIndex
    DD 5     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Int16.MaxValue
    DD 2899         ; NameOffset
    DD 85  ; Flags
    DD 42 ; DeclaringTypeIndex
    DD 5     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: UInt16._value
    DD 2787         ; NameOffset
    DD 35  ; Flags
    DD 43 ; DeclaringTypeIndex
    DD 6     ; FieldTypeIndex
    DW 0       ; Offset
    DW 2         ; Size
    ; Field: UInt16.MinValue
    DD 2890         ; NameOffset
    DD 85  ; Flags
    DD 43 ; DeclaringTypeIndex
    DD 6     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: UInt16.MaxValue
    DD 2899         ; NameOffset
    DD 85  ; Flags
    DD 43 ; DeclaringTypeIndex
    DD 6     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Int32._value
    DD 2787         ; NameOffset
    DD 35  ; Flags
    DD 44 ; DeclaringTypeIndex
    DD 7     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: Int32.MinValue
    DD 2890         ; NameOffset
    DD 85  ; Flags
    DD 44 ; DeclaringTypeIndex
    DD 7     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Int32.MaxValue
    DD 2899         ; NameOffset
    DD 85  ; Flags
    DD 44 ; DeclaringTypeIndex
    DD 7     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: UInt32._value
    DD 2787         ; NameOffset
    DD 35  ; Flags
    DD 45 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: UInt32.MinValue
    DD 2890         ; NameOffset
    DD 85  ; Flags
    DD 45 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: UInt32.MaxValue
    DD 2899         ; NameOffset
    DD 85  ; Flags
    DD 45 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Int64._value
    DD 2787         ; NameOffset
    DD 35  ; Flags
    DD 46 ; DeclaringTypeIndex
    DD 9     ; FieldTypeIndex
    DW 0       ; Offset
    DW 8         ; Size
    ; Field: Int64.MinValue
    DD 2890         ; NameOffset
    DD 85  ; Flags
    DD 46 ; DeclaringTypeIndex
    DD 9     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Int64.MaxValue
    DD 2899         ; NameOffset
    DD 85  ; Flags
    DD 46 ; DeclaringTypeIndex
    DD 9     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: UInt64._value
    DD 2787         ; NameOffset
    DD 35  ; Flags
    DD 47 ; DeclaringTypeIndex
    DD 10     ; FieldTypeIndex
    DW 0       ; Offset
    DW 8         ; Size
    ; Field: UInt64.MinValue
    DD 2890         ; NameOffset
    DD 85  ; Flags
    DD 47 ; DeclaringTypeIndex
    DD 10     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: UInt64.MaxValue
    DD 2899         ; NameOffset
    DD 85  ; Flags
    DD 47 ; DeclaringTypeIndex
    DD 10     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Single._value
    DD 2787         ; NameOffset
    DD 35  ; Flags
    DD 48 ; DeclaringTypeIndex
    DD 11     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: Single.MinValue
    DD 2890         ; NameOffset
    DD 85  ; Flags
    DD 48 ; DeclaringTypeIndex
    DD 11     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Single.MaxValue
    DD 2899         ; NameOffset
    DD 85  ; Flags
    DD 48 ; DeclaringTypeIndex
    DD 11     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Single.Epsilon
    DD 2908         ; NameOffset
    DD 85  ; Flags
    DD 48 ; DeclaringTypeIndex
    DD 11     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Single.NaN
    DD 2916         ; NameOffset
    DD 85  ; Flags
    DD 48 ; DeclaringTypeIndex
    DD 11     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Single.PositiveInfinity
    DD 2920         ; NameOffset
    DD 85  ; Flags
    DD 48 ; DeclaringTypeIndex
    DD 11     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Single.NegativeInfinity
    DD 2937         ; NameOffset
    DD 85  ; Flags
    DD 48 ; DeclaringTypeIndex
    DD 11     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Double._value
    DD 2787         ; NameOffset
    DD 35  ; Flags
    DD 49 ; DeclaringTypeIndex
    DD 12     ; FieldTypeIndex
    DW 0       ; Offset
    DW 8         ; Size
    ; Field: Double.MinValue
    DD 2890         ; NameOffset
    DD 85  ; Flags
    DD 49 ; DeclaringTypeIndex
    DD 12     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Double.MaxValue
    DD 2899         ; NameOffset
    DD 85  ; Flags
    DD 49 ; DeclaringTypeIndex
    DD 12     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Double.Epsilon
    DD 2908         ; NameOffset
    DD 85  ; Flags
    DD 49 ; DeclaringTypeIndex
    DD 12     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Double.NaN
    DD 2916         ; NameOffset
    DD 85  ; Flags
    DD 49 ; DeclaringTypeIndex
    DD 12     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Double.PositiveInfinity
    DD 2920         ; NameOffset
    DD 85  ; Flags
    DD 49 ; DeclaringTypeIndex
    DD 12     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Double.NegativeInfinity
    DD 2937         ; NameOffset
    DD 85  ; Flags
    DD 49 ; DeclaringTypeIndex
    DD 12     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: IntPtr._value
    DD 2787         ; NameOffset
    DD 35  ; Flags
    DD 50 ; DeclaringTypeIndex
    DD 7     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: IntPtr.Zero
    DD 2954         ; NameOffset
    DD 53  ; Flags
    DD 50 ; DeclaringTypeIndex
    DD 13     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: UIntPtr._value
    DD 2787         ; NameOffset
    DD 35  ; Flags
    DD 51 ; DeclaringTypeIndex
    DD 8     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: UIntPtr.Zero
    DD 2954         ; NameOffset
    DD 53  ; Flags
    DD 51 ; DeclaringTypeIndex
    DD 14     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: RuntimeTypeHandle._value
    DD 2787         ; NameOffset
    DD 3  ; Flags
    DD 54 ; DeclaringTypeIndex
    DD 13     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: String._length
    DD 2390         ; NameOffset
    DD 35  ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 7     ; FieldTypeIndex
    DW 4       ; Offset
    DW 4         ; Size
    ; Field: String._firstChar
    DD 2959         ; NameOffset
    DD 35  ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 2     ; FieldTypeIndex
    DW 8       ; Offset
    DW 2         ; Size
    ; Field: String.Empty
    DD 2970         ; NameOffset
    DD 53  ; Flags
    DD 55 ; DeclaringTypeIndex
    DD 16     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: RuntimeType._typeIndex
    DD 2976         ; NameOffset
    DD 34  ; Flags
    DD 57 ; DeclaringTypeIndex
    DD 7     ; FieldTypeIndex
    DW 4       ; Offset
    DW 4         ; Size
    ; Field: RuntimeType._name
    DD 2987         ; NameOffset
    DD 34  ; Flags
    DD 57 ; DeclaringTypeIndex
    DD 16     ; FieldTypeIndex
    DW 8       ; Offset
    DW 4         ; Size
    ; Field: RuntimeType._namespace
    DD 2993         ; NameOffset
    DD 34  ; Flags
    DD 57 ; DeclaringTypeIndex
    DD 16     ; FieldTypeIndex
    DW 12       ; Offset
    DW 4         ; Size
    ; Field: RuntimeType._baseType
    DD 3004         ; NameOffset
    DD 34  ; Flags
    DD 57 ; DeclaringTypeIndex
    DD 57     ; FieldTypeIndex
    DW 16       ; Offset
    DW 4         ; Size
    ; Field: RuntimeType._flags
    DD 3014         ; NameOffset
    DD 34  ; Flags
    DD 57 ; DeclaringTypeIndex
    DD 72     ; FieldTypeIndex
    DW 20       ; Offset
    DW 4         ; Size
    ; Field: CompilerFeatureRequiredAttribute.<FeatureName>k__BackingField
    DD 3021         ; NameOffset
    DD 34  ; Flags
    DD 68 ; DeclaringTypeIndex
    DD 16     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: CompilerFeatureRequiredAttribute.<IsOptional>k__BackingField
    DD 3050         ; NameOffset
    DD 2  ; Flags
    DD 68 ; DeclaringTypeIndex
    DD 1     ; FieldTypeIndex
    DW 4       ; Offset
    DW 1         ; Size
    ; Field: NullableContextAttribute.Flag
    DD 3078         ; NameOffset
    DD 37  ; Flags
    DD 69 ; DeclaringTypeIndex
    DD 4     ; FieldTypeIndex
    DW 0       ; Offset
    DW 1         ; Size
    ; Field: NullableAttribute.NullableFlags
    DD 3083         ; NameOffset
    DD 37  ; Flags
    DD 70 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: DefaultMemberAttribute.<MemberName>k__BackingField
    DD 3097         ; NameOffset
    DD 34  ; Flags
    DD 71 ; DeclaringTypeIndex
    DD 16     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: TypeFlags.value__
    DD 2622         ; NameOffset
    DD 5  ; Flags
    DD 72 ; DeclaringTypeIndex
    DD 7     ; FieldTypeIndex
    DW 0       ; Offset
    DW 4         ; Size
    ; Field: TypeFlags.None
    DD 2824         ; NameOffset
    DD 85  ; Flags
    DD 72 ; DeclaringTypeIndex
    DD 72     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.ValueType
    DD 824         ; NameOffset
    DD 85  ; Flags
    DD 72 ; DeclaringTypeIndex
    DD 72     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.Interface
    DD 2699         ; NameOffset
    DD 85  ; Flags
    DD 72 ; DeclaringTypeIndex
    DD 72     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.Enum
    DD 383         ; NameOffset
    DD 85  ; Flags
    DD 72 ; DeclaringTypeIndex
    DD 72     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.Array
    DD 97         ; NameOffset
    DD 85  ; Flags
    DD 72 ; DeclaringTypeIndex
    DD 72     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size

; String Heap
__string_heap:
    DB 'EmbeddedAttribute', 0
    DB 'Microsoft.CodeAnalysis', 0
    DB 'RefSafetyRulesAttribute', 0
    DB 'System.Runtime.CompilerServices', 0
    DB 'Array', 0
    DB 'System', 0
    DB 'Asm386ImplementationAttribute', 0
    DB 'Asm386IntrinsicAttribute', 0
    DB 'Asm386LayoutAttribute', 0
    DB 'AttributeUsageAttribute', 0
    DB 'Attribute', 0
    DB 'AttributeTargets', 0
    DB 'FlagsAttribute', 0
    DB 'Delegate', 0
    DB 'MulticastDelegate', 0
    DB 'Nullable`1', 0
    DB 'Action', 0
    DB 'Action`1', 0
    DB 'Action`2', 0
    DB 'Func`1', 0
    DB 'Func`2', 0
    DB 'Func`3', 0
    DB 'Predicate`1', 0
    DB 'Console', 0
    DB 'ConsoleKeyInfo', 0
    DB 'ConsoleKey', 0
    DB 'Enum', 0
    DB 'Exception', 0
    DB 'SystemException', 0
    DB 'NullReferenceException', 0
    DB 'InvalidOperationException', 0
    DB 'ArgumentException', 0
    DB 'ArgumentNullException', 0
    DB 'ArgumentOutOfRangeException', 0
    DB 'IndexOutOfRangeException', 0
    DB 'OutOfMemoryException', 0
    DB 'OverflowException', 0
    DB 'DivideByZeroException', 0
    DB 'NotSupportedException', 0
    DB 'NotImplementedException', 0
    DB 'Object', 0
    DB 'Boolean', 0
    DB 'Char', 0
    DB 'SByte', 0
    DB 'Byte', 0
    DB 'Int16', 0
    DB 'UInt16', 0
    DB 'Int32', 0
    DB 'UInt32', 0
    DB 'Int64', 0
    DB 'UInt64', 0
    DB 'Single', 0
    DB 'Double', 0
    DB 'IntPtr', 0
    DB 'UIntPtr', 0
    DB 'Void', 0
    DB 'RuntimeHelpers', 0
    DB 'RuntimeTypeHandle', 0
    DB 'String', 0
    DB 'Type', 0
    DB 'RuntimeType', 0
    DB 'ValueType', 0
    DB 'SetsRequiredMembersAttribute', 0
    DB 'System.Diagnostics.CodeAnalysis', 0
    DB 'OutAttribute', 0
    DB 'System.Runtime.InteropServices', 0
    DB 'InAttribute', 0
    DB 'CompilerGeneratedAttribute', 0
    DB 'CallerMemberNameAttribute', 0
    DB 'CallerFilePathAttribute', 0
    DB 'CallerLineNumberAttribute', 0
    DB 'IsExternalInit', 0
    DB 'RequiredMemberAttribute', 0
    DB 'CompilerFeatureRequiredAttribute', 0
    DB 'NullableContextAttribute', 0
    DB 'NullableAttribute', 0
    DB 'DefaultMemberAttribute', 0
    DB 'System.Reflection', 0
    DB 'TypeFlags', 0
    DB 0
    DB '.ctor', 0
    DB 'get_Length', 0
    DB 'GetLength', 0
    DB 'get_Rank', 0
    DB 'Copy', 0
    DB 'Clear', 0
    DB 'IndexOf', 0
    DB 'get_Assembly', 0
    DB 'get_SoftFloatAssembly', 0
    DB 'get_IntrinsicName', 0
    DB 'get_Size', 0
    DB 'set_Size', 0
    DB 'get_Alignment', 0
    DB 'set_Alignment', 0
    DB 'get_ValidOn', 0
    DB 'get_AllowMultiple', 0
    DB 'set_AllowMultiple', 0
    DB 'get_Inherited', 0
    DB 'set_Inherited', 0
    DB 'get_Target', 0
    DB 'Equals', 0
    DB 'GetHashCode', 0
    DB 'get_HasValue', 0
    DB 'get_Value', 0
    DB 'GetValueOrDefault', 0
    DB 'ToString', 0
    DB 'Invoke', 0
    DB 'Write', 0
    DB 'WriteLine', 0
    DB 'Read', 0
    DB 'ReadLine', 0
    DB 'ReadKey', 0
    DB 'CheckKeyAvailable', 0
    DB 'get_KeyAvailable', 0
    DB 'get_Message', 0
    DB 'get_InnerException', 0
    DB 'GetType', 0
    DB 'Finalize', 0
    DB 'MemberwiseClone', 0
    DB 'ReferenceEquals', 0
    DB 'IsWhiteSpace', 0
    DB 'IsDigit', 0
    DB 'IsLetter', 0
    DB 'IsLetterOrDigit', 0
    DB 'IsUpper', 0
    DB 'IsLower', 0
    DB 'ToUpper', 0
    DB 'ToLower', 0
    DB 'Parse', 0
    DB 'IsNaN', 0
    DB 'IsInfinity', 0
    DB 'ToInt32', 0
    DB 'op_Equality', 0
    DB 'op_Inequality', 0
    DB '.cctor', 0
    DB 'ToUInt32', 0
    DB 'GetTypeHandle', 0
    DB 'GetTypeFromHandle', 0
    DB 'ValueTypeEquals', 0
    DB 'ValueTypeGetHashCode', 0
    DB 'GetCharAt', 0
    DB 'StringEquals', 0
    DB 'StringGetHashCode', 0
    DB 'CopyCharsToString', 0
    DB 'StringConcat', 0
    DB 'CharToString', 0
    DB 'Int32ToString', 0
    DB 'UInt32ToString', 0
    DB 'Int64ToString', 0
    DB 'UInt64ToString', 0
    DB 'SingleToString', 0
    DB 'DoubleToString', 0
    DB 'SingleToInt32Bits', 0
    DB 'DoubleToInt64Bits', 0
    DB 'ParseInt32', 0
    DB 'ArrayClear', 0
    DB 'ArrayGetValue', 0
    DB 'get_Item', 0
    DB 'IsNullOrEmpty', 0
    DB 'IsNullOrWhiteSpace', 0
    DB 'Concat', 0
    DB 'get_Name', 0
    DB 'get_Namespace', 0
    DB 'get_FullName', 0
    DB 'get_BaseType', 0
    DB 'get_IsValueType', 0
    DB 'get_IsClass', 0
    DB 'get_IsInterface', 0
    DB 'get_IsEnum', 0
    DB 'get_IsArray', 0
    DB 'get_FeatureName', 0
    DB 'get_IsOptional', 0
    DB 'set_IsOptional', 0
    DB 'get_MemberName', 0
    DB 'Version', 0
    DB '_length', 0
    DB '<Assembly>k__BackingField', 0
    DB '<SoftFloatAssembly>k__BackingField', 0
    DB '<IntrinsicName>k__BackingField', 0
    DB '<Size>k__BackingField', 0
    DB '<Alignment>k__BackingField', 0
    DB '<ValidOn>k__BackingField', 0
    DB '<AllowMultiple>k__BackingField', 0
    DB '<Inherited>k__BackingField', 0
    DB 'value__', 0
    DB 'Assembly', 0
    DB 'Module', 0
    DB 'Class', 0
    DB 'Struct', 0
    DB 'Constructor', 0
    DB 'Method', 0
    DB 'Property', 0
    DB 'Field', 0
    DB 'Event', 0
    DB 'Interface', 0
    DB 'Parameter', 0
    DB 'ReturnValue', 0
    DB 'GenericParameter', 0
    DB 'All', 0
    DB '_target', 0
    DB '_methodPtr', 0
    DB '_prev', 0
    DB '_hasValue', 0
    DB '_value', 0
    DB 'KeyChar', 0
    DB 'Key', 0
    DB 'Shift', 0
    DB 'Alt', 0
    DB 'Control', 0
    DB 'None', 0
    DB 'Backspace', 0
    DB 'Tab', 0
    DB 'Enter', 0
    DB 'Escape', 0
    DB 'Spacebar', 0
    DB '_message', 0
    DB '_innerException', 0
    DB 'MinValue', 0
    DB 'MaxValue', 0
    DB 'Epsilon', 0
    DB 'NaN', 0
    DB 'PositiveInfinity', 0
    DB 'NegativeInfinity', 0
    DB 'Zero', 0
    DB '_firstChar', 0
    DB 'Empty', 0
    DB '_typeIndex', 0
    DB '_name', 0
    DB '_namespace', 0
    DB '_baseType', 0
    DB '_flags', 0
    DB '<FeatureName>k__BackingField', 0
    DB '<IsOptional>k__BackingField', 0
    DB 'Flag', 0
    DB 'NullableFlags', 0
    DB '<MemberName>k__BackingField', 0



; Void EmbeddedAttribute..ctor()
PUBLIC __Microsoft_CodeAnalysis_EmbeddedAttribute__ctor
__Microsoft_CodeAnalysis_EmbeddedAttribute__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_Microsoft_CodeAnalysis_EmbeddedAttributector_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__Microsoft_CodeAnalysis_EmbeddedAttribute__ctor ENDP

; Void RefSafetyRulesAttribute..ctor(Int32)
PUBLIC __System_Runtime_CompilerServices_RefSafetyRulesAttribute__ctor_Int32
__System_Runtime_CompilerServices_RefSafetyRulesAttribute__ctor_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Runtime_CompilerServices_RefSafetyRulesAttributector_Int32_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Runtime_CompilerServices_RefSafetyRulesAttribute__ctor_Int32 ENDP

; Int32 Array.get_Length()
PUBLIC __System_Array_get_Length
__System_Array_get_Length PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Array_get_Length_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Array_get_Length ENDP

; Int32 Array.GetLength(Int32)
PUBLIC __System_Array_GetLength_Int32
__System_Array_GetLength_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 5
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Array_GetLength_Int32_0000:
    NOP
    PUSH DWORD PTR [EBP+12]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETA AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    POP EAX
    TEST EAX, EAX
    JZ L_System_Array_GetLength_Int32_000F
L_System_Array_GetLength_Int32_0009:
    ; newobj System.IndexOutOfRangeException::.ctor
    MOV EAX, 8
    MOV EBX, 50
    CALL __gc_alloc_typed
    TEST EAX, EAX
    JZ __throw_out_of_memory
    MOV DWORD PTR [EAX], OFFSET __vtbl_System_IndexOutOfRangeException
    PUSH EAX
    CALL __System_IndexOutOfRangeException__ctor
    ADD ESP, 4
    POP EAX
    CALL __throw_exception
L_System_Array_GetLength_Int32_000F:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_Array_GetLength_Int32_0018
L_System_Array_GetLength_Int32_0018:
    PUSH DWORD PTR [EBP-13]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Array_GetLength_Int32 ENDP

; Int32 Array.get_Rank()
PUBLIC __System_Array_get_Rank
__System_Array_get_Rank PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Array_get_Rank_0000:
    PUSH 1
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Array_get_Rank ENDP

; Void Array.Copy(Array, Array, Int32)
PUBLIC __System_Array_Copy_Array_Array_Int32
__System_Array_Copy_Array_Array_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Array_Copy_Array_Array_Int32_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH 0
    PUSH DWORD PTR [EBP+12]
    PUSH 0
    PUSH DWORD PTR [EBP+16]
    CALL __System_Array_Copy_Array_Int32_Array_Int32_Int32
    ADD ESP, 20
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Array_Copy_Array_Array_Int32 ENDP

; Void Array.Copy(Array, Int32, Array, Int32, Int32)
PUBLIC __System_Array_Copy_Array_Int32_Array_Int32_Int32
__System_Array_Copy_Array_Int32_Array_Int32_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    MOV ESI, [EBP+8]
    MOV EDI, [EBP+16]
    MOV ECX, [EBP+24]
    ADD ESI, [EBP+12]
    ADD EDI, [EBP+20]
    REP MOVSB
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Array_Copy_Array_Int32_Array_Int32_Int32 ENDP

; Void Array.Clear(Array, Int32, Int32)
PUBLIC __System_Array_Clear_Array_Int32_Int32
__System_Array_Clear_Array_Int32_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Array_Clear_Array_Int32_Int32_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    PUSH DWORD PTR [EBP+16]
    CALL __System_RuntimeHelpers_ArrayClear_Array_Int32_Int32
    ADD ESP, 12
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Array_Clear_Array_Int32_Int32 ENDP

; Int32 Array.IndexOf(Array, Object)
PUBLIC __System_Array_IndexOf_Array_Object
__System_Array_IndexOf_Array_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Array_IndexOf_Array_Object_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    PUSH 0
    PUSH DWORD PTR [EBP+8]
    CALL __System_Array_get_Length
    ADD ESP, 8
    PUSH EAX
    CALL __System_Array_IndexOf_Array_Object_Int32_Int32
    ADD ESP, 16
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_Array_IndexOf_Array_Object_0012
L_System_Array_IndexOf_Array_Object_0012:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Array_IndexOf_Array_Object ENDP

; Int32 Array.IndexOf(Array, Object, Int32, Int32)
PUBLIC __System_Array_IndexOf_Array_Object_Int32_Int32
__System_Array_IndexOf_Array_Object_Int32_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 10
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Array_IndexOf_Array_Object_Int32_Int32_0000:
    NOP
    PUSH DWORD PTR [EBP+16]
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_Array_IndexOf_Array_Object_Int32_Int32_0020
L_System_Array_IndexOf_Array_Object_Int32_Int32_0005:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP-12]
    CALL __System_RuntimeHelpers_ArrayGetValue_Array_Int32
    ADD ESP, 8
    PUSH EAX
    PUSH DWORD PTR [EBP+12]
    CALL __System_Object_Equals_Object_Object
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-16], EAX
    PUSH DWORD PTR [EBP-16]
    POP EAX
    TEST EAX, EAX
    JZ L_System_Array_IndexOf_Array_Object_Int32_Int32_001B
L_System_Array_IndexOf_Array_Object_Int32_Int32_0017:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    MOV [EBP-17], EAX
    JMP L_System_Array_IndexOf_Array_Object_Int32_Int32_003A
L_System_Array_IndexOf_Array_Object_Int32_Int32_001B:
    NOP
    PUSH DWORD PTR [EBP-12]
    PUSH 1
    POP EBX
    POP EAX
    ADD EAX, EBX
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
L_System_Array_IndexOf_Array_Object_Int32_Int32_0020:
    PUSH DWORD PTR [EBP-12]
    PUSH DWORD PTR [EBP+16]
    PUSH DWORD PTR [EBP+20]
    POP EBX
    POP EAX
    ADD EAX, EBX
    PUSH EAX
    POP EBX
    POP EAX
    CMP EAX, EBX
    JGE L_System_Array_IndexOf_Array_Object_Int32_Int32_0031
L_System_Array_IndexOf_Array_Object_Int32_Int32_0026:
    PUSH DWORD PTR [EBP-12]
    PUSH DWORD PTR [EBP+8]
    CALL __System_Array_get_Length
    ADD ESP, 8
    PUSH EAX
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETL AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Array_IndexOf_Array_Object_Int32_Int32_0032
L_System_Array_IndexOf_Array_Object_Int32_Int32_0031:
    PUSH 0
L_System_Array_IndexOf_Array_Object_Int32_Int32_0032:
    POP EAX
    MOV [EBP-21], EAX
    PUSH DWORD PTR [EBP-21]
    POP EAX
    TEST EAX, EAX
    JNZ L_System_Array_IndexOf_Array_Object_Int32_Int32_0005
L_System_Array_IndexOf_Array_Object_Int32_Int32_0036:
    PUSH -1
    POP EAX
    MOV [EBP-17], EAX
    JMP L_System_Array_IndexOf_Array_Object_Int32_Int32_003A
L_System_Array_IndexOf_Array_Object_Int32_Int32_003A:
    PUSH DWORD PTR [EBP-17]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Array_IndexOf_Array_Object_Int32_Int32 ENDP

; Void Array..ctor()
PUBLIC __System_Array__ctor
__System_Array__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Arrayctor_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Object__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Array__ctor ENDP

; String Asm386ImplementationAttribute.get_Assembly()
PUBLIC __System_Asm386ImplementationAttribute_get_Assembly
__System_Asm386ImplementationAttribute_get_Assembly PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Asm386ImplementationAttribute_get_Assembly_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Asm386ImplementationAttribute_get_Assembly ENDP

; String Asm386ImplementationAttribute.get_SoftFloatAssembly()
PUBLIC __System_Asm386ImplementationAttribute_get_SoftFloatAssembly
__System_Asm386ImplementationAttribute_get_SoftFloatAssembly PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Asm386ImplementationAttribute_get_SoftFloatAssembly_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Asm386ImplementationAttribute_get_SoftFloatAssembly ENDP

; Void Asm386ImplementationAttribute..ctor(String)
PUBLIC __System_Asm386ImplementationAttribute__ctor_String
__System_Asm386ImplementationAttribute__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Asm386ImplementationAttributector_String_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Asm386ImplementationAttribute__ctor_String ENDP

; Void Asm386ImplementationAttribute..ctor(String, String)
PUBLIC __System_Asm386ImplementationAttribute__ctor_String_String
__System_Asm386ImplementationAttribute__ctor_String_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Asm386ImplementationAttributector_String_String_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+16]
    POP EAX
    POP ESI
    MOV [ESI+4], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Asm386ImplementationAttribute__ctor_String_String ENDP

; String Asm386IntrinsicAttribute.get_IntrinsicName()
PUBLIC __System_Asm386IntrinsicAttribute_get_IntrinsicName
__System_Asm386IntrinsicAttribute_get_IntrinsicName PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Asm386IntrinsicAttribute_get_IntrinsicName_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Asm386IntrinsicAttribute_get_IntrinsicName ENDP

; Void Asm386IntrinsicAttribute..ctor(String)
PUBLIC __System_Asm386IntrinsicAttribute__ctor_String
__System_Asm386IntrinsicAttribute__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Asm386IntrinsicAttributector_String_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Asm386IntrinsicAttribute__ctor_String ENDP

; Int32 Asm386LayoutAttribute.get_Size()
PUBLIC __System_Asm386LayoutAttribute_get_Size
__System_Asm386LayoutAttribute_get_Size PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Asm386LayoutAttribute_get_Size_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Asm386LayoutAttribute_get_Size ENDP

; Void Asm386LayoutAttribute.set_Size(Int32)
PUBLIC __System_Asm386LayoutAttribute_set_Size_Int32
__System_Asm386LayoutAttribute_set_Size_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Asm386LayoutAttribute_set_Size_Int32_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Asm386LayoutAttribute_set_Size_Int32 ENDP

; Int32 Asm386LayoutAttribute.get_Alignment()
PUBLIC __System_Asm386LayoutAttribute_get_Alignment
__System_Asm386LayoutAttribute_get_Alignment PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Asm386LayoutAttribute_get_Alignment_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Asm386LayoutAttribute_get_Alignment ENDP

; Void Asm386LayoutAttribute.set_Alignment(Int32)
PUBLIC __System_Asm386LayoutAttribute_set_Alignment_Int32
__System_Asm386LayoutAttribute_set_Alignment_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Asm386LayoutAttribute_set_Alignment_Int32_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+4], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Asm386LayoutAttribute_set_Alignment_Int32 ENDP

; Void Asm386LayoutAttribute..ctor()
PUBLIC __System_Asm386LayoutAttribute__ctor
__System_Asm386LayoutAttribute__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Asm386LayoutAttributector_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH 4
    POP EAX
    POP ESI
    MOV [ESI+4], EAX
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Asm386LayoutAttribute__ctor ENDP

; AttributeTargets AttributeUsageAttribute.get_ValidOn()
PUBLIC __System_AttributeUsageAttribute_get_ValidOn
__System_AttributeUsageAttribute_get_ValidOn PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_AttributeUsageAttribute_get_ValidOn_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_AttributeUsageAttribute_get_ValidOn ENDP

; Boolean AttributeUsageAttribute.get_AllowMultiple()
PUBLIC __System_AttributeUsageAttribute_get_AllowMultiple
__System_AttributeUsageAttribute_get_AllowMultiple PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_AttributeUsageAttribute_get_AllowMultiple_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_AttributeUsageAttribute_get_AllowMultiple ENDP

; Void AttributeUsageAttribute.set_AllowMultiple(Boolean)
PUBLIC __System_AttributeUsageAttribute_set_AllowMultiple_Boolean
__System_AttributeUsageAttribute_set_AllowMultiple_Boolean PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_AttributeUsageAttribute_set_AllowMultiple_Boolean_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+4], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_AttributeUsageAttribute_set_AllowMultiple_Boolean ENDP

; Boolean AttributeUsageAttribute.get_Inherited()
PUBLIC __System_AttributeUsageAttribute_get_Inherited
__System_AttributeUsageAttribute_get_Inherited PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_AttributeUsageAttribute_get_Inherited_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+5]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_AttributeUsageAttribute_get_Inherited ENDP

; Void AttributeUsageAttribute.set_Inherited(Boolean)
PUBLIC __System_AttributeUsageAttribute_set_Inherited_Boolean
__System_AttributeUsageAttribute_set_Inherited_Boolean PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_AttributeUsageAttribute_set_Inherited_Boolean_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+5], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_AttributeUsageAttribute_set_Inherited_Boolean ENDP

; Void AttributeUsageAttribute..ctor(AttributeTargets)
PUBLIC __System_AttributeUsageAttribute__ctor_AttributeTargets
__System_AttributeUsageAttribute__ctor_AttributeTargets PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_AttributeUsageAttributector_AttributeTargets_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH 1
    POP EAX
    POP ESI
    MOV [ESI+5], EAX
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_AttributeUsageAttribute__ctor_AttributeTargets ENDP

; Void Attribute..ctor()
PUBLIC __System_Attribute__ctor
__System_Attribute__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Attributector_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Object__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Attribute__ctor ENDP

; Void FlagsAttribute..ctor()
PUBLIC __System_FlagsAttribute__ctor
__System_FlagsAttribute__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_FlagsAttributector_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_FlagsAttribute__ctor ENDP

; Object Delegate.get_Target()
PUBLIC __System_Delegate_get_Target
__System_Delegate_get_Target PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Delegate_get_Target_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Delegate_get_Target ENDP

; Boolean Delegate.Equals(Object)
PUBLIC __System_Delegate_Equals_Object
__System_Delegate_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 6
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Delegate_Equals_Object_0000:
    NOP
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_Delegate
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETA AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-16], EAX
    PUSH DWORD PTR [EBP-16]
    POP EAX
    TEST EAX, EAX
    JZ L_System_Delegate_Equals_Object_0035
L_System_Delegate_Equals_Object_0010:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    PUSH DWORD PTR [EBP-12]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EBX
    POP EAX
    CMP EAX, EBX
    JNE L_System_Delegate_Equals_Object_0031
L_System_Delegate_Equals_Object_001E:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    PUSH DWORD PTR [EBP-12]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    CALL __System_IntPtr_op_Equality_IntPtr_IntPtr
    ADD ESP, 8
    PUSH EAX
    JMP L_System_Delegate_Equals_Object_0032
L_System_Delegate_Equals_Object_0031:
    PUSH 0
L_System_Delegate_Equals_Object_0032:
    POP EAX
    MOV [EBP-17], EAX
    JMP L_System_Delegate_Equals_Object_0039
L_System_Delegate_Equals_Object_0035:
    PUSH 0
    POP EAX
    MOV [EBP-17], EAX
    JMP L_System_Delegate_Equals_Object_0039
L_System_Delegate_Equals_Object_0039:
    PUSH DWORD PTR [EBP-17]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Delegate_Equals_Object ENDP

; Int32 Delegate.GetHashCode()
PUBLIC __System_Delegate_GetHashCode
__System_Delegate_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Delegate_GetHashCode_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    LEA EAX, [ESI+4]
    PUSH EAX
    CALL __System_IntPtr_GetHashCode
    ADD ESP, 4
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Delegate_GetHashCode ENDP

; Void Delegate..ctor()
PUBLIC __System_Delegate__ctor
__System_Delegate__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Delegatector_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Object__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Delegate__ctor ENDP

; Void MulticastDelegate..ctor()
PUBLIC __System_MulticastDelegate__ctor
__System_MulticastDelegate__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_MulticastDelegatector_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Delegate__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_MulticastDelegate__ctor ENDP

; Boolean Nullable`1.get_HasValue()
PUBLIC __System_Nullable_1_get_HasValue
__System_Nullable_1_get_HasValue PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Nullable_1_get_HasValue_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Nullable_1_get_HasValue ENDP

; T0 Nullable`1.get_Value()
PUBLIC __System_Nullable_1_get_Value
__System_Nullable_1_get_Value PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Nullable_1_get_Value_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    TEST EAX, EAX
    JNZ L_System_Nullable_1_get_Value_0013
L_System_Nullable_1_get_Value_0008:
    PUSH OFFSET __str_0
    ; newobj System.InvalidOperationException::.ctor
    MOV EAX, 8
    MOV EBX, 46
    CALL __gc_alloc_typed
    TEST EAX, EAX
    JZ __throw_out_of_memory
    MOV DWORD PTR [EAX], OFFSET __vtbl_System_InvalidOperationException
    PUSH EAX
    CALL __System_InvalidOperationException__ctor_String
    ADD ESP, 8
    POP EAX
    CALL __throw_exception
L_System_Nullable_1_get_Value_0013:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Nullable_1_get_Value ENDP

; Void Nullable`1..ctor(T0)
PUBLIC __System_Nullable_1__ctor_T0
__System_Nullable_1__ctor_T0 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Nullable_1ctor_T0_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH 1
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+4], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Nullable_1__ctor_T0 ENDP

; T0 Nullable`1.GetValueOrDefault()
PUBLIC __System_Nullable_1_GetValueOrDefault
__System_Nullable_1_GetValueOrDefault PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Nullable_1_GetValueOrDefault_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Nullable_1_GetValueOrDefault ENDP

; T0 Nullable`1.GetValueOrDefault(T0)
PUBLIC __System_Nullable_1_GetValueOrDefault_T0
__System_Nullable_1_GetValueOrDefault_T0 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Nullable_1_GetValueOrDefault_T0_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    TEST EAX, EAX
    JNZ L_System_Nullable_1_GetValueOrDefault_T0_000B
L_System_Nullable_1_GetValueOrDefault_T0_0008:
    PUSH DWORD PTR [EBP+12]
    JMP L_System_Nullable_1_GetValueOrDefault_T0_0011
L_System_Nullable_1_GetValueOrDefault_T0_000B:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
L_System_Nullable_1_GetValueOrDefault_T0_0011:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Nullable_1_GetValueOrDefault_T0 ENDP

; Boolean Nullable`1.Equals(Object)
PUBLIC __System_Nullable_1_Equals_Object
__System_Nullable_1_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 7
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Nullable_1_Equals_Object_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    POP EAX
    TEST EAX, EAX
    JZ L_System_Nullable_1_Equals_Object_0015
L_System_Nullable_1_Equals_Object_000E:
    PUSH DWORD PTR [EBP+12]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_Nullable_1_Equals_Object_0039
L_System_Nullable_1_Equals_Object_0015:
    PUSH DWORD PTR [EBP+12]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-14], EAX
    PUSH DWORD PTR [EBP-14]
    POP EAX
    TEST EAX, EAX
    JZ L_System_Nullable_1_Equals_Object_0021
L_System_Nullable_1_Equals_Object_001D:
    PUSH 0
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_Nullable_1_Equals_Object_0039
L_System_Nullable_1_Equals_Object_0021:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    POP EAX
    MOV [EBP-15], EAX
    NOP
    PUSH DWORD PTR [EBP+12]
    NOP
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+0]
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_Nullable_1_Equals_Object_0039
L_System_Nullable_1_Equals_Object_0039:
    PUSH DWORD PTR [EBP-13]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Nullable_1_Equals_Object ENDP

; Int32 Nullable`1.GetHashCode()
PUBLIC __System_Nullable_1_GetHashCode
__System_Nullable_1_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Nullable_1_GetHashCode_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    TEST EAX, EAX
    JNZ L_System_Nullable_1_GetHashCode_000B
L_System_Nullable_1_GetHashCode_0008:
    PUSH 0
    JMP L_System_Nullable_1_GetHashCode_001F
L_System_Nullable_1_GetHashCode_000B:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    POP EAX
    MOV [EBP-12], EAX
    NOP
    NOP
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+4]
    ADD ESP, 4
    PUSH EAX
L_System_Nullable_1_GetHashCode_001F:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Nullable_1_GetHashCode ENDP

; String Nullable`1.ToString()
PUBLIC __System_Nullable_1_ToString
__System_Nullable_1_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Nullable_1_ToString_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    TEST EAX, EAX
    JNZ L_System_Nullable_1_ToString_000F
L_System_Nullable_1_ToString_0008:
    PUSH OFFSET __str_1
    JMP L_System_Nullable_1_ToString_0023
L_System_Nullable_1_ToString_000F:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    POP EAX
    MOV [EBP-12], EAX
    NOP
    NOP
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+8]
    ADD ESP, 4
    PUSH EAX
L_System_Nullable_1_ToString_0023:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Nullable_1_ToString ENDP

; Void Action..ctor(Object, IntPtr)
PUBLIC __System_Action__ctor_Object_IntPtr
__System_Action__ctor_Object_IntPtr PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Action__ctor_Object_IntPtr ENDP

; Void Action.Invoke()
PUBLIC __System_Action_Invoke
__System_Action_Invoke PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Action_Invoke ENDP

; Void Action`1..ctor(Object, IntPtr)
PUBLIC __System_Action_1__ctor_Object_IntPtr
__System_Action_1__ctor_Object_IntPtr PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Action_1__ctor_Object_IntPtr ENDP

; Void Action`1.Invoke(T0)
PUBLIC __System_Action_1_Invoke_T0
__System_Action_1_Invoke_T0 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Action_1_Invoke_T0 ENDP

; Void Action`2..ctor(Object, IntPtr)
PUBLIC __System_Action_2__ctor_Object_IntPtr
__System_Action_2__ctor_Object_IntPtr PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Action_2__ctor_Object_IntPtr ENDP

; Void Action`2.Invoke(T0, T1)
PUBLIC __System_Action_2_Invoke_T0_T1
__System_Action_2_Invoke_T0_T1 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Action_2_Invoke_T0_T1 ENDP

; Void Func`1..ctor(Object, IntPtr)
PUBLIC __System_Func_1__ctor_Object_IntPtr
__System_Func_1__ctor_Object_IntPtr PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Func_1__ctor_Object_IntPtr ENDP

; T0 Func`1.Invoke()
PUBLIC __System_Func_1_Invoke
__System_Func_1_Invoke PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Func_1_Invoke ENDP

; Void Func`2..ctor(Object, IntPtr)
PUBLIC __System_Func_2__ctor_Object_IntPtr
__System_Func_2__ctor_Object_IntPtr PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Func_2__ctor_Object_IntPtr ENDP

; T1 Func`2.Invoke(T0)
PUBLIC __System_Func_2_Invoke_T0
__System_Func_2_Invoke_T0 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Func_2_Invoke_T0 ENDP

; Void Func`3..ctor(Object, IntPtr)
PUBLIC __System_Func_3__ctor_Object_IntPtr
__System_Func_3__ctor_Object_IntPtr PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Func_3__ctor_Object_IntPtr ENDP

; T2 Func`3.Invoke(T0, T1)
PUBLIC __System_Func_3_Invoke_T0_T1
__System_Func_3_Invoke_T0_T1 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Func_3_Invoke_T0_T1 ENDP

; Void Predicate`1..ctor(Object, IntPtr)
PUBLIC __System_Predicate_1__ctor_Object_IntPtr
__System_Predicate_1__ctor_Object_IntPtr PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Predicate_1__ctor_Object_IntPtr ENDP

; Boolean Predicate`1.Invoke(T0)
PUBLIC __System_Predicate_1_Invoke_T0
__System_Predicate_1_Invoke_T0 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Predicate_1_Invoke_T0 ENDP

; Void Console.Write(String)
PUBLIC __System_Console_Write_String
__System_Console_Write_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    MOV ESI, [EBP+8]
    TEST ESI, ESI
    JZ @@done
    MOV ECX, [ESI]
    LEA EDX, [ESI+4]
    PUSH ECX
    PUSH EDX
    PUSH 1
    CALL __write
    ADD ESP, 12
    @@done:
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_Write_String ENDP

; Void Console.WriteLine(String)
PUBLIC __System_Console_WriteLine_String
__System_Console_WriteLine_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Console_WriteLine_String_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    CALL __System_Console_Write_String
    ADD ESP, 4
    NOP
    CALL __System_Console_WriteLine
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_WriteLine_String ENDP

; Void Console.WriteLine()
PUBLIC __System_Console_WriteLine
__System_Console_WriteLine PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    PUSH 2
    PUSH OFFSET __crlf
    PUSH 1
    CALL __write
    ADD ESP, 12
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_WriteLine ENDP

; Void Console.Write(Char)
PUBLIC __System_Console_Write_Char
__System_Console_Write_Char PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    LEA EAX, [EBP+8]
    PUSH 1
    PUSH EAX
    PUSH 1
    CALL __write
    ADD ESP, 12
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_Write_Char ENDP

; Void Console.Write(Int32)
PUBLIC __System_Console_Write_Int32
__System_Console_Write_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Console_Write_Int32_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_RuntimeHelpers_Int32ToString_Int32
    ADD ESP, 4
    PUSH EAX
    CALL __System_Console_Write_String
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_Write_Int32 ENDP

; Void Console.WriteLine(Int32)
PUBLIC __System_Console_WriteLine_Int32
__System_Console_WriteLine_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Console_WriteLine_Int32_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_RuntimeHelpers_Int32ToString_Int32
    ADD ESP, 4
    PUSH EAX
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_WriteLine_Int32 ENDP

; Void Console.Write(Int64)
PUBLIC __System_Console_Write_Int64
__System_Console_Write_Int64 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Console_Write_Int64_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_RuntimeHelpers_Int64ToString_Int64
    ADD ESP, 8
    PUSH EAX
    CALL __System_Console_Write_String
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_Write_Int64 ENDP

; Void Console.WriteLine(Int64)
PUBLIC __System_Console_WriteLine_Int64
__System_Console_WriteLine_Int64 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Console_WriteLine_Int64_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_RuntimeHelpers_Int64ToString_Int64
    ADD ESP, 8
    PUSH EAX
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_WriteLine_Int64 ENDP

; Void Console.Write(Boolean)
PUBLIC __System_Console_Write_Boolean
__System_Console_Write_Boolean PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Console_Write_Boolean_0000:
    PUSH DWORD PTR [EBP+8]
    POP EAX
    TEST EAX, EAX
    JNZ L_System_Console_Write_Boolean_000A
L_System_Console_Write_Boolean_0003:
    PUSH OFFSET __str_2
    JMP L_System_Console_Write_Boolean_000F
L_System_Console_Write_Boolean_000A:
    PUSH OFFSET __str_3
L_System_Console_Write_Boolean_000F:
    CALL __System_Console_Write_String
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_Write_Boolean ENDP

; Void Console.WriteLine(Boolean)
PUBLIC __System_Console_WriteLine_Boolean
__System_Console_WriteLine_Boolean PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Console_WriteLine_Boolean_0000:
    PUSH DWORD PTR [EBP+8]
    POP EAX
    TEST EAX, EAX
    JNZ L_System_Console_WriteLine_Boolean_000A
L_System_Console_WriteLine_Boolean_0003:
    PUSH OFFSET __str_2
    JMP L_System_Console_WriteLine_Boolean_000F
L_System_Console_WriteLine_Boolean_000A:
    PUSH OFFSET __str_3
L_System_Console_WriteLine_Boolean_000F:
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_WriteLine_Boolean ENDP

; Void Console.Write(Object)
PUBLIC __System_Console_Write_Object
__System_Console_Write_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 1
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Console_Write_Object_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETA AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    POP EAX
    TEST EAX, EAX
    JZ L_System_Console_Write_Object_0015
L_System_Console_Write_Object_0009:
    PUSH DWORD PTR [EBP+8]
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+8]
    ADD ESP, 4
    PUSH EAX
    CALL __System_Console_Write_String
    ADD ESP, 4
    NOP
L_System_Console_Write_Object_0015:
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_Write_Object ENDP

; Void Console.WriteLine(Object)
PUBLIC __System_Console_WriteLine_Object
__System_Console_WriteLine_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 1
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Console_WriteLine_Object_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETA AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    POP EAX
    TEST EAX, EAX
    JZ L_System_Console_WriteLine_Object_0017
L_System_Console_WriteLine_Object_0009:
    PUSH DWORD PTR [EBP+8]
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+8]
    ADD ESP, 4
    PUSH EAX
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    JMP L_System_Console_WriteLine_Object_001D
L_System_Console_WriteLine_Object_0017:
    CALL __System_Console_WriteLine
    NOP
L_System_Console_WriteLine_Object_001D:
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_WriteLine_Object ENDP

; Int32 Console.Read()
PUBLIC __System_Console_Read
__System_Console_Read PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    SUB ESP, 4
    PUSH 1
    LEA EAX, [ESP+4]
    PUSH EAX
    PUSH 0
    CALL __read
    ADD ESP, 12
    MOVZX EAX, BYTE PTR [ESP]
    ADD ESP, 4
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_Read ENDP

; String Console.ReadLine()
PUBLIC __System_Console_ReadLine
__System_Console_ReadLine PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    XOR EAX, EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_ReadLine ENDP

; ConsoleKeyInfo Console.ReadKey()
PUBLIC __System_Console_ReadKey
__System_Console_ReadKey PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    CALL __getch
    MOVZX EAX, AL
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_ReadKey ENDP

; Boolean Console.CheckKeyAvailable()
PUBLIC __System_Console_CheckKeyAvailable
__System_Console_CheckKeyAvailable PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    CALL __kbhit
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_CheckKeyAvailable ENDP

; Boolean Console.get_KeyAvailable()
PUBLIC __System_Console_get_KeyAvailable
__System_Console_get_KeyAvailable PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Console_get_KeyAvailable_0000:
    CALL __System_Console_CheckKeyAvailable
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Console_get_KeyAvailable ENDP

; String Enum.ToString()
PUBLIC __System_Enum_ToString
__System_Enum_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Enum_ToString_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    CALL __System_ValueType_ToString
    ADD ESP, 4
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_Enum_ToString_000A
L_System_Enum_ToString_000A:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Enum_ToString ENDP

; Boolean Enum.Equals(Object)
PUBLIC __System_Enum_Equals_Object
__System_Enum_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 1
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Enum_Equals_Object_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_ValueType_Equals_Object
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_Enum_Equals_Object_000B
L_System_Enum_Equals_Object_000B:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Enum_Equals_Object ENDP

; Int32 Enum.GetHashCode()
PUBLIC __System_Enum_GetHashCode
__System_Enum_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Enum_GetHashCode_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    CALL __System_ValueType_GetHashCode
    ADD ESP, 4
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_Enum_GetHashCode_000A
L_System_Enum_GetHashCode_000A:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Enum_GetHashCode ENDP

; Void Enum..ctor()
PUBLIC __System_Enum__ctor
__System_Enum__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Enumctor_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_ValueType__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Enum__ctor ENDP

; Void Exception..ctor()
PUBLIC __System_Exception__ctor
__System_Exception__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Exceptionctor_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Object__ctor
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH OFFSET __str_4
    PUSH DWORD PTR [EBP+8]
    CALL __System_Object_GetType
    ADD ESP, 4
    PUSH EAX
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+24]
    ADD ESP, 4
    PUSH EAX
    PUSH OFFSET __str_5
    CALL __System_String_Concat_String_String_String
    ADD ESP, 12
    PUSH EAX
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Exception__ctor ENDP

; Void Exception..ctor(String)
PUBLIC __System_Exception__ctor_String
__System_Exception__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Exceptionctor_String_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Object__ctor
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Exception__ctor_String ENDP

; Void Exception..ctor(String, Exception)
PUBLIC __System_Exception__ctor_String_Exception
__System_Exception__ctor_String_Exception PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Exceptionctor_String_Exception_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Object__ctor
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+16]
    POP EAX
    POP ESI
    MOV [ESI+4], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Exception__ctor_String_Exception ENDP

; String Exception.get_Message()
PUBLIC __System_Exception_get_Message
__System_Exception_get_Message PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Exception_get_Message_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Exception_get_Message ENDP

; Exception Exception.get_InnerException()
PUBLIC __System_Exception_get_InnerException
__System_Exception_get_InnerException PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Exception_get_InnerException_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Exception_get_InnerException ENDP

; String Exception.ToString()
PUBLIC __System_Exception_ToString
__System_Exception_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Exception_ToString_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    CALL __System_Object_GetType
    ADD ESP, 4
    PUSH EAX
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+24]
    ADD ESP, 4
    PUSH EAX
    PUSH OFFSET __str_6
    PUSH DWORD PTR [EBP+8]
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+16]
    ADD ESP, 4
    PUSH EAX
    CALL __System_String_Concat_String_String_String
    ADD ESP, 12
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_Exception_ToString_001F
L_System_Exception_ToString_001F:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Exception_ToString ENDP

; Void SystemException..ctor()
PUBLIC __System_SystemException__ctor
__System_SystemException__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_SystemExceptionctor_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Exception__ctor
    ADD ESP, 4
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_SystemException__ctor ENDP

; Void SystemException..ctor(String)
PUBLIC __System_SystemException__ctor_String
__System_SystemException__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_SystemExceptionctor_String_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_Exception__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_SystemException__ctor_String ENDP

; Void SystemException..ctor(String, Exception)
PUBLIC __System_SystemException__ctor_String_Exception
__System_SystemException__ctor_String_Exception PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_SystemExceptionctor_String_Exception_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    PUSH DWORD PTR [EBP+16]
    CALL __System_Exception__ctor_String_Exception
    ADD ESP, 12
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_SystemException__ctor_String_Exception ENDP

; Void NullReferenceException..ctor()
PUBLIC __System_NullReferenceException__ctor
__System_NullReferenceException__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_NullReferenceExceptionctor_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH OFFSET __str_7
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_NullReferenceException__ctor ENDP

; Void NullReferenceException..ctor(String)
PUBLIC __System_NullReferenceException__ctor_String
__System_NullReferenceException__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_NullReferenceExceptionctor_String_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_NullReferenceException__ctor_String ENDP

; Void InvalidOperationException..ctor()
PUBLIC __System_InvalidOperationException__ctor
__System_InvalidOperationException__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_InvalidOperationExceptionctor_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH OFFSET __str_8
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_InvalidOperationException__ctor ENDP

; Void InvalidOperationException..ctor(String)
PUBLIC __System_InvalidOperationException__ctor_String
__System_InvalidOperationException__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_InvalidOperationExceptionctor_String_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_InvalidOperationException__ctor_String ENDP

; Void ArgumentException..ctor()
PUBLIC __System_ArgumentException__ctor
__System_ArgumentException__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_ArgumentExceptionctor_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH OFFSET __str_9
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_ArgumentException__ctor ENDP

; Void ArgumentException..ctor(String)
PUBLIC __System_ArgumentException__ctor_String
__System_ArgumentException__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_ArgumentExceptionctor_String_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_ArgumentException__ctor_String ENDP

; Void ArgumentNullException..ctor()
PUBLIC __System_ArgumentNullException__ctor
__System_ArgumentNullException__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_ArgumentNullExceptionctor_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH OFFSET __str_10
    CALL __System_ArgumentException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_ArgumentNullException__ctor ENDP

; Void ArgumentNullException..ctor(String)
PUBLIC __System_ArgumentNullException__ctor_String
__System_ArgumentNullException__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_ArgumentNullExceptionctor_String_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH OFFSET __str_11
    PUSH DWORD PTR [EBP+12]
    CALL __System_String_Concat_String_String
    ADD ESP, 8
    PUSH EAX
    CALL __System_ArgumentException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_ArgumentNullException__ctor_String ENDP

; Void ArgumentOutOfRangeException..ctor()
PUBLIC __System_ArgumentOutOfRangeException__ctor
__System_ArgumentOutOfRangeException__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_ArgumentOutOfRangeExceptionctor_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH OFFSET __str_12
    CALL __System_ArgumentException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_ArgumentOutOfRangeException__ctor ENDP

; Void ArgumentOutOfRangeException..ctor(String)
PUBLIC __System_ArgumentOutOfRangeException__ctor_String
__System_ArgumentOutOfRangeException__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_ArgumentOutOfRangeExceptionctor_String_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH OFFSET __str_13
    PUSH DWORD PTR [EBP+12]
    CALL __System_String_Concat_String_String
    ADD ESP, 8
    PUSH EAX
    CALL __System_ArgumentException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_ArgumentOutOfRangeException__ctor_String ENDP

; Void IndexOutOfRangeException..ctor()
PUBLIC __System_IndexOutOfRangeException__ctor
__System_IndexOutOfRangeException__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_IndexOutOfRangeExceptionctor_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH OFFSET __str_14
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_IndexOutOfRangeException__ctor ENDP

; Void IndexOutOfRangeException..ctor(String)
PUBLIC __System_IndexOutOfRangeException__ctor_String
__System_IndexOutOfRangeException__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_IndexOutOfRangeExceptionctor_String_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_IndexOutOfRangeException__ctor_String ENDP

; Void OutOfMemoryException..ctor()
PUBLIC __System_OutOfMemoryException__ctor
__System_OutOfMemoryException__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_OutOfMemoryExceptionctor_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH OFFSET __str_15
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_OutOfMemoryException__ctor ENDP

; Void OutOfMemoryException..ctor(String)
PUBLIC __System_OutOfMemoryException__ctor_String
__System_OutOfMemoryException__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_OutOfMemoryExceptionctor_String_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_OutOfMemoryException__ctor_String ENDP

; Void OverflowException..ctor()
PUBLIC __System_OverflowException__ctor
__System_OverflowException__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_OverflowExceptionctor_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH OFFSET __str_16
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_OverflowException__ctor ENDP

; Void OverflowException..ctor(String)
PUBLIC __System_OverflowException__ctor_String
__System_OverflowException__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_OverflowExceptionctor_String_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_OverflowException__ctor_String ENDP

; Void DivideByZeroException..ctor()
PUBLIC __System_DivideByZeroException__ctor
__System_DivideByZeroException__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_DivideByZeroExceptionctor_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH OFFSET __str_17
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_DivideByZeroException__ctor ENDP

; Void DivideByZeroException..ctor(String)
PUBLIC __System_DivideByZeroException__ctor_String
__System_DivideByZeroException__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_DivideByZeroExceptionctor_String_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_DivideByZeroException__ctor_String ENDP

; Void NotSupportedException..ctor()
PUBLIC __System_NotSupportedException__ctor
__System_NotSupportedException__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_NotSupportedExceptionctor_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH OFFSET __str_18
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_NotSupportedException__ctor ENDP

; Void NotSupportedException..ctor(String)
PUBLIC __System_NotSupportedException__ctor_String
__System_NotSupportedException__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_NotSupportedExceptionctor_String_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_NotSupportedException__ctor_String ENDP

; Void NotImplementedException..ctor()
PUBLIC __System_NotImplementedException__ctor
__System_NotImplementedException__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_NotImplementedExceptionctor_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH OFFSET __str_19
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_NotImplementedException__ctor ENDP

; Void NotImplementedException..ctor(String)
PUBLIC __System_NotImplementedException__ctor_String
__System_NotImplementedException__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_NotImplementedExceptionctor_String_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_SystemException__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_NotImplementedException__ctor_String ENDP

; Boolean Object.Equals(Object)
PUBLIC __System_Object_Equals_Object
__System_Object_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 1
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Object_Equals_Object_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_Object_Equals_Object_0008
L_System_Object_Equals_Object_0008:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Object_Equals_Object ENDP

; Int32 Object.GetHashCode()
PUBLIC __System_Object_GetHashCode
__System_Object_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Object_GetHashCode_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    CALL __System_RuntimeHelpers_GetHashCode_Object
    ADD ESP, 4
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_Object_GetHashCode_000A
L_System_Object_GetHashCode_000A:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Object_GetHashCode ENDP

; String Object.ToString()
PUBLIC __System_Object_ToString
__System_Object_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Object_ToString_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    CALL __System_Object_GetType
    ADD ESP, 4
    PUSH EAX
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+24]
    ADD ESP, 4
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_Object_ToString_000F
L_System_Object_ToString_000F:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Object_ToString ENDP

; Type Object.GetType()
PUBLIC __System_Object_GetType
__System_Object_GetType PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Object_GetType_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    CALL __System_RuntimeHelpers_GetTypeHandle_Object
    ADD ESP, 4
    PUSH EAX
    CALL __System_RuntimeHelpers_GetTypeFromHandle_RuntimeTypeHandle
    ADD ESP, 4
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_Object_GetType_000F
L_System_Object_GetType_000F:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Object_GetType ENDP

; Void Object.Finalize()
PUBLIC __System_Object_Finalize
__System_Object_Finalize PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Object_Finalize_0000:
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Object_Finalize ENDP

; Object Object.MemberwiseClone()
PUBLIC __System_Object_MemberwiseClone
__System_Object_MemberwiseClone PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Object_MemberwiseClone_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    CALL __System_RuntimeHelpers_MemberwiseClone_Object
    ADD ESP, 4
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_Object_MemberwiseClone_000A
L_System_Object_MemberwiseClone_000A:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Object_MemberwiseClone ENDP

; Boolean Object.Equals(Object, Object)
PUBLIC __System_Object_Equals_Object_Object
__System_Object_Equals_Object_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 3
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Object_Equals_Object_Object_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    POP EAX
    TEST EAX, EAX
    JZ L_System_Object_Equals_Object_Object_000D
L_System_Object_Equals_Object_Object_0009:
    PUSH 1
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_Object_Equals_Object_Object_0029
L_System_Object_Equals_Object_Object_000D:
    PUSH DWORD PTR [EBP+8]
    POP EAX
    TEST EAX, EAX
    JZ L_System_Object_Equals_Object_Object_0016
L_System_Object_Equals_Object_Object_0010:
    PUSH DWORD PTR [EBP+12]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Object_Equals_Object_Object_0017
L_System_Object_Equals_Object_Object_0016:
    PUSH 1
L_System_Object_Equals_Object_Object_0017:
    POP EAX
    MOV [EBP-14], EAX
    PUSH DWORD PTR [EBP-14]
    POP EAX
    TEST EAX, EAX
    JZ L_System_Object_Equals_Object_Object_001F
L_System_Object_Equals_Object_Object_001B:
    PUSH 0
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_Object_Equals_Object_Object_0029
L_System_Object_Equals_Object_Object_001F:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+0]
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_Object_Equals_Object_Object_0029
L_System_Object_Equals_Object_Object_0029:
    PUSH DWORD PTR [EBP-13]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Object_Equals_Object_Object ENDP

; Boolean Object.ReferenceEquals(Object, Object)
PUBLIC __System_Object_ReferenceEquals_Object_Object
__System_Object_ReferenceEquals_Object_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 1
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Object_ReferenceEquals_Object_Object_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_Object_ReferenceEquals_Object_Object_0008
L_System_Object_ReferenceEquals_Object_Object_0008:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Object_ReferenceEquals_Object_Object ENDP

; Void Object..ctor()
PUBLIC __System_Object__ctor
__System_Object__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Objectctor_0000:
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Object__ctor ENDP

; String Boolean.ToString()
PUBLIC __System_Boolean_ToString
__System_Boolean_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Boolean_ToString_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    POP EAX
    TEST EAX, EAX
    JNZ L_System_Boolean_ToString_000B
L_System_Boolean_ToString_0004:
    PUSH OFFSET __str_2
    JMP L_System_Boolean_ToString_0010
L_System_Boolean_ToString_000B:
    PUSH OFFSET __str_3
L_System_Boolean_ToString_0010:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Boolean_ToString ENDP

; Int32 Boolean.GetHashCode()
PUBLIC __System_Boolean_GetHashCode
__System_Boolean_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Boolean_GetHashCode_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    POP EAX
    TEST EAX, EAX
    JNZ L_System_Boolean_GetHashCode_0007
L_System_Boolean_GetHashCode_0004:
    PUSH 0
    JMP L_System_Boolean_GetHashCode_0008
L_System_Boolean_GetHashCode_0007:
    PUSH 1
L_System_Boolean_GetHashCode_0008:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Boolean_GetHashCode ENDP

; Boolean Boolean.Equals(Object)
PUBLIC __System_Boolean_Equals_Object
__System_Boolean_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 1
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Boolean_Equals_Object_0000:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_Boolean
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JZ L_System_Boolean_Equals_Object_0016
L_System_Boolean_Equals_Object_0008:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    PUSH DWORD PTR [EAX+4]
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP+8]
    NOP
    PUSH DWORD PTR [EBP-12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Boolean_Equals_Object_0017
L_System_Boolean_Equals_Object_0016:
    PUSH 0
L_System_Boolean_Equals_Object_0017:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Boolean_Equals_Object ENDP

; String Char.ToString()
PUBLIC __System_Char_ToString
__System_Char_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Char_ToString_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    CALL __System_RuntimeHelpers_CharToString_Char
    ADD ESP, 2
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Char_ToString ENDP

; Int32 Char.GetHashCode()
PUBLIC __System_Char_GetHashCode
__System_Char_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Char_GetHashCode_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Char_GetHashCode ENDP

; Boolean Char.Equals(Object)
PUBLIC __System_Char_Equals_Object
__System_Char_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 2
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Char_Equals_Object_0000:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_Char
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JZ L_System_Char_Equals_Object_0016
L_System_Char_Equals_Object_0008:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    PUSH DWORD PTR [EAX+4]
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP+8]
    NOP
    PUSH DWORD PTR [EBP-12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Char_Equals_Object_0017
L_System_Char_Equals_Object_0016:
    PUSH 0
L_System_Char_Equals_Object_0017:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Char_Equals_Object ENDP

; Boolean Char.IsWhiteSpace(Char)
PUBLIC __System_Char_IsWhiteSpace_Char
__System_Char_IsWhiteSpace_Char PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Char_IsWhiteSpace_Char_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH 32
    POP EBX
    POP EAX
    CMP EAX, EBX
    JE L_System_Char_IsWhiteSpace_Char_0016
L_System_Char_IsWhiteSpace_Char_0005:
    PUSH DWORD PTR [EBP+8]
    PUSH 9
    POP EBX
    POP EAX
    CMP EAX, EBX
    JE L_System_Char_IsWhiteSpace_Char_0016
L_System_Char_IsWhiteSpace_Char_000A:
    PUSH DWORD PTR [EBP+8]
    PUSH 10
    POP EBX
    POP EAX
    CMP EAX, EBX
    JE L_System_Char_IsWhiteSpace_Char_0016
L_System_Char_IsWhiteSpace_Char_000F:
    PUSH DWORD PTR [EBP+8]
    PUSH 13
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Char_IsWhiteSpace_Char_0017
L_System_Char_IsWhiteSpace_Char_0016:
    PUSH 1
L_System_Char_IsWhiteSpace_Char_0017:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Char_IsWhiteSpace_Char ENDP

; Boolean Char.IsDigit(Char)
PUBLIC __System_Char_IsDigit_Char
__System_Char_IsDigit_Char PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Char_IsDigit_Char_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH 48
    POP EBX
    POP EAX
    CMP EAX, EBX
    JL L_System_Char_IsDigit_Char_000F
L_System_Char_IsDigit_Char_0005:
    PUSH DWORD PTR [EBP+8]
    PUSH 57
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETG AL
    MOVZX EAX, AL
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Char_IsDigit_Char_0010
L_System_Char_IsDigit_Char_000F:
    PUSH 0
L_System_Char_IsDigit_Char_0010:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Char_IsDigit_Char ENDP

; Boolean Char.IsLetter(Char)
PUBLIC __System_Char_IsLetter_Char
__System_Char_IsLetter_Char PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Char_IsLetter_Char_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH 97
    POP EBX
    POP EAX
    CMP EAX, EBX
    JL L_System_Char_IsLetter_Char_000A
L_System_Char_IsLetter_Char_0005:
    PUSH DWORD PTR [EBP+8]
    PUSH 122
    POP EBX
    POP EAX
    CMP EAX, EBX
    JLE L_System_Char_IsLetter_Char_001C
L_System_Char_IsLetter_Char_000A:
    PUSH DWORD PTR [EBP+8]
    PUSH 65
    POP EBX
    POP EAX
    CMP EAX, EBX
    JL L_System_Char_IsLetter_Char_0019
L_System_Char_IsLetter_Char_000F:
    PUSH DWORD PTR [EBP+8]
    PUSH 90
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETG AL
    MOVZX EAX, AL
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Char_IsLetter_Char_001A
L_System_Char_IsLetter_Char_0019:
    PUSH 0
L_System_Char_IsLetter_Char_001A:
    JMP L_System_Char_IsLetter_Char_001D
L_System_Char_IsLetter_Char_001C:
    PUSH 1
L_System_Char_IsLetter_Char_001D:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Char_IsLetter_Char ENDP

; Boolean Char.IsLetterOrDigit(Char)
PUBLIC __System_Char_IsLetterOrDigit_Char
__System_Char_IsLetterOrDigit_Char PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Char_IsLetterOrDigit_Char_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Char_IsLetter_Char
    ADD ESP, 2
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JNZ L_System_Char_IsLetterOrDigit_Char_0010
L_System_Char_IsLetterOrDigit_Char_0008:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Char_IsDigit_Char
    ADD ESP, 2
    PUSH EAX
    JMP L_System_Char_IsLetterOrDigit_Char_0011
L_System_Char_IsLetterOrDigit_Char_0010:
    PUSH 1
L_System_Char_IsLetterOrDigit_Char_0011:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Char_IsLetterOrDigit_Char ENDP

; Boolean Char.IsUpper(Char)
PUBLIC __System_Char_IsUpper_Char
__System_Char_IsUpper_Char PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Char_IsUpper_Char_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH 65
    POP EBX
    POP EAX
    CMP EAX, EBX
    JL L_System_Char_IsUpper_Char_000F
L_System_Char_IsUpper_Char_0005:
    PUSH DWORD PTR [EBP+8]
    PUSH 90
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETG AL
    MOVZX EAX, AL
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Char_IsUpper_Char_0010
L_System_Char_IsUpper_Char_000F:
    PUSH 0
L_System_Char_IsUpper_Char_0010:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Char_IsUpper_Char ENDP

; Boolean Char.IsLower(Char)
PUBLIC __System_Char_IsLower_Char
__System_Char_IsLower_Char PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Char_IsLower_Char_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH 97
    POP EBX
    POP EAX
    CMP EAX, EBX
    JL L_System_Char_IsLower_Char_000F
L_System_Char_IsLower_Char_0005:
    PUSH DWORD PTR [EBP+8]
    PUSH 122
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETG AL
    MOVZX EAX, AL
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Char_IsLower_Char_0010
L_System_Char_IsLower_Char_000F:
    PUSH 0
L_System_Char_IsLower_Char_0010:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Char_IsLower_Char ENDP

; Char Char.ToUpper(Char)
PUBLIC __System_Char_ToUpper_Char
__System_Char_ToUpper_Char PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Char_ToUpper_Char_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Char_IsLower_Char
    ADD ESP, 2
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JNZ L_System_Char_ToUpper_Char_000B
L_System_Char_ToUpper_Char_0008:
    PUSH DWORD PTR [EBP+8]
    JMP L_System_Char_ToUpper_Char_0010
L_System_Char_ToUpper_Char_000B:
    PUSH DWORD PTR [EBP+8]
    PUSH 32
    POP EBX
    POP EAX
    SUB EAX, EBX
    PUSH EAX
    POP EAX
    MOVZX EAX, AX
    PUSH EAX
L_System_Char_ToUpper_Char_0010:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Char_ToUpper_Char ENDP

; Char Char.ToLower(Char)
PUBLIC __System_Char_ToLower_Char
__System_Char_ToLower_Char PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Char_ToLower_Char_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Char_IsUpper_Char
    ADD ESP, 2
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JNZ L_System_Char_ToLower_Char_000B
L_System_Char_ToLower_Char_0008:
    PUSH DWORD PTR [EBP+8]
    JMP L_System_Char_ToLower_Char_0010
L_System_Char_ToLower_Char_000B:
    PUSH DWORD PTR [EBP+8]
    PUSH 32
    POP EBX
    POP EAX
    ADD EAX, EBX
    PUSH EAX
    POP EAX
    MOVZX EAX, AX
    PUSH EAX
L_System_Char_ToLower_Char_0010:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Char_ToLower_Char ENDP

; String SByte.ToString()
PUBLIC __System_SByte_ToString
__System_SByte_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_SByte_ToString_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    CALL __System_RuntimeHelpers_Int32ToString_Int32
    ADD ESP, 4
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_SByte_ToString ENDP

; Int32 SByte.GetHashCode()
PUBLIC __System_SByte_GetHashCode
__System_SByte_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_SByte_GetHashCode_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_SByte_GetHashCode ENDP

; Boolean SByte.Equals(Object)
PUBLIC __System_SByte_Equals_Object
__System_SByte_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 1
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_SByte_Equals_Object_0000:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_SByte
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JZ L_System_SByte_Equals_Object_0016
L_System_SByte_Equals_Object_0008:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    PUSH DWORD PTR [EAX+4]
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP+8]
    NOP
    PUSH DWORD PTR [EBP-12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_SByte_Equals_Object_0017
L_System_SByte_Equals_Object_0016:
    PUSH 0
L_System_SByte_Equals_Object_0017:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_SByte_Equals_Object ENDP

; String Byte.ToString()
PUBLIC __System_Byte_ToString
__System_Byte_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Byte_ToString_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    CALL __System_RuntimeHelpers_UInt32ToString_UInt32
    ADD ESP, 4
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Byte_ToString ENDP

; Int32 Byte.GetHashCode()
PUBLIC __System_Byte_GetHashCode
__System_Byte_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Byte_GetHashCode_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Byte_GetHashCode ENDP

; Boolean Byte.Equals(Object)
PUBLIC __System_Byte_Equals_Object
__System_Byte_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 1
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Byte_Equals_Object_0000:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_Byte
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JZ L_System_Byte_Equals_Object_0016
L_System_Byte_Equals_Object_0008:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    PUSH DWORD PTR [EAX+4]
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP+8]
    NOP
    PUSH DWORD PTR [EBP-12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Byte_Equals_Object_0017
L_System_Byte_Equals_Object_0016:
    PUSH 0
L_System_Byte_Equals_Object_0017:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Byte_Equals_Object ENDP

; String Int16.ToString()
PUBLIC __System_Int16_ToString
__System_Int16_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Int16_ToString_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    CALL __System_RuntimeHelpers_Int32ToString_Int32
    ADD ESP, 4
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Int16_ToString ENDP

; Int32 Int16.GetHashCode()
PUBLIC __System_Int16_GetHashCode
__System_Int16_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Int16_GetHashCode_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Int16_GetHashCode ENDP

; Boolean Int16.Equals(Object)
PUBLIC __System_Int16_Equals_Object
__System_Int16_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 2
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Int16_Equals_Object_0000:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_Int16
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JZ L_System_Int16_Equals_Object_0016
L_System_Int16_Equals_Object_0008:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    PUSH DWORD PTR [EAX+4]
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP+8]
    NOP
    PUSH DWORD PTR [EBP-12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Int16_Equals_Object_0017
L_System_Int16_Equals_Object_0016:
    PUSH 0
L_System_Int16_Equals_Object_0017:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Int16_Equals_Object ENDP

; String UInt16.ToString()
PUBLIC __System_UInt16_ToString
__System_UInt16_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UInt16_ToString_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    CALL __System_RuntimeHelpers_UInt32ToString_UInt32
    ADD ESP, 4
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UInt16_ToString ENDP

; Int32 UInt16.GetHashCode()
PUBLIC __System_UInt16_GetHashCode
__System_UInt16_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UInt16_GetHashCode_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UInt16_GetHashCode ENDP

; Boolean UInt16.Equals(Object)
PUBLIC __System_UInt16_Equals_Object
__System_UInt16_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 2
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UInt16_Equals_Object_0000:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_UInt16
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JZ L_System_UInt16_Equals_Object_0016
L_System_UInt16_Equals_Object_0008:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    PUSH DWORD PTR [EAX+4]
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP+8]
    NOP
    PUSH DWORD PTR [EBP-12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_UInt16_Equals_Object_0017
L_System_UInt16_Equals_Object_0016:
    PUSH 0
L_System_UInt16_Equals_Object_0017:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UInt16_Equals_Object ENDP

; String Int32.ToString()
PUBLIC __System_Int32_ToString
__System_Int32_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Int32_ToString_0000:
    PUSH DWORD PTR [EBP+8]
    POP EAX
    PUSH DWORD PTR [EAX]
    CALL __System_RuntimeHelpers_Int32ToString_Int32
    ADD ESP, 4
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Int32_ToString ENDP

; Int32 Int32.GetHashCode()
PUBLIC __System_Int32_GetHashCode
__System_Int32_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Int32_GetHashCode_0000:
    PUSH DWORD PTR [EBP+8]
    POP EAX
    PUSH DWORD PTR [EAX]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Int32_GetHashCode ENDP

; Boolean Int32.Equals(Object)
PUBLIC __System_Int32_Equals_Object
__System_Int32_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Int32_Equals_Object_0000:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_Int32
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JZ L_System_Int32_Equals_Object_0016
L_System_Int32_Equals_Object_0008:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    PUSH DWORD PTR [EAX+4]
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP+8]
    POP EAX
    PUSH DWORD PTR [EAX]
    PUSH DWORD PTR [EBP-12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Int32_Equals_Object_0017
L_System_Int32_Equals_Object_0016:
    PUSH 0
L_System_Int32_Equals_Object_0017:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Int32_Equals_Object ENDP

; Int32 Int32.Parse(String)
PUBLIC __System_Int32_Parse_String
__System_Int32_Parse_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Int32_Parse_String_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_RuntimeHelpers_ParseInt32_String
    ADD ESP, 4
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Int32_Parse_String ENDP

; String UInt32.ToString()
PUBLIC __System_UInt32_ToString
__System_UInt32_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UInt32_ToString_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    CALL __System_RuntimeHelpers_UInt32ToString_UInt32
    ADD ESP, 4
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UInt32_ToString ENDP

; Int32 UInt32.GetHashCode()
PUBLIC __System_UInt32_GetHashCode
__System_UInt32_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UInt32_GetHashCode_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UInt32_GetHashCode ENDP

; Boolean UInt32.Equals(Object)
PUBLIC __System_UInt32_Equals_Object
__System_UInt32_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UInt32_Equals_Object_0000:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_UInt32
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JZ L_System_UInt32_Equals_Object_0016
L_System_UInt32_Equals_Object_0008:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    PUSH DWORD PTR [EAX+4]
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP+8]
    NOP
    PUSH DWORD PTR [EBP-12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_UInt32_Equals_Object_0017
L_System_UInt32_Equals_Object_0016:
    PUSH 0
L_System_UInt32_Equals_Object_0017:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UInt32_Equals_Object ENDP

; String Int64.ToString()
PUBLIC __System_Int64_ToString
__System_Int64_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Int64_ToString_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    CALL __System_RuntimeHelpers_Int64ToString_Int64
    ADD ESP, 8
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Int64_ToString ENDP

; Int32 Int64.GetHashCode()
PUBLIC __System_Int64_GetHashCode
__System_Int64_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Int64_GetHashCode_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    PUSH DWORD PTR [EBP+8]
    NOP
    PUSH 32
    POP ECX
    POP EAX
    SAR EAX, CL
    PUSH EAX
    POP EBX
    POP EAX
    XOR EAX, EBX
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Int64_GetHashCode ENDP

; Boolean Int64.Equals(Object)
PUBLIC __System_Int64_Equals_Object
__System_Int64_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 8
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Int64_Equals_Object_0000:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_Int64
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JZ L_System_Int64_Equals_Object_0016
L_System_Int64_Equals_Object_0008:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    PUSH DWORD PTR [EAX+4]
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP+8]
    NOP
    PUSH DWORD PTR [EBP-12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Int64_Equals_Object_0017
L_System_Int64_Equals_Object_0016:
    PUSH 0
L_System_Int64_Equals_Object_0017:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Int64_Equals_Object ENDP

; String UInt64.ToString()
PUBLIC __System_UInt64_ToString
__System_UInt64_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UInt64_ToString_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    CALL __System_RuntimeHelpers_UInt64ToString_UInt64
    ADD ESP, 8
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UInt64_ToString ENDP

; Int32 UInt64.GetHashCode()
PUBLIC __System_UInt64_GetHashCode
__System_UInt64_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UInt64_GetHashCode_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    PUSH DWORD PTR [EBP+8]
    NOP
    PUSH 32
    POP ECX
    POP EAX
    SHR EAX, CL
    PUSH EAX
    POP EBX
    POP EAX
    XOR EAX, EBX
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UInt64_GetHashCode ENDP

; Boolean UInt64.Equals(Object)
PUBLIC __System_UInt64_Equals_Object
__System_UInt64_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 8
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UInt64_Equals_Object_0000:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_UInt64
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JZ L_System_UInt64_Equals_Object_0016
L_System_UInt64_Equals_Object_0008:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    PUSH DWORD PTR [EAX+4]
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP+8]
    NOP
    PUSH DWORD PTR [EBP-12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_UInt64_Equals_Object_0017
L_System_UInt64_Equals_Object_0016:
    PUSH 0
L_System_UInt64_Equals_Object_0017:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UInt64_Equals_Object ENDP

; String Single.ToString()
PUBLIC __System_Single_ToString
__System_Single_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Single_ToString_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    CALL __System_RuntimeHelpers_SingleToString_Single
    ADD ESP, 4
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Single_ToString ENDP

; Int32 Single.GetHashCode()
PUBLIC __System_Single_GetHashCode
__System_Single_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Single_GetHashCode_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    CALL __System_RuntimeHelpers_SingleToInt32Bits_Single
    ADD ESP, 4
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Single_GetHashCode ENDP

; Boolean Single.Equals(Object)
PUBLIC __System_Single_Equals_Object
__System_Single_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Single_Equals_Object_0000:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_Single
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JZ L_System_Single_Equals_Object_0016
L_System_Single_Equals_Object_0008:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    PUSH DWORD PTR [EAX+4]
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP+8]
    NOP
    PUSH DWORD PTR [EBP-12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Single_Equals_Object_0017
L_System_Single_Equals_Object_0016:
    PUSH 0
L_System_Single_Equals_Object_0017:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Single_Equals_Object ENDP

; Boolean Single.IsNaN(Single)
PUBLIC __System_Single_IsNaN_Single
__System_Single_IsNaN_Single PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Single_IsNaN_Single_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+8]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Single_IsNaN_Single ENDP

; Boolean Single.IsInfinity(Single)
PUBLIC __System_Single_IsInfinity_Single
__System_Single_IsInfinity_Single PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Single_IsInfinity_Single_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH 2139095040
    POP EBX
    POP EAX
    CMP EAX, EBX
    JE L_System_Single_IsInfinity_Single_0012
L_System_Single_IsInfinity_Single_0008:
    PUSH DWORD PTR [EBP+8]
    PUSH -8388608
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Single_IsInfinity_Single_0013
L_System_Single_IsInfinity_Single_0012:
    PUSH 1
L_System_Single_IsInfinity_Single_0013:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Single_IsInfinity_Single ENDP

; String Double.ToString()
PUBLIC __System_Double_ToString
__System_Double_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Double_ToString_0000:
    PUSH DWORD PTR [EBP+8]
    NOP
    CALL __System_RuntimeHelpers_DoubleToString_Double
    ADD ESP, 8
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Double_ToString ENDP

; Int32 Double.GetHashCode()
PUBLIC __System_Double_GetHashCode
__System_Double_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 12
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Double_GetHashCode_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    NOP
    CALL __System_RuntimeHelpers_DoubleToInt64Bits_Double
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    PUSH DWORD PTR [EBP-12]
    PUSH 32
    POP ECX
    POP EAX
    SAR EAX, CL
    PUSH EAX
    POP EBX
    POP EAX
    XOR EAX, EBX
    PUSH EAX
    POP EAX
    MOV [EBP-20], EAX
    JMP L_System_Double_GetHashCode_0014
L_System_Double_GetHashCode_0014:
    PUSH DWORD PTR [EBP-20]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Double_GetHashCode ENDP

; Boolean Double.Equals(Object)
PUBLIC __System_Double_Equals_Object
__System_Double_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 8
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Double_Equals_Object_0000:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_Double
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JZ L_System_Double_Equals_Object_0016
L_System_Double_Equals_Object_0008:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    PUSH DWORD PTR [EAX+4]
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP+8]
    NOP
    PUSH DWORD PTR [EBP-12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Double_Equals_Object_0017
L_System_Double_Equals_Object_0016:
    PUSH 0
L_System_Double_Equals_Object_0017:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Double_Equals_Object ENDP

; Boolean Double.IsNaN(Double)
PUBLIC __System_Double_IsNaN_Double
__System_Double_IsNaN_Double PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Double_IsNaN_Double_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+8]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Double_IsNaN_Double ENDP

; Boolean Double.IsInfinity(Double)
PUBLIC __System_Double_IsInfinity_Double
__System_Double_IsInfinity_Double PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Double_IsInfinity_Double_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH 2146435072
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    JE L_System_Double_IsInfinity_Double_001A
L_System_Double_IsInfinity_Double_000C:
    PUSH DWORD PTR [EBP+8]
    PUSH -1048576
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Double_IsInfinity_Double_001B
L_System_Double_IsInfinity_Double_001A:
    PUSH 1
L_System_Double_IsInfinity_Double_001B:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Double_IsInfinity_Double ENDP

; Int32 IntPtr.get_Size()
PUBLIC __System_IntPtr_get_Size
__System_IntPtr_get_Size PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_IntPtr_get_Size_0000:
    PUSH 4
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_IntPtr_get_Size ENDP

; Void IntPtr..ctor(Int32)
PUBLIC __System_IntPtr__ctor_Int32
__System_IntPtr__ctor_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_IntPtrctor_Int32_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_IntPtr__ctor_Int32 ENDP

; Int32 IntPtr.ToInt32()
PUBLIC __System_IntPtr_ToInt32
__System_IntPtr_ToInt32 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_IntPtr_ToInt32_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_IntPtr_ToInt32 ENDP

; String IntPtr.ToString()
PUBLIC __System_IntPtr_ToString
__System_IntPtr_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_IntPtr_ToString_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    CALL __System_RuntimeHelpers_Int32ToString_Int32
    ADD ESP, 4
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_IntPtr_ToString ENDP

; Int32 IntPtr.GetHashCode()
PUBLIC __System_IntPtr_GetHashCode
__System_IntPtr_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_IntPtr_GetHashCode_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_IntPtr_GetHashCode ENDP

; Boolean IntPtr.Equals(Object)
PUBLIC __System_IntPtr_Equals_Object
__System_IntPtr_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_IntPtr_Equals_Object_0000:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_IntPtr
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JZ L_System_IntPtr_Equals_Object_0020
L_System_IntPtr_Equals_Object_0008:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    PUSH DWORD PTR [EAX+4]
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    NOP
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_IntPtr_Equals_Object_0021
L_System_IntPtr_Equals_Object_0020:
    PUSH 0
L_System_IntPtr_Equals_Object_0021:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_IntPtr_Equals_Object ENDP

; Boolean IntPtr.op_Equality(IntPtr, IntPtr)
PUBLIC __System_IntPtr_op_Equality_IntPtr_IntPtr
__System_IntPtr_op_Equality_IntPtr_IntPtr PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_IntPtr_op_Equality_IntPtr_IntPtr_0000:
    NOP
    POP ESI
    PUSH DWORD PTR [ESI+0]
    NOP
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_IntPtr_op_Equality_IntPtr_IntPtr ENDP

; Boolean IntPtr.op_Inequality(IntPtr, IntPtr)
PUBLIC __System_IntPtr_op_Inequality_IntPtr_IntPtr
__System_IntPtr_op_Inequality_IntPtr_IntPtr PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_IntPtr_op_Inequality_IntPtr_IntPtr_0000:
    NOP
    POP ESI
    PUSH DWORD PTR [ESI+0]
    NOP
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_IntPtr_op_Inequality_IntPtr_IntPtr ENDP

; Void IntPtr..cctor()
__System_IntPtr__cctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_IntPtrcctor_0000:
    PUSH 0
    ; newobj System.IntPtr::.ctor
    MOV EAX, 4
    MOV EBX, 0
    CALL __gc_alloc_typed
    TEST EAX, EAX
    JZ __throw_out_of_memory
    MOV DWORD PTR [EAX], OFFSET __vtbl_System_IntPtr
    PUSH EAX
    CALL __System_IntPtr__ctor_Int32
    ADD ESP, 8
    POP EAX
    MOV [__static_System_IntPtr_Zero], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_IntPtr__cctor ENDP

; Int32 UIntPtr.get_Size()
PUBLIC __System_UIntPtr_get_Size
__System_UIntPtr_get_Size PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UIntPtr_get_Size_0000:
    PUSH 4
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UIntPtr_get_Size ENDP

; Void UIntPtr..ctor(UInt32)
PUBLIC __System_UIntPtr__ctor_UInt32
__System_UIntPtr__ctor_UInt32 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UIntPtrctor_UInt32_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UIntPtr__ctor_UInt32 ENDP

; UInt32 UIntPtr.ToUInt32()
PUBLIC __System_UIntPtr_ToUInt32
__System_UIntPtr_ToUInt32 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UIntPtr_ToUInt32_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UIntPtr_ToUInt32 ENDP

; String UIntPtr.ToString()
PUBLIC __System_UIntPtr_ToString
__System_UIntPtr_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UIntPtr_ToString_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    CALL __System_RuntimeHelpers_UInt32ToString_UInt32
    ADD ESP, 4
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UIntPtr_ToString ENDP

; Int32 UIntPtr.GetHashCode()
PUBLIC __System_UIntPtr_GetHashCode
__System_UIntPtr_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UIntPtr_GetHashCode_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UIntPtr_GetHashCode ENDP

; Boolean UIntPtr.Equals(Object)
PUBLIC __System_UIntPtr_Equals_Object
__System_UIntPtr_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UIntPtr_Equals_Object_0000:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_UIntPtr
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JZ L_System_UIntPtr_Equals_Object_0020
L_System_UIntPtr_Equals_Object_0008:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    PUSH DWORD PTR [EAX+4]
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    NOP
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_UIntPtr_Equals_Object_0021
L_System_UIntPtr_Equals_Object_0020:
    PUSH 0
L_System_UIntPtr_Equals_Object_0021:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UIntPtr_Equals_Object ENDP

; Boolean UIntPtr.op_Equality(UIntPtr, UIntPtr)
PUBLIC __System_UIntPtr_op_Equality_UIntPtr_UIntPtr
__System_UIntPtr_op_Equality_UIntPtr_UIntPtr PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UIntPtr_op_Equality_UIntPtr_UIntPtr_0000:
    NOP
    POP ESI
    PUSH DWORD PTR [ESI+0]
    NOP
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UIntPtr_op_Equality_UIntPtr_UIntPtr ENDP

; Boolean UIntPtr.op_Inequality(UIntPtr, UIntPtr)
PUBLIC __System_UIntPtr_op_Inequality_UIntPtr_UIntPtr
__System_UIntPtr_op_Inequality_UIntPtr_UIntPtr PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UIntPtr_op_Inequality_UIntPtr_UIntPtr_0000:
    NOP
    POP ESI
    PUSH DWORD PTR [ESI+0]
    NOP
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UIntPtr_op_Inequality_UIntPtr_UIntPtr ENDP

; Void UIntPtr..cctor()
__System_UIntPtr__cctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_UIntPtrcctor_0000:
    PUSH 0
    ; newobj System.UIntPtr::.ctor
    MOV EAX, 4
    MOV EBX, 0
    CALL __gc_alloc_typed
    TEST EAX, EAX
    JZ __throw_out_of_memory
    MOV DWORD PTR [EAX], OFFSET __vtbl_System_UIntPtr
    PUSH EAX
    CALL __System_UIntPtr__ctor_UInt32
    ADD ESP, 8
    POP EAX
    MOV [__static_System_UIntPtr_Zero], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_UIntPtr__cctor ENDP

; Int32 RuntimeHelpers.GetHashCode(Object)
PUBLIC __System_RuntimeHelpers_GetHashCode_Object
__System_RuntimeHelpers_GetHashCode_Object PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    MOV EAX, [EBP+8]
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_GetHashCode_Object ENDP

; RuntimeTypeHandle RuntimeHelpers.GetTypeHandle(Object)
PUBLIC __System_RuntimeHelpers_GetTypeHandle_Object
__System_RuntimeHelpers_GetTypeHandle_Object PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    MOV EAX, [EBP+8]
    MOV EAX, [EAX-4]
    MOVZX EAX, AX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_GetTypeHandle_Object ENDP

; Type RuntimeHelpers.GetTypeFromHandle(RuntimeTypeHandle)
PUBLIC __System_RuntimeHelpers_GetTypeFromHandle_RuntimeTypeHandle
__System_RuntimeHelpers_GetTypeFromHandle_RuntimeTypeHandle PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    XOR EAX, EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_GetTypeFromHandle_RuntimeTypeHandle ENDP

; Object RuntimeHelpers.MemberwiseClone(Object)
PUBLIC __System_RuntimeHelpers_MemberwiseClone_Object
__System_RuntimeHelpers_MemberwiseClone_Object PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    MOV EAX, [EBP+8]
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_MemberwiseClone_Object ENDP

; Boolean RuntimeHelpers.ValueTypeEquals(Object, Object)
PUBLIC __System_RuntimeHelpers_ValueTypeEquals_Object_Object
__System_RuntimeHelpers_ValueTypeEquals_Object_Object PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    MOV ESI, [EBP+8]
    MOV EDI, [EBP+12]
    MOV ECX, [ESI-8]
    SUB ECX, 12
    REPE CMPSB
    SETE AL
    MOVZX EAX, AL
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_ValueTypeEquals_Object_Object ENDP

; Int32 RuntimeHelpers.ValueTypeGetHashCode(Object)
PUBLIC __System_RuntimeHelpers_ValueTypeGetHashCode_Object
__System_RuntimeHelpers_ValueTypeGetHashCode_Object PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    MOV ESI, [EBP+8]
    MOV ECX, [ESI-8]
    SUB ECX, 12
    XOR EAX, EAX
    @@loop:
    JECXZ @@done
    ROL EAX, 5
    XOR AL, [ESI]
    INC ESI
    DEC ECX
    JMP @@loop
    @@done:
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_ValueTypeGetHashCode_Object ENDP

; Char RuntimeHelpers.GetCharAt(String, Int32)
PUBLIC __System_RuntimeHelpers_GetCharAt_String_Int32
__System_RuntimeHelpers_GetCharAt_String_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    MOV ESI, [EBP+8]
    MOV ECX, [EBP+12]
    ADD ESI, 8
    MOVZX EAX, WORD PTR [ESI + ECX*2]
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_GetCharAt_String_Int32 ENDP

; Boolean RuntimeHelpers.StringEquals(String, String)
PUBLIC __System_RuntimeHelpers_StringEquals_String_String
__System_RuntimeHelpers_StringEquals_String_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    MOV ESI, [EBP+8]
    MOV EDI, [EBP+12]
    MOV ECX, [ESI]
    ADD ESI, 4
    ADD EDI, 4
    SHL ECX, 1
    REPE CMPSB
    SETE AL
    MOVZX EAX, AL
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_StringEquals_String_String ENDP

; Int32 RuntimeHelpers.StringGetHashCode(String)
PUBLIC __System_RuntimeHelpers_StringGetHashCode_String
__System_RuntimeHelpers_StringGetHashCode_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    MOV ESI, [EBP+8]
    MOV ECX, [ESI]
    ADD ESI, 4
    XOR EAX, EAX
    @@loop:
    JECXZ @@done
    ROL EAX, 5
    XOR AX, [ESI]
    ADD ESI, 2
    DEC ECX
    JMP @@loop
    @@done:
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_StringGetHashCode_String ENDP

; Void RuntimeHelpers.CopyCharsToString(String, Char[])
PUBLIC __System_RuntimeHelpers_CopyCharsToString_String_Char__
__System_RuntimeHelpers_CopyCharsToString_String_Char__ PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; CopyCharsToString - copia chars do array para a string
    ; [EBP+8] = string destino, [EBP+12] = char[] fonte
    MOV EDI, [EBP+8]
    MOV ESI, [EBP+12]
    MOV ECX, [ESI]          ; Length do array
    ADD EDI, 5              ; Pular length (4) + firstChar (1)
    ADD ESI, 5              ; Pular length (4) + primeiro elemento (1)
    DEC ECX                 ; Já copiamos o primeiro char
    TEST ECX, ECX
    JLE @@done
    REP MOVSB
    @@done:
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_CopyCharsToString_String_Char__ ENDP

; String RuntimeHelpers.StringConcat(String, String)
PUBLIC __System_RuntimeHelpers_StringConcat_String_String
__System_RuntimeHelpers_StringConcat_String_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    MOV EAX, [EBP+8]
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_StringConcat_String_String ENDP

; String RuntimeHelpers.CharToString(Char)
PUBLIC __System_RuntimeHelpers_CharToString_Char
__System_RuntimeHelpers_CharToString_Char PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    XOR EAX, EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_CharToString_Char ENDP

; String RuntimeHelpers.Int32ToString(Int32)
PUBLIC __System_RuntimeHelpers_Int32ToString_Int32
__System_RuntimeHelpers_Int32ToString_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 30
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_RuntimeHelpers_Int32ToString_Int32_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-33], EAX
    PUSH DWORD PTR [EBP-33]
    POP EAX
    TEST EAX, EAX
    JZ L_System_RuntimeHelpers_Int32ToString_Int32_0017
L_System_RuntimeHelpers_Int32ToString_Int32_000B:
    PUSH OFFSET __str_20
    POP EAX
    MOV [EBP-34], EAX
    JMP L_System_RuntimeHelpers_Int32ToString_Int32_0098
L_System_RuntimeHelpers_Int32ToString_Int32_0017:
    PUSH DWORD PTR [EBP+8]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETL AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    POP EAX
    MOV [EBP-38], EAX
    PUSH DWORD PTR [EBP-38]
    POP EAX
    TEST EAX, EAX
    JZ L_System_RuntimeHelpers_Int32ToString_Int32_0027
L_System_RuntimeHelpers_Int32ToString_Int32_0023:
    PUSH DWORD PTR [EBP+8]
    POP EAX
    NEG EAX
    PUSH EAX
    POP EAX
    MOV [EBP+8], EAX
L_System_RuntimeHelpers_Int32ToString_Int32_0027:
    PUSH DWORD PTR [EBP+8]
    POP EAX
    MOV [EBP-13], EAX
    PUSH 0
    POP EAX
    MOV [EBP-17], EAX
    JMP L_System_RuntimeHelpers_Int32ToString_Int32_0038
L_System_RuntimeHelpers_Int32ToString_Int32_002D:
    NOP
    PUSH DWORD PTR [EBP-17]
    PUSH 1
    POP EBX
    POP EAX
    ADD EAX, EBX
    PUSH EAX
    POP EAX
    MOV [EBP-17], EAX
    PUSH DWORD PTR [EBP-13]
    PUSH 10
    POP EBX
    POP EAX
    CDQ
    IDIV EBX
    PUSH EAX
    POP EAX
    MOV [EBP-13], EAX
    NOP
L_System_RuntimeHelpers_Int32ToString_Int32_0038:
    PUSH DWORD PTR [EBP-13]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETG AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-39], EAX
    PUSH DWORD PTR [EBP-39]
    POP EAX
    TEST EAX, EAX
    JNZ L_System_RuntimeHelpers_Int32ToString_Int32_002D
L_System_RuntimeHelpers_Int32ToString_Int32_0042:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    TEST EAX, EAX
    JNZ L_System_RuntimeHelpers_Int32ToString_Int32_0048
L_System_RuntimeHelpers_Int32ToString_Int32_0045:
    PUSH DWORD PTR [EBP-17]
    JMP L_System_RuntimeHelpers_Int32ToString_Int32_004B
L_System_RuntimeHelpers_Int32ToString_Int32_0048:
    PUSH DWORD PTR [EBP-17]
    PUSH 1
    POP EBX
    POP EAX
    ADD EAX, EBX
    PUSH EAX
L_System_RuntimeHelpers_Int32ToString_Int32_004B:
    POP EAX
    MOV [EBP-21], EAX
    PUSH DWORD PTR [EBP-21]
    POP ECX
    MOV EAX, ECX
    IMUL EAX, 4
    ADD EAX, 12
    PUSH ECX
    CALL __gc_alloc
    POP ECX
    TEST EAX, EAX
    JZ __throw_out_of_memory
    MOV DWORD PTR [EAX], OFFSET __vtbl_System_Array
    MOV [EAX+4], ECX
    PUSH EAX
    POP EAX
    MOV [EBP-25], EAX
    PUSH DWORD PTR [EBP-21]
    PUSH 1
    POP EBX
    POP EAX
    SUB EAX, EBX
    PUSH EAX
    POP EAX
    MOV [EBP-29], EAX
    JMP L_System_RuntimeHelpers_Int32ToString_Int32_0076
L_System_RuntimeHelpers_Int32ToString_Int32_005B:
    NOP
    PUSH DWORD PTR [EBP-25]
    PUSH DWORD PTR [EBP-29]
    PUSH 48
    PUSH DWORD PTR [EBP+8]
    PUSH 10
    POP EBX
    POP EAX
    CDQ
    IDIV EBX
    PUSH EDX
    POP EBX
    POP EAX
    ADD EAX, EBX
    PUSH EAX
    POP EAX
    MOVZX EAX, AX
    PUSH EAX
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH 10
    POP EBX
    POP EAX
    CDQ
    IDIV EBX
    PUSH EAX
    POP EAX
    MOV [EBP+8], EAX
    PUSH DWORD PTR [EBP-29]
    PUSH 1
    POP EBX
    POP EAX
    SUB EAX, EBX
    PUSH EAX
    POP EAX
    MOV [EBP-29], EAX
    NOP
L_System_RuntimeHelpers_Int32ToString_Int32_0076:
    PUSH DWORD PTR [EBP+8]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETG AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-40], EAX
    PUSH DWORD PTR [EBP-40]
    POP EAX
    TEST EAX, EAX
    JNZ L_System_RuntimeHelpers_Int32ToString_Int32_005B
L_System_RuntimeHelpers_Int32ToString_Int32_0080:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    MOV [EBP-41], EAX
    PUSH DWORD PTR [EBP-41]
    POP EAX
    TEST EAX, EAX
    JZ L_System_RuntimeHelpers_Int32ToString_Int32_008D
L_System_RuntimeHelpers_Int32ToString_Int32_0087:
    PUSH DWORD PTR [EBP-25]
    PUSH 0
    PUSH 45
    NOP
L_System_RuntimeHelpers_Int32ToString_Int32_008D:
    PUSH DWORD PTR [EBP-25]
    ; newobj System.String::.ctor
    MOV EAX, 12
    MOV EBX, 0
    CALL __gc_alloc_typed
    TEST EAX, EAX
    JZ __throw_out_of_memory
    MOV DWORD PTR [EAX], OFFSET __vtbl_System_String
    PUSH EAX
    CALL __System_String__ctor_Char__
    ADD ESP, 8
    POP EAX
    MOV [EBP-34], EAX
    JMP L_System_RuntimeHelpers_Int32ToString_Int32_0098
L_System_RuntimeHelpers_Int32ToString_Int32_0098:
    PUSH DWORD PTR [EBP-34]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_Int32ToString_Int32 ENDP

; String RuntimeHelpers.UInt32ToString(UInt32)
PUBLIC __System_RuntimeHelpers_UInt32ToString_UInt32
__System_RuntimeHelpers_UInt32ToString_UInt32 PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 23
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_RuntimeHelpers_UInt32ToString_UInt32_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-28], EAX
    PUSH DWORD PTR [EBP-28]
    POP EAX
    TEST EAX, EAX
    JZ L_System_RuntimeHelpers_UInt32ToString_UInt32_0014
L_System_RuntimeHelpers_UInt32ToString_UInt32_000B:
    PUSH OFFSET __str_20
    POP EAX
    MOV [EBP-29], EAX
    JMP L_System_RuntimeHelpers_UInt32ToString_UInt32_0067
L_System_RuntimeHelpers_UInt32ToString_UInt32_0014:
    PUSH DWORD PTR [EBP+8]
    POP EAX
    MOV [EBP-12], EAX
    PUSH 0
    POP EAX
    MOV [EBP-16], EAX
    JMP L_System_RuntimeHelpers_UInt32ToString_UInt32_0025
L_System_RuntimeHelpers_UInt32ToString_UInt32_001A:
    NOP
    PUSH DWORD PTR [EBP-16]
    PUSH 1
    POP EBX
    POP EAX
    ADD EAX, EBX
    PUSH EAX
    POP EAX
    MOV [EBP-16], EAX
    PUSH DWORD PTR [EBP-12]
    PUSH 10
    POP EBX
    POP EAX
    XOR EDX, EDX
    DIV EBX
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    NOP
L_System_RuntimeHelpers_UInt32ToString_UInt32_0025:
    PUSH DWORD PTR [EBP-12]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETA AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-33], EAX
    PUSH DWORD PTR [EBP-33]
    POP EAX
    TEST EAX, EAX
    JNZ L_System_RuntimeHelpers_UInt32ToString_UInt32_001A
L_System_RuntimeHelpers_UInt32ToString_UInt32_002F:
    PUSH DWORD PTR [EBP-16]
    POP ECX
    MOV EAX, ECX
    IMUL EAX, 4
    ADD EAX, 12
    PUSH ECX
    CALL __gc_alloc
    POP ECX
    TEST EAX, EAX
    JZ __throw_out_of_memory
    MOV DWORD PTR [EAX], OFFSET __vtbl_System_Array
    MOV [EAX+4], ECX
    PUSH EAX
    POP EAX
    MOV [EBP-20], EAX
    PUSH DWORD PTR [EBP-16]
    PUSH 1
    POP EBX
    POP EAX
    SUB EAX, EBX
    PUSH EAX
    POP EAX
    MOV [EBP-24], EAX
    JMP L_System_RuntimeHelpers_UInt32ToString_UInt32_0053
L_System_RuntimeHelpers_UInt32ToString_UInt32_003C:
    NOP
    PUSH DWORD PTR [EBP-20]
    PUSH DWORD PTR [EBP-24]
    PUSH 48
    PUSH DWORD PTR [EBP+8]
    PUSH 10
    POP EBX
    POP EAX
    XOR EDX, EDX
    DIV EBX
    PUSH EDX
    POP EBX
    POP EAX
    ADD EAX, EBX
    PUSH EAX
    POP EAX
    MOVZX EAX, AX
    PUSH EAX
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH 10
    POP EBX
    POP EAX
    XOR EDX, EDX
    DIV EBX
    PUSH EAX
    POP EAX
    MOV [EBP+8], EAX
    PUSH DWORD PTR [EBP-24]
    PUSH 1
    POP EBX
    POP EAX
    SUB EAX, EBX
    PUSH EAX
    POP EAX
    MOV [EBP-24], EAX
    NOP
L_System_RuntimeHelpers_UInt32ToString_UInt32_0053:
    PUSH DWORD PTR [EBP+8]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETA AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-34], EAX
    PUSH DWORD PTR [EBP-34]
    POP EAX
    TEST EAX, EAX
    JNZ L_System_RuntimeHelpers_UInt32ToString_UInt32_003C
L_System_RuntimeHelpers_UInt32ToString_UInt32_005D:
    PUSH DWORD PTR [EBP-20]
    ; newobj System.String::.ctor
    MOV EAX, 12
    MOV EBX, 0
    CALL __gc_alloc_typed
    TEST EAX, EAX
    JZ __throw_out_of_memory
    MOV DWORD PTR [EAX], OFFSET __vtbl_System_String
    PUSH EAX
    CALL __System_String__ctor_Char__
    ADD ESP, 8
    POP EAX
    MOV [EBP-29], EAX
    JMP L_System_RuntimeHelpers_UInt32ToString_UInt32_0067
L_System_RuntimeHelpers_UInt32ToString_UInt32_0067:
    PUSH DWORD PTR [EBP-29]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_UInt32ToString_UInt32 ENDP

; String RuntimeHelpers.Int64ToString(Int64)
PUBLIC __System_RuntimeHelpers_Int64ToString_Int64
__System_RuntimeHelpers_Int64ToString_Int64 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    XOR EAX, EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_Int64ToString_Int64 ENDP

; String RuntimeHelpers.UInt64ToString(UInt64)
PUBLIC __System_RuntimeHelpers_UInt64ToString_UInt64
__System_RuntimeHelpers_UInt64ToString_UInt64 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    XOR EAX, EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_UInt64ToString_UInt64 ENDP

; String RuntimeHelpers.SingleToString(Single)
PUBLIC __System_RuntimeHelpers_SingleToString_Single
__System_RuntimeHelpers_SingleToString_Single PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    XOR EAX, EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_SingleToString_Single ENDP

; String RuntimeHelpers.DoubleToString(Double)
PUBLIC __System_RuntimeHelpers_DoubleToString_Double
__System_RuntimeHelpers_DoubleToString_Double PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    XOR EAX, EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_DoubleToString_Double ENDP

; Int32 RuntimeHelpers.SingleToInt32Bits(Single)
PUBLIC __System_RuntimeHelpers_SingleToInt32Bits_Single
__System_RuntimeHelpers_SingleToInt32Bits_Single PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    MOV EAX, [EBP+8]
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_SingleToInt32Bits_Single ENDP

; Int64 RuntimeHelpers.DoubleToInt64Bits(Double)
PUBLIC __System_RuntimeHelpers_DoubleToInt64Bits_Double
__System_RuntimeHelpers_DoubleToInt64Bits_Double PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    MOV EAX, [EBP+8]
    MOV EDX, [EBP+8]+4
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_DoubleToInt64Bits_Double ENDP

; Int32 RuntimeHelpers.ParseInt32(String)
PUBLIC __System_RuntimeHelpers_ParseInt32_String
__System_RuntimeHelpers_ParseInt32_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    XOR EAX, EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_ParseInt32_String ENDP

; Void RuntimeHelpers.ArrayClear(Array, Int32, Int32)
PUBLIC __System_RuntimeHelpers_ArrayClear_Array_Int32_Int32
__System_RuntimeHelpers_ArrayClear_Array_Int32_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    MOV EDI, [EBP+8]
    ADD EDI, [EBP+12]
    MOV ECX, [EBP+16]
    XOR EAX, EAX
    REP STOSB
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_ArrayClear_Array_Int32_Int32 ENDP

; Object RuntimeHelpers.ArrayGetValue(Array, Int32)
PUBLIC __System_RuntimeHelpers_ArrayGetValue_Array_Int32
__System_RuntimeHelpers_ArrayGetValue_Array_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    MOV ESI, [EBP+8]
    MOV ECX, [EBP+12]
    MOV EAX, [ESI + ECX*4 + 8]
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeHelpers_ArrayGetValue_Array_Int32 ENDP

; IntPtr RuntimeTypeHandle.get_Value()
PUBLIC __System_RuntimeTypeHandle_get_Value
__System_RuntimeTypeHandle_get_Value PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_RuntimeTypeHandle_get_Value_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeTypeHandle_get_Value ENDP

; Int32 String.get_Length()
PUBLIC __System_String_get_Length
__System_String_get_Length PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_String_get_Length_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_String_get_Length ENDP

; Void String..ctor(Char[])
PUBLIC __System_String__ctor_Char__
__System_String__ctor_Char__ PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 1
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Stringctor_Char_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Object__ctor
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ L_System_Stringctor_Char_0012
L_System_Stringctor_Char_000B:
    PUSH DWORD PTR [EBP+12]
    POP EAX
    PUSH DWORD PTR [EAX+4]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Stringctor_Char_0013
L_System_Stringctor_Char_0012:
    PUSH 1
L_System_Stringctor_Char_0013:
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    POP EAX
    TEST EAX, EAX
    JZ L_System_Stringctor_Char_0028
L_System_Stringctor_Char_0017:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH 0
    POP EAX
    POP ESI
    MOV [ESI+4], EAX
    PUSH DWORD PTR [EBP+8]
    PUSH 0
    POP EAX
    POP ESI
    MOV [ESI+8], EAX
    JMP L_System_Stringctor_Char_0042
L_System_Stringctor_Char_0028:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    PUSH DWORD PTR [EAX+4]
    POP EAX
    POP ESI
    MOV [ESI+4], EAX
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    PUSH 0
    NOP
    POP EAX
    POP ESI
    MOV [ESI+8], EAX
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_RuntimeHelpers_CopyCharsToString_String_Char__
    ADD ESP, 8
    NOP
L_System_Stringctor_Char_0042:
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_String__ctor_Char__ ENDP

; Char String.get_Item(Int32)
PUBLIC __System_String_get_Item_Int32
__System_String_get_Item_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 3
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_String_get_Item_Int32_0000:
    NOP
    PUSH DWORD PTR [EBP+12]
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETB AL
    MOVZX EAX, AL
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    POP EAX
    TEST EAX, EAX
    JZ L_System_String_get_Item_Int32_0017
L_System_String_get_Item_Int32_0011:
    ; newobj System.IndexOutOfRangeException::.ctor
    MOV EAX, 8
    MOV EBX, 50
    CALL __gc_alloc_typed
    TEST EAX, EAX
    JZ __throw_out_of_memory
    MOV DWORD PTR [EAX], OFFSET __vtbl_System_IndexOutOfRangeException
    PUSH EAX
    CALL __System_IndexOutOfRangeException__ctor
    ADD ESP, 4
    POP EAX
    CALL __throw_exception
L_System_String_get_Item_Int32_0017:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_RuntimeHelpers_GetCharAt_String_Int32
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_String_get_Item_Int32_0021
L_System_String_get_Item_Int32_0021:
    PUSH DWORD PTR [EBP-13]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_String_get_Item_Int32 ENDP

; Boolean String.IsNullOrEmpty(String)
PUBLIC __System_String_IsNullOrEmpty_String
__System_String_IsNullOrEmpty_String PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 1
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_String_IsNullOrEmpty_String_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    POP EAX
    TEST EAX, EAX
    JZ L_System_String_IsNullOrEmpty_String_000F
L_System_String_IsNullOrEmpty_String_0004:
    PUSH DWORD PTR [EBP+8]
    CALL __System_String_get_Length
    ADD ESP, 8
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_String_IsNullOrEmpty_String_0010
L_System_String_IsNullOrEmpty_String_000F:
    PUSH 1
L_System_String_IsNullOrEmpty_String_0010:
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_String_IsNullOrEmpty_String_0013
L_System_String_IsNullOrEmpty_String_0013:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_String_IsNullOrEmpty_String ENDP

; Boolean String.IsNullOrWhiteSpace(String)
PUBLIC __System_String_IsNullOrWhiteSpace_String
__System_String_IsNullOrWhiteSpace_String PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 8
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_String_IsNullOrWhiteSpace_String_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    POP EAX
    TEST EAX, EAX
    JZ L_System_String_IsNullOrWhiteSpace_String_000D
L_System_String_IsNullOrWhiteSpace_String_0009:
    PUSH 1
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_String_IsNullOrWhiteSpace_String_0041
L_System_String_IsNullOrWhiteSpace_String_000D:
    PUSH 0
    POP EAX
    MOV [EBP-14], EAX
    JMP L_System_String_IsNullOrWhiteSpace_String_002E
L_System_String_IsNullOrWhiteSpace_String_0011:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP-14]
    CALL __System_String_get_Item_Int32
    ADD ESP, 12
    PUSH EAX
    CALL __System_Char_IsWhiteSpace_Char
    ADD ESP, 2
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-18], EAX
    PUSH DWORD PTR [EBP-18]
    POP EAX
    TEST EAX, EAX
    JZ L_System_String_IsNullOrWhiteSpace_String_0029
L_System_String_IsNullOrWhiteSpace_String_0025:
    PUSH 0
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_String_IsNullOrWhiteSpace_String_0041
L_System_String_IsNullOrWhiteSpace_String_0029:
    NOP
    PUSH DWORD PTR [EBP-14]
    PUSH 1
    POP EBX
    POP EAX
    ADD EAX, EBX
    PUSH EAX
    POP EAX
    MOV [EBP-14], EAX
L_System_String_IsNullOrWhiteSpace_String_002E:
    PUSH DWORD PTR [EBP-14]
    PUSH DWORD PTR [EBP+8]
    CALL __System_String_get_Length
    ADD ESP, 8
    PUSH EAX
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETL AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-19], EAX
    PUSH DWORD PTR [EBP-19]
    POP EAX
    TEST EAX, EAX
    JNZ L_System_String_IsNullOrWhiteSpace_String_0011
L_System_String_IsNullOrWhiteSpace_String_003D:
    PUSH 1
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_String_IsNullOrWhiteSpace_String_0041
L_System_String_IsNullOrWhiteSpace_String_0041:
    PUSH DWORD PTR [EBP-13]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_String_IsNullOrWhiteSpace_String ENDP

; Boolean String.Equals(Object)
PUBLIC __System_String_Equals_Object
__System_String_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 6
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_String_Equals_Object_0000:
    NOP
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_String
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETA AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-16], EAX
    PUSH DWORD PTR [EBP-16]
    POP EAX
    TEST EAX, EAX
    JZ L_System_String_Equals_Object_001A
L_System_String_Equals_Object_0010:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP-12]
    CALL __System_String_Equals_String_String
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-17], EAX
    JMP L_System_String_Equals_Object_001E
L_System_String_Equals_Object_001A:
    PUSH 0
    POP EAX
    MOV [EBP-17], EAX
    JMP L_System_String_Equals_Object_001E
L_System_String_Equals_Object_001E:
    PUSH DWORD PTR [EBP-17]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_String_Equals_Object ENDP

; Boolean String.Equals(String)
PUBLIC __System_String_Equals_String
__System_String_Equals_String PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 1
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_String_Equals_String_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_String_Equals_String_String
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_String_Equals_String_000B
L_System_String_Equals_String_000B:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_String_Equals_String ENDP

; Boolean String.Equals(String, String)
PUBLIC __System_String_Equals_String_String
__System_String_Equals_String_String PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_String_Equals_String_String_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    POP EAX
    TEST EAX, EAX
    JZ L_System_String_Equals_String_String_000D
L_System_String_Equals_String_String_0009:
    PUSH 1
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_String_Equals_String_String_0042
L_System_String_Equals_String_String_000D:
    PUSH DWORD PTR [EBP+8]
    POP EAX
    TEST EAX, EAX
    JZ L_System_String_Equals_String_String_0016
L_System_String_Equals_String_String_0010:
    PUSH DWORD PTR [EBP+12]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_String_Equals_String_String_0017
L_System_String_Equals_String_String_0016:
    PUSH 1
L_System_String_Equals_String_String_0017:
    POP EAX
    MOV [EBP-14], EAX
    PUSH DWORD PTR [EBP-14]
    POP EAX
    TEST EAX, EAX
    JZ L_System_String_Equals_String_String_001F
L_System_String_Equals_String_String_001B:
    PUSH 0
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_String_Equals_String_String_0042
L_System_String_Equals_String_String_001F:
    PUSH DWORD PTR [EBP+8]
    CALL __System_String_get_Length
    ADD ESP, 8
    PUSH EAX
    PUSH DWORD PTR [EBP+12]
    CALL __System_String_get_Length
    ADD ESP, 8
    PUSH EAX
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-15], EAX
    PUSH DWORD PTR [EBP-15]
    POP EAX
    TEST EAX, EAX
    JZ L_System_String_Equals_String_String_0038
L_System_String_Equals_String_String_0034:
    PUSH 0
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_String_Equals_String_String_0042
L_System_String_Equals_String_String_0038:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_RuntimeHelpers_StringEquals_String_String
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_String_Equals_String_String_0042
L_System_String_Equals_String_String_0042:
    PUSH DWORD PTR [EBP-13]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_String_Equals_String_String ENDP

; Int32 String.GetHashCode()
PUBLIC __System_String_GetHashCode
__System_String_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_String_GetHashCode_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    CALL __System_RuntimeHelpers_StringGetHashCode_String
    ADD ESP, 4
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_String_GetHashCode_000A
L_System_String_GetHashCode_000A:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_String_GetHashCode ENDP

; String String.ToString()
PUBLIC __System_String_ToString
__System_String_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_String_ToString_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_String_ToString_0005
L_System_String_ToString_0005:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_String_ToString ENDP

; String String.Concat(String, String)
PUBLIC __System_String_Concat_String_String
__System_String_Concat_String_String PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 6
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_String_Concat_String_String_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    CALL __System_String_IsNullOrEmpty_String
    ADD ESP, 4
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    POP EAX
    TEST EAX, EAX
    JZ L_System_String_Concat_String_String_0018
L_System_String_Concat_String_String_000B:
    PUSH DWORD PTR [EBP+12]
    PUSH DWORD PTR [ESP]
    POP EAX
    TEST EAX, EAX
    JNZ L_System_String_Concat_String_String_0015
L_System_String_Concat_String_String_000F:
    ADD ESP, 4
    PUSH DWORD PTR [__static_System_String_Empty]
L_System_String_Concat_String_String_0015:
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_String_Concat_String_String_0030
L_System_String_Concat_String_String_0018:
    PUSH DWORD PTR [EBP+12]
    CALL __System_String_IsNullOrEmpty_String
    ADD ESP, 4
    PUSH EAX
    POP EAX
    MOV [EBP-17], EAX
    PUSH DWORD PTR [EBP-17]
    POP EAX
    TEST EAX, EAX
    JZ L_System_String_Concat_String_String_0026
L_System_String_Concat_String_String_0022:
    PUSH DWORD PTR [EBP+8]
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_String_Concat_String_String_0030
L_System_String_Concat_String_String_0026:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_RuntimeHelpers_StringConcat_String_String
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_String_Concat_String_String_0030
L_System_String_Concat_String_String_0030:
    PUSH DWORD PTR [EBP-13]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_String_Concat_String_String ENDP

; String String.Concat(String, String, String)
PUBLIC __System_String_Concat_String_String_String
__System_String_Concat_String_String_String PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_String_Concat_String_String_String_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_String_Concat_String_String
    ADD ESP, 8
    PUSH EAX
    PUSH DWORD PTR [EBP+16]
    CALL __System_String_Concat_String_String
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_String_Concat_String_String_String_0011
L_System_String_Concat_String_String_String_0011:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_String_Concat_String_String_String ENDP

; String String.Concat(String, String, String, String)
PUBLIC __System_String_Concat_String_String_String_String
__System_String_Concat_String_String_String_String PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_String_Concat_String_String_String_String_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_String_Concat_String_String
    ADD ESP, 8
    PUSH EAX
    PUSH DWORD PTR [EBP+16]
    PUSH DWORD PTR [EBP+20]
    CALL __System_String_Concat_String_String
    ADD ESP, 8
    PUSH EAX
    CALL __System_String_Concat_String_String
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_String_Concat_String_String_String_String_0017
L_System_String_Concat_String_String_String_String_0017:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_String_Concat_String_String_String_String ENDP

; Boolean String.op_Equality(String, String)
PUBLIC __System_String_op_Equality_String_String
__System_String_op_Equality_String_String PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 1
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_String_op_Equality_String_String_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_String_Equals_String_String
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_String_op_Equality_String_String_000B
L_System_String_op_Equality_String_String_000B:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_String_op_Equality_String_String ENDP

; Boolean String.op_Inequality(String, String)
PUBLIC __System_String_op_Inequality_String_String
__System_String_op_Inequality_String_String PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 1
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_String_op_Inequality_String_String_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_String_Equals_String_String
    ADD ESP, 8
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_String_op_Inequality_String_String_000E
L_System_String_op_Inequality_String_String_000E:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_String_op_Inequality_String_String ENDP

; Void String..cctor()
__System_String__cctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Stringcctor_0000:
    PUSH OFFSET __str_1
    POP EAX
    MOV [__static_System_String_Empty], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_String__cctor ENDP

; String Type.get_Name()
PUBLIC __System_Type_get_Name
__System_Type_get_Name PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Type_get_Name ENDP

; String Type.get_Namespace()
PUBLIC __System_Type_get_Namespace
__System_Type_get_Namespace PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Type_get_Namespace ENDP

; String Type.get_FullName()
PUBLIC __System_Type_get_FullName
__System_Type_get_FullName PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Type_get_FullName ENDP

; Type Type.get_BaseType()
PUBLIC __System_Type_get_BaseType
__System_Type_get_BaseType PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Type_get_BaseType ENDP

; Boolean Type.get_IsValueType()
PUBLIC __System_Type_get_IsValueType
__System_Type_get_IsValueType PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Type_get_IsValueType ENDP

; Boolean Type.get_IsClass()
PUBLIC __System_Type_get_IsClass
__System_Type_get_IsClass PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Type_get_IsClass ENDP

; Boolean Type.get_IsInterface()
PUBLIC __System_Type_get_IsInterface
__System_Type_get_IsInterface PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Type_get_IsInterface ENDP

; Boolean Type.get_IsEnum()
PUBLIC __System_Type_get_IsEnum
__System_Type_get_IsEnum PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Type_get_IsEnum ENDP

; Boolean Type.get_IsArray()
PUBLIC __System_Type_get_IsArray
__System_Type_get_IsArray PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Type_get_IsArray ENDP

; String Type.ToString()
PUBLIC __System_Type_ToString
__System_Type_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Type_ToString_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+24]
    ADD ESP, 4
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_Type_ToString_000A
L_System_Type_ToString_000A:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Type_ToString ENDP

; Boolean Type.Equals(Object)
PUBLIC __System_Type_Equals_Object
__System_Type_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 6
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Type_Equals_Object_0000:
    NOP
    PUSH DWORD PTR [EBP+12]
    POP EAX
    TEST EAX, EAX
    JZ @@L0
    MOV EBX, [EAX]
    CMP EBX, OFFSET __vtbl_System_Type
    JE @@L1
    XOR EAX, EAX
@@L0:
@@L1:
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETA AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-16], EAX
    PUSH DWORD PTR [EBP-16]
    POP EAX
    TEST EAX, EAX
    JZ L_System_Type_Equals_Object_001A
L_System_Type_Equals_Object_0010:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP-12]
    CALL __System_Type_op_Equality_Type_Type
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-17], EAX
    JMP L_System_Type_Equals_Object_001E
L_System_Type_Equals_Object_001A:
    PUSH 0
    POP EAX
    MOV [EBP-17], EAX
    JMP L_System_Type_Equals_Object_001E
L_System_Type_Equals_Object_001E:
    PUSH DWORD PTR [EBP-17]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Type_Equals_Object ENDP

; Int32 Type.GetHashCode()
PUBLIC __System_Type_GetHashCode
__System_Type_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Type_GetHashCode_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+24]
    ADD ESP, 4
    PUSH EAX
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+4]
    ADD ESP, 4
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_Type_GetHashCode_000F
L_System_Type_GetHashCode_000F:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Type_GetHashCode ENDP

; Boolean Type.op_Equality(Type, Type)
PUBLIC __System_Type_op_Equality_Type_Type
__System_Type_op_Equality_Type_Type PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 3
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Type_op_Equality_Type_Type_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    POP EAX
    TEST EAX, EAX
    JZ L_System_Type_op_Equality_Type_Type_000D
L_System_Type_op_Equality_Type_Type_0009:
    PUSH 1
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_Type_op_Equality_Type_Type_0033
L_System_Type_op_Equality_Type_Type_000D:
    PUSH DWORD PTR [EBP+8]
    POP EAX
    TEST EAX, EAX
    JZ L_System_Type_op_Equality_Type_Type_0016
L_System_Type_op_Equality_Type_Type_0010:
    PUSH DWORD PTR [EBP+12]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_Type_op_Equality_Type_Type_0017
L_System_Type_op_Equality_Type_Type_0016:
    PUSH 1
L_System_Type_op_Equality_Type_Type_0017:
    POP EAX
    MOV [EBP-14], EAX
    PUSH DWORD PTR [EBP-14]
    POP EAX
    TEST EAX, EAX
    JZ L_System_Type_op_Equality_Type_Type_001F
L_System_Type_op_Equality_Type_Type_001B:
    PUSH 0
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_Type_op_Equality_Type_Type_0033
L_System_Type_op_Equality_Type_Type_001F:
    PUSH DWORD PTR [EBP+8]
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+24]
    ADD ESP, 4
    PUSH EAX
    PUSH DWORD PTR [EBP+12]
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+24]
    ADD ESP, 4
    PUSH EAX
    CALL __System_String_op_Equality_String_String
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_Type_op_Equality_Type_Type_0033
L_System_Type_op_Equality_Type_Type_0033:
    PUSH DWORD PTR [EBP-13]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Type_op_Equality_Type_Type ENDP

; Boolean Type.op_Inequality(Type, Type)
PUBLIC __System_Type_op_Inequality_Type_Type
__System_Type_op_Inequality_Type_Type PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 1
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Type_op_Inequality_Type_Type_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_Type_op_Equality_Type_Type
    ADD ESP, 8
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_Type_op_Inequality_Type_Type_000E
L_System_Type_op_Inequality_Type_Type_000E:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Type_op_Inequality_Type_Type ENDP

; Type Type.GetType(String)
PUBLIC __System_Type_GetType_String
__System_Type_GetType_String PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Type_GetType_String_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    CALL __System_RuntimeType_GetType_String
    ADD ESP, 4
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_Type_GetType_String_000A
L_System_Type_GetType_String_000A:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Type_GetType_String ENDP

; Void Type..ctor()
PUBLIC __System_Type__ctor
__System_Type__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Typector_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Object__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Type__ctor ENDP

; Void RuntimeType..ctor(Int32, String, String, RuntimeType, TypeFlags)
PUBLIC __System_RuntimeType__ctor_Int32_String_String_RuntimeType_TypeFlags
__System_RuntimeType__ctor_Int32_String_String_RuntimeType_TypeFlags PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_RuntimeTypector_Int32_String_String_RuntimeType_TypeFlags_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Type__ctor
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+4], EAX
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+16]
    POP EAX
    POP ESI
    MOV [ESI+8], EAX
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+20]
    POP EAX
    POP ESI
    MOV [ESI+12], EAX
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+24]
    POP EAX
    POP ESI
    MOV [ESI+16], EAX
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+28]
    POP EAX
    POP ESI
    MOV [ESI+20], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeType__ctor_Int32_String_String_RuntimeType_TypeFlags ENDP

; String RuntimeType.get_Name()
PUBLIC __System_RuntimeType_get_Name
__System_RuntimeType_get_Name PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_RuntimeType_get_Name_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+8]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeType_get_Name ENDP

; String RuntimeType.get_Namespace()
PUBLIC __System_RuntimeType_get_Namespace
__System_RuntimeType_get_Namespace PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_RuntimeType_get_Namespace_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeType_get_Namespace ENDP

; String RuntimeType.get_FullName()
PUBLIC __System_RuntimeType_get_FullName
__System_RuntimeType_get_FullName PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_RuntimeType_get_FullName_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+12]
    CALL __System_String_IsNullOrEmpty_String
    ADD ESP, 4
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JNZ L_System_RuntimeType_get_FullName_0025
L_System_RuntimeType_get_FullName_000D:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+12]
    PUSH OFFSET __str_21
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+8]
    CALL __System_String_Concat_String_String_String
    ADD ESP, 12
    PUSH EAX
    JMP L_System_RuntimeType_get_FullName_002B
L_System_RuntimeType_get_FullName_0025:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+8]
L_System_RuntimeType_get_FullName_002B:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeType_get_FullName ENDP

; Type RuntimeType.get_BaseType()
PUBLIC __System_RuntimeType_get_BaseType
__System_RuntimeType_get_BaseType PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_RuntimeType_get_BaseType_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+16]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeType_get_BaseType ENDP

; Boolean RuntimeType.get_IsValueType()
PUBLIC __System_RuntimeType_get_IsValueType
__System_RuntimeType_get_IsValueType PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_RuntimeType_get_IsValueType_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+20]
    PUSH 1
    POP EBX
    POP EAX
    AND EAX, EBX
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETA AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeType_get_IsValueType ENDP

; Boolean RuntimeType.get_IsClass()
PUBLIC __System_RuntimeType_get_IsClass
__System_RuntimeType_get_IsClass PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_RuntimeType_get_IsClass_0000:
    PUSH DWORD PTR [EBP+8]
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+32]
    ADD ESP, 4
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JNZ L_System_RuntimeType_get_IsClass_0013
L_System_RuntimeType_get_IsClass_0008:
    PUSH DWORD PTR [EBP+8]
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+40]
    ADD ESP, 4
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    JMP L_System_RuntimeType_get_IsClass_0014
L_System_RuntimeType_get_IsClass_0013:
    PUSH 0
L_System_RuntimeType_get_IsClass_0014:
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeType_get_IsClass ENDP

; Boolean RuntimeType.get_IsInterface()
PUBLIC __System_RuntimeType_get_IsInterface
__System_RuntimeType_get_IsInterface PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_RuntimeType_get_IsInterface_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+20]
    PUSH 2
    POP EBX
    POP EAX
    AND EAX, EBX
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETA AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeType_get_IsInterface ENDP

; Boolean RuntimeType.get_IsEnum()
PUBLIC __System_RuntimeType_get_IsEnum
__System_RuntimeType_get_IsEnum PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_RuntimeType_get_IsEnum_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+20]
    PUSH 4
    POP EBX
    POP EAX
    AND EAX, EBX
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETA AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeType_get_IsEnum ENDP

; Boolean RuntimeType.get_IsArray()
PUBLIC __System_RuntimeType_get_IsArray
__System_RuntimeType_get_IsArray PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_RuntimeType_get_IsArray_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+20]
    PUSH 8
    POP EBX
    POP EAX
    AND EAX, EBX
    PUSH EAX
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETA AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeType_get_IsArray ENDP

; Type RuntimeType.GetType(String)
PUBLIC __System_RuntimeType_GetType_String
__System_RuntimeType_GetType_String PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_RuntimeType_GetType_String_0000:
    NOP
    PUSH 0
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_RuntimeType_GetType_String_0005
L_System_RuntimeType_GetType_String_0005:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_RuntimeType_GetType_String ENDP

; Boolean ValueType.Equals(Object)
PUBLIC __System_ValueType_Equals_Object
__System_ValueType_Equals_Object PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 3
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_ValueType_Equals_Object_0000:
    NOP
    PUSH DWORD PTR [EBP+12]
    PUSH 0
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETE AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    POP EAX
    TEST EAX, EAX
    JZ L_System_ValueType_Equals_Object_000D
L_System_ValueType_Equals_Object_0009:
    PUSH 0
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_ValueType_Equals_Object_0030
L_System_ValueType_Equals_Object_000D:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Object_GetType
    ADD ESP, 4
    PUSH EAX
    PUSH DWORD PTR [EBP+12]
    CALL __System_Object_GetType
    ADD ESP, 8
    PUSH EAX
    CALL __System_Type_op_Inequality_Type_Type
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-14], EAX
    PUSH DWORD PTR [EBP-14]
    POP EAX
    TEST EAX, EAX
    JZ L_System_ValueType_Equals_Object_0026
L_System_ValueType_Equals_Object_0022:
    PUSH 0
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_ValueType_Equals_Object_0030
L_System_ValueType_Equals_Object_0026:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __System_RuntimeHelpers_ValueTypeEquals_Object_Object
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-13], EAX
    JMP L_System_ValueType_Equals_Object_0030
L_System_ValueType_Equals_Object_0030:
    PUSH DWORD PTR [EBP-13]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_ValueType_Equals_Object ENDP

; Int32 ValueType.GetHashCode()
PUBLIC __System_ValueType_GetHashCode
__System_ValueType_GetHashCode PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_ValueType_GetHashCode_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    CALL __System_RuntimeHelpers_ValueTypeGetHashCode_Object
    ADD ESP, 4
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_ValueType_GetHashCode_000A
L_System_ValueType_GetHashCode_000A:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_ValueType_GetHashCode ENDP

; String ValueType.ToString()
PUBLIC __System_ValueType_ToString
__System_ValueType_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_ValueType_ToString_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    CALL __System_Object_GetType
    ADD ESP, 4
    PUSH EAX
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+24]
    ADD ESP, 4
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_System_ValueType_ToString_000F
L_System_ValueType_ToString_000F:
    PUSH DWORD PTR [EBP-12]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_ValueType_ToString ENDP

; Void ValueType..ctor()
PUBLIC __System_ValueType__ctor
__System_ValueType__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_ValueTypector_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Object__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_ValueType__ctor ENDP

; Void SetsRequiredMembersAttribute..ctor()
PUBLIC __System_Diagnostics_CodeAnalysis_SetsRequiredMembersAttribute__ctor
__System_Diagnostics_CodeAnalysis_SetsRequiredMembersAttribute__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Diagnostics_CodeAnalysis_SetsRequiredMembersAttributector_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Diagnostics_CodeAnalysis_SetsRequiredMembersAttribute__ctor ENDP

; Void OutAttribute..ctor()
PUBLIC __System_Runtime_InteropServices_OutAttribute__ctor
__System_Runtime_InteropServices_OutAttribute__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Runtime_InteropServices_OutAttributector_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Runtime_InteropServices_OutAttribute__ctor ENDP

; Void InAttribute..ctor()
PUBLIC __System_Runtime_InteropServices_InAttribute__ctor
__System_Runtime_InteropServices_InAttribute__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Runtime_InteropServices_InAttributector_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Runtime_InteropServices_InAttribute__ctor ENDP

; Void CompilerGeneratedAttribute..ctor()
PUBLIC __System_Runtime_CompilerServices_CompilerGeneratedAttribute__ctor
__System_Runtime_CompilerServices_CompilerGeneratedAttribute__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Runtime_CompilerServices_CompilerGeneratedAttributector_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Runtime_CompilerServices_CompilerGeneratedAttribute__ctor ENDP

; Void CallerMemberNameAttribute..ctor()
PUBLIC __System_Runtime_CompilerServices_CallerMemberNameAttribute__ctor
__System_Runtime_CompilerServices_CallerMemberNameAttribute__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Runtime_CompilerServices_CallerMemberNameAttributector_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Runtime_CompilerServices_CallerMemberNameAttribute__ctor ENDP

; Void CallerFilePathAttribute..ctor()
PUBLIC __System_Runtime_CompilerServices_CallerFilePathAttribute__ctor
__System_Runtime_CompilerServices_CallerFilePathAttribute__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Runtime_CompilerServices_CallerFilePathAttributector_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Runtime_CompilerServices_CallerFilePathAttribute__ctor ENDP

; Void CallerLineNumberAttribute..ctor()
PUBLIC __System_Runtime_CompilerServices_CallerLineNumberAttribute__ctor
__System_Runtime_CompilerServices_CallerLineNumberAttribute__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Runtime_CompilerServices_CallerLineNumberAttributector_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Runtime_CompilerServices_CallerLineNumberAttribute__ctor ENDP

; Void RequiredMemberAttribute..ctor()
PUBLIC __System_Runtime_CompilerServices_RequiredMemberAttribute__ctor
__System_Runtime_CompilerServices_RequiredMemberAttribute__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Runtime_CompilerServices_RequiredMemberAttributector_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Runtime_CompilerServices_RequiredMemberAttribute__ctor ENDP

; String CompilerFeatureRequiredAttribute.get_FeatureName()
PUBLIC __System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_get_FeatureName
__System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_get_FeatureName PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_get_FeatureName_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_get_FeatureName ENDP

; Boolean CompilerFeatureRequiredAttribute.get_IsOptional()
PUBLIC __System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_get_IsOptional
__System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_get_IsOptional PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_get_IsOptional_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_get_IsOptional ENDP

; Void CompilerFeatureRequiredAttribute.set_IsOptional(Boolean)
PUBLIC __System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_set_IsOptional_Boolean
__System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_set_IsOptional_Boolean PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_set_IsOptional_Boolean_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+4], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_set_IsOptional_Boolean ENDP

; Void CompilerFeatureRequiredAttribute..ctor(String)
PUBLIC __System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute__ctor_String
__System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Runtime_CompilerServices_CompilerFeatureRequiredAttributector_String_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute__ctor_String ENDP

; Void NullableContextAttribute..ctor(Byte)
PUBLIC __System_Runtime_CompilerServices_NullableContextAttribute__ctor_Byte
__System_Runtime_CompilerServices_NullableContextAttribute__ctor_Byte PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Runtime_CompilerServices_NullableContextAttributector_Byte_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Runtime_CompilerServices_NullableContextAttribute__ctor_Byte ENDP

; Void NullableAttribute..ctor(Byte)
PUBLIC __System_Runtime_CompilerServices_NullableAttribute__ctor_Byte
__System_Runtime_CompilerServices_NullableAttribute__ctor_Byte PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Runtime_CompilerServices_NullableAttributector_Byte_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH 1
    POP ECX
    MOV EAX, ECX
    IMUL EAX, 4
    ADD EAX, 12
    PUSH ECX
    CALL __gc_alloc
    POP ECX
    TEST EAX, EAX
    JZ __throw_out_of_memory
    MOV DWORD PTR [EAX], OFFSET __vtbl_System_Array
    MOV [EAX+4], ECX
    PUSH EAX
    PUSH DWORD PTR [ESP]
    PUSH 0
    PUSH DWORD PTR [EBP+12]
    NOP
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Runtime_CompilerServices_NullableAttribute__ctor_Byte ENDP

; Void NullableAttribute..ctor(Byte[])
PUBLIC __System_Runtime_CompilerServices_NullableAttribute__ctor_Byte__
__System_Runtime_CompilerServices_NullableAttribute__ctor_Byte__ PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Runtime_CompilerServices_NullableAttributector_Byte_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Runtime_CompilerServices_NullableAttribute__ctor_Byte__ ENDP

; String DefaultMemberAttribute.get_MemberName()
PUBLIC __System_Reflection_DefaultMemberAttribute_get_MemberName
__System_Reflection_DefaultMemberAttribute_get_MemberName PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Reflection_DefaultMemberAttribute_get_MemberName_0000:
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+0]
    POP EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Reflection_DefaultMemberAttribute_get_MemberName ENDP

; Void DefaultMemberAttribute..ctor(String)
PUBLIC __System_Reflection_DefaultMemberAttribute__ctor_String
__System_Reflection_DefaultMemberAttribute__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_System_Reflection_DefaultMemberAttributector_String_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Attribute__ctor
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+0], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__System_Reflection_DefaultMemberAttribute__ctor_String ENDP



END
