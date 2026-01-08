; ============================================================
; STARTUP CODE - DosNET Application
; Exception handlers are in corlib.lib
; ============================================================

.386
.MODEL FLAT, C

.CODE

; ============================================================
; Entry Point
; ============================================================
EXTRN __exit:PROC

PUBLIC __start
__start PROC
    ; Chamar Program.Main (definido no código do usuário)
    CALL __Program_Main
    
    ; Sair com código de retorno
    PUSH EAX
    CALL __exit
__start ENDP


; ============================================================
; External Runtime Functions (from corlib.lib)
; ============================================================

EXTRN __gc_init:PROC
EXTRN __gc_alloc:PROC
EXTRN __gc_alloc_typed:PROC
EXTRN __gc_collect:PROC
EXTRN __throw_exception:PROC
EXTRN __throw_out_of_memory:PROC
EXTRN __throw_null_reference:PROC
EXTRN __throw_invalid_cast:PROC
EXTRN __throw_index_out_of_range:PROC
EXTRN __soft_fadd:PROC
EXTRN __soft_fsub:PROC
EXTRN __soft_fmul:PROC
EXTRN __soft_fdiv:PROC

; ============================================================
; User Code
; ============================================================

; External Corlib Methods
EXTRN __Microsoft_CodeAnalysis_EmbeddedAttribute__ctor:PROC
EXTRN __System_Runtime_CompilerServices_RefSafetyRulesAttribute__ctor_Int32:PROC
EXTRN __System_Array_get_Length:PROC
EXTRN __System_Array_GetLength_Int32:PROC
EXTRN __System_Array_get_Rank:PROC
EXTRN __System_Array_Copy_Array_Array_Int32:PROC
EXTRN __System_Array_Copy_Array_Int32_Array_Int32_Int32:PROC
EXTRN __System_Array_Clear_Array_Int32_Int32:PROC
EXTRN __System_Array_IndexOf_Array_Object:PROC
EXTRN __System_Array_IndexOf_Array_Object_Int32_Int32:PROC
EXTRN __System_Array__ctor:PROC
EXTRN __System_Asm386ImplementationAttribute_get_Assembly:PROC
EXTRN __System_Asm386ImplementationAttribute_get_SoftFloatAssembly:PROC
EXTRN __System_Asm386ImplementationAttribute__ctor_String:PROC
EXTRN __System_Asm386ImplementationAttribute__ctor_String_String:PROC
EXTRN __System_Asm386IntrinsicAttribute_get_IntrinsicName:PROC
EXTRN __System_Asm386IntrinsicAttribute__ctor_String:PROC
EXTRN __System_Asm386LayoutAttribute_get_Size:PROC
EXTRN __System_Asm386LayoutAttribute_set_Size_Int32:PROC
EXTRN __System_Asm386LayoutAttribute_get_Alignment:PROC
EXTRN __System_Asm386LayoutAttribute_set_Alignment_Int32:PROC
EXTRN __System_Asm386LayoutAttribute__ctor:PROC
EXTRN __System_AttributeUsageAttribute_get_ValidOn:PROC
EXTRN __System_AttributeUsageAttribute_get_AllowMultiple:PROC
EXTRN __System_AttributeUsageAttribute_set_AllowMultiple_Boolean:PROC
EXTRN __System_AttributeUsageAttribute_get_Inherited:PROC
EXTRN __System_AttributeUsageAttribute_set_Inherited_Boolean:PROC
EXTRN __System_AttributeUsageAttribute__ctor_AttributeTargets:PROC
EXTRN __System_Attribute__ctor:PROC
EXTRN __System_FlagsAttribute__ctor:PROC
EXTRN __System_Delegate_get_Target:PROC
EXTRN __System_Delegate_Equals_Object:PROC
EXTRN __System_Delegate_GetHashCode:PROC
EXTRN __System_Delegate__ctor:PROC
EXTRN __System_MulticastDelegate__ctor:PROC
EXTRN __System_Nullable_1_get_HasValue:PROC
EXTRN __System_Nullable_1_get_Value:PROC
EXTRN __System_Nullable_1__ctor_T0:PROC
EXTRN __System_Nullable_1_GetValueOrDefault:PROC
EXTRN __System_Nullable_1_GetValueOrDefault_T0:PROC
EXTRN __System_Nullable_1_Equals_Object:PROC
EXTRN __System_Nullable_1_GetHashCode:PROC
EXTRN __System_Nullable_1_ToString:PROC
EXTRN __System_Action__ctor_Object_IntPtr:PROC
EXTRN __System_Action_Invoke:PROC
EXTRN __System_Action_1__ctor_Object_IntPtr:PROC
EXTRN __System_Action_1_Invoke_T0:PROC
EXTRN __System_Action_2__ctor_Object_IntPtr:PROC
EXTRN __System_Action_2_Invoke_T0_T1:PROC
EXTRN __System_Func_1__ctor_Object_IntPtr:PROC
EXTRN __System_Func_1_Invoke:PROC
EXTRN __System_Func_2__ctor_Object_IntPtr:PROC
EXTRN __System_Func_2_Invoke_T0:PROC
EXTRN __System_Func_3__ctor_Object_IntPtr:PROC
EXTRN __System_Func_3_Invoke_T0_T1:PROC
EXTRN __System_Predicate_1__ctor_Object_IntPtr:PROC
EXTRN __System_Predicate_1_Invoke_T0:PROC
EXTRN __System_Console_Write_String:PROC
EXTRN __System_Console_WriteLine_String:PROC
EXTRN __System_Console_WriteLine:PROC
EXTRN __System_Console_Write_Char:PROC
EXTRN __System_Console_Write_Int32:PROC
EXTRN __System_Console_WriteLine_Int32:PROC
EXTRN __System_Console_Write_Int64:PROC
EXTRN __System_Console_WriteLine_Int64:PROC
EXTRN __System_Console_Write_Boolean:PROC
EXTRN __System_Console_WriteLine_Boolean:PROC
EXTRN __System_Console_Write_Object:PROC
EXTRN __System_Console_WriteLine_Object:PROC
EXTRN __System_Console_Read:PROC
EXTRN __System_Console_ReadLine:PROC
EXTRN __System_Console_ReadKey:PROC
EXTRN __System_Console_CheckKeyAvailable:PROC
EXTRN __System_Console_get_KeyAvailable:PROC
EXTRN __System_Enum_ToString:PROC
EXTRN __System_Enum_Equals_Object:PROC
EXTRN __System_Enum_GetHashCode:PROC
EXTRN __System_Enum__ctor:PROC
EXTRN __System_Exception__ctor:PROC
EXTRN __System_Exception__ctor_String:PROC
EXTRN __System_Exception__ctor_String_Exception:PROC
EXTRN __System_Exception_get_Message:PROC
EXTRN __System_Exception_get_InnerException:PROC
EXTRN __System_Exception_ToString:PROC
EXTRN __System_SystemException__ctor:PROC
EXTRN __System_SystemException__ctor_String:PROC
EXTRN __System_SystemException__ctor_String_Exception:PROC
EXTRN __System_NullReferenceException__ctor:PROC
EXTRN __System_NullReferenceException__ctor_String:PROC
EXTRN __System_InvalidOperationException__ctor:PROC
EXTRN __System_InvalidOperationException__ctor_String:PROC
EXTRN __System_ArgumentException__ctor:PROC
EXTRN __System_ArgumentException__ctor_String:PROC
EXTRN __System_ArgumentNullException__ctor:PROC
EXTRN __System_ArgumentNullException__ctor_String:PROC
EXTRN __System_ArgumentOutOfRangeException__ctor:PROC
EXTRN __System_ArgumentOutOfRangeException__ctor_String:PROC
EXTRN __System_IndexOutOfRangeException__ctor:PROC
EXTRN __System_IndexOutOfRangeException__ctor_String:PROC
EXTRN __System_OutOfMemoryException__ctor:PROC
EXTRN __System_OutOfMemoryException__ctor_String:PROC
EXTRN __System_OverflowException__ctor:PROC
EXTRN __System_OverflowException__ctor_String:PROC
EXTRN __System_DivideByZeroException__ctor:PROC
EXTRN __System_DivideByZeroException__ctor_String:PROC
EXTRN __System_NotSupportedException__ctor:PROC
EXTRN __System_NotSupportedException__ctor_String:PROC
EXTRN __System_NotImplementedException__ctor:PROC
EXTRN __System_NotImplementedException__ctor_String:PROC
EXTRN __System_Object_Equals_Object:PROC
EXTRN __System_Object_GetHashCode:PROC
EXTRN __System_Object_ToString:PROC
EXTRN __System_Object_GetType:PROC
EXTRN __System_Object_Finalize:PROC
EXTRN __System_Object_MemberwiseClone:PROC
EXTRN __System_Object_Equals_Object_Object:PROC
EXTRN __System_Object_ReferenceEquals_Object_Object:PROC
EXTRN __System_Object__ctor:PROC
EXTRN __System_Boolean_ToString:PROC
EXTRN __System_Boolean_GetHashCode:PROC
EXTRN __System_Boolean_Equals_Object:PROC
EXTRN __System_Char_ToString:PROC
EXTRN __System_Char_GetHashCode:PROC
EXTRN __System_Char_Equals_Object:PROC
EXTRN __System_Char_IsWhiteSpace_Char:PROC
EXTRN __System_Char_IsDigit_Char:PROC
EXTRN __System_Char_IsLetter_Char:PROC
EXTRN __System_Char_IsLetterOrDigit_Char:PROC
EXTRN __System_Char_IsUpper_Char:PROC
EXTRN __System_Char_IsLower_Char:PROC
EXTRN __System_Char_ToUpper_Char:PROC
EXTRN __System_Char_ToLower_Char:PROC
EXTRN __System_SByte_ToString:PROC
EXTRN __System_SByte_GetHashCode:PROC
EXTRN __System_SByte_Equals_Object:PROC
EXTRN __System_Byte_ToString:PROC
EXTRN __System_Byte_GetHashCode:PROC
EXTRN __System_Byte_Equals_Object:PROC
EXTRN __System_Int16_ToString:PROC
EXTRN __System_Int16_GetHashCode:PROC
EXTRN __System_Int16_Equals_Object:PROC
EXTRN __System_UInt16_ToString:PROC
EXTRN __System_UInt16_GetHashCode:PROC
EXTRN __System_UInt16_Equals_Object:PROC
EXTRN __System_Int32_ToString:PROC
EXTRN __System_Int32_GetHashCode:PROC
EXTRN __System_Int32_Equals_Object:PROC
EXTRN __System_Int32_Parse_String:PROC
EXTRN __System_UInt32_ToString:PROC
EXTRN __System_UInt32_GetHashCode:PROC
EXTRN __System_UInt32_Equals_Object:PROC
EXTRN __System_Int64_ToString:PROC
EXTRN __System_Int64_GetHashCode:PROC
EXTRN __System_Int64_Equals_Object:PROC
EXTRN __System_UInt64_ToString:PROC
EXTRN __System_UInt64_GetHashCode:PROC
EXTRN __System_UInt64_Equals_Object:PROC
EXTRN __System_Single_ToString:PROC
EXTRN __System_Single_GetHashCode:PROC
EXTRN __System_Single_Equals_Object:PROC
EXTRN __System_Single_IsNaN_Single:PROC
EXTRN __System_Single_IsInfinity_Single:PROC
EXTRN __System_Double_ToString:PROC
EXTRN __System_Double_GetHashCode:PROC
EXTRN __System_Double_Equals_Object:PROC
EXTRN __System_Double_IsNaN_Double:PROC
EXTRN __System_Double_IsInfinity_Double:PROC
EXTRN __System_IntPtr_get_Size:PROC
EXTRN __System_IntPtr__ctor_Int32:PROC
EXTRN __System_IntPtr_ToInt32:PROC
EXTRN __System_IntPtr_ToString:PROC
EXTRN __System_IntPtr_GetHashCode:PROC
EXTRN __System_IntPtr_Equals_Object:PROC
EXTRN __System_IntPtr_op_Equality_IntPtr_IntPtr:PROC
EXTRN __System_IntPtr_op_Inequality_IntPtr_IntPtr:PROC
EXTRN __System_IntPtr__cctor:PROC
EXTRN __System_UIntPtr_get_Size:PROC
EXTRN __System_UIntPtr__ctor_UInt32:PROC
EXTRN __System_UIntPtr_ToUInt32:PROC
EXTRN __System_UIntPtr_ToString:PROC
EXTRN __System_UIntPtr_GetHashCode:PROC
EXTRN __System_UIntPtr_Equals_Object:PROC
EXTRN __System_UIntPtr_op_Equality_UIntPtr_UIntPtr:PROC
EXTRN __System_UIntPtr_op_Inequality_UIntPtr_UIntPtr:PROC
EXTRN __System_UIntPtr__cctor:PROC
EXTRN __System_RuntimeHelpers_GetHashCode_Object:PROC
EXTRN __System_RuntimeHelpers_GetTypeHandle_Object:PROC
EXTRN __System_RuntimeHelpers_GetTypeFromHandle_RuntimeTypeHandle:PROC
EXTRN __System_RuntimeHelpers_MemberwiseClone_Object:PROC
EXTRN __System_RuntimeHelpers_ValueTypeEquals_Object_Object:PROC
EXTRN __System_RuntimeHelpers_ValueTypeGetHashCode_Object:PROC
EXTRN __System_RuntimeHelpers_GetCharAt_String_Int32:PROC
EXTRN __System_RuntimeHelpers_StringEquals_String_String:PROC
EXTRN __System_RuntimeHelpers_StringGetHashCode_String:PROC
EXTRN __System_RuntimeHelpers_StringConcat_String_String:PROC
EXTRN __System_RuntimeHelpers_CharToString_Char:PROC
EXTRN __System_RuntimeHelpers_Int32ToString_Int32:PROC
EXTRN __System_RuntimeHelpers_UInt32ToString_UInt32:PROC
EXTRN __System_RuntimeHelpers_Int64ToString_Int64:PROC
EXTRN __System_RuntimeHelpers_UInt64ToString_UInt64:PROC
EXTRN __System_RuntimeHelpers_SingleToString_Single:PROC
EXTRN __System_RuntimeHelpers_DoubleToString_Double:PROC
EXTRN __System_RuntimeHelpers_SingleToInt32Bits_Single:PROC
EXTRN __System_RuntimeHelpers_DoubleToInt64Bits_Double:PROC
EXTRN __System_RuntimeHelpers_ParseInt32_String:PROC
EXTRN __System_RuntimeHelpers_ArrayClear_Array_Int32_Int32:PROC
EXTRN __System_RuntimeHelpers_ArrayGetValue_Array_Int32:PROC
EXTRN __System_RuntimeTypeHandle_get_Value:PROC
EXTRN __System_String_get_Length:PROC
EXTRN __System_String_get_Item_Int32:PROC
EXTRN __System_String_IsNullOrEmpty_String:PROC
EXTRN __System_String_IsNullOrWhiteSpace_String:PROC
EXTRN __System_String_Equals_Object:PROC
EXTRN __System_String_Equals_String:PROC
EXTRN __System_String_Equals_String_String:PROC
EXTRN __System_String_GetHashCode:PROC
EXTRN __System_String_ToString:PROC
EXTRN __System_String_Concat_String_String:PROC
EXTRN __System_String_Concat_String_String_String:PROC
EXTRN __System_String_Concat_String_String_String_String:PROC
EXTRN __System_String_op_Equality_String_String:PROC
EXTRN __System_String_op_Inequality_String_String:PROC
EXTRN __System_String__ctor:PROC
EXTRN __System_String__cctor:PROC
EXTRN __System_Type_get_Name:PROC
EXTRN __System_Type_get_Namespace:PROC
EXTRN __System_Type_get_FullName:PROC
EXTRN __System_Type_get_BaseType:PROC
EXTRN __System_Type_get_IsValueType:PROC
EXTRN __System_Type_get_IsClass:PROC
EXTRN __System_Type_get_IsInterface:PROC
EXTRN __System_Type_get_IsEnum:PROC
EXTRN __System_Type_get_IsArray:PROC
EXTRN __System_Type_ToString:PROC
EXTRN __System_Type_Equals_Object:PROC
EXTRN __System_Type_GetHashCode:PROC
EXTRN __System_Type_op_Equality_Type_Type:PROC
EXTRN __System_Type_op_Inequality_Type_Type:PROC
EXTRN __System_Type_GetType_String:PROC
EXTRN __System_Type__ctor:PROC
EXTRN __System_RuntimeType__ctor_Int32_String_String_RuntimeType_TypeFlags:PROC
EXTRN __System_RuntimeType_get_Name:PROC
EXTRN __System_RuntimeType_get_Namespace:PROC
EXTRN __System_RuntimeType_get_FullName:PROC
EXTRN __System_RuntimeType_get_BaseType:PROC
EXTRN __System_RuntimeType_get_IsValueType:PROC
EXTRN __System_RuntimeType_get_IsClass:PROC
EXTRN __System_RuntimeType_get_IsInterface:PROC
EXTRN __System_RuntimeType_get_IsEnum:PROC
EXTRN __System_RuntimeType_get_IsArray:PROC
EXTRN __System_RuntimeType_GetType_String:PROC
EXTRN __System_ValueType_Equals_Object:PROC
EXTRN __System_ValueType_GetHashCode:PROC
EXTRN __System_ValueType_ToString:PROC
EXTRN __System_ValueType__ctor:PROC
EXTRN __System_Diagnostics_CodeAnalysis_SetsRequiredMembersAttribute__ctor:PROC
EXTRN __System_Runtime_InteropServices_OutAttribute__ctor:PROC
EXTRN __System_Runtime_InteropServices_InAttribute__ctor:PROC
EXTRN __System_Runtime_CompilerServices_CompilerGeneratedAttribute__ctor:PROC
EXTRN __System_Runtime_CompilerServices_CallerMemberNameAttribute__ctor:PROC
EXTRN __System_Runtime_CompilerServices_CallerFilePathAttribute__ctor:PROC
EXTRN __System_Runtime_CompilerServices_CallerLineNumberAttribute__ctor:PROC
EXTRN __System_Runtime_CompilerServices_RequiredMemberAttribute__ctor:PROC
EXTRN __System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_get_FeatureName:PROC
EXTRN __System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_get_IsOptional:PROC
EXTRN __System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute_set_IsOptional_Boolean:PROC
EXTRN __System_Runtime_CompilerServices_CompilerFeatureRequiredAttribute__ctor_String:PROC
EXTRN __System_Runtime_CompilerServices_NullableContextAttribute__ctor_Byte:PROC
EXTRN __System_Runtime_CompilerServices_NullableAttribute__ctor_Byte:PROC
EXTRN __System_Runtime_CompilerServices_NullableAttribute__ctor_Byte__:PROC
EXTRN __System_Reflection_DefaultMemberAttribute_get_MemberName:PROC
EXTRN __System_Reflection_DefaultMemberAttribute__ctor_String:PROC
EXTRN __Microsoft_CodeAnalysis_EmbeddedAttribute__ctor:PROC
EXTRN __System_Runtime_CompilerServices_RefSafetyRulesAttribute__ctor_Int32:PROC

; ============================================================
; DATA SECTION
; ============================================================
.DATA

    __crlf DB 13, 10, 0
    __null_string DD 0

    ; Static Fields
    __static_TypeFlags_None DD 0  ; TypeFlags.None
    __static_TypeFlags_ValueType DD 0  ; TypeFlags.ValueType
    __static_TypeFlags_Interface DD 0  ; TypeFlags.Interface
    __static_TypeFlags_Enum DD 0  ; TypeFlags.Enum
    __static_TypeFlags_Array DD 0  ; TypeFlags.Array


; ============================================================
; BSS SECTION (Uninitialized Data)
; ============================================================
.DATA?



.CODE

; ============================================================
; VTABLES
; ============================================================

; VTable for TypeFlags
__vtbl_TypeFlags:
    DD OFFSET __System_Enum_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Enum_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Enum_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for Point
__vtbl_Point:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for Program
__vtbl_Program:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize


; ============================================================
; METADATA TABLES
; ============================================================

; Metadata Header
__metadata_header:
    DD 080386E4Eh           ; Magic (0x80386NET)
    DW 1                    ; MajorVersion
    DW 0                    ; MinorVersion
    DD 0                    ; Flags
    DD 3       ; TypeCount
    DD 4     ; MethodCount
    DD 8      ; FieldCount
    DD 0                    ; PropertyCount
    DD OFFSET __metadata_types    ; TypeTableOffset
    DD OFFSET __metadata_methods  ; MethodTableOffset
    DD OFFSET __metadata_fields   ; FieldTableOffset
    DD OFFSET __string_heap       ; StringHeapOffset

; Type Definition Table
__metadata_types:
    ; Type: TypeFlags
    DD 0         ; NameOffset
    DD 10           ; NamespaceOffset
    DD 3   ; Flags
    DD 23      ; BaseTypeIndex
    DD 0         ; FieldListStart
    DD 6  ; FieldCount
    DD 0        ; MethodListStart
    DD 0 ; MethodCount
    DD 0  ; InstanceSize
    DD OFFSET __vtbl_TypeFlags ; VTableOffset
    ; Type: Point
    DD 11         ; NameOffset
    DD 10           ; NamespaceOffset
    DD 4096   ; Flags
    DD 37      ; BaseTypeIndex
    DD 6         ; FieldListStart
    DD 2  ; FieldCount
    DD 0        ; MethodListStart
    DD 2 ; MethodCount
    DD 12  ; InstanceSize
    DD OFFSET __vtbl_Point ; VTableOffset
    ; Type: Program
    DD 17         ; NameOffset
    DD 10           ; NamespaceOffset
    DD 4096   ; Flags
    DD 37      ; BaseTypeIndex
    DD 8         ; FieldListStart
    DD 0  ; FieldCount
    DD 2        ; MethodListStart
    DD 2 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_Program ; VTableOffset

; Method Definition Table
__metadata_methods:
    ; Method: Point..ctor
    DD 25         ; NameOffset
    DD 517 ; Flags
    DD 1 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 2 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __Point__ctor_Int32_Int32 ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Point.Sum
    DD 31         ; NameOffset
    DD 5 ; Flags
    DD 1 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __Point_Sum ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Program.Main
    DD 35         ; NameOffset
    DD 18 ; Flags
    DD 2 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 2     ; LocalCount
    DD OFFSET __Program_Main ; CodeOffset
    DW 65535 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Program..ctor
    DD 25         ; NameOffset
    DD 517 ; Flags
    DD 2 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __Program__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize

; Field Definition Table
__metadata_fields:
    ; Field: TypeFlags.value__
    DD 40         ; NameOffset
    DD 5  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.None
    DD 48         ; NameOffset
    DD 85  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.ValueType
    DD 53         ; NameOffset
    DD 85  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.Interface
    DD 63         ; NameOffset
    DD 85  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.Enum
    DD 73         ; NameOffset
    DD 85  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.Array
    DD 78         ; NameOffset
    DD 85  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Point.X
    DD 84         ; NameOffset
    DD 5  ; Flags
    DD 1 ; DeclaringTypeIndex
    DD 44     ; FieldTypeIndex
    DW 4       ; Offset
    DW 4         ; Size
    ; Field: Point.Y
    DD 86         ; NameOffset
    DD 5  ; Flags
    DD 1 ; DeclaringTypeIndex
    DD 44     ; FieldTypeIndex
    DW 8       ; Offset
    DW 4         ; Size

; String Heap
__string_heap:
    DB 'TypeFlags', 0
    DB 0
    DB 'Point', 0
    DB 'Program', 0
    DB '.ctor', 0
    DB 'Sum', 0
    DB 'Main', 0
    DB 'value__', 0
    DB 'None', 0
    DB 'ValueType', 0
    DB 'Interface', 0
    DB 'Enum', 0
    DB 'Array', 0
    DB 'X', 0
    DB 'Y', 0



; Void Point..ctor(Int32, Int32)
PUBLIC __Point__ctor_Int32_Int32
__Point__ctor_Int32_Int32 PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_Pointctor_Int32_Int32_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Object__ctor
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    POP EAX
    POP ESI
    MOV [ESI+4], EAX
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+16]
    POP EAX
    POP ESI
    MOV [ESI+8], EAX
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__Point__ctor_Int32_Int32 ENDP

; Int32 Point.Sum()
PUBLIC __Point_Sum
__Point_Sum PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_Point_Sum_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+8]
    POP EBX
    POP EAX
    ADD EAX, EBX
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_Point_Sum_0011
L_Point_Sum_0011:
    PUSH DWORD PTR [EBP-12]
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__Point_Sum ENDP

; Void Program.Main()
__Program_Main PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 8
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_Program_Main_0000:
    NOP
    PUSH 3
    PUSH 4
    ; newobj Point::.ctor
    MOV EAX, 12
    MOV EBX, 73
    CALL __gc_alloc_typed
    TEST EAX, EAX
    JZ __throw_out_of_memory
    MOV DWORD PTR [EAX], OFFSET __vtbl_Point
    PUSH EAX
    CALL __Point__ctor_Int32_Int32
    ADD ESP, 12
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    CALL __Point_Sum
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-16], EAX
    PUSH DWORD PTR [EBP-16]
    CALL __System_Console_WriteLine_Int32
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__Program_Main ENDP

; Void Program..ctor()
PUBLIC __Program__ctor
__Program__ctor PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_Programctor_0000:
    PUSH DWORD PTR [EBP+8]
    CALL __System_Object__ctor
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__Program__ctor ENDP


END __start
