namespace DosNet.Core.IR;

/// <summary>
/// Opcodes da Intermediate Representation.
/// Representação independente de arquitetura.
/// </summary>
public enum IROpCode
{
    // Constantes
    Nop,
    LoadConst,          // Carregar constante
    LoadNull,           // Carregar null
    
    // Variáveis locais
    LoadLocal,          // Carregar variável local
    StoreLocal,         // Armazenar em variável local
    LoadLocalAddress,   // Carregar endereço de variável local
    
    // Argumentos
    LoadArg,            // Carregar argumento
    StoreArg,           // Armazenar em argumento
    LoadArgAddress,     // Carregar endereço de argumento
    
    // Campos
    LoadField,          // Carregar campo de instância
    StoreField,         // Armazenar em campo de instância
    LoadFieldAddress,   // Carregar endereço de campo
    LoadStaticField,    // Carregar campo estático
    StoreStaticField,   // Armazenar em campo estático
    LoadStaticFieldAddress, // Carregar endereço de campo estático
    
    // Arrays
    LoadElement,        // Carregar elemento de array
    StoreElement,       // Armazenar em elemento de array
    LoadElementAddress, // Carregar endereço de elemento
    LoadLength,         // Carregar tamanho do array
    LoadArrayLength,    // Alias para LoadLength
    NewArray,           // Criar novo array
    
    // Aritmética inteira
    Add,
    Sub,
    Mul,
    Div,
    DivUn,              // Divisão unsigned
    Rem,                // Resto
    RemUn,              // Resto unsigned
    Neg,                // Negação
    
    // Aritmética de ponto flutuante
    AddFloat,
    SubFloat,
    MulFloat,
    DivFloat,
    NegFloat,
    
    // Bitwise
    And,
    Or,
    Xor,
    Not,
    Shl,                // Shift left
    Shr,                // Shift right (signed)
    ShrUn,              // Shift right (unsigned)
    
    // Comparação
    CompareEqual,
    CompareNotEqual,
    CompareLessThan,
    CompareLessThanUn,
    CompareGreaterThan,
    CompareGreaterThanUn,
    CompareLessOrEqual,
    CompareGreaterOrEqual,
    
    // Comparação de ponto flutuante
    CompareFloatEqual,
    CompareFloatLessThan,
    CompareFloatGreaterThan,
    
    // Controle de fluxo
    Branch,             // Branch incondicional
    BranchTrue,         // Branch se true
    BranchFalse,        // Branch se false
    BranchEqual,        // Branch se igual
    BranchNotEqual,     // Branch se diferente
    BranchLessThan,
    BranchGreaterThan,
    BranchLessOrEqual,
    BranchGreaterOrEqual,
    Switch,             // Switch table
    
    // Chamadas
    Call,               // Chamada direta
    CallVirtual,        // Chamada virtual (via VTable)
    CallInterface,      // Chamada de interface
    CallIndirect,       // Chamada indireta (function pointer)
    Return,             // Retorno
    
    // Objetos
    NewObj,             // Criar novo objeto
    CastClass,          // Cast com exceção
    IsInstance,         // Cast sem exceção (retorna null)
    Box,                // Boxing de value type
    Unbox,              // Unboxing
    UnboxAny,           // Unboxing com conversão
    
    // Conversões
    ConvertI1,          // Converter para int8
    ConvertI2,          // Converter para int16
    ConvertI4,          // Converter para int32
    ConvertI8,          // Converter para int64
    ConvertU1,          // Converter para uint8
    ConvertU2,          // Converter para uint16
    ConvertU4,          // Converter para uint32
    ConvertU8,          // Converter para uint64
    ConvertR4,          // Converter para float32
    ConvertR8,          // Converter para float64
    ConvertIPtr,        // Converter para IntPtr
    ConvertUPtr,        // Converter para UIntPtr
    
    // Stack
    Dup,                // Duplicar topo da pilha
    Pop,                // Remover topo da pilha
    
    // Memória
    LoadIndirect,       // Carregar via ponteiro
    StoreIndirect,      // Armazenar via ponteiro
    InitObj,            // Inicializar value type
    CopyObj,            // Copiar value type
    CopyBlock,          // Copiar bloco de memória
    InitBlock,          // Inicializar bloco de memória
    
    // Exceções
    Throw,              // Lançar exceção
    Rethrow,            // Relançar exceção
    Leave,              // Sair de bloco protegido
    EndFinally,         // Fim de finally
    EndFilter,          // Fim de filter
    
    // Strings
    LoadString,         // Carregar string literal
    
    // Misc
    Sizeof,             // Tamanho de tipo
    LoadToken,          // Carregar token de metadata
    Breakpoint,         // Breakpoint para debug
}
