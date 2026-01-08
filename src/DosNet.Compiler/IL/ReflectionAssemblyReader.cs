using System.Reflection;
using DosNet.Core.Abstractions;
using DosNet.Core.Types;

namespace DosNet.Compiler.IL;

/// <summary>
/// Leitor de assemblies usando System.Reflection.
/// Mais simples e confiável que decodificação manual de metadata.
/// </summary>
public class ReflectionAssemblyReader : IAssemblyReader
{
    private readonly string _path;
    private Assembly _assembly;
    private readonly Dictionary<Type, TypeDef> _typeCache = new();
    private readonly Dictionary<MethodInfo, MethodDef> _methodCache = new();
    private readonly Dictionary<FieldInfo, FieldDef> _fieldCache = new();
    private readonly List<TypeDef> _allTypes = new();
    private readonly List<MethodDef> _allMethods = new();
    
    public string AssemblyName => _assembly?.GetName().Name ?? Path.GetFileNameWithoutExtension(_path);
    public string FilePath => _path;
    public IEnumerable<TypeDef> Types => _allTypes;
    public IEnumerable<MethodDef> Methods => _allMethods;
    
    public ReflectionAssemblyReader(string path)
    {
        _path = path;
    }
    
    public void Open()
    {
        // Carregar assembly em contexto isolado
        _assembly = Assembly.LoadFrom(_path);
        
        // Ler todos os tipos
        foreach (var type in _assembly.GetTypes())
        {
            if (type.Name.StartsWith("<"))
                continue; // Ignorar tipos gerados pelo compilador
            
            var typeDef = ReadType(type);
            if (typeDef != null)
            {
                _allTypes.Add(typeDef);
            }
        }
    }
    
    private TypeDef ReadType(Type type)
    {
        if (_typeCache.TryGetValue(type, out var cached))
            return cached;
        
        var typeDef = new TypeDef
        {
            Name = type.Name,
            Namespace = type.Namespace ?? "",
            Flags = ConvertTypeFlags(type),
        };
        
        _typeCache[type] = typeDef;
        
        // Base type
        if (type.BaseType != null && type.BaseType != typeof(object))
        {
            typeDef.BaseType = GetOrCreateTypeDef(type.BaseType);
        }
        
        // Interfaces
        foreach (var iface in type.GetInterfaces())
        {
            var ifaceDef = GetOrCreateTypeDef(iface);
            if (ifaceDef != null)
                typeDef.Interfaces.Add(ifaceDef);
        }
        
        // Fields
        foreach (var field in type.GetFields(BindingFlags.Public | BindingFlags.NonPublic | 
                                              BindingFlags.Instance | BindingFlags.Static | 
                                              BindingFlags.DeclaredOnly))
        {
            var fieldDef = ReadField(field, typeDef);
            typeDef.Fields.Add(fieldDef);
        }
        
        // Methods
        foreach (var method in type.GetMethods(BindingFlags.Public | BindingFlags.NonPublic | 
                                                BindingFlags.Instance | BindingFlags.Static | 
                                                BindingFlags.DeclaredOnly))
        {
            if (method.Name.StartsWith("<"))
                continue; // Ignorar métodos gerados
            
            var methodDef = ReadMethod(method, typeDef);
            typeDef.Methods.Add(methodDef);
            _allMethods.Add(methodDef);
        }
        
        // Constructors
        foreach (var ctor in type.GetConstructors(BindingFlags.Public | BindingFlags.NonPublic | 
                                                   BindingFlags.Instance | BindingFlags.Static))
        {
            var methodDef = ReadConstructor(ctor, typeDef);
            typeDef.Methods.Add(methodDef);
            _allMethods.Add(methodDef);
        }
        
        // Properties
        foreach (var prop in type.GetProperties(BindingFlags.Public | BindingFlags.NonPublic | 
                                                 BindingFlags.Instance | BindingFlags.Static | 
                                                 BindingFlags.DeclaredOnly))
        {
            var propDef = ReadProperty(prop, typeDef);
            typeDef.Properties.Add(propDef);
        }
        
        return typeDef;
    }
    
    private TypeDef GetOrCreateTypeDef(Type type)
    {
        if (_typeCache.TryGetValue(type, out var cached))
            return cached;
        
        // Criar placeholder para tipos externos
        var typeDef = new TypeDef
        {
            Name = type.Name,
            Namespace = type.Namespace ?? "",
            Flags = ConvertTypeFlags(type),
        };
        
        _typeCache[type] = typeDef;
        return typeDef;
    }
    
    private FieldDef ReadField(FieldInfo field, TypeDef declaringType)
    {
        var fieldDef = new FieldDef
        {
            Name = field.Name,
            DeclaringType = declaringType,
            FieldType = GetOrCreateTypeDef(field.FieldType),
            Flags = ConvertFieldFlags(field),
        };
        
        _fieldCache[field] = fieldDef;
        return fieldDef;
    }
    
    private MethodDef ReadMethod(MethodInfo method, TypeDef declaringType)
    {
        var methodDef = new MethodDef
        {
            Name = method.Name,
            DeclaringType = declaringType,
            ReturnType = GetOrCreateTypeDef(method.ReturnType),
            Flags = ConvertMethodFlags(method),
        };
        
        // Parameters
        foreach (var param in method.GetParameters())
        {
            methodDef.Parameters.Add(new ParameterDef
            {
                Name = param.Name,
                Index = param.Position,
                ParameterType = GetOrCreateTypeDef(param.ParameterType),
            });
        }
        
        // Custom attributes - procurar Asm386ImplementationAttribute
        ReadMethodAttributes(method, methodDef);
        
        // IL Body
        if (!methodDef.HasCustomAssembly)
        {
            try
            {
                var body = method.GetMethodBody();
                if (body != null)
                {
                    methodDef.ILBody = body.GetILAsByteArray();
                    methodDef.MaxStack = body.MaxStackSize;
                    
                    // Local variables
                    int localIndex = 0;
                    foreach (var local in body.LocalVariables)
                    {
                        methodDef.Locals.Add(new LocalVariable
                        {
                            Index = localIndex++,
                            Type = GetOrCreateTypeDef(local.LocalType),
                        });
                    }
                }
            }
            catch
            {
                // Alguns métodos não têm corpo (abstract, extern)
            }
        }
        
        _methodCache[method] = methodDef;
        return methodDef;
    }
    
    private MethodDef ReadConstructor(ConstructorInfo ctor, TypeDef declaringType)
    {
        var methodDef = new MethodDef
        {
            Name = ctor.IsStatic ? ".cctor" : ".ctor",
            DeclaringType = declaringType,
            ReturnType = null, // Void
            Flags = ConvertConstructorFlags(ctor),
        };
        
        // Parameters
        foreach (var param in ctor.GetParameters())
        {
            methodDef.Parameters.Add(new ParameterDef
            {
                Name = param.Name,
                Index = param.Position,
                ParameterType = GetOrCreateTypeDef(param.ParameterType),
            });
        }
        
        // Custom attributes
        ReadConstructorAttributes(ctor, methodDef);
        
        // IL Body
        if (!methodDef.HasCustomAssembly)
        {
            try
            {
                var body = ctor.GetMethodBody();
                if (body != null)
                {
                    methodDef.ILBody = body.GetILAsByteArray();
                    methodDef.MaxStack = body.MaxStackSize;
                }
            }
            catch { }
        }
        
        return methodDef;
    }
    
    private PropertyDef ReadProperty(PropertyInfo prop, TypeDef declaringType)
    {
        var propDef = new PropertyDef
        {
            Name = prop.Name,
            DeclaringType = declaringType,
            PropertyType = GetOrCreateTypeDef(prop.PropertyType),
        };
        
        var getter = prop.GetGetMethod(true);
        var setter = prop.GetSetMethod(true);
        
        if (getter != null && _methodCache.TryGetValue(getter, out var getterDef))
            propDef.Getter = getterDef;
        if (setter != null && _methodCache.TryGetValue(setter, out var setterDef))
            propDef.Setter = setterDef;
        
        return propDef;
    }
    
    private void ReadMethodAttributes(MethodInfo method, MethodDef methodDef)
    {
        foreach (var attr in method.GetCustomAttributesData())
        {
            var attrName = attr.AttributeType.Name;
            
            if (attrName == "Asm386ImplementationAttribute")
            {
                // Primeiro argumento é o código assembly
                if (attr.ConstructorArguments.Count > 0)
                {
                    methodDef.CustomAssembly = attr.ConstructorArguments[0].Value?.ToString();
                }
                // Segundo argumento (opcional) é soft-float assembly
                if (attr.ConstructorArguments.Count > 1)
                {
                    methodDef.SoftFloatAssembly = attr.ConstructorArguments[1].Value?.ToString();
                }
            }
            else if (attrName == "Asm386IntrinsicAttribute")
            {
                if (attr.ConstructorArguments.Count > 0)
                {
                    methodDef.IsIntrinsic = true;
                    methodDef.IntrinsicName = attr.ConstructorArguments[0].Value?.ToString();
                }
            }
        }
    }
    
    private void ReadConstructorAttributes(ConstructorInfo ctor, MethodDef methodDef)
    {
        foreach (var attr in ctor.GetCustomAttributesData())
        {
            var attrName = attr.AttributeType.Name;
            
            if (attrName == "Asm386ImplementationAttribute")
            {
                if (attr.ConstructorArguments.Count > 0)
                {
                    methodDef.CustomAssembly = attr.ConstructorArguments[0].Value?.ToString();
                }
                if (attr.ConstructorArguments.Count > 1)
                {
                    methodDef.SoftFloatAssembly = attr.ConstructorArguments[1].Value?.ToString();
                }
            }
        }
    }
    
    private static TypeFlags ConvertTypeFlags(Type type)
    {
        var flags = TypeFlags.None;
        
        if (type.IsPublic || type.IsNestedPublic)
            flags |= TypeFlags.Public;
        if (type.IsSealed)
            flags |= TypeFlags.Sealed;
        if (type.IsAbstract)
            flags |= TypeFlags.Abstract;
        if (type.IsInterface)
            flags |= TypeFlags.Interface;
        if (type.IsValueType)
            flags |= TypeFlags.ValueType;
        if (type.IsEnum)
            flags |= TypeFlags.Enum;
        
        return flags;
    }
    
    private static FieldFlags ConvertFieldFlags(FieldInfo field)
    {
        var flags = FieldFlags.None;
        
        if (field.IsPublic)
            flags |= FieldFlags.Public;
        if (field.IsPrivate)
            flags |= FieldFlags.Private;
        if (field.IsFamily)
            flags |= FieldFlags.Protected;
        if (field.IsStatic)
            flags |= FieldFlags.Static;
        if (field.IsInitOnly)
            flags |= FieldFlags.InitOnly;
        if (field.IsLiteral)
            flags |= FieldFlags.Literal;
        
        return flags;
    }
    
    private static MethodFlags ConvertMethodFlags(MethodInfo method)
    {
        var flags = MethodFlags.None;
        
        if (method.IsPublic)
            flags |= MethodFlags.Public;
        if (method.IsPrivate)
            flags |= MethodFlags.Private;
        if (method.IsFamily)
            flags |= MethodFlags.Protected;
        if (method.IsStatic)
            flags |= MethodFlags.Static;
        if (method.IsVirtual)
            flags |= MethodFlags.Virtual;
        if (method.IsAbstract)
            flags |= MethodFlags.Abstract;
        if (method.IsFinal)
            flags |= MethodFlags.Final;
        if (method.IsSpecialName)
            flags |= MethodFlags.SpecialName;
        
        return flags;
    }
    
    private static MethodFlags ConvertConstructorFlags(ConstructorInfo ctor)
    {
        var flags = MethodFlags.SpecialName;
        
        if (ctor.IsPublic)
            flags |= MethodFlags.Public;
        if (ctor.IsPrivate)
            flags |= MethodFlags.Private;
        if (ctor.IsFamily)
            flags |= MethodFlags.Protected;
        if (ctor.IsStatic)
            flags |= MethodFlags.Static;
        
        return flags;
    }
    
    public IEnumerable<TypeDef> ReadTypes() => _allTypes;
    
    public TypeDef ResolveType(string fullName)
    {
        foreach (var type in _allTypes)
        {
            if (type.FullName == fullName)
                return type;
        }
        return null;
    }
    
    public void Dispose()
    {
        // Assembly não precisa ser disposed
    }
}
