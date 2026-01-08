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

    ; String Literals
    __str_0 DD 36
    __str_0_data DB 'Inheritance and Virtual Methods Test', 0
    __str_1 DD 3
    __str_1_data DB 'Rex', 0
    __str_2 DD 8
    __str_2_data DB 'Whiskers', 0
    __str_3 DD 5
    __str_3_data DB 'Buddy', 0
    __str_4 DD 26
    __str_4_data DB 'Testing ToString override:', 0
    __str_5 DD 3
    __str_5_data DB 'Max', 0
    __str_6 DD 8
    __str_6_data DB 'Animal: ', 0
    __str_7 DD 12
    __str_7_data DB ' says: Woof!', 0
    __str_8 DD 5
    __str_8_data DB 'Dog: ', 0
    __str_9 DD 12
    __str_9_data DB ' says: Meow!', 0

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

; VTable for Program
__vtbl_Program:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __System_Object_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize

; VTable for Animal
__vtbl_Animal:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __Animal_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __Animal_Speak  ; Slot 4: Speak

; VTable for Dog
__vtbl_Dog:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __Dog_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __Dog_Speak  ; Slot 4: Speak

; VTable for Cat
__vtbl_Cat:
    DD OFFSET __System_Object_Equals_Object  ; Slot 0: Equals
    DD OFFSET __System_Object_GetHashCode  ; Slot 1: GetHashCode
    DD OFFSET __Animal_ToString  ; Slot 2: ToString
    DD OFFSET __System_Object_Finalize  ; Slot 3: Finalize
    DD OFFSET __Cat_Speak  ; Slot 4: Speak


; ============================================================
; METADATA TABLES
; ============================================================

; Metadata Header
__metadata_header:
    DD 080386E4Eh           ; Magic (0x80386NET)
    DW 1                    ; MajorVersion
    DW 0                    ; MinorVersion
    DD 0                    ; Flags
    DD 5       ; TypeCount
    DD 10     ; MethodCount
    DD 7      ; FieldCount
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
    ; Type: Program
    DD 11         ; NameOffset
    DD 10           ; NamespaceOffset
    DD 4096   ; Flags
    DD 37      ; BaseTypeIndex
    DD 6         ; FieldListStart
    DD 0  ; FieldCount
    DD 0        ; MethodListStart
    DD 2 ; MethodCount
    DD 4  ; InstanceSize
    DD OFFSET __vtbl_Program ; VTableOffset
    ; Type: Animal
    DD 19         ; NameOffset
    DD 10           ; NamespaceOffset
    DD 4100   ; Flags
    DD 37      ; BaseTypeIndex
    DD 6         ; FieldListStart
    DD 1  ; FieldCount
    DD 2        ; MethodListStart
    DD 3 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_Animal ; VTableOffset
    ; Type: Dog
    DD 26         ; NameOffset
    DD 10           ; NamespaceOffset
    DD 4096   ; Flags
    DD 2      ; BaseTypeIndex
    DD 7         ; FieldListStart
    DD 0  ; FieldCount
    DD 5        ; MethodListStart
    DD 3 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_Dog ; VTableOffset
    ; Type: Cat
    DD 30         ; NameOffset
    DD 10           ; NamespaceOffset
    DD 4096   ; Flags
    DD 2      ; BaseTypeIndex
    DD 7         ; FieldListStart
    DD 0  ; FieldCount
    DD 8        ; MethodListStart
    DD 2 ; MethodCount
    DD 8  ; InstanceSize
    DD OFFSET __vtbl_Cat ; VTableOffset

; Method Definition Table
__metadata_methods:
    ; Method: Program.Main
    DD 34         ; NameOffset
    DD 18 ; Flags
    DD 1 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 4     ; LocalCount
    DD OFFSET __Program_Main ; CodeOffset
    DW 65535 ; VTableSlot
    DW 3    ; StackSize
    ; Method: Program..ctor
    DD 39         ; NameOffset
    DD 517 ; Flags
    DD 1 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __Program__ctor ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Animal..ctor
    DD 39         ; NameOffset
    DD 517 ; Flags
    DD 2 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __Animal__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Animal.Speak
    DD 45         ; NameOffset
    DD 357 ; Flags
    DD 2 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __Animal_Speak ; CodeOffset
    DW 4 ; VTableSlot
    DW 0    ; StackSize
    ; Method: Animal.ToString
    DD 51         ; NameOffset
    DD 37 ; Flags
    DD 2 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __Animal_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Dog..ctor
    DD 39         ; NameOffset
    DD 517 ; Flags
    DD 3 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __Dog__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Dog.Speak
    DD 45         ; NameOffset
    DD 37 ; Flags
    DD 3 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __Dog_Speak ; CodeOffset
    DW 4 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Dog.ToString
    DD 51         ; NameOffset
    DD 37 ; Flags
    DD 3 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 1     ; LocalCount
    DD OFFSET __Dog_ToString ; CodeOffset
    DW 2 ; VTableSlot
    DW 2    ; StackSize
    ; Method: Cat..ctor
    DD 39         ; NameOffset
    DD 517 ; Flags
    DD 4 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 1 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __Cat__ctor_String ; CodeOffset
    DW 65535 ; VTableSlot
    DW 8    ; StackSize
    ; Method: Cat.Speak
    DD 45         ; NameOffset
    DD 37 ; Flags
    DD 4 ; DeclaringTypeIndex
    DD 0                    ; SignatureOffset
    DW 0 ; ParamCount
    DW 0     ; LocalCount
    DD OFFSET __Cat_Speak ; CodeOffset
    DW 4 ; VTableSlot
    DW 8    ; StackSize

; Field Definition Table
__metadata_fields:
    ; Field: TypeFlags.value__
    DD 60         ; NameOffset
    DD 5  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.None
    DD 68         ; NameOffset
    DD 85  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.ValueType
    DD 73         ; NameOffset
    DD 85  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.Interface
    DD 83         ; NameOffset
    DD 85  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.Enum
    DD 93         ; NameOffset
    DD 85  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: TypeFlags.Array
    DD 98         ; NameOffset
    DD 85  ; Flags
    DD 0 ; DeclaringTypeIndex
    DD 0     ; FieldTypeIndex
    DW 0       ; Offset
    DW 0         ; Size
    ; Field: Animal._name
    DD 104         ; NameOffset
    DD 5  ; Flags
    DD 2 ; DeclaringTypeIndex
    DD 55     ; FieldTypeIndex
    DW 4       ; Offset
    DW 4         ; Size

; String Heap
__string_heap:
    DB 'TypeFlags', 0
    DB 0
    DB 'Program', 0
    DB 'Animal', 0
    DB 'Dog', 0
    DB 'Cat', 0
    DB 'Main', 0
    DB '.ctor', 0
    DB 'Speak', 0
    DB 'ToString', 0
    DB 'value__', 0
    DB 'None', 0
    DB 'ValueType', 0
    DB 'Interface', 0
    DB 'Enum', 0
    DB 'Array', 0
    DB '_name', 0



; Void Program.Main()
__Program_Main PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 16
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_Program_Main_0000:
    NOP
    PUSH OFFSET __str_0
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    PUSH 3
    POP ECX
    MOV EAX, ECX
    IMUL EAX, 4
    ADD EAX, 12
    PUSH ECX
    CALL __gc_alloc
    POP ECX
    TEST EAX, EAX
    JZ __throw_out_of_memory
    MOV DWORD PTR [EAX], OFFSET __vtbl_System_Array
    MOV [EAX+4], ECX
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    PUSH DWORD PTR [EBP-12]
    PUSH 0
    PUSH OFFSET __str_1
    ; newobj Dog::.ctor
    MOV EAX, 8
    MOV EBX, 75
    CALL __gc_alloc_typed
    TEST EAX, EAX
    JZ __throw_out_of_memory
    MOV DWORD PTR [EAX], OFFSET __vtbl_Dog
    PUSH EAX
    CALL __Dog__ctor_String
    ADD ESP, 8
    POP EBX
    POP ECX
    POP ESI
    LEA EAX, [ESI + ECX*4 + 8]
    MOV [EAX], EBX
    PUSH DWORD PTR [EBP-12]
    PUSH 1
    PUSH OFFSET __str_2
    ; newobj Cat::.ctor
    MOV EAX, 8
    MOV EBX, 76
    CALL __gc_alloc_typed
    TEST EAX, EAX
    JZ __throw_out_of_memory
    MOV DWORD PTR [EAX], OFFSET __vtbl_Cat
    PUSH EAX
    CALL __Cat__ctor_String
    ADD ESP, 8
    POP EBX
    POP ECX
    POP ESI
    LEA EAX, [ESI + ECX*4 + 8]
    MOV [EAX], EBX
    PUSH DWORD PTR [EBP-12]
    PUSH 2
    PUSH OFFSET __str_3
    ; newobj Dog::.ctor
    MOV EAX, 8
    MOV EBX, 75
    CALL __gc_alloc_typed
    TEST EAX, EAX
    JZ __throw_out_of_memory
    MOV DWORD PTR [EAX], OFFSET __vtbl_Dog
    PUSH EAX
    CALL __Dog__ctor_String
    ADD ESP, 8
    POP EBX
    POP ECX
    POP ESI
    LEA EAX, [ESI + ECX*4 + 8]
    MOV [EAX], EBX
    PUSH 0
    POP EAX
    MOV [EBP-20], EAX
    JMP L_Program_Main_004D
L_Program_Main_003E:
    NOP
    PUSH DWORD PTR [EBP-12]
    PUSH DWORD PTR [EBP-20]
    POP ECX
    POP ESI
    LEA EAX, [ESI + ECX*4 + 8]
    PUSH DWORD PTR [EAX]
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+16]
    ADD ESP, 4
    NOP
    NOP
    PUSH DWORD PTR [EBP-20]
    PUSH 1
    POP EBX
    POP EAX
    ADD EAX, EBX
    PUSH EAX
    POP EAX
    MOV [EBP-20], EAX
L_Program_Main_004D:
    PUSH DWORD PTR [EBP-20]
    PUSH 3
    POP EBX
    POP EAX
    CMP EAX, EBX
    SETL AL
    MOVZX EAX, AL
    PUSH EAX
    POP EAX
    MOV [EBP-24], EAX
    PUSH DWORD PTR [EBP-24]
    POP EAX
    TEST EAX, EAX
    JNZ L_Program_Main_003E
L_Program_Main_0055:
    PUSH OFFSET __str_4
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    PUSH OFFSET __str_5
    ; newobj Dog::.ctor
    MOV EAX, 8
    MOV EBX, 75
    CALL __gc_alloc_typed
    TEST EAX, EAX
    JZ __throw_out_of_memory
    MOV DWORD PTR [EAX], OFFSET __vtbl_Dog
    PUSH EAX
    CALL __Dog__ctor_String
    ADD ESP, 8
    POP EAX
    MOV [EBP-16], EAX
    PUSH DWORD PTR [EBP-16]
    MOV ESI, [ESP]
    MOV EAX, [ESI]
    CALL DWORD PTR [EAX+8]
    ADD ESP, 4
    PUSH EAX
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
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

; Void Animal..ctor(String)
PUBLIC __Animal__ctor_String
__Animal__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_Animalctor_String_0000:
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
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__Animal__ctor_String ENDP

; Void Animal.Speak()
PUBLIC __Animal_Speak
__Animal_Speak PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
    ; TODO: IL body not yet processed
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__Animal_Speak ENDP

; String Animal.ToString()
PUBLIC __Animal_ToString
__Animal_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_Animal_ToString_0000:
    NOP
    PUSH OFFSET __str_6
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    CALL __System_String_Concat_String_String
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_Animal_ToString_0014
L_Animal_ToString_0014:
    PUSH DWORD PTR [EBP-12]
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__Animal_ToString ENDP

; Void Dog..ctor(String)
PUBLIC __Dog__ctor_String
__Dog__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_Dogctor_String_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __Animal__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__Dog__ctor_String ENDP

; Void Dog.Speak()
PUBLIC __Dog_Speak
__Dog_Speak PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_Dog_Speak_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    PUSH OFFSET __str_7
    CALL __System_String_Concat_String_String
    ADD ESP, 8
    PUSH EAX
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__Dog_Speak ENDP

; String Dog.ToString()
PUBLIC __Dog_ToString
__Dog_ToString PROC
    PUSH EBP
    MOV EBP, ESP
    SUB ESP, 4
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_Dog_ToString_0000:
    NOP
    PUSH OFFSET __str_8
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    CALL __System_String_Concat_String_String
    ADD ESP, 8
    PUSH EAX
    POP EAX
    MOV [EBP-12], EAX
    JMP L_Dog_ToString_0014
L_Dog_ToString_0014:
    PUSH DWORD PTR [EBP-12]
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__Dog_ToString ENDP

; Void Cat..ctor(String)
PUBLIC __Cat__ctor_String
__Cat__ctor_String PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_Catctor_String_0000:
    PUSH DWORD PTR [EBP+8]
    PUSH DWORD PTR [EBP+12]
    CALL __Animal__ctor_String
    ADD ESP, 8
    NOP
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__Cat__ctor_String ENDP

; Void Cat.Speak()
PUBLIC __Cat_Speak
__Cat_Speak PROC
    PUSH EBP
    MOV EBP, ESP
    PUSH EBX
    PUSH ESI
    PUSH EDI
L_Cat_Speak_0000:
    NOP
    PUSH DWORD PTR [EBP+8]
    POP ESI
    PUSH DWORD PTR [ESI+4]
    PUSH OFFSET __str_9
    CALL __System_String_Concat_String_String
    ADD ESP, 8
    PUSH EAX
    CALL __System_Console_WriteLine_String
    ADD ESP, 4
    NOP
    POP EDI
    POP ESI
    POP EBX
    MOV ESP, EBP
    POP EBP
    RET
__Cat_Speak ENDP


END __start
