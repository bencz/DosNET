namespace DosNet.Core.Runtime.Exception;

/// <summary>
/// Gera código assembly para o runtime de exceções.
/// </summary>
public class ExceptionRuntimeGenerator
{
    public string Generate()
    {
        return @"; ============================================================
; EXCEPTION RUNTIME
; Compatível com HX DOS Extender (32-bit protected mode)
; ============================================================

.DATA
    __current_exception  DD 0        ; Ponteiro para exceção atual
    __exception_handler  DD 0        ; Handler de exceção atual
    __msg_unhandled      DB 'Unhandled exception', 13, 10, '$'
    __msg_invalid_cast   DB 'InvalidCastException', 13, 10, '$'
    __msg_null_ref       DB 'NullReferenceException', 13, 10, '$'
    __msg_index_range    DB 'IndexOutOfRangeException', 13, 10, '$'

.CODE

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
";
    }
    
    /// <summary>
    /// Gera apenas o código (sem seções .DATA/.CODE)
    /// </summary>
    public string GenerateCodeOnly()
    {
        var full = Generate();
        var codeStart = full.IndexOf(".CODE");
        if (codeStart >= 0)
        {
            return full.Substring(codeStart + 6);
        }
        return full;
    }
    
    /// <summary>
    /// Gera apenas os dados
    /// </summary>
    public string GenerateDataOnly()
    {
        return @"    ; Exception Runtime Data
    __current_exception  DD 0
    __exception_handler  DD 0
    __msg_unhandled      DB 'Unhandled exception', 13, 10, '$'
    __msg_invalid_cast   DB 'InvalidCastException', 13, 10, '$'
    __msg_null_ref       DB 'NullReferenceException', 13, 10, '$'
    __msg_index_range    DB 'IndexOutOfRangeException', 13, 10, '$'
";
    }
}
