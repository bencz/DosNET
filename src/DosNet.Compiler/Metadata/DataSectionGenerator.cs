using System.Text;
using DosNet.Core.Types;

namespace DosNet.Compiler.Metadata;

/// <summary>
/// Gera a seção .DATA com strings, constantes e números.
/// </summary>
public class DataSectionGenerator
{
    private readonly Dictionary<string, string> _stringLiterals = new();
    private readonly Dictionary<float, string> _floatConstants = new();
    private readonly Dictionary<double, string> _doubleConstants = new();
    private readonly Dictionary<long, string> _int64Constants = new();
    private readonly List<FieldDef> _staticFields = new();
    
    private int _stringCounter = 0;
    private int _floatCounter = 0;
    private int _doubleCounter = 0;
    private int _int64Counter = 0;
    
    /// <summary>
    /// Registra uma string literal e retorna seu label
    /// </summary>
    public string RegisterString(string value)
    {
        if (value == null)
            return "__null_string";
        
        if (_stringLiterals.TryGetValue(value, out var label))
            return label;
        
        label = $"__str_{_stringCounter++}";
        _stringLiterals[value] = label;
        return label;
    }
    
    /// <summary>
    /// Registra uma constante float e retorna seu label
    /// </summary>
    public string RegisterFloat(float value)
    {
        if (_floatConstants.TryGetValue(value, out var label))
            return label;
        
        label = $"__flt_{_floatCounter++}";
        _floatConstants[value] = label;
        return label;
    }
    
    /// <summary>
    /// Registra uma constante double e retorna seu label
    /// </summary>
    public string RegisterDouble(double value)
    {
        if (_doubleConstants.TryGetValue(value, out var label))
            return label;
        
        label = $"__dbl_{_doubleCounter++}";
        _doubleConstants[value] = label;
        return label;
    }
    
    /// <summary>
    /// Registra uma constante int64 e retorna seu label
    /// </summary>
    public string RegisterInt64(long value)
    {
        if (_int64Constants.TryGetValue(value, out var label))
            return label;
        
        label = $"__i64_{_int64Counter++}";
        _int64Constants[value] = label;
        return label;
    }
    
    /// <summary>
    /// Adiciona campos estáticos
    /// </summary>
    public void AddStaticFields(IEnumerable<FieldDef> fields)
    {
        foreach (var field in fields)
        {
            if (field.IsStatic)
                _staticFields.Add(field);
        }
    }
    
    /// <summary>
    /// Gera a seção .DATA
    /// </summary>
    public string GenerateDataSection()
    {
        var sb = new StringBuilder();
        
        sb.AppendLine("; ============================================================");
        sb.AppendLine("; DATA SECTION");
        sb.AppendLine("; ============================================================");
        sb.AppendLine(".DATA");
        sb.AppendLine();
        
        // Constante CRLF para Console.WriteLine
        sb.AppendLine("    __crlf DB 13, 10, 0");
        sb.AppendLine("    __null_string DD 0");
        sb.AppendLine();
        
        // String literals
        if (_stringLiterals.Count > 0)
        {
            sb.AppendLine("    ; String Literals");
            foreach (var (value, label) in _stringLiterals)
            {
                var length = value.Length;
                sb.AppendLine($"    {label} DD {length}");
                
                // Tratar string vazia
                if (string.IsNullOrEmpty(value))
                {
                    sb.AppendLine($"    {label}_data DB 0");
                }
                else
                {
                    // Gerar string como sequência de bytes para evitar problemas com escape
                    var bytes = GenerateStringBytes(value);
                    sb.AppendLine($"    {label}_data DB {bytes}");
                }
            }
            sb.AppendLine();
        }
        
        // Float constants
        if (_floatConstants.Count > 0)
        {
            sb.AppendLine("    ; Float Constants");
            foreach (var (value, label) in _floatConstants)
            {
                var bits = BitConverter.SingleToInt32Bits(value);
                sb.AppendLine($"    {label} DD 0{bits:X8}h  ; {value}");
            }
            sb.AppendLine();
        }
        
        // Double constants
        if (_doubleConstants.Count > 0)
        {
            sb.AppendLine("    ; Double Constants");
            foreach (var (value, label) in _doubleConstants)
            {
                var bits = BitConverter.DoubleToInt64Bits(value);
                var low = (uint)(bits & 0xFFFFFFFF);
                var high = (uint)(bits >> 32);
                sb.AppendLine($"    {label} DD 0{low:X8}h, 0{high:X8}h  ; {value}");
            }
            sb.AppendLine();
        }
        
        // Int64 constants
        if (_int64Constants.Count > 0)
        {
            sb.AppendLine("    ; Int64 Constants");
            foreach (var (value, label) in _int64Constants)
            {
                var low = (uint)(value & 0xFFFFFFFF);
                var high = (uint)((ulong)value >> 32);
                sb.AppendLine($"    {label} DD 0{low:X8}h, 0{high:X8}h  ; {value}");
            }
            sb.AppendLine();
        }
        
        // Static fields
        if (_staticFields.Count > 0)
        {
            sb.AppendLine("    ; Static Fields");
            foreach (var field in _staticFields)
            {
                var size = field.Size > 0 ? field.Size : 4;
                var directive = size switch
                {
                    1 => "DB",
                    2 => "DW",
                    4 => "DD",
                    8 => "DQ",
                    _ => "DD"
                };
                sb.AppendLine($"    {field.GetStaticLabel()} {directive} 0  ; {field.DeclaringType?.Name}.{field.Name}");
            }
            sb.AppendLine();
        }
        
        return sb.ToString();
    }
    
    /// <summary>
    /// Gera a seção .DATA? (BSS)
    /// </summary>
    public string GenerateBssSection()
    {
        var sb = new StringBuilder();
        
        sb.AppendLine("; ============================================================");
        sb.AppendLine("; BSS SECTION (Uninitialized Data)");
        sb.AppendLine("; ============================================================");
        sb.AppendLine(".DATA?");
        sb.AppendLine();
        // Nota: __gc_* variáveis são definidas em GCRuntimeGenerator.GenerateDataOnly()
        sb.AppendLine();
        
        return sb.ToString();
    }
    
    /// <summary>
    /// Gera string como sequência de bytes para MASM
    /// </summary>
    private static string GenerateStringBytes(string value)
    {
        var parts = new List<string>();
        var currentText = new StringBuilder();
        
        foreach (var c in value)
        {
            if (c < 32 || c > 126 || c == '\'')
            {
                // Caractere especial - flush texto atual e adicionar como byte
                if (currentText.Length > 0)
                {
                    parts.Add($"'{currentText}'");
                    currentText.Clear();
                }
                parts.Add($"{(int)c}");
            }
            else
            {
                currentText.Append(c);
            }
        }
        
        // Flush texto restante
        if (currentText.Length > 0)
        {
            parts.Add($"'{currentText}'");
        }
        
        // Adicionar terminador nulo
        parts.Add("0");
        
        return string.Join(", ", parts);
    }
}
