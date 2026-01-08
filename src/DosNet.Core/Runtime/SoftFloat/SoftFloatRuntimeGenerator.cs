namespace DosNet.Core.Runtime.SoftFloat;

/// <summary>
/// Gera código assembly para emulação de ponto flutuante IEEE 754.
/// Usado em i386/i486 quando FPU não está disponível.
/// </summary>
public class SoftFloatRuntimeGenerator
{
    /// <summary>
    /// Gera o código completo de soft-float para MASM
    /// </summary>
    public string Generate()
    {
        return @"; ============================================================
; SOFT-FLOAT RUNTIME - IEEE 754 Emulation
; Para i386/i486 sem FPU
; ============================================================

.DATA
    ; Constantes para IEEE 754 single-precision
    __sf_sign_mask      DD 80000000h
    __sf_exp_mask       DD 7F800000h
    __sf_mant_mask      DD 007FFFFFh
    __sf_exp_bias       DD 127
    __sf_implicit_bit   DD 00800000h
    
    ; Constantes para IEEE 754 double-precision
    __sf_d_sign_mask_hi DD 80000000h
    __sf_d_exp_mask_hi  DD 7FF00000h
    __sf_d_mant_mask_hi DD 000FFFFFh
    __sf_d_exp_bias     DD 1023

.CODE

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
    /// Gera apenas os dados do SoftFloat
    /// </summary>
    public string GenerateDataOnly()
    {
        return @"    ; SoftFloat Constants
    __sf_sign_mask      DD 80000000h
    __sf_exp_mask       DD 7F800000h
    __sf_mant_mask      DD 007FFFFFh
    __sf_exp_bias       DD 127
    __sf_implicit_bit   DD 00800000h
    __sf_d_sign_mask_hi DD 80000000h
    __sf_d_exp_mask_hi  DD 7FF00000h
    __sf_d_mant_mask_hi DD 000FFFFFh
    __sf_d_exp_bias     DD 1023
";
    }
}
