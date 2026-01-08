namespace DosNet.Core.Runtime.Startup;

/// <summary>
/// Gera código de startup para executáveis DOS.
/// Compatível com HX DOS Extender (32-bit protected mode).
/// </summary>
public class StartupCodeGenerator
{
    private readonly RuntimeOptions _options;
    
    public StartupCodeGenerator(RuntimeOptions options)
    {
        _options = options;
    }
    
    /// <summary>
    /// Gera o código de startup completo
    /// </summary>
    public string Generate()
    {
        return $@"; ============================================================
; STARTUP CODE - DosNET Runtime
; Compatível com HX DOS Extender (32-bit protected mode)
; Target CPU: {_options.CpuLevel}
; ============================================================

{GetCpuDirective()}
.MODEL FLAT, C

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
    
{GenerateCpuCheck()}
{GenerateFpuCheck()}
{GenerateGCInit()}
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
";
    }
    
    private string GetCpuDirective()
    {
        return _options.CpuLevel switch
        {
            CpuLevel.I386 => ".386",
            CpuLevel.I486 => ".486",
            CpuLevel.I586 => ".586",
            _ => ".386"
        };
    }
    
    private string GenerateCpuCheck()
    {
        return @"    ; ==========================================
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
";
    }
    
    private string GenerateFpuCheck()
    {
        if (_options.SoftFloatOnly)
        {
            return @"    ; FPU desabilitada (soft-float only)
    MOV DWORD PTR [__fpu_available], 0
";
        }
        
        var code = @"    ; ==========================================
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
";
        
        if (_options.FpuRequired)
        {
            code += @"    JMP __no_fpu
";
        }
        
        code += @"__fpu_check_done:
";
        return code;
    }
    
    private string GenerateGCInit()
    {
        if (!_options.EnableGC)
        {
            return @"    ; GC desabilitado
";
        }
        
        return $@"    ; ==========================================
    ; Inicializar Garbage Collector
    ; ==========================================
    MOV EAX, {_options.HeapSize}
    CALL __gc_init
    TEST EAX, EAX
    JZ __gc_init_failed

    ; ==========================================
    ; Instalar Timer Interrupt para GC automático
    ; ==========================================
    CALL __gc_install_timer
";
    }
    
    /// <summary>
    /// Gera código para GC automático via timer interrupt
    /// </summary>
    public string GenerateGCTimerCode()
    {
        if (!_options.EnableGC)
            return "";
        
        return @"
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
";
    }
    
    /// <summary>
    /// Gera apenas o código do startup (sem seções .DATA/.CODE/.MODEL)
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
    /// Gera startup para aplicações (sem exception handlers - vêm do corlib)
    /// </summary>
    public string GenerateAppStartup()
    {
        var heapSize = _options.HeapSize;
        
        return $@"; ============================================================
; STARTUP CODE - DosNET Application
; Exception handlers are in corlib.lib
; ============================================================

{GetCpuDirective()}
.MODEL FLAT, C

.CODE

; ============================================================
; Entry Point
; ============================================================
EXTRN __exit:PROC
EXTRN __gc_init:PROC

PUBLIC __start
__start PROC
    ; Inicializar GC
    MOV EAX, {heapSize}
    CALL __gc_init
    TEST EAX, EAX
    JZ __gc_init_failed_app
    
    ; Chamar Program.Main (definido no código do usuário)
    CALL __Program_Main
    
    ; Sair com código de retorno
    PUSH EAX
    CALL __exit

__gc_init_failed_app:
    ; GC init failed - exit with error
    PUSH 1
    CALL __exit
__start ENDP
";
    }
    
    /// <summary>
    /// Gera apenas os dados do startup
    /// </summary>
    public string GenerateDataOnly()
    {
        return @"    ; Startup Data
    __msg_no_386        DB 'Error: Requires 80386 or higher', 13, 10, 0
    __msg_no_memory     DB 'Error: Not enough memory', 13, 10, 0
";
    }
    
    /// <summary>
    /// Gera apenas o código do timer GC (sem seções)
    /// Para modo protegido 32-bit, usamos stubs simples
    /// </summary>
    public string GenerateGCTimerCodeOnly()
    {
        if (!_options.EnableGC)
            return "";
        
        // Em modo protegido 32-bit, o timer interrupt não funciona da mesma forma
        // Usar stubs que não fazem nada por enquanto - GC será chamado manualmente
        return @"
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
";
    }
    
    /// <summary>
    /// Gera apenas os dados do timer GC
    /// </summary>
    public string GenerateGCTimerDataOnly()
    {
        if (!_options.EnableGC)
            return "";
        
        return @"    ; GC Timer Data
    __gc_old_timer_handler  DD 0
    __gc_timer_counter      DD 0
    __gc_timer_threshold    DD 18
    __gc_in_collection      DD 0
    __gc_alloc_counter      DD 0
";
    }
}
