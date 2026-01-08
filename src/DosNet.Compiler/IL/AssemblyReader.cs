using System.Collections.Immutable;
using System.Reflection;
using System.Reflection.Metadata;
using System.Reflection.Metadata.Ecma335;
using System.Reflection.PortableExecutable;
using DosNet.Core.Abstractions;
using DosNet.Core.Types;
using GenericParameter = DosNet.Core.Types.GenericParameter;
using LocalVariable = DosNet.Core.Types.LocalVariable;

namespace DosNet.Compiler.IL;

/// <summary>
/// Leitor de assemblies .NET usando System.Reflection.Metadata.
/// </summary>
public class AssemblyReader : IAssemblyReader
{
    private readonly string _path;
    private readonly ITypeSystem _typeSystem;
    private FileStream _stream;
    private PEReader _peReader;
    private MetadataReader _metadataReader;
    
    private readonly Dictionary<TypeDefinitionHandle, TypeDef> _typeCache = new();
    private readonly Dictionary<MethodDefinitionHandle, MethodDef> _methodCache = new();
    private readonly Dictionary<FieldDefinitionHandle, FieldDef> _fieldCache = new();
    
    public string FilePath => _path;
    
    public AssemblyReader(string path, ITypeSystem typeSystem = null)
    {
        _path = path;
        _typeSystem = typeSystem;
    }
    
    /// <summary>
    /// Abre o assembly para leitura
    /// </summary>
    public void Open()
    {
        _stream = new FileStream(_path, FileMode.Open, FileAccess.Read, FileShare.Read);
        _peReader = new PEReader(_stream);
        _metadataReader = _peReader.GetMetadataReader();
    }
    
    /// <summary>
    /// Nome do assembly
    /// </summary>
    public string AssemblyName => _metadataReader.GetString(
        _metadataReader.GetAssemblyDefinition().Name);
    
    /// <summary>
    /// Lê todos os tipos definidos no assembly
    /// </summary>
    public IEnumerable<TypeDef> ReadTypes()
    {
        foreach (var typeHandle in _metadataReader.TypeDefinitions)
        {
            var typeDef = ReadType(typeHandle);
            if (typeDef != null)
                yield return typeDef;
        }
    }
    
    /// <summary>
    /// Segundo pass: decodifica IL e gera CFG para todos os métodos
    /// </summary>
    public void DecodeAllMethodBodies()
    {
        foreach (var method in _methodCache.Values)
        {
            if (method.HasCustomAssembly)
                continue;
            
            if (method.ILBody == null || method.ILBody.Length == 0)
                continue;
            
            try
            {
                var decoder = new ILDecoder(method.ILBody);
                var ilInstructions = decoder.Decode();
                
                var converter = new ILToIRConverter(method, ilInstructions, this);
                method.CFG = converter.Convert();
            }
            catch
            {
                // Se falhar, deixa CFG como null
            }
        }
    }
    
    /// <summary>
    /// Resolve um tipo pelo nome completo
    /// </summary>
    public TypeDef ResolveType(string fullName)
    {
        // Primeiro tentar no cache local
        foreach (var cached in _typeCache.Values)
        {
            if (cached.FullName == fullName)
                return cached;
        }
        
        // Tentar no TypeSystem
        if (_typeSystem != null)
        {
            return _typeSystem.ResolveType(fullName);
        }
        
        return null;
    }
    
    /// <summary>
    /// Lê um tipo específico
    /// </summary>
    public TypeDef ReadType(TypeDefinitionHandle handle)
    {
        if (_typeCache.TryGetValue(handle, out var cached))
            return cached;
        
        var typeDefinition = _metadataReader.GetTypeDefinition(handle);
        
        var name = _metadataReader.GetString(typeDefinition.Name);
        var ns = _metadataReader.GetString(typeDefinition.Namespace);
        
        // Ignorar tipos especiais como <Module>
        if (name == "<Module>")
            return null;
        
        var typeDef = new TypeDef
        {
            Name = name,
            Namespace = ns,
            Flags = ConvertTypeFlags(typeDefinition.Attributes),
        };
        
        _typeCache[handle] = typeDef;
        
        // Ler tipo base
        if (!typeDefinition.BaseType.IsNil)
        {
            typeDef.BaseType = ResolveTypeReference(typeDefinition.BaseType);
        }
        
        // Ler interfaces
        foreach (var ifaceHandle in typeDefinition.GetInterfaceImplementations())
        {
            var iface = _metadataReader.GetInterfaceImplementation(ifaceHandle);
            var ifaceType = ResolveTypeReference(iface.Interface);
            if (ifaceType != null)
                typeDef.Interfaces.Add(ifaceType);
        }
        
        // Ler parâmetros genéricos
        foreach (var gpHandle in typeDefinition.GetGenericParameters())
        {
            var gp = _metadataReader.GetGenericParameter(gpHandle);
            typeDef.GenericParameters.Add(new GenericParameter
            {
                Name = _metadataReader.GetString(gp.Name),
                Index = gp.Index,
            });
        }
        
        // Ler campos
        foreach (var fieldHandle in typeDefinition.GetFields())
        {
            var field = ReadField(fieldHandle, typeDef);
            if (field != null)
                typeDef.Fields.Add(field);
        }
        
        // Ler métodos
        foreach (var methodHandle in typeDefinition.GetMethods())
        {
            var method = ReadMethod(methodHandle, typeDef);
            if (method != null)
                typeDef.Methods.Add(method);
        }
        
        // Ler propriedades
        foreach (var propHandle in typeDefinition.GetProperties())
        {
            var prop = ReadProperty(propHandle, typeDef);
            if (prop != null)
                typeDef.Properties.Add(prop);
        }
        
        return typeDef;
    }
    
    /// <summary>
    /// Lê um campo
    /// </summary>
    private FieldDef ReadField(FieldDefinitionHandle handle, TypeDef declaringType)
    {
        if (_fieldCache.TryGetValue(handle, out var cached))
            return cached;
        
        var fieldDefinition = _metadataReader.GetFieldDefinition(handle);
        
        var field = new FieldDef
        {
            Name = _metadataReader.GetString(fieldDefinition.Name),
            DeclaringType = declaringType,
            Flags = ConvertFieldFlags(fieldDefinition.Attributes),
        };
        
        // Decodificar tipo do campo
        var signature = fieldDefinition.DecodeSignature(new TypeProvider(this), null);
        field.FieldType = signature;
        
        _fieldCache[handle] = field;
        return field;
    }
    
    /// <summary>
    /// Lê um método
    /// </summary>
    private MethodDef ReadMethod(MethodDefinitionHandle handle, TypeDef declaringType)
    {
        if (_methodCache.TryGetValue(handle, out var cached))
            return cached;
        
        var methodDefinition = _metadataReader.GetMethodDefinition(handle);
        
        var method = new MethodDef
        {
            Name = _metadataReader.GetString(methodDefinition.Name),
            DeclaringType = declaringType,
            Flags = ConvertMethodFlags(methodDefinition.Attributes),
        };
        
        // Decodificar assinatura
        var signature = methodDefinition.DecodeSignature(new TypeProvider(this), null);
        method.ReturnType = signature.ReturnType;
        
        // Parâmetros
        int paramIndex = 0;
        foreach (var paramType in signature.ParameterTypes)
        {
            method.Parameters.Add(new ParameterDef
            {
                Index = paramIndex++,
                ParameterType = paramType,
            });
        }
        
        // Nomes dos parâmetros
        foreach (var paramHandle in methodDefinition.GetParameters())
        {
            var param = _metadataReader.GetParameter(paramHandle);
            if (param.SequenceNumber > 0 && param.SequenceNumber <= method.Parameters.Count)
            {
                method.Parameters[param.SequenceNumber - 1].Name = 
                    _metadataReader.GetString(param.Name);
            }
        }
        
        // Parâmetros genéricos
        foreach (var gpHandle in methodDefinition.GetGenericParameters())
        {
            var gp = _metadataReader.GetGenericParameter(gpHandle);
            method.GenericParameters.Add(new Core.Types.GenericParameter
            {
                Name = _metadataReader.GetString(gp.Name),
                Index = gp.Index,
            });
        }
        
        // Corpo do método (IL)
        if (methodDefinition.RelativeVirtualAddress != 0)
        {
            var body = _peReader.GetMethodBody(methodDefinition.RelativeVirtualAddress);
            method.ILBody = body.GetILBytes();
            method.MaxStack = body.MaxStack;
            
            // Variáveis locais
            if (!body.LocalSignature.IsNil)
            {
                var localSig = _metadataReader.GetStandaloneSignature(body.LocalSignature);
                var locals = localSig.DecodeLocalSignature(new TypeProvider(this), null);
                
                int localIndex = 0;
                foreach (var localType in locals)
                {
                    method.Locals.Add(new Core.Types.LocalVariable
                    {
                        Index = localIndex++,
                        Type = localType,
                    });
                }
            }
        }
        
        // Ler custom attributes (para AsmImplementationAttribute)
        ReadMethodCustomAttributes(methodDefinition, method);
        
        _methodCache[handle] = method;
        return method;
    }
    
    /// <summary>
    /// Lê custom attributes de um método
    /// </summary>
    private void ReadMethodCustomAttributes(MethodDefinition methodDefinition, MethodDef method)
    {
        foreach (var attrHandle in methodDefinition.GetCustomAttributes())
        {
            var attr = _metadataReader.GetCustomAttribute(attrHandle);
            
            // Obter nome do atributo
            string attrName = null;
            if (attr.Constructor.Kind == HandleKind.MemberReference)
            {
                var memberRef = _metadataReader.GetMemberReference((MemberReferenceHandle)attr.Constructor);
                var typeRef = _metadataReader.GetTypeReference((TypeReferenceHandle)memberRef.Parent);
                attrName = _metadataReader.GetString(typeRef.Name);
            }
            else if (attr.Constructor.Kind == HandleKind.MethodDefinition)
            {
                var methodDef = _metadataReader.GetMethodDefinition((MethodDefinitionHandle)attr.Constructor);
                var typeDef = _metadataReader.GetTypeDefinition(methodDef.GetDeclaringType());
                attrName = _metadataReader.GetString(typeDef.Name);
            }
            
            // Processar atributos conhecidos
            if (attrName == "AsmImplementationAttribute" || attrName == "Asm386ImplementationAttribute")
            {
                var value = _metadataReader.GetBlobBytes(attr.Value);
                var asmCode = DecodeAttributeStringArg(value, 0);
                if (!string.IsNullOrEmpty(asmCode))
                {
                    method.CustomAssembly = asmCode;
                    
                    // Verificar se tem segundo argumento (soft-float assembly)
                    var softFloatAsm = DecodeAttributeStringArg(value, 1);
                    if (!string.IsNullOrEmpty(softFloatAsm))
                    {
                        method.SoftFloatAssembly = softFloatAsm;
                    }
                }
            }
            else if (attrName == "Asm386IntrinsicAttribute")
            {
                var value = _metadataReader.GetBlobBytes(attr.Value);
                var intrinsicName = DecodeAttributeStringArg(value, 0);
                if (!string.IsNullOrEmpty(intrinsicName))
                {
                    method.IsIntrinsic = true;
                    method.IntrinsicName = intrinsicName;
                }
            }
        }
    }
    
    /// <summary>
    /// Decodifica um argumento string de um custom attribute
    /// </summary>
    private string DecodeAttributeStringArg(byte[] blob, int argIndex)
    {
        if (blob == null || blob.Length < 2)
            return null;
        
        // Custom attribute blob format:
        // - 2 bytes: prolog (0x0001)
        // - Fixed args (in order)
        // - Named args count (2 bytes)
        // - Named args
        
        int offset = 2; // Skip prolog
        
        for (int i = 0; i <= argIndex; i++)
        {
            if (offset >= blob.Length)
                return null;
            
            // Check for null string (0xFF)
            if (blob[offset] == 0xFF)
            {
                offset++;
                if (i == argIndex)
                    return null;
                continue;
            }
            
            // Read packed length
            int length = 0;
            byte b = blob[offset++];
            if ((b & 0x80) == 0)
            {
                length = b;
            }
            else if ((b & 0xC0) == 0x80)
            {
                if (offset >= blob.Length) return null;
                length = ((b & 0x3F) << 8) | blob[offset++];
            }
            else if ((b & 0xE0) == 0xC0)
            {
                if (offset + 2 >= blob.Length) return null;
                length = ((b & 0x1F) << 24) | (blob[offset++] << 16) | (blob[offset++] << 8) | blob[offset++];
            }
            
            if (i == argIndex)
            {
                if (offset + length > blob.Length)
                    return null;
                return System.Text.Encoding.UTF8.GetString(blob, offset, length);
            }
            
            offset += length;
        }
        
        return null;
    }
    
    /// <summary>
    /// Lê uma propriedade
    /// </summary>
    private PropertyDef ReadProperty(PropertyDefinitionHandle handle, TypeDef declaringType)
    {
        var propDefinition = _metadataReader.GetPropertyDefinition(handle);
        
        var prop = new PropertyDef
        {
            Name = _metadataReader.GetString(propDefinition.Name),
            DeclaringType = declaringType,
        };
        
        // Decodificar tipo
        var signature = propDefinition.DecodeSignature(new TypeProvider(this), null);
        prop.PropertyType = signature.ReturnType;
        
        // Getter e Setter
        var accessors = propDefinition.GetAccessors();
        if (!accessors.Getter.IsNil)
        {
            prop.Getter = _methodCache.GetValueOrDefault(accessors.Getter);
        }
        if (!accessors.Setter.IsNil)
        {
            prop.Setter = _methodCache.GetValueOrDefault(accessors.Setter);
        }
        
        return prop;
    }
    
    /// <summary>
    /// Resolve uma referência de tipo
    /// </summary>
    public TypeDef ResolveTypeReference(EntityHandle handle)
    {
        if (handle.IsNil)
            return null;
        
        switch (handle.Kind)
        {
            case HandleKind.TypeDefinition:
                return ReadType((TypeDefinitionHandle)handle);
            
            case HandleKind.TypeReference:
                var typeRef = _metadataReader.GetTypeReference((TypeReferenceHandle)handle);
                var name = _metadataReader.GetString(typeRef.Name);
                var ns = _metadataReader.GetString(typeRef.Namespace);
                var fullName = string.IsNullOrEmpty(ns) ? name : $"{ns}.{name}";
                
                // Resolver do TypeSystem (que contém tipos do corlib)
                return _typeSystem.ResolveType(fullName);
            
            case HandleKind.TypeSpecification:
                var typeSpec = _metadataReader.GetTypeSpecification((TypeSpecificationHandle)handle);
                return typeSpec.DecodeSignature(new TypeProvider(this), null);
            
            default:
                return null;
        }
    }
    
    private static TypeFlags ConvertTypeFlags(TypeAttributes attrs)
    {
        var flags = TypeFlags.None;
        
        if ((attrs & TypeAttributes.Public) != 0 || (attrs & TypeAttributes.NestedPublic) != 0)
            flags |= TypeFlags.Public;
        if ((attrs & TypeAttributes.Sealed) != 0)
            flags |= TypeFlags.Sealed;
        if ((attrs & TypeAttributes.Abstract) != 0)
            flags |= TypeFlags.Abstract;
        if ((attrs & TypeAttributes.Interface) != 0)
            flags |= TypeFlags.Interface;
#pragma warning disable SYSLIB0050
        if ((attrs & TypeAttributes.Serializable) != 0)
            flags |= TypeFlags.Serializable;
#pragma warning restore SYSLIB0050
        if ((attrs & TypeAttributes.BeforeFieldInit) != 0)
            flags |= TypeFlags.BeforeFieldInit;
        
        return flags;
    }
    
    private static MethodFlags ConvertMethodFlags(MethodAttributes attrs)
    {
        var flags = MethodFlags.None;
        
        if ((attrs & MethodAttributes.Public) != 0)
            flags |= MethodFlags.Public;
        if ((attrs & MethodAttributes.Private) != 0)
            flags |= MethodFlags.Private;
        if ((attrs & MethodAttributes.Family) != 0)
            flags |= MethodFlags.Protected;
        if ((attrs & MethodAttributes.Static) != 0)
            flags |= MethodFlags.Static;
        if ((attrs & MethodAttributes.Virtual) != 0)
            flags |= MethodFlags.Virtual;
        if ((attrs & MethodAttributes.Abstract) != 0)
            flags |= MethodFlags.Abstract;
        if ((attrs & MethodAttributes.Final) != 0)
            flags |= MethodFlags.Final;
        if ((attrs & MethodAttributes.NewSlot) != 0)
            flags |= MethodFlags.NewSlot;
        if ((attrs & MethodAttributes.SpecialName) != 0)
            flags |= MethodFlags.SpecialName;
        
        return flags;
    }
    
    private static FieldFlags ConvertFieldFlags(FieldAttributes attrs)
    {
        var flags = FieldFlags.None;
        
        if ((attrs & FieldAttributes.Public) != 0)
            flags |= FieldFlags.Public;
        if ((attrs & FieldAttributes.Private) != 0)
            flags |= FieldFlags.Private;
        if ((attrs & FieldAttributes.Family) != 0)
            flags |= FieldFlags.Protected;
        if ((attrs & FieldAttributes.Static) != 0)
            flags |= FieldFlags.Static;
        if ((attrs & FieldAttributes.InitOnly) != 0)
            flags |= FieldFlags.InitOnly;
        if ((attrs & FieldAttributes.Literal) != 0)
            flags |= FieldFlags.Literal;
        
        return flags;
    }
    
    /// <summary>
    /// Resolve um token de método (uint)
    /// </summary>
    public MethodDef ResolveMethod(uint tokenValue)
    {
        return ResolveMethod(new MetadataToken(tokenValue));
    }
    
    /// <summary>
    /// Resolve um token de tipo (uint)
    /// </summary>
    public TypeDef ResolveTypeByToken(uint tokenValue)
    {
        try
        {
            var handle = MetadataTokens.EntityHandle((int)tokenValue);
            
            if (handle.Kind == HandleKind.TypeDefinition)
            {
                return _typeCache.GetValueOrDefault((TypeDefinitionHandle)handle);
            }
            else if (handle.Kind == HandleKind.TypeReference)
            {
                return ResolveTypeReference(handle);
            }
        }
        catch { 
            throw;
        }
        
        return null;
    }
    
    /// <summary>
    /// Resolve um token de campo (uint)
    /// </summary>
    public FieldDef ResolveField(uint tokenValue)
    {
        return ResolveField(new MetadataToken(tokenValue));
    }
    
    /// <summary>
    /// Resolve um token de método
    /// </summary>
    public MethodDef ResolveMethod(MetadataToken token)
    {
        try
        {
            var handle = MetadataTokens.EntityHandle((int)token.Value);
            
            if (handle.Kind == HandleKind.MethodDefinition)
            {
                return _methodCache.GetValueOrDefault((MethodDefinitionHandle)handle);
            }
            else if (handle.Kind == HandleKind.MethodSpecification)
            {
                // Método genérico instanciado (ex: List<int>.Add)
                var methodSpec = _metadataReader.GetMethodSpecification((MethodSpecificationHandle)handle);
                
                // Resolver o método base (MethodDef ou MemberRef)
                var baseMethod = ResolveMethod(new MetadataToken((uint)MetadataTokens.GetToken(methodSpec.Method)));
                
                // TODO: Para monomorphization completa, criar uma cópia especializada
                // Por agora, retornar o método genérico base
                return baseMethod;
            }
            else if (handle.Kind == HandleKind.MemberReference)
            {
                var memberRef = _metadataReader.GetMemberReference((MemberReferenceHandle)handle);
                var name = _metadataReader.GetString(memberRef.Name);
                
                // Resolver tipo pai
                var parentType = ResolveTypeReference(memberRef.Parent);
                if (parentType != null)
                {
                    // Decodificar assinatura para encontrar overload correto
                    var signature = memberRef.DecodeMethodSignature(new TypeProvider(this), null);
                    var paramTypes = signature.ParameterTypes;
                    
                    // Procurar método com mesmo nome
                    var candidates = parentType.Methods.Where(m => m.Name == name).ToList();
                    
                    // Match exato por tipos dos parâmetros
                    foreach (var candidate in candidates)
                    {
                        if (candidate.Parameters.Count != paramTypes.Length)
                            continue;
                        
                        bool match = true;
                        for (int i = 0; i < paramTypes.Length; i++)
                        {
                            var expectedType = paramTypes[i];
                            var actualType = candidate.Parameters[i].ParameterType;
                            
                            if (expectedType == null || actualType == null)
                                continue;
                            
                            // Comparar por nome completo
                            if (expectedType.FullName != actualType.FullName)
                            {
                                match = false;
                                break;
                            }
                        }
                        
                        if (match)
                            return candidate;
                    }
                    
                    // Fallback: match por número de parâmetros
                    var fallback = candidates.FirstOrDefault(m => m.Parameters.Count == paramTypes.Length);
                    if (fallback != null)
                        return fallback;
                    
                    // Último fallback: primeiro com mesmo nome
                    return candidates.FirstOrDefault();
                }
            }
        }
        catch { }
        
        return null;
    }
    
    /// <summary>
    /// Resolve um token de campo
    /// </summary>
    public FieldDef ResolveField(MetadataToken token)
    {
        try
        {
            var handle = MetadataTokens.EntityHandle((int)token.Value);
            
            if (handle.Kind == HandleKind.FieldDefinition)
            {
                var fieldDef = _metadataReader.GetFieldDefinition((FieldDefinitionHandle)handle);
                var declaringType = ReadType(fieldDef.GetDeclaringType());
                var name = _metadataReader.GetString(fieldDef.Name);
                return declaringType?.Fields.FirstOrDefault(f => f.Name == name);
            }
            else if (handle.Kind == HandleKind.MemberReference)
            {
                var memberRef = _metadataReader.GetMemberReference((MemberReferenceHandle)handle);
                var name = _metadataReader.GetString(memberRef.Name);
                var parentType = ResolveTypeReference(memberRef.Parent);
                return parentType?.Fields.FirstOrDefault(f => f.Name == name);
            }
        }
        catch { }
        
        return null;
    }
    
    /// <summary>
    /// Resolve um token de string (uint)
    /// </summary>
    public string ResolveString(uint tokenValue)
    {
        return ResolveString(new MetadataToken(tokenValue));
    }
    
    /// <summary>
    /// Resolve um token de string
    /// </summary>
    public string ResolveString(MetadataToken token)
    {
        try
        {
            var handle = MetadataTokens.UserStringHandle((int)(token.Value & 0x00FFFFFF));
            return _metadataReader.GetUserString(handle);
        }
        catch
        {
            return null;
        }
    }
    
    public void Dispose()
    {
        _peReader?.Dispose();
        _stream?.Dispose();
    }
    
    /// <summary>
    /// Provider de tipos para decodificação de assinaturas.
    /// Usa o TypeSystem para resolver tipos primitivos do corlib customizado.
    /// </summary>
    private class TypeProvider : ISignatureTypeProvider<TypeDef, object>
    {
        private readonly AssemblyReader _reader;
        
        public TypeProvider(AssemblyReader reader)
        {
            _reader = reader;
        }
        
        public TypeDef GetPrimitiveType(PrimitiveTypeCode typeCode)
        {
            // Mapear PrimitiveTypeCode para nome do tipo
            var typeName = typeCode switch
            {
                PrimitiveTypeCode.Void => "Void",
                PrimitiveTypeCode.Boolean => "Boolean",
                PrimitiveTypeCode.Char => "Char",
                PrimitiveTypeCode.SByte => "SByte",
                PrimitiveTypeCode.Byte => "Byte",
                PrimitiveTypeCode.Int16 => "Int16",
                PrimitiveTypeCode.UInt16 => "UInt16",
                PrimitiveTypeCode.Int32 => "Int32",
                PrimitiveTypeCode.UInt32 => "UInt32",
                PrimitiveTypeCode.Int64 => "Int64",
                PrimitiveTypeCode.UInt64 => "UInt64",
                PrimitiveTypeCode.Single => "Single",
                PrimitiveTypeCode.Double => "Double",
                PrimitiveTypeCode.String => "String",
                PrimitiveTypeCode.Object => "Object",
                PrimitiveTypeCode.IntPtr => "IntPtr",
                PrimitiveTypeCode.UIntPtr => "UIntPtr",
                PrimitiveTypeCode.TypedReference => "TypedReference",
                _ => typeCode.ToString()
            };
            
            // Usar TypeSystem se disponível (referencia ao corlib customizado)
            if (_reader._typeSystem != null)
            {
                return _reader._typeSystem.GetPrimitiveType(typeName);
            }
            
            // Fallback: criar tipo placeholder
            var isValueType = typeCode != PrimitiveTypeCode.String && 
                              typeCode != PrimitiveTypeCode.Object;
            
            return new TypeDef 
            { 
                Name = typeName, 
                Namespace = "System", 
                Flags = isValueType ? TypeFlags.ValueType : TypeFlags.None 
            };
        }
        
        public TypeDef GetTypeFromDefinition(MetadataReader reader, TypeDefinitionHandle handle, byte rawTypeKind)
        {
            return _reader.ReadType(handle);
        }
        
        public TypeDef GetTypeFromReference(MetadataReader reader, TypeReferenceHandle handle, byte rawTypeKind)
        {
            return _reader.ResolveTypeReference(handle);
        }
        
        public TypeDef GetTypeFromSpecification(MetadataReader reader, object genericContext, TypeSpecificationHandle handle, byte rawTypeKind)
        {
            var typeSpec = reader.GetTypeSpecification(handle);
            return typeSpec.DecodeSignature(this, genericContext);
        }
        
        public TypeDef GetSZArrayType(TypeDef elementType)
        {
            return new TypeDef
            {
                Name = elementType.Name + "[]",
                Namespace = elementType.Namespace,
            };
        }
        
        public TypeDef GetArrayType(TypeDef elementType, ArrayShape shape)
        {
            return new TypeDef
            {
                Name = elementType.Name + "[" + new string(',', shape.Rank - 1) + "]",
                Namespace = elementType.Namespace,
            };
        }
        
        public TypeDef GetByReferenceType(TypeDef elementType)
        {
            return new TypeDef
            {
                Name = elementType.Name + "&",
                Namespace = elementType.Namespace,
            };
        }
        
        public TypeDef GetPointerType(TypeDef elementType)
        {
            return new TypeDef
            {
                Name = elementType.Name + "*",
                Namespace = elementType.Namespace,
            };
        }
        
        public TypeDef GetGenericInstantiation(TypeDef genericType, ImmutableArray<TypeDef> typeArguments)
        {
            if (genericType == null)
                return null;
            
            // Criar nome especializado: SimpleList`1<Int32> -> SimpleList_Int32
            var typeArgNames = string.Join("_", typeArguments.Select(t => t?.Name ?? "T"));
            var baseName = genericType.Name;
            if (baseName.Contains('`'))
                baseName = baseName.Substring(0, baseName.IndexOf('`'));
            var specializedName = $"{baseName}_{typeArgNames}";
            
            // Verificar se já existe no cache do TypeSystem
            var fullName = string.IsNullOrEmpty(genericType.Namespace) 
                ? specializedName 
                : $"{genericType.Namespace}.{specializedName}";
            
            var existing = _reader._typeSystem?.ResolveType(fullName);
            if (existing != null)
                return existing;
            
            // Criar tipo especializado (monomorphization)
            var specialized = new TypeDef
            {
                Name = specializedName,
                Namespace = genericType.Namespace,
                Flags = genericType.Flags,
                IsGenericInstance = true,
                GenericDefinition = genericType,
                BaseType = genericType.BaseType,
                InstanceSize = genericType.InstanceSize,
            };
            specialized.TypeArguments.AddRange(typeArguments);
            
            // Copiar e especializar métodos
            foreach (var method in genericType.Methods)
            {
                var specializedMethod = new MethodDef
                {
                    Name = method.Name,
                    DeclaringType = specialized,
                    Flags = method.Flags,
                    ReturnType = SubstituteGenericType(method.ReturnType, genericType.GenericParameters, typeArguments),
                    VTableSlot = method.VTableSlot,
                    ILBody = method.ILBody,
                    CFG = method.CFG,
                    CustomAssembly = method.CustomAssembly,
                    SoftFloatAssembly = method.SoftFloatAssembly,
                };
                
                // Especializar parâmetros
                foreach (var param in method.Parameters)
                {
                    specializedMethod.Parameters.Add(new ParameterDef
                    {
                        Name = param.Name,
                        ParameterType = SubstituteGenericType(param.ParameterType, genericType.GenericParameters, typeArguments),
                        Index = param.Index,
                    });
                }
                
                // Especializar locais
                foreach (var local in method.Locals)
                {
                    specializedMethod.Locals.Add(new LocalVariable
                    {
                        Index = local.Index,
                        Type = SubstituteGenericType(local.Type, genericType.GenericParameters, typeArguments),
                    });
                }
                
                specialized.Methods.Add(specializedMethod);
            }
            
            // Copiar e especializar campos
            foreach (var field in genericType.Fields)
            {
                specialized.Fields.Add(new FieldDef
                {
                    Name = field.Name,
                    DeclaringType = specialized,
                    FieldType = SubstituteGenericType(field.FieldType, genericType.GenericParameters, typeArguments),
                    Flags = field.Flags,
                    Offset = field.Offset,
                });
            }
            
            // Registrar no TypeSystem
            _reader._typeSystem?.RegisterType(specialized);
            
            return specialized;
        }
        
        private TypeDef SubstituteGenericType(TypeDef type, List<GenericParameter> genericParams, ImmutableArray<TypeDef> typeArgs)
        {
            if (type == null)
                return null;
            
            // Verificar se é um parâmetro genérico (T0, T1, etc.)
            if (type.Name != null && type.Name.StartsWith("T") && type.Name.Length <= 2)
            {
                if (int.TryParse(type.Name.Substring(1), out int index) && index < typeArgs.Length)
                {
                    return typeArgs[index];
                }
            }
            
            // Verificar pelo nome do parâmetro genérico
            for (int i = 0; i < genericParams.Count && i < typeArgs.Length; i++)
            {
                if (type.Name == genericParams[i].Name)
                {
                    return typeArgs[i];
                }
            }
            
            return type;
        }
        
        public TypeDef GetGenericTypeParameter(object genericContext, int index)
        {
            return new TypeDef { Name = $"T{index}", Flags = TypeFlags.None };
        }
        
        public TypeDef GetGenericMethodParameter(object genericContext, int index)
        {
            return new TypeDef { Name = $"TM{index}", Flags = TypeFlags.None };
        }
        
        public TypeDef GetFunctionPointerType(MethodSignature<TypeDef> signature)
        {
            return new TypeDef { Name = "FunctionPointer", Namespace = "System" };
        }
        
        public TypeDef GetModifiedType(TypeDef modifier, TypeDef unmodifiedType, bool isRequired)
        {
            return unmodifiedType;
        }
        
        public TypeDef GetPinnedType(TypeDef elementType)
        {
            return elementType;
        }
    }
}
