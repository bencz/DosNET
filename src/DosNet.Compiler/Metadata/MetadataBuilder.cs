using System.Text;
using DosNet.Core.Types;

namespace DosNet.Compiler.Metadata;

/// <summary>
/// Constrói as tabelas de metadados para reflection em runtime.
/// </summary>
public class MetadataBuilder
{
    private readonly List<TypeDef> _types;
    private readonly List<MethodDef> _methods;
    private readonly List<FieldDef> _fields;
    private readonly Dictionary<string, int> _stringHeap = new();
    private readonly StringBuilder _stringHeapData = new();
    private int _stringHeapOffset = 0;
    
    public MetadataBuilder(IEnumerable<TypeDef> types)
    {
        _types = types.ToList();
        _methods = _types.SelectMany(t => t.Methods).ToList();
        _fields = _types.SelectMany(t => t.Fields).ToList();
        
        // Atribuir índices
        for (int i = 0; i < _types.Count; i++)
            _types[i].TypeIndex = i;
        for (int i = 0; i < _methods.Count; i++)
            _methods[i].MethodIndex = i;
        for (int i = 0; i < _fields.Count; i++)
            _fields[i].FieldIndex = i;
    }
    
    /// <summary>
    /// Gera o código assembly para as tabelas de metadados
    /// </summary>
    public string GenerateMetadataTables()
    {
        var sb = new StringBuilder();
        
        sb.AppendLine("; ============================================================");
        sb.AppendLine("; METADATA TABLES");
        sb.AppendLine("; ============================================================");
        sb.AppendLine();
        
        // Header
        GenerateHeader(sb);
        
        // Type table
        GenerateTypeTable(sb);
        
        // Method table
        GenerateMethodTable(sb);
        
        // Field table
        GenerateFieldTable(sb);
        
        // String heap
        GenerateStringHeap(sb);
        
        return sb.ToString();
    }
    
    private void GenerateHeader(StringBuilder sb)
    {
        sb.AppendLine("; Metadata Header");
        sb.AppendLine("__metadata_header:");
        sb.AppendLine($"    DD 080386E4Eh           ; Magic (0x80386NET)");
        sb.AppendLine($"    DW 1                    ; MajorVersion");
        sb.AppendLine($"    DW 0                    ; MinorVersion");
        sb.AppendLine($"    DD 0                    ; Flags");
        sb.AppendLine($"    DD {_types.Count}       ; TypeCount");
        sb.AppendLine($"    DD {_methods.Count}     ; MethodCount");
        sb.AppendLine($"    DD {_fields.Count}      ; FieldCount");
        sb.AppendLine($"    DD 0                    ; PropertyCount");
        sb.AppendLine($"    DD OFFSET __metadata_types    ; TypeTableOffset");
        sb.AppendLine($"    DD OFFSET __metadata_methods  ; MethodTableOffset");
        sb.AppendLine($"    DD OFFSET __metadata_fields   ; FieldTableOffset");
        sb.AppendLine($"    DD OFFSET __string_heap       ; StringHeapOffset");
        sb.AppendLine();
    }
    
    private void GenerateTypeTable(StringBuilder sb)
    {
        sb.AppendLine("; Type Definition Table");
        sb.AppendLine("__metadata_types:");
        
        int methodIndex = 0;
        int fieldIndex = 0;
        
        foreach (var type in _types)
        {
            var nameOffset = AddString(type.Name);
            var nsOffset = AddString(type.Namespace ?? "");
            var baseTypeIndex = type.BaseType != null ? (uint)type.BaseType.TypeIndex : 0xFFFFFFFF;
            
            sb.AppendLine($"    ; Type: {type.FullName}");
            sb.AppendLine($"    DD {nameOffset}         ; NameOffset");
            sb.AppendLine($"    DD {nsOffset}           ; NamespaceOffset");
            sb.AppendLine($"    DD {(uint)type.Flags}   ; Flags");
            sb.AppendLine($"    DD {baseTypeIndex}      ; BaseTypeIndex");
            sb.AppendLine($"    DD {fieldIndex}         ; FieldListStart");
            sb.AppendLine($"    DD {type.Fields.Count}  ; FieldCount");
            sb.AppendLine($"    DD {methodIndex}        ; MethodListStart");
            sb.AppendLine($"    DD {type.Methods.Count} ; MethodCount");
            sb.AppendLine($"    DD {type.InstanceSize}  ; InstanceSize");
            sb.AppendLine($"    DD OFFSET {type.VTableLabel} ; VTableOffset");
            
            methodIndex += type.Methods.Count;
            fieldIndex += type.Fields.Count;
        }
        sb.AppendLine();
    }
    
    private void GenerateMethodTable(StringBuilder sb)
    {
        sb.AppendLine("; Method Definition Table");
        sb.AppendLine("__metadata_methods:");
        
        foreach (var method in _methods)
        {
            var nameOffset = AddString(method.Name);
            var declaringTypeIndex = method.DeclaringType?.TypeIndex ?? 0;
            
            sb.AppendLine($"    ; Method: {method.DeclaringType?.Name}.{method.Name}");
            sb.AppendLine($"    DD {nameOffset}         ; NameOffset");
            sb.AppendLine($"    DD {(uint)method.Flags} ; Flags");
            sb.AppendLine($"    DD {declaringTypeIndex} ; DeclaringTypeIndex");
            sb.AppendLine($"    DD 0                    ; SignatureOffset");
            sb.AppendLine($"    DW {method.Parameters.Count} ; ParamCount");
            sb.AppendLine($"    DW {method.Locals.Count}     ; LocalCount");
            sb.AppendLine($"    DD OFFSET {method.GetLabel()} ; CodeOffset");
            sb.AppendLine($"    DW {(method.VTableSlot >= 0 ? method.VTableSlot : 0xFFFF)} ; VTableSlot");
            sb.AppendLine($"    DW {method.MaxStack}    ; StackSize");
        }
        sb.AppendLine();
    }
    
    private void GenerateFieldTable(StringBuilder sb)
    {
        sb.AppendLine("; Field Definition Table");
        sb.AppendLine("__metadata_fields:");
        
        foreach (var field in _fields)
        {
            var nameOffset = AddString(field.Name);
            var declaringTypeIndex = field.DeclaringType?.TypeIndex ?? 0;
            var fieldTypeIndex = field.FieldType?.TypeIndex ?? 0;
            
            sb.AppendLine($"    ; Field: {field.DeclaringType?.Name}.{field.Name}");
            sb.AppendLine($"    DD {nameOffset}         ; NameOffset");
            sb.AppendLine($"    DD {(uint)field.Flags}  ; Flags");
            sb.AppendLine($"    DD {declaringTypeIndex} ; DeclaringTypeIndex");
            sb.AppendLine($"    DD {fieldTypeIndex}     ; FieldTypeIndex");
            sb.AppendLine($"    DW {field.Offset}       ; Offset");
            sb.AppendLine($"    DW {field.Size}         ; Size");
        }
        sb.AppendLine();
    }
    
    private void GenerateStringHeap(StringBuilder sb)
    {
        sb.AppendLine("; String Heap");
        sb.AppendLine("__string_heap:");
        sb.AppendLine(_stringHeapData.ToString());
        sb.AppendLine();
    }
    
    private int AddString(string str)
    {
        if (string.IsNullOrEmpty(str))
            str = "";
        
        if (_stringHeap.TryGetValue(str, out var offset))
            return offset;
        
        offset = _stringHeapOffset;
        _stringHeap[str] = offset;
        
        // Gerar string para assembly
        if (string.IsNullOrEmpty(str))
        {
            _stringHeapData.AppendLine("    DB 0");
        }
        else
        {
            var bytes = GenerateStringBytes(str);
            _stringHeapData.AppendLine($"    DB {bytes}");
        }
        
        _stringHeapOffset += str.Length + 1;
        return offset;
    }
    
    private static string GenerateStringBytes(string value)
    {
        var parts = new List<string>();
        var currentText = new StringBuilder();
        
        foreach (var c in value)
        {
            if (c < 32 || c > 126 || c == '\'')
            {
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
        
        if (currentText.Length > 0)
        {
            parts.Add($"'{currentText}'");
        }
        
        parts.Add("0");
        return string.Join(", ", parts);
    }
    
    private static string EscapeString(string value)
    {
        var sb = new StringBuilder();
        foreach (var c in value)
        {
            switch (c)
            {
                case '\'': sb.Append("', 27h, '"); break;
                case '\r': sb.Append("', 0Dh, '"); break;
                case '\n': sb.Append("', 0Ah, '"); break;
                case '\t': sb.Append("', 09h, '"); break;
                default: sb.Append(c); break;
            }
        }
        return sb.ToString();
    }
}
