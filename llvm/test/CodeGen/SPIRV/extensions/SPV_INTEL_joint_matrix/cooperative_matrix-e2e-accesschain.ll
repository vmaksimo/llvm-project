; This test verifies we correctly demangle real-life cooperative matrix usage
; into SPIR-V instructions.
; Test case reduced from intel/llvm/sycl/test-e2e/Matrix/element_wise_abc.cpp

; RUN: llc -O0 -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_KHR_cooperative_matrix,+SPV_INTEL_joint_matrix %s -o %t.spvasm
; RUN: FileCheck < %t.spvasm %s

; CHECK-DAG: OpCapability CooperativeMatrixKHR
; CHECK-DAG: OpCapability PackedCooperativeMatrixINTEL
; CHECK-DAG: OpExtension "SPV_KHR_cooperative_matrix"
; CHECK-DAG: OpExtension "SPV_INTEL_joint_matrix"

; CHECK: OpName %[[#ArgAccA:]] "_arg_accA"
; CHECK: OpName %[[#ArgAccB:]] "_arg_accB"

; CHECK-DAG: %[[#Int8:]] = OpTypeInt 8 0
; CHECK-DAG: %[[#PtrCrossWG:]] = OpTypePointer CrossWorkgroup %[[#Int8]]
; CHECK-DAG: %[[#PtrGeneric:]] = OpTypePointer Generic %[[#Int8]]
; CHECK-DAG: %[[#Int64:]] = OpTypeInt 64 0
; CHECK-DAG: %[[#Int32:]] = OpTypeInt 32 0

; CHECK-DAG: %[[#Const3:]] = OpConstant %[[#Int32]] 3
; CHECK-DAG: %[[#Const8:]] = OpConstant %[[#Int32]] 8
; CHECK-DAG: %[[#Const32:]] = OpConstant %[[#Int32]] 32
; CHECK-DAG: %[[#Const0:]] = OpConstantNull %[[#Int32]]
; CHECK-DAG: %[[#Matrix_Int8_Scope3_8x32_Use0:]] = OpTypeCooperativeMatrixKHR %[[#Int8]] %[[#Const3]] %[[#Const8]] %[[#Const32]] %[[#Const0]]
; CHECK-DAG: %[[#Const1:]] = OpConstant %[[#Int32]] 1
; CHECK-DAG: %[[#Matrix_Int8_Scope3_32x8_Use1:]] = OpTypeCooperativeMatrixKHR %[[#Int8]] %[[#Const3]] %[[#Const32]] %[[#Const8]] %[[#Const1]]
; CHECK-DAG: %[[#Const2:]] = OpConstant %[[#Int32]] 2
; CHECK-DAG: %[[#Matrix_Int32_Scope3_8x8_Use2:]] = OpTypeCooperativeMatrixKHR %[[#Int32]] %[[#Const3]] %[[#Const8]] %[[#Const8]] %[[#Const2]]
; CHECK-DAG: %[[#ConstNull64:]] = OpConstantNull %[[#Int64]]
; CHECK-DAG: %[[#Const64_8:]] = OpConstant %[[#Int64]] 8
; CHECK-DAG: %[[#Const64_32:]] = OpConstant %[[#Int64]] 32

; First cooperative matrix load (8x32, Use0)
; CHECK: %[[#MatrixA:]] = OpCooperativeMatrixLoadKHR %[[#Matrix_Int8_Scope3_8x32_Use0]] %[[#ArgAccA]] %[[#Const0]] %[[#Const64_32]] 0
; CHECK: %[[#LengthA:]] = OpCooperativeMatrixLengthKHR %[[#Int64]] %[[#Matrix_Int8_Scope3_8x32_Use0]]

; Second cooperative matrix load (32x8, Use1)
; CHECK: %[[#MatrixB:]] = OpCooperativeMatrixLoadKHR %[[#Matrix_Int8_Scope3_32x8_Use1]] %[[#ArgAccA]] %[[#Const2]] %[[#Const64_32]] 0
; CHECK: %[[#LengthB:]] = OpCooperativeMatrixLengthKHR %[[#Int64]] %[[#Matrix_Int8_Scope3_32x8_Use1]]

; Third cooperative matrix load (8x8, Use2)
; CHECK: %[[#MatrixC:]] = OpCooperativeMatrixLoadKHR %[[#Matrix_Int32_Scope3_8x8_Use2]] %[[#ArgAccA]] %[[#Const0]] %[[#Const64_8]] 0
; CHECK: %[[#LengthC:]] = OpCooperativeMatrixLengthKHR %[[#Int64]] %[[#Matrix_Int32_Scope3_8x8_Use2]]

; CHECK: %[[#AC1:]] = OpAccessChain %[[#PtrGeneric]] %[[#]] %[[#ConstNull64]]
; CHECK: %[[#AC2:]] = OpAccessChain %[[#PtrGeneric]] %[[#]] %[[#ConstNull64]]

; CHECK: %[[#AC3:]] = OpAccessChain %[[#PtrGeneric]] %[[#]] %[[#ConstNull64]]
; CHECK: %[[#AC4:]] = OpAccessChain %[[#PtrGeneric]] %[[#]] %[[#ConstNull64]]

; CHECK: %[[#AC5:]] = OpAccessChain %[[#PtrGeneric]] %[[#]] %[[#ConstNull64]]
; CHECK: %[[#AC6:]] = OpAccessChain %[[#PtrGeneric]] %[[#]] %[[#ConstNull64]]

declare spir_func target("spirv.CooperativeMatrixKHR", i8, 3, 8, 32, 0) @_Z32__spirv_CooperativeMatrixLoadKHRIU3AS1aaLm8ELm32ELN5__spv9MatrixUseE0ELNS1_12MatrixLayoutE0ELNS1_5Scope4FlagE3EEPNS1_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEEPT_S3_mi(ptr addrspace(1), i32, i64, i32)

declare spir_func i64 @_Z34__spirv_CooperativeMatrixLengthKHRIaLm8ELm32ELN5__spv9MatrixUseE0ELNS0_12MatrixLayoutE0ELNS0_5Scope4FlagE3EEmPNS0_28__spirv_CooperativeMatrixKHRIT_XT4_EXT0_EXT1_EXT2_EEE(target("spirv.CooperativeMatrixKHR", i8, 3, 8, 32, 0))

declare spir_func ptr addrspace(4) @_Z19__spirv_AccessChainIaaLm8ELm32ELN5__spv9MatrixUseE0ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4), i64)

define spir_kernel void @_ZTS3addILm8ELm8ELm32ELi4EE(ptr addrspace(1) %_arg_accA, ptr %_arg_accA2, ptr %_arg_accA3, ptr addrspace(1) %_arg_accB, ptr %_arg_accB5, ptr %_arg_accB6, i64 %_arg_sg_size, ptr addrspace(1) %_arg_accC, ptr %_arg_accC8, ptr %_arg_accC9, ptr %sub_a.i, ptr addrspace(4) %0, ptr %sub_b.i, ptr addrspace(4) %1, ptr %sub_c.i, ptr addrspace(4) %2) {
entry:
  ; __spv::__spirv_CooperativeMatrixKHR<signed char, (__spv::Scope::Flag)3, 8ul, 32ul, (__spv::MatrixUse)0>* __spirv_CooperativeMatrixLoadKHR<signed char AS1, signed char, 8ul, 32ul, (__spv::MatrixUse)0, (__spv::MatrixLayout)0, (__spv::Scope::Flag)3>(signed char AS1*, __spv::MatrixLayout, unsigned long, int)
  %call2.i.i = tail call spir_func target("spirv.CooperativeMatrixKHR", i8, 3, 8, 32, 0) @_Z32__spirv_CooperativeMatrixLoadKHRIU3AS1aaLm8ELm32ELN5__spv9MatrixUseE0ELNS1_12MatrixLayoutE0ELNS1_5Scope4FlagE3EEPNS1_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEEPT_S3_mi(ptr addrspace(1) %_arg_accA, i32 0, i64 32, i32 0)
  br label %for.cond.i

for.cond.i:                                       ; preds = %for.body.i, %entry
  ; unsigned long __spirv_CooperativeMatrixLengthKHR<signed char, 8ul, 32ul, (__spv::MatrixUse)0, (__spv::MatrixLayout)0, (__spv::Scope::Flag)3>(__spv::__spirv_CooperativeMatrixKHR<signed char, (__spv::Scope::Flag)3, 8ul, 32ul, (__spv::MatrixUse)0>*)
  %call.i146 = call spir_func i64 @_Z34__spirv_CooperativeMatrixLengthKHRIaLm8ELm32ELN5__spv9MatrixUseE0ELNS0_12MatrixLayoutE0ELNS0_5Scope4FlagE3EEmPNS0_28__spirv_CooperativeMatrixKHRIT_XT4_EXT0_EXT1_EXT2_EEE(target("spirv.CooperativeMatrixKHR", i8, 3, 8, 32, 0) %call2.i.i)
  br i1 false, label %for.body.i, label %_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEaLNS4_3useE0ELm8ELm32ELNS4_6layoutE0EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRaE_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit

for.body.i:                                       ; preds = %for.cond.i
  ; signed char* __spirv_AccessChain<signed char, signed char, 8ul, 32ul, (__spv::MatrixUse)0, (__spv::Scope::Flag)3>(__spv::__spirv_CooperativeMatrixKHR<signed char, (__spv::Scope::Flag)3, 8ul, 32ul, (__spv::MatrixUse)0>**, unsigned long)
  %call.i = call spir_func ptr addrspace(4) @_Z19__spirv_AccessChainIaaLm8ELm32ELN5__spv9MatrixUseE0ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4) %0, i64 0)
  %call.i155 = call spir_func ptr addrspace(4) @_Z19__spirv_AccessChainIaaLm8ELm32ELN5__spv9MatrixUseE0ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4) %0, i64 0)
  br label %for.cond.i

_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEaLNS4_3useE0ELm8ELm32ELNS4_6layoutE0EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRaE_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit: ; preds = %for.cond.i
  ; __spv::__spirv_CooperativeMatrixKHR<signed char, (__spv::Scope::Flag)3, 32ul, 8ul, (__spv::MatrixUse)1>* __spirv_CooperativeMatrixLoadKHR<signed char AS1, signed char, 32ul, 8ul, (__spv::MatrixUse)1, (__spv::MatrixLayout)2, (__spv::Scope::Flag)3>(signed char AS1*, __spv::MatrixLayout, unsigned long, int)
  %call2.i32 = call spir_func target("spirv.CooperativeMatrixKHR", i8, 3, 32, 8, 1) @_Z32__spirv_CooperativeMatrixLoadKHRIU3AS1aaLm32ELm8ELN5__spv9MatrixUseE1ELNS1_12MatrixLayoutE2ELNS1_5Scope4FlagE3EEPNS1_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEEPT_S3_mi(ptr addrspace(1) %_arg_accA, i32 2, i64 32, i32 0)
  br label %for.cond.i43

for.cond.i43:                                     ; preds = %for.body.i48, %_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEaLNS4_3useE0ELm8ELm32ELNS4_6layoutE0EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRaE_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit
  ; unsigned long __spirv_CooperativeMatrixLengthKHR<signed char, 32ul, 8ul, (__spv::MatrixUse)1, (__spv::MatrixLayout)0, (__spv::Scope::Flag)3>(__spv::__spirv_CooperativeMatrixKHR<signed char, (__spv::Scope::Flag)3, 32ul, 8ul, (__spv::MatrixUse)1>*)
  %call.i173 = call spir_func i64 @_Z34__spirv_CooperativeMatrixLengthKHRIaLm32ELm8ELN5__spv9MatrixUseE1ELNS0_12MatrixLayoutE0ELNS0_5Scope4FlagE3EEmPNS0_28__spirv_CooperativeMatrixKHRIT_XT4_EXT0_EXT1_EXT2_EEE(target("spirv.CooperativeMatrixKHR", i8, 3, 32, 8, 1) %call2.i32)
  br i1 false, label %for.body.i48, label %_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEaLNS4_3useE1ELm32ELm8ELNS4_6layoutE2EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRaE0_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit

for.body.i48:                                     ; preds = %for.cond.i43
  ; signed char* __spirv_AccessChain<signed char, signed char, 32ul, 8ul, (__spv::MatrixUse)1, (__spv::Scope::Flag)3>(__spv::__spirv_CooperativeMatrixKHR<signed char, (__spv::Scope::Flag)3, 32ul, 8ul, (__spv::MatrixUse)1>**, unsigned long)
  %call.i180 = call spir_func ptr addrspace(4) @_Z19__spirv_AccessChainIaaLm32ELm8ELN5__spv9MatrixUseE1ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4) %0, i64 0)
  %call.i188 = call spir_func ptr addrspace(4) @_Z19__spirv_AccessChainIaaLm32ELm8ELN5__spv9MatrixUseE1ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4) %0, i64 0)
  br label %for.cond.i43

_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEaLNS4_3useE1ELm32ELm8ELNS4_6layoutE2EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRaE0_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit: ; preds = %for.cond.i43
  ; __spv::__spirv_CooperativeMatrixKHR<int, (__spv::Scope::Flag)3, 8ul, 8ul, (__spv::MatrixUse)2>* __spirv_CooperativeMatrixLoadKHR<int AS1, int, 8ul, 8ul, (__spv::MatrixUse)2, (__spv::MatrixLayout)3, (__spv::Scope::Flag)3>(int AS1*, __spv::MatrixLayout, unsigned long, int)
  %call3.i = call spir_func target("spirv.CooperativeMatrixKHR", i32, 3, 8, 8, 2) @_Z32__spirv_CooperativeMatrixLoadKHRIU3AS1iiLm8ELm8ELN5__spv9MatrixUseE2ELNS1_12MatrixLayoutE3ELNS1_5Scope4FlagE3EEPNS1_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEEPT_S3_mi(ptr addrspace(1) %_arg_accA, i32 0, i64 8, i32 0)
  br label %for.cond.i70

for.cond.i70:                                     ; preds = %for.cond.i70, %_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEaLNS4_3useE1ELm32ELm8ELNS4_6layoutE2EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRaE0_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit
  ; unsigned long __spirv_CooperativeMatrixLengthKHR<int, 8ul, 8ul, (__spv::MatrixUse)2, (__spv::MatrixLayout)0, (__spv::Scope::Flag)3>(__spv::__spirv_CooperativeMatrixKHR<int, (__spv::Scope::Flag)3, 8ul, 8ul, (__spv::MatrixUse)2>*)
  %call.i209 = call spir_func i64 @_Z34__spirv_CooperativeMatrixLengthKHRIiLm8ELm8ELN5__spv9MatrixUseE2ELNS0_12MatrixLayoutE0ELNS0_5Scope4FlagE3EEmPNS0_28__spirv_CooperativeMatrixKHRIT_XT4_EXT0_EXT1_EXT2_EEE(target("spirv.CooperativeMatrixKHR", i32, 3, 8, 8, 2) poison)
  %call.i216 = call spir_func ptr addrspace(4) @_Z19__spirv_AccessChainIiiLm8ELm8ELN5__spv9MatrixUseE2ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4) %0, i64 0)
  %call.i224 = call spir_func ptr addrspace(4) @_Z19__spirv_AccessChainIiiLm8ELm8ELN5__spv9MatrixUseE2ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4) %0, i64 0)
  br label %for.cond.i70
}

declare spir_func target("spirv.CooperativeMatrixKHR", i8, 3, 32, 8, 1) @_Z32__spirv_CooperativeMatrixLoadKHRIU3AS1aaLm32ELm8ELN5__spv9MatrixUseE1ELNS1_12MatrixLayoutE2ELNS1_5Scope4FlagE3EEPNS1_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEEPT_S3_mi(ptr addrspace(1), i32, i64, i32)

declare spir_func target("spirv.CooperativeMatrixKHR", i32, 3, 8, 8, 2) @_Z32__spirv_CooperativeMatrixLoadKHRIU3AS1iiLm8ELm8ELN5__spv9MatrixUseE2ELNS1_12MatrixLayoutE3ELNS1_5Scope4FlagE3EEPNS1_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEEPT_S3_mi(ptr addrspace(1), i32, i64, i32)

declare spir_func i64 @_Z34__spirv_CooperativeMatrixLengthKHRIaLm32ELm8ELN5__spv9MatrixUseE1ELNS0_12MatrixLayoutE0ELNS0_5Scope4FlagE3EEmPNS0_28__spirv_CooperativeMatrixKHRIT_XT4_EXT0_EXT1_EXT2_EEE(target("spirv.CooperativeMatrixKHR", i8, 3, 32, 8, 1))

declare spir_func i64 @_Z34__spirv_CooperativeMatrixLengthKHRIiLm8ELm8ELN5__spv9MatrixUseE2ELNS0_12MatrixLayoutE0ELNS0_5Scope4FlagE3EEmPNS0_28__spirv_CooperativeMatrixKHRIT_XT4_EXT0_EXT1_EXT2_EEE(target("spirv.CooperativeMatrixKHR", i32, 3, 8, 8, 2))

declare spir_func ptr addrspace(4) @_Z19__spirv_AccessChainIaaLm32ELm8ELN5__spv9MatrixUseE1ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4), i64)

declare spir_func ptr addrspace(4) @_Z19__spirv_AccessChainIiiLm8ELm8ELN5__spv9MatrixUseE2ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4), i64)
