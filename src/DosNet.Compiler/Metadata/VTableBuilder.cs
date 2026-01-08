using System.Text;
using DosNet.Core.Types;

namespace DosNet.Compiler.Metadata;

/// <summary>
/// Constrói VTables para tipos com métodos virtuais.
/// </summary>
public class VTableBuilder
{
    private readonly List<TypeDef> _types;
    
    public VTableBuilder(IEnumerable<TypeDef> types)
    {
        _types = types.ToList();
    }
    
    /// <summary>
    /// Calcula os slots de VTable para todos os tipos
    /// </summary>
    public void BuildVTables()
    {
        foreach (var type in _types)
        {
            if (type.IsInterface || type.IsValueType)
                continue;
            
            BuildVTableForType(type);
        }
    }
    
    private void BuildVTableForType(TypeDef type)
    {
        var virtualMethods = new List<MethodDef>();
        
        // Herdar métodos virtuais do tipo base
        if (type.BaseType != null)
        {
            virtualMethods.AddRange(GetVirtualMethods(type.BaseType));
        }
        
        // Processar métodos deste tipo
        foreach (var method in type.Methods)
        {
            if (!method.IsVirtual)
                continue;
            
            // Verificar se é override
            int existingSlot = FindMatchingSlot(virtualMethods, method);
            
            if (existingSlot >= 0)
            {
                // Override - substituir no slot existente
                method.VTableSlot = existingSlot;
                virtualMethods[existingSlot] = method;
            }
            else
            {
                // Novo método virtual - adicionar slot
                method.VTableSlot = virtualMethods.Count;
                virtualMethods.Add(method);
            }
        }
        
        type.VirtualMethods = virtualMethods;
    }
    
    private List<MethodDef> GetVirtualMethods(TypeDef type)
    {
        if (type.VirtualMethods != null)
            return new List<MethodDef>(type.VirtualMethods);
        
        // Construir VTable do tipo base primeiro
        BuildVTableForType(type);
        return type.VirtualMethods != null 
            ? new List<MethodDef>(type.VirtualMethods) 
            : new List<MethodDef>();
    }
    
    private int FindMatchingSlot(List<MethodDef> virtualMethods, MethodDef method)
    {
        for (int i = 0; i < virtualMethods.Count; i++)
        {
            var existing = virtualMethods[i];
            if (existing.Name == method.Name && ParametersMatch(existing, method))
            {
                return i;
            }
        }
        return -1;
    }
    
    private static bool ParametersMatch(MethodDef m1, MethodDef m2)
    {
        if (m1.Parameters.Count != m2.Parameters.Count)
            return false;
        
        for (int i = 0; i < m1.Parameters.Count; i++)
        {
            var p1 = m1.Parameters[i].ParameterType;
            var p2 = m2.Parameters[i].ParameterType;
            
            if (p1?.FullName != p2?.FullName)
                return false;
        }
        
        return true;
    }
    
    /// <summary>
    /// Gera o código assembly para as VTables
    /// </summary>
    public string GenerateVTables()
    {
        var sb = new StringBuilder();
        
        sb.AppendLine("; ============================================================");
        sb.AppendLine("; VTABLES");
        sb.AppendLine("; ============================================================");
        sb.AppendLine();
        
        foreach (var type in _types)
        {
            if (type.IsInterface || type.IsValueType)
                continue;
            
            if (type.VirtualMethods == null || type.VirtualMethods.Count == 0)
            {
                // Tipo sem métodos virtuais - VTable vazia
                sb.AppendLine($"; VTable for {type.FullName} (empty)");
                sb.AppendLine($"PUBLIC {type.VTableLabel}");
                sb.AppendLine($"{type.VTableLabel}:");
                sb.AppendLine($"    DD 0                    ; No virtual methods");
                sb.AppendLine();
                continue;
            }
            
            sb.AppendLine($"; VTable for {type.FullName}");
            sb.AppendLine($"PUBLIC {type.VTableLabel}");
            sb.AppendLine($"{type.VTableLabel}:");
            
            foreach (var method in type.VirtualMethods)
            {
                sb.AppendLine($"    DD OFFSET {method.GetLabel()}  ; Slot {method.VTableSlot}: {method.Name}");
            }
            
            sb.AppendLine();
        }
        
        return sb.ToString();
    }
}
