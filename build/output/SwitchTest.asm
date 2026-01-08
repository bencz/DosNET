; ============================================================
; STARTUP CODE - DosNET Runtime
; Compatível com HX DOS Extender (32-bit protected mode)
; Target CPU: I386
; ============================================================

.386
.MODEL FLAT, STDCALL

; ============================================================
; Imports do C Runtime (HX DOS Extender)
; ============================================================
EXTRN _write:PROC
EXTRN _read:PROC
EXTRN _getch:PROC
EXTRN _kbhit:PROC

; ============================================================
; Segmentos
; ============================================================
.DATA
    ; Mensagens de erro (null-terminated para _write)
    __msg_no_386        DB 'Error: Requires 80386 or higher', 13, 10, 0
    __msg_no_386_len    EQU $ - __msg_no_386 - 1
    __msg_no_fpu        DB 'Error: FPU required but not found', 13, 10, 0
    __msg_no_fpu_len    EQU $ - __msg_no_fpu - 1
    __msg_gc_fail       DB 'Error: Failed to initialize heap', 13, 10, 0
    __msg_gc_fail_len   EQU $ - __msg_gc_fail - 1
    __msg_oom           DB 'Error: Out of memory', 13, 10, 0
    __msg_oom_len       EQU $ - __msg_oom - 1
    __msg_unhandled     DB 'Unhandled exception', 13, 10, 0
    __msg_unhandled_len EQU $ - __msg_unhandled - 1
    __msg_invalid_cast  DB 'InvalidCastException', 13, 10, 0
    __msg_invalid_cast_len EQU $ - __msg_invalid_cast - 1
    __msg_null_ref      DB 'NullReferenceException', 13, 10, 0
    __msg_null_ref_len  EQU $ - __msg_null_ref - 1
    __msg_index_range   DB 'IndexOutOfRangeException', 13, 10, 0
    __msg_index_range_len EQU $ - __msg_index_range - 1
    
    ; CRLF para Console.WriteLine
    __crlf              DB 13, 10, 0
    
    ; Flag de FPU disponível
    __fpu_available     DD 0
    
    ; Ponteiro para argumentos de linha de comando
    __argc              DD 0
    __argv              DD 0
    
    ; Exception handling
    __current_exception DD 0
    __exception_handler DD 0

.DATA?
    ; Variáveis do GC
    __gc_heap_start     DD ?
    __gc_heap_end       DD ?
    __gc_free_ptr       DD ?
    __gc_stack_bottom   DD ?
    __gc_collections    DD ?
    __gc_bytes_freed    DD ?
    __program_end       DD ?

.CODE

; ============================================================
; Entry Point
; ============================================================
PUBLIC __start
__start PROC
    ; Salvar base da stack para GC
    MOV [__gc_stack_bottom], ESP
    
    ; ==========================================
    ; Verificar CPU (386+)
    ; ==========================================
    PUSHFD
    POP EAX
    MOV ECX, EAX
    XOR EAX, 40000h             ; Flip AC bit
    PUSH EAX
    POPFD
    PUSHFD
    POP EAX
    XOR EAX, ECX
    JZ __no_386
    
    ; Restaurar flags
    PUSH ECX
    POPFD

    ; ==========================================
    ; Detectar FPU
    ; ==========================================
    FNINIT
    MOV WORD PTR [ESP-2], 5A5Ah
    FNSTSW WORD PTR [ESP-2]
    CMP WORD PTR [ESP-2], 0
    JNE __no_fpu_detected
    
    ; FPU encontrada
    MOV DWORD PTR [__fpu_available], 1
    JMP __fpu_check_done
    
__no_fpu_detected:
    MOV DWORD PTR [__fpu_available], 0
__fpu_check_done:

    ; ==========================================
    ; Inicializar Garbage Collector
    ; ==========================================
    MOV EAX, 4194304
    CALL __gc_init
    TEST EAX, EAX
    JZ __gc_init_failed

    ; ==========================================
    ; Instalar Timer Interrupt para GC automático
    ; ==========================================
    CALL __gc_install_timer

    ; Chamar Main
    CALL __Main
    
    ; Exit com código de retorno em EAX
    PUSH EAX
    CALL __exit
    
__start ENDP

; ============================================================
; __exit
; Termina o programa usando C runtime
;
; Input: [ESP+4] = código de saída
; ============================================================
PUBLIC __exit
__exit PROC
    MOV EAX, [ESP+4]
    ; Usar INT 21h função 4Ch para terminar
    MOV AH, 4Ch
    INT 21h
    ; Nunca retorna
__exit ENDP

; ============================================================
; __print_error
; Imprime mensagem de erro usando _write
;
; Input: EAX = ponteiro para mensagem
;        ECX = tamanho da mensagem
; ============================================================
__print_error PROC
    PUSH ECX            ; length
    PUSH EAX            ; buffer
    PUSH 2              ; stderr (fd=2)
    CALL _write
    ADD ESP, 12
    RET
__print_error ENDP

; ============================================================
; __throw_out_of_memory
; Chamado quando alocação falha
; ============================================================
PUBLIC __throw_out_of_memory
__throw_out_of_memory PROC
    MOV EAX, OFFSET __msg_oom
    MOV ECX, __msg_oom_len
    CALL __print_error
    
    PUSH 1
    CALL __exit
__throw_out_of_memory ENDP

; ============================================================
; __gc_init_failed
; Chamado quando inicialização do GC falha
; ============================================================
PUBLIC __gc_init_failed
__gc_init_failed PROC
    MOV EAX, OFFSET __msg_gc_fail
    MOV ECX, __msg_gc_fail_len
    CALL __print_error
    
    PUSH 1
    CALL __exit
__gc_init_failed ENDP

; ============================================================
; __no_386
; Chamado quando CPU não é 386+
; ============================================================
__no_386 PROC
    MOV EAX, OFFSET __msg_no_386
    MOV ECX, __msg_no_386_len
    CALL __print_error
    
    PUSH 1
    CALL __exit
__no_386 ENDP

; ============================================================
; __no_fpu
; Chamado quando FPU é requerida mas não encontrada
; ============================================================
__no_fpu PROC
    MOV EAX, OFFSET __msg_no_fpu
    MOV ECX, __msg_no_fpu_len
    CALL __print_error
    
    PUSH 1
    CALL __exit
__no_fpu ENDP

; ============================================================
; Exception Handling Runtime
; ============================================================

PUBLIC __throw_exception
__throw_exception PROC
    MOV [__current_exception], EAX
    
    ; Verificar se há handler registrado
    MOV EBX, [__exception_handler]
    TEST EBX, EBX
    JZ __unhandled_exception
    
    ; Restaurar contexto do handler
    MOV ESP, [EBX]
    MOV EBP, [EBX+4]
    JMP DWORD PTR [EBX+8]
__throw_exception ENDP

PUBLIC __rethrow_exception
__rethrow_exception PROC
    MOV EAX, [__current_exception]
    JMP __throw_exception
__rethrow_exception ENDP

PUBLIC __unhandled_exception
__unhandled_exception PROC
    MOV EAX, OFFSET __msg_unhandled
    MOV ECX, __msg_unhandled_len
    CALL __print_error
    
    PUSH 1
    CALL __exit
__unhandled_exception ENDP

PUBLIC __throw_null_reference
__throw_null_reference PROC
    MOV EAX, OFFSET __msg_null_ref
    MOV ECX, __msg_null_ref_len
    CALL __print_error
    
    PUSH 1
    CALL __exit
__throw_null_reference ENDP

PUBLIC __throw_invalid_cast
__throw_invalid_cast PROC
    MOV EAX, OFFSET __msg_invalid_cast
    MOV ECX, __msg_invalid_cast_len
    CALL __print_error
    
    PUSH 1
    CALL __exit
__throw_invalid_cast ENDP

PUBLIC __throw_index_out_of_range
__throw_index_out_of_range PROC
    MOV EAX, OFFSET __msg_index_range
    MOV ECX, __msg_index_range_len
    CALL __print_error
    
    PUSH 1
    CALL __exit
__throw_index_out_of_range ENDP



; ============================================================
; GC Timer Interrupt Handler
; Chamado periodicamente via INT 1Ch (timer tick)
; ============================================================
.DATA
    __gc_old_timer_handler  DD 0    ; Ponteiro para handler original
    __gc_timer_counter      DD 0    ; Contador de ticks
    __gc_timer_threshold    DD 18   ; Ticks até próximo GC (18 = ~1 segundo)
    __gc_in_collection      DD 0    ; Flag para evitar reentrada
    __gc_alloc_counter      DD 0    ; Contador de alocações desde último GC

.CODE

; ============================================================
; __gc_install_timer
; Instala o handler de timer para GC automático
; ============================================================
PUBLIC __gc_install_timer
__gc_install_timer PROC
    PUSH EAX
    PUSH EBX
    PUSH ES
    
    ; Obter vetor de interrupção atual (INT 1Ch)
    MOV AX, 351Ch
    INT 21h
    MOV DWORD PTR [__gc_old_timer_handler], EBX
    
    ; Instalar novo handler
    PUSH DS
    MOV AX, CS
    MOV DS, AX
    MOV DX, OFFSET __gc_timer_handler
    MOV AX, 251Ch
    INT 21h
    POP DS
    
    POP ES
    POP EBX
    POP EAX
    RET
__gc_install_timer ENDP

; ============================================================
; __gc_uninstall_timer
; Remove o handler de timer e restaura o original
; ============================================================
PUBLIC __gc_uninstall_timer
__gc_uninstall_timer PROC
    PUSH EAX
    PUSH EDX
    PUSH DS
    
    ; Restaurar handler original
    MOV EDX, DWORD PTR [__gc_old_timer_handler]
    TEST EDX, EDX
    JZ __gc_uninstall_done
    
    PUSH CS
    POP DS
    MOV AX, 251Ch
    INT 21h
    
__gc_uninstall_done:
    POP DS
    POP EDX
    POP EAX
    RET
__gc_uninstall_timer ENDP

; ============================================================
; __gc_timer_handler
; Handler de timer interrupt - verifica se deve coletar
; ============================================================
__gc_timer_handler PROC
    PUSHAD
    
    ; Verificar se já está coletando (evitar reentrada)
    CMP DWORD PTR [__gc_in_collection], 0
    JNE __gc_timer_skip
    
    ; Incrementar contador
    INC DWORD PTR [__gc_timer_counter]
    
    ; Verificar threshold
    MOV EAX, [__gc_timer_counter]
    CMP EAX, [__gc_timer_threshold]
    JB __gc_timer_skip
    
    ; Reset contador
    MOV DWORD PTR [__gc_timer_counter], 0
    
    ; Verificar se houve alocações desde último GC
    CMP DWORD PTR [__gc_alloc_counter], 0
    JE __gc_timer_skip
    
    ; Marcar como coletando
    MOV DWORD PTR [__gc_in_collection], 1
    
    ; Chamar GC
    CALL __gc_collect
    
    ; Reset contador de alocações
    MOV DWORD PTR [__gc_alloc_counter], 0
    
    ; Desmarcar flag
    MOV DWORD PTR [__gc_in_collection], 0
    
__gc_timer_skip:
    POPAD
    
    ; Chamar handler original
    JMP DWORD PTR [__gc_old_timer_handler]
__gc_timer_handler ENDP

; ============================================================
; __gc_notify_alloc
; Chamado após cada alocação para incrementar contador
; ============================================================
PUBLIC __gc_notify_alloc
__gc_notify_alloc PROC
    INC DWORD PTR [__gc_alloc_counter]
    RET
__gc_notify_alloc ENDP


; ============================================================
; External Runtime Functions (from corlib.lib)
; ============================================================

EXTRN __gc_init:PROC
EXTRN __gc_alloc:PROC
EXTRN __gc_alloc_typed:PROC
EXTRN __gc_collect:PROC
EXTRN __throw_exception:PROC
EXTRN __throw_out_of_memory:PROC
EXTRN __throw_null_reference:PROC
EXTRN __throw_invalid_cast:PROC
EXTRN __throw_index_out_of_range:PROC
EXTRN __soft_fadd:PROC
EXTRN __soft_fsub:PROC
EXTRN __soft_fmul:PROC
EXTRN __soft_fdiv:PROC
EXTRN _write:PROC
EXTRN _read:PROC
EXTRN _getch:PROC
EXTRN _kbhit:PROC

; ============================================================
; User Code
; ============================================================

; External Corlib Methods
EXTRN __Microsoft_CodeAnalysis_EmbeddedAttribute__ctor:PROC
EXTRN __System_Runtime_CompilerServices_RefSafetyRulesAttribute__ctor_Int32:PROC
EXTRN __System_Array_get_Length:PROC
EXTRN __System_Array_GetLength_Int32:PROC
EXTRN __System_Array_get_Rank:PROC
EXTRN __System_Array_Copy_Array_Array_Int32:PROC
EXTRN __System_Array_Copy_Array_Int32_Array_Int32_Int32:PROC
EXTRN __System_Array_Clear_Array_Int32_Int32:PROC
EXTRN __System_Array_IndexOf_Array_Object:PROC
EXTRN __System_Array_IndexOf_Array_Object_Int32_Int32:PROC
EXTRN __System_Array__ctor:PROC
EXTRN __System_Asm386ImplementationAttribute_get_Assembly:PROC
EXTRN __System_Asm386ImplementationAttribute_get_SoftFloatAssembly:PROC
EXTRN __System_Asm386ImplementationAttribute__ctor_String:PROC
EXTRN __System_Asm386ImplementationAttribute__ctor_String_String:PROC
EXTRN __System_Asm386IntrinsicAttribute_get_IntrinsicName:PROC
EXTRN __System_Asm386IntrinsicAttribute__ctor_String:PROC
EXTRN __System_Asm386LayoutAttribute_get_Size:PROC
EXTRN __System_Asm386LayoutAttribute_set_Size_Int32:PROC
EXTRN __System_Asm386LayoutAttribute_get_Alignment:PROC
EXTRN __System_Asm386LayoutAttribute_set_Alignment_Int32:PROC
EXTRN __System_Asm386LayoutAttribute__ctor:PROC
EXTRN __System_AttributeUsageAttribute_get_ValidOn:PROC
EXTRN __System_AttributeUsageAttribute_get_AllowMultiple:PROC
EXTRN __System_AttributeUsageAttribute_set_AllowMultiple_Boolean:PROC
EXTRN __System_AttributeUsageAttribute_get_Inherited:PROC
EXTRN __System_AttributeUsageAttribute_set_Inherited_Boolean:PROC
EXTRN __System_AttributeUsageAttribute__ctor_AttributeTargets:PROC
EXTRN __System_Attribute__ctor:PROC
EXTRN __System_FlagsAttribute__ctor:PROC
EXTRN __System_Delegate_get_Target:PROC
EXTRN __System_Delegate_Equals_Object:PROC
EXTRN __System_Delegate_GetHashCode:PROC
EXTRN __System_Delegate__ctor:PROC
EXTRN __System_MulticastDelegate__ctor:PROC
EXTRN __System_Nullable`1_get_HasValue:PROC
EXTRN __System_Nullable`1_get_Value:PROC
EXTRN __System_Nullable`1__ctor_T0:PROC
EXTRN __System_Nullable`1_GetValueOrDefault:PROC
EXTRN __System_Nullable`1_GetValueOrDefault_T0:PROC
EXTRN __System_Nullable`1_Equals_Object:PROC
EXTRN __System_Nullable`1_GetHashCode:PROC
EXTRN __System_Nullable`1_ToString:PROC
EXTRN __System_Action__ctor_Object_IntPtr:PROC
EXTRN __System_Action_Invoke:PROC
EXTRN __System_Action`1__ctor_Object_IntPtr:PROC
EXTRN __System_Action`1_Invoke_T0:PROC
EXTRN __System_Action`2__ctor_Object_IntPtr:PROC
EXTRN __System_Action`2_Invoke_T0_T1:PROC
EXTRN __System_Func`1__ctor_Object_IntPtr:PROC
EXTRN __System_Func`1_Invoke:PROC
EXTRN __System_Func`2__ctor_Object_IntPtr:PROC
EXTRN __System_Func`2_Invoke_T0:PROC
EXTRN __System_Func`3__ctor_Object_IntPtr:PROC
EXTRN __System_Func`3_Invoke_T0_T1:PROC
EXTRN __System_Predicate`1__ctor_Object_IntPtr:PROC
EXTRN __System_Predicate`1_Invoke_T0:PROC
EXTRN __System_Console_Write_String:PROC
EXTRN __System_Console_WriteLine_String:PROC
EXTRN __System_Console_WriteLine:PROC
EXTRN __System_Console_Write_Char:PROC
EXTRN __System_Console_Write_Int32:PROC
EXTRN __System_Console_WriteLine_Int32:PROC
EXTRN __System_Console_Write_Int64:PROC
EXTRN __System_Console_WriteLine_Int64:PROC
EXTRN __System_Console_Write_Boolean:PROC
EXTRN __System_Console_WriteLine_Boolean:PROC
EXTRN __System_Console_Write_Object:PROC
EXTRN __System_Console_WriteLine_Object:PROC
EXTRN __System_Console_Read:PROC
EXTRN __System_Console_ReadLine:PROC
EXTRN __System_Console_ReadKey:PROC
EXTRN __System_Console_CheckKeyAvailable:PROC
EXTRN __System_Console_get_KeyAvailable:PROC
EXTRN __System_Enum_ToString:PROC
EXTRN __System_Enum_Equals_Object:PROC
EXTRN __System_Enum_GetHashCode:PROC
EXTRN __System_Enum__ctor:PROC
EXTRN __System_Exception__ctor:PROC
EXTRN __System_Exception__ctor_String:PROC
EXTRN __System_Exception__ctor_String_Exception:PROC
EXTRN __System_Exception_get_Message:PROC
EXTRN __System_Exception_get_InnerException:PROC
EXTRN __System_Exception_ToString:PROC
EXTRN __System_SystemException__ctor:PROC
EXTRN __System_SystemException__ctor_String:PROC
EXTRN __System_SystemException__ctor_String_Exception:PROC
EXTRN __System_NullReferenceException__ctor:PROC
EXTRN __System_NullReferenceException__ctor_String:PROC
EXTRN __System_InvalidOperationException__ctor:PROC
EXTRN __System_InvalidOperationException__ctor_String:PROC
EXTRN __System_ArgumentException__ctor:PROC
EXTRN __System_ArgumentException__ctor_String:PROC
EXTRN __System_ArgumentNullException__ctor:PROC
EXTRN __System_ArgumentNullException__ctor_String:PROC
EXTRN __System_ArgumentOutOfRangeException__ctor:PROC
EXTRN __System_ArgumentOutOfRangeException__ctor_String:PROC
EXTRN __System_IndexOutOfRangeException__ctor:PROC
EXTRN __System_IndexOutOfRangeException__ctor_String:PROC
EXTRN __System_OutOfMemoryException__ctor:PROC
EXTRN __System_OutOfMemoryException__ctor_String:PROC
EXTRN __System_OverflowException__ctor:PROC
EXTRN __System_OverflowException__ctor_String:PROC
EXTRN __System_DivideByZeroException__ctor:PROC
EXTRN __System_DivideByZeroException__ctor_String:PROC
EXTRN __System_NotSupportedException__ctor:PROC
EXTRN __System_NotSupportedException__ctor_String:PROC
EXTRN __System_NotImplementedException__ctor:PROC
EXTRN __System_NotImplementedException__ctor_String:PROC
EXTRN __System_Object_Equals_Object:PROC
EXTRN __System_Object_GetHashCode:PROC
EXTRN __System_Object_ToString:PROC
EXTRN __System_Object_GetType:PROC
EXTRN __System_Object_Finalize:PROC
EXTRN __System_Object_MemberwiseClone:PROC
EXTRN __System_Object_Equals_Object_Object:PROC
EXTRN __System_Object_ReferenceEquals_Object_Object:PROC
EXTRN __System_Object__ctor:PROC
EXTRN __System_Boolean_ToString:PROC
EXTRN __System_Boolean_GetHashCode:PROC
EXTRN __System_Boolean_Equals_Object:PROC
EXTRN __System_Char_ToString:PROC
EXTRN __System_Char_GetHashCode:PROC
EXTRN __System_Char_Equals_Object:PROC
EXTRN __System_Char_IsWhiteSpace_Char:PROC
EXTRN __System_Char_IsDigit_Char:PROC
EXTRN __System_Char_IsLetter_Char:PROC
EXTRN __System_Char_IsLetterOrDigit_Char:PROC
EXTRN __System_Char_IsUpper_Char:PROC
EXTRN __System_Char_IsLower_Char:PROC
EXTRN __System_Char_ToUpper_Char:PROC
EXTRN __System_Char_ToLower_Char:PROC
EXTRN __System_SByte_ToString:PROC
EXTRN __System_SByte_GetHashCode:PROC
EXTRN __System_SByte_Equals_Object:PROC
EXTRN __System_Byte_ToString:PROC
EXTRN __System_Byte_GetHashCode:PROC
EXTRN __System_Byte_Equals_Object:PROC
EXTRN __System_Int16_ToString:PROC
EXTRN __System_Int16_GetHashCode:PROC
EXTRN __System_Int16_Equals_Object:PROC
EXTRN __System_UInt16_ToString:PROC
EXTRN __System_UInt16_GetHashCode:PROC
EXTRN __System_UInt16_Equals_Object:PROC
EXTRN __System_Int32_ToString:PROC
EXTRN __System_Int32_GetHashCode:PROC
EXTRN __System_Int32_Equals_Object:PROC
EXTRN __System_Int32_Parse_String:PROC
EXTRN __System_UInt32_ToString:PROC
EXTRN __System_UInt32_GetHashCode:PROC
EXTRN __System_UInt32_Equals_Object:PROC
EXTRN __System_Int64_ToString:PROC
EXTRN __System_Int64_GetHashCode:PROC
EXTRN __System_Int64_Equals_Object:PROC
EXTRN __System_UInt64_ToString:PROC
EXTRN __System_UInt64_GetHashCode:PROC
EXTRN __System_UInt64_Equals_Object:PROC
EXTRN __System_Single_ToString:PROC
EXTRN __System_Single_GetHashCode:PROC
EXTRN __System_Single_Equals_Object:PROC
EXTRN __System_Single_IsNaN_Single:PROC
EXTRN __System_Single_IsInfinity_Single:PROC
EXTRN __System_Double_ToString:PROC
EXTRN __System_Double_GetHashCode:PROC
EXTRN __System_Double_Equals_Object:PROC
EXTRN __System_Double_IsNaN_Double:PROC
EXTRN __System_Double_IsInfinity_Double:PROC
EXTRN __System_IntPtr_get_Size:PROC
EXTRN __System_IntPtr__ctor_Int32:PROC
EXTRN __System_IntPtr_ToInt32:PROC
EXTRN __System_IntPtr_ToString:PROC
EXTRN __System_IntPtr_GetHashCode:PROC
EXTRN __System_IntPtr_Equals_Object:PROC
EXTRN __System_IntPtr_op_Equality_IntPtr_IntPtr:PROC
EXTRN __System_IntPtr_op_Inequality_IntPtr_IntPtr:PROC
EXTRN __System_IntPtr__cctor:PROC
EXTRN __System_UIntPtr_get_Size:PROC
EXTRN __System_UIntPtr__ctor_UInt32:PROC
EXTRN __System_UIntPtr_ToUInt32:PROC
EXTRN __System_UIntPtr_ToString:PROC
EXTRN __System_UIntPtr_GetHashCode:PROC
EXTRN __System_UIntPtr_Equals_Object:PROC
EXTRN __System_UIntPtr_op_Equality_UIntPtr_UIntPtr:PROC
EXTRN __System_UIntPtr_op_Inequality_UIntPtr_UIntPtr:PROC
EXTRN __System_UIntPtr__cctor:PROC
EXTRN __System_RuntimeHelpers_GetHashCode_Object:PROC
EXTRN __System_RuntimeHelpers_GetTypeHandle_Object:PROC
EXTRN __System_RuntimeHelpers_GetTypeFromHandle_RuntimeTypeHandle:PROC
EXTRN __System_RuntimeHelpers_MemberwiseClone_Object:PROC
EXTRN __System_RuntimeHelpers_ValueTypeEquals_Object_Object:PROC
EXTRN __System_RuntimeHelpers_ValueTypeGetHashCode_Object:PROC
EXTRN __System_RuntimeHelpers_GetCharAt_String_Int32:PROC
EXTRN __System_RuntimeHelpers_StringEquals_String_String:PROC
EXTRN __System_RuntimeHelpers_StringGetHashCode_String:PROC
EXTRN __System_RuntimeHelpers_StringConcat_String_String:PROC
EXTRN __System_RuntimeHelpers_CharToString_Char:PROC
EXTRN __System_RuntimeHelpers_Int32ToString_Int32:PROC
EXTRN __System_RuntimeHelpers_UInt32ToString_UInt32:PROC
EXTRN __System_RuntimeHelpers_Int64ToString_Int64:PROC
EXTRN __System_RuntimeHelpers_UInt64ToString_UInt64:PROC
EXTRN __System_RuntimeHelpers_SingleToString_Single:PROC
EXTRN __System_RuntimeHelpers_DoubleToString_Double:PROC
EXTRN __System_RuntimeHelpers_SingleToInt32Bits_Single:PROC
EXTRN __System_RuntimeHelpers_DoubleToInt64Bits_Double:PROC
EXTRN __System_RuntimeHelpers_ParseInt32_String:PROC
EXTRN __System_RuntimeHelpers_ArrayClear_Array_Int32_Int32:PROC
EXTRN __System_RuntimeHelpers_ArrayGetValue_Array_Int32:PROC
EXTRN __System_RuntimeTypeHandle_get_Value:PROC
EXTRN __System_String_get_Length:PROC
EXTRN __System_String_get_Item_Int32:PROC
EXTRN __System_String_IsNullOrEmpty_String:PROC
EXTRN __System_String_IsNullOrWhiteSpace_String:PROC
EXTRN __System_String_Equals_Object:PROC
EXTRN __System_String_Equals_String:PROC
EXTRN __System_String_Equals_String_String:PROC
EXTRN __System_String_GetHashCode:PROC
EXTRN __System_String_ToString:PROC
EXTRN __System_String_Concat_String_String:PROC
EXTRN __System_String_Concat_String_String_String:PROC
EXTRN __System_String_Concat_String_String_String_String:PROC
EXTRN __System_String_op_Equality_String_String:PROC
EXTRN __System_String_op_Inequality_String_String:PROC
EXTRN __System_String__ctor:PROC
EXTRN __System_String__cctor:PROC
EXTRN __System_Type_get_Name:PROC
EXTRN __System_Type_get_Namespace:PROC
EXTRN __System_Type_get_FullName:PROC
EXTRN __System_Type_get_BaseType:PROC
EXTRN __System_Type_get_IsValueType:PROC
EXTRN __System_Type_get_IsClass:PROC
EXTRN __System_Type_get_IsInterface:PROC
EXTRN __System_Type_get_IsEnum:PROC
EXTRN __System_Type_get_IsArray:PROC
EXTRN __System_Type_ToString:PROC
EXTRN __System_Type_Equals_Object:PROC
EXTRN __System_Type_GetHashCode:PROC
EXTRN __System_Type_op_Equality_Type_Type:PROC
EXTRN __System_Type_op_Inequality_Type_Type:PROC
EXTRN __System_Type_GetType_String:PROC
EXTRN __System_Type__ctor:PROC
EXTRN __System_RuntimeType__ctor_Int32_String_String_RuntimeType_TypeFlags:PROC
EXTRN __System_RuntimeType_get_Name:PROC
EXTRN __System_RuntimeType_get_Namespace:PROC
EXTRN __System_RuntimeType_get_FullName:PROC
EXTRN __System_RuntimeType_get_BaseType:PROC
EXTRN __System_RuntimeType_get_IsValueType:PROC
EXTRN __System_RuntimeType_get_IsClass:PROC
EXTRN __System_RuntimeType_get_IsInterface:PROC
EXTRN __System_RuntimeType_get_IsEnum:PROC
EXTRN __System_RuntimeType_get_IsArray:PROC
EXTRN __System_RuntimeType_GetType_String:PROC
EXTRN __System_ValueType_Equals_Object:PROC
EXTRN __System_ValueType_GetHashCode:PROC
EXTRN __System_ValueType_ToString:PROC
EXTRN __System_ValueType__ctor:PROC
EXTRN __System_Diagnostics_CodeAnalysis_SetsRequiredMembersAttribute__ctor:PROC
EXTRN __System_Runtime_InteropServices_OutAttribute__ctor:PROC
EXTRN __System_Runtime_InteropServices_InAttribute__ctor:PROC
EXTRN __System_Runtime_CompilerServices_CompilerGeneratedAttribute__ctor:PROC
EXTRN __System_Runtime_CompilerServices_CallerMemberNameAttribute__ctor:PROC
EXTRN __System_Runtime_CompilerServices_CallerFilePathAttribute__ctor:PROC
EXTRN __System_Runtime_CompilerServices_CallerLineNumberAttribute__ctor:PROC
EXTRN __System_Runtime_CompilerServices_RequiredMemberAttribute__ctor:PROC
EXTRN __System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_get_FeatureName:PROC
EXTRN __System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_get_IsOptional:PROC
EXTRN __System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_set_IsOptional_Boolean:PROC
EXTRN __System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute__ctor_String:PROC
EXTRN __System_Runtime_CompilerServices_NullableContextAttribute__ctor_Byte:PROC
EXTRN __System_Runtime_CompilerServices_NullableAttribute__ctor_Byte:PROC
EXTRN __System_Runtime_CompilerServices_NullableAttribute__ctor_Byte__:PROC
EXTRN __System_Reflection_DefaultMemberAttribute_get_MemberName:PROC
EXTRN __System_Reflection_DefaultMemberAttribute__ctor_String:PROC
EXTRN __Microsoft_CodeAnalysis_EmbeddedAttribute__ctor:PROC
EXTRN __System_Runtime_CompilerServices_RefSafetyRulesAttribute__ctor_Int32:PROC

; ============================================================
; DATA SECTION
; ============================================================
.DATA

    __crlf DB 13, 10, 0
    __null_string DD 0

    ; String Literals
    __str_0 DD 11
    __str_0_data DB 'Switch Test', 0
    __str_1 DD 5
    __str_1_data DB 'hello', 0
    __str_2 DD 5
    __str_2_data DB 'world', 0
    __str_3 DD 7
    __str_3_data DB 'unknown', 0
    __str_4 DD 4
    __str_4_data DB 'Zero', 0
    __str_5 DD 3
    __str_5_data DB 'One', 0
    __str_6 DD 3
    __str_6_data DB 'Two', 0
    __str_7 DD 5
    __str_7_data DB 'Three', 0
    __str_8 DD 5
    __str_8_data DB 'Other', 0
    __str_9 DD 9
    __str_9_data DB 'Greeting!', 0
    __str_10 DD 7
    __str_10_data DB 'Planet!', 0
    __str_11 DD 14
    __str_11_data DB 'Unknown string', 0

    ; Static Fields
    __static_TypeFlags_None DD 0  ; TypeFlags.None
    __static_TypeFlags_ValueType DD 0  ; TypeFlags.ValueType
    __static_TypeFlags_Interface DD 0  ; TypeFlags.Interface
    __static_TypeFlags_Enum DD 0  ; TypeFlags.Enum
    __static_TypeFlags_Array DD 0  ; TypeFlags.Array


; ============================================================
; BSS SECTION (Uninitialized Data)
; ============================================================
.DATA?

    __heap_start DD ?
    __heap_end DD ?
    __gc_stack_bottom DD ?


.CODE

; ============================================================
; VTABLES
; ============================================================

; VTable for TypeFlags
__vtbl_TypeFlags:
    DD OFFSET __System_Enum_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Enum_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Enum_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for Program
__vtbl_Program:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
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
    DD 2       ; TypeCount
    DD 4     ; MethodCount
    DD 6      ; FieldCount
    DD 0                    ; PropertyCount
    DD OFFSET __metadata_types    ; TypeTableOffset
    DD OFFSET __metadata_methods  ; MethodTableOffset
    DD OFFSET __metadata_fields   ; FieldTableOffset
    DD OFFSET __string_heap       ; StringHeapOffset

; Type Definition Table
__metadata_types:
    ; Type: TypeFlags
    DD 0         ; NameOffset
    DD 10           ; NamespaceOffset
    DD 3   ; Flags
    DD 23      ; BaseTypeIndex
    DD 0         ; FieldListStart
    DD 6  ; FieldCount
    DD 0        ; MethodListStart
    DD 0 ; MethodCount
    DD 0  ; InstanceSize
    DD OFFSET __vtbl_TypeFlags ; VTableOffset
    ; Type: Program
    DD 11         ; NameOffset
    DD 10           ; NamespaceOffset
    DD 4096   ; Flags
    DD 37      ; BaseTypeIndex
    DD 6         ; FieldListStart
    DD 0  ; FieldCount
    DD 0        ; MethodListStart
    DD 4 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_Program ; VTableOffset

; Method Definition Table
__metadata_methods:
    ; Method: Program.Main
    DD 19         ; NameOffset
    DD 18 ; Flags
    DD 1 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 2     ; LocalCount
    DD OFFSET __Program_Main ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Program.TestSwitch
    DD 24         ; NameOffset
    DD 18 ; Flags
    DD 1 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 2     ; LocalCount
    DD OFFSET __Program_TestSwitch_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 1    ; StackSize
    ; Method: Program.TestStringSwitch
    DD 35         ; NameOffset
    DD 18 ; Flags
    DD 1 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 2     ; LocalCount
    DD OFFSET __Program_TestStringSwitch_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Program..ctor
    DD 52         ; NameOffset
    DD 517 ; Flags
    DD 1 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __Program__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize

; Field Definition Table
__metadata_fields:
    ; Field: TypeFlags.value__
    DD 58         ; NameOffset
    DD 5  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.None
    DD 66         ; NameOffset
    DD 85  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.ValueType
    DD 71         ; NameOffset
    DD 85  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.Interface
    DD 81         ; NameOffset
    DD 85  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.Enum
    DD 91         ; NameOffset
    DD 85  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.Array
    DD 96         ; NameOffset
    DD 85  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size

; String Heap
__string_heap:
    DB 'TypeFlags', 0
    DB '', 0
    DB 'Program', 0
    DB 'Main', 0
    DB 'TestSwitch', 0
    DB 'TestStringSwitch', 0
    DB '.ctor', 0
    DB 'value__', 0
    DB 'None', 0
    DB 'ValueType', 0
    DB 'Interface', 0
    DB 'Enum', 0
    DB 'Array', 0



; Void Program.Main()
__Program_Main PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 8
    PUSH EBX
    PUSH ESI
    PUSH EDI
IL_0000:
    NOP
    PUSH OFFSET __str_0
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    PUSH 0
    POP EAX
    MOV [EBP-12], EAX
    JMP IL_001D
IL_0010:
    NOP
    PUSH DWORD PTR [EBP-12]
    CALL __Program_TestSwitch_Int32
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP-12]
    PUSH 1
    POP EBX
    POP EAX
    ADD EAX, EBX
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
IL_001D:
    PUSH DWORD PTR [EBP-12]
    PUSH 5
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETL AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-16], EAX
    PUSH DWORD PTR [EBP-16]
    POP EAX
    TEST EAX, EAX
    JNZ IL_0010
IL_0025:
    PUSH OFFSET __str_1
    CALL __Program_TestStringSwitch_String
    ADD ESP, 4
    NOP
    PUSH OFFSET __str_2
    CALL __Program_TestStringSwitch_String
    ADD ESP, 4
    NOP
    PUSH OFFSET __str_3
    CALL __Program_TestStringSwitch_String
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__Program_Main ENDP

; Void Program.TestSwitch(Int32)
__Program_TestSwitch_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 8
    PUSH EBX
    PUSH ESI
    PUSH EDI
IL_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    POP EAX
    MOV [EBP-16], EAX
    PUSH DWORD PTR [EBP-16]
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    NOP
IL_001B:
    JMP IL_0051
IL_001D:
    PUSH OFFSET __str_4
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    JMP IL_005E
IL_002A:
    PUSH OFFSET __str_5
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    JMP IL_005E
IL_0037:
    PUSH OFFSET __str_6
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    JMP IL_005E
IL_0044:
    PUSH OFFSET __str_7
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    JMP IL_005E
IL_0051:
    PUSH OFFSET __str_8
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    JMP IL_005E
IL_005E:
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__Program_TestSwitch_Int32 ENDP

; Void Program.TestStringSwitch(String)
__Program_TestStringSwitch_String PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 8
    PUSH EBX
    PUSH ESI
    PUSH EDI
IL_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    POP EAX
    MOV [EBP-16], EAX
    PUSH DWORD PTR [EBP-16]
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    PUSH OFFSET __str_1
    CALL __System_String_op_Equality_String_String
    ADD ESP, 8
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JNZ IL_0021
IL_0012:
    PUSH DWORD PTR [EBP-12]
    PUSH OFFSET __str_2
    CALL __System_String_op_Equality_String_String
    ADD ESP, 8
    PUSH EAX
    POP EAX
    TEST EAX, EAX
    JNZ IL_002E
IL_001F:
    JMP IL_003B
IL_0021:
    PUSH OFFSET __str_9
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    JMP IL_0048
IL_002E:
    PUSH OFFSET __str_10
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    JMP IL_0048
IL_003B:
    PUSH OFFSET __str_11
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    JMP IL_0048
IL_0048:
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__Program_TestStringSwitch_String ENDP

; Void Program..ctor()
PUBLIC __Program__ctor
__Program__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
IL_0000:
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
__Program__ctor ENDP


END __start
