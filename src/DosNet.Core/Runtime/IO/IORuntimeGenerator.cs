namespace DosNet.Core.Runtime.IO;

/// <summary>
/// Gera código assembly para funções de I/O.
/// Usa INT 21h que é interceptado pelo HX DOS Extender em modo protegido.
/// O HX DOS Extender traduz as chamadas INT 21h para chamadas Win32 API
/// quando rodando em Windows, ou para DPMI quando em DOS real.
/// </summary>
public class IORuntimeGenerator
{
    /// <summary>
    /// Gera o código completo de I/O
    /// </summary>
    public string Generate()
    {
        return @"; ============================================================
; I/O RUNTIME
; Compatível com HX DOS Extender (32-bit protected mode)
; INT 21h é interceptado pelo HX e traduzido apropriadamente
; ============================================================

.CODE

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
";
    }
    
    /// <summary>
    /// Gera apenas o código (sem seção .CODE)
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
}
