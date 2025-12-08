; This test verifies we correctly demangle real-life cooperative matrix usage
; into SPIR-V instructions.
; Test case reduced from intel/llvm/sycl/test-e2e/Matrix/joint_matrix_colA_rowB_colC.cpp

; RUN: llc -O0 -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_KHR_cooperative_matrix,+SPV_INTEL_joint_matrix %s -o %t.spvasm
; RUN: FileCheck < %t.spvasm %s

; CHECK-DAG: OpCapability CooperativeMatrixKHR
; CHECK-DAG: OpCapability CooperativeMatrixBFloat16ComponentTypeINTEL
; CHECK-DAG: OpCapability Int16
; CHECK-DAG: Extension "SPV_KHR_cooperative_matrix"
; CHECK-DAG: Extension "SPV_INTEL_joint_matrix"

; CHECK: %[[#Int16:]] = OpTypeInt 16 0
; CHECK: %[[#Int:]] = OpTypeInt 32 0
; CHECK: %[[#Const3:]] = OpConstant %[[#Int]] 3
; CHECK: %[[#Const8:]] = OpConstant %[[#Int]] 8
; CHECK: %[[#Const16:]] = OpConstant %[[#Int]] 16
; CHECK: %[[#Const0:]] = OpConstantNull %[[#Int]]
; CHECK: %[[#Matrix_Bfloat16_Scope3_8x16_Use0:]] = OpTypeCooperativeMatrixKHR %[[#Int16]] %[[#Const3]] %[[#Const8]] %[[#Const16]] %[[#Const0]]
; CHECK: %[[#Const1:]] = OpConstant %[[#Int]] 1
; CHECK: %[[#Matrix_Bfloat16_Scope3_16x16_Use1:]] = OpTypeCooperativeMatrixKHR %[[#Int16]] %[[#Const3]] %[[#Const16]] %[[#Const16]] %[[#Const1]]
; CHECK: %[[#Float:]] = OpTypeFloat 32
; CHECK: %[[#Const2:]] = OpConstant %[[#Int]] 2
; CHECK: %[[#Matrix_Float_Scope3_8x16_Use2:]] = OpTypeCooperativeMatrixKHR %[[#Float]] %[[#Const3]] %[[#Const8]] %[[#Const16]] %[[#Const2]]

; CHECK: %[[#MatrixA:]] = OpConstantNull %[[#Matrix_Bfloat16_Scope3_8x16_Use0]]
; CHECK: %[[#MatrixB:]] = OpConstantNull %[[#Matrix_Bfloat16_Scope3_16x16_Use1]]
; CHECK: %[[#MatrixC:]] = OpConstantNull %[[#Matrix_Float_Scope3_8x16_Use2]]

; CHECK: OpCooperativeMatrixLoadKHR %[[#Matrix_Bfloat16_Scope3_8x16_Use0]]
; CHECK: OpCooperativeMatrixLoadKHR %[[#Matrix_Bfloat16_Scope3_16x16_Use1]]
; CHECK: OpCooperativeMatrixMulAddKHR %[[#Matrix_Float_Scope3_8x16_Use2]] %[[#MatrixA]] %[[#MatrixB]] %[[#MatrixC]] MatrixAAndBBFloat16ComponentsINTEL
; CHECK: OpCooperativeMatrixStoreKHR %[[#]] %[[#MatrixC]] %[[#Const0]]

define spir_kernel void @matrix_multiply() {
entry:
  %call1.i = call spir_func target("spirv.CooperativeMatrixKHR", i16, 3, 8, 16, 0) @_Z32__spirv_CooperativeMatrixLoadKHRIU3AS1N4sycl3_V13ext6oneapi8bfloat16ES4_Lm8ELm16ELN5__spv9MatrixUseE0ELNS6_12MatrixLayoutE1ELNS6_5Scope4FlagE3EEPNS6_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEEPT_S8_mi(ptr addrspace(1) null, i32 0)
  %call1.i29 = call spir_func target("spirv.CooperativeMatrixKHR", i16, 3, 16, 16, 1) @_Z32__spirv_CooperativeMatrixLoadKHRIU3AS1N4sycl3_V13ext6oneapi8bfloat16ES4_Lm16ELm16ELN5__spv9MatrixUseE1ELNS6_12MatrixLayoutE0ELNS6_5Scope4FlagE3EEPNS6_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEEPT_S8_mi(ptr addrspace(1) null, i32 0)
  %call.i33 = tail call spir_func target("spirv.CooperativeMatrixKHR", float, 3, 8, 16, 2) @_Z34__spirv_CooperativeMatrixMulAddKHRIN4sycl3_V13ext6oneapi8bfloat16ES4_ffLm8ELm16ELm16ELN5__spv9MatrixUseE0ELS6_1ELS6_2ELNS5_12MatrixLayoutE0ELS7_0ELS7_0ELNS5_5Scope4FlagE3EEPNS5_28__spirv_CooperativeMatrixKHRIT2_XT12_EXT3_EXT5_EXT8_EEEPNSA_IT_XT12_EXT3_EXT4_EXT6_EEEPNSA_IT0_XT12_EXT4_EXT5_EXT7_EEEPNSA_IT1_XT12_EXT3_EXT5_EXT8_EEEm(target("spirv.CooperativeMatrixKHR", i16, 3, 8, 16, 0) zeroinitializer, target("spirv.CooperativeMatrixKHR", i16, 3, 16, 16, 1) zeroinitializer, target("spirv.CooperativeMatrixKHR", float, 3, 8, 16, 2) zeroinitializer, i64 64)
  call spir_func void @_Z33__spirv_CooperativeMatrixStoreKHRIU3AS1ffLm8ELm16ELN5__spv9MatrixUseE2ELNS1_12MatrixLayoutE3ELNS1_5Scope4FlagE3EEvPT_PNS1_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEES3_mi(ptr addrspace(1) null, target("spirv.CooperativeMatrixKHR", float, 3, 8, 16, 2) zeroinitializer, i32 0)
  ret void
}

declare spir_func target("spirv.CooperativeMatrixKHR", i16, 3, 8, 16, 0) @_Z32__spirv_CooperativeMatrixLoadKHRIU3AS1N4sycl3_V13ext6oneapi8bfloat16ES4_Lm8ELm16ELN5__spv9MatrixUseE0ELNS6_12MatrixLayoutE1ELNS6_5Scope4FlagE3EEPNS6_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEEPT_S8_mi(ptr addrspace(1), i32)

declare spir_func target("spirv.CooperativeMatrixKHR", i16, 3, 16, 16, 1) @_Z32__spirv_CooperativeMatrixLoadKHRIU3AS1N4sycl3_V13ext6oneapi8bfloat16ES4_Lm16ELm16ELN5__spv9MatrixUseE1ELNS6_12MatrixLayoutE0ELNS6_5Scope4FlagE3EEPNS6_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEEPT_S8_mi(ptr addrspace(1), i32)

declare spir_func target("spirv.CooperativeMatrixKHR", float, 3, 8, 16, 2) @_Z34__spirv_CooperativeMatrixMulAddKHRIN4sycl3_V13ext6oneapi8bfloat16ES4_ffLm8ELm16ELm16ELN5__spv9MatrixUseE0ELS6_1ELS6_2ELNS5_12MatrixLayoutE0ELS7_0ELS7_0ELNS5_5Scope4FlagE3EEPNS5_28__spirv_CooperativeMatrixKHRIT2_XT12_EXT3_EXT5_EXT8_EEEPNSA_IT_XT12_EXT3_EXT4_EXT6_EEEPNSA_IT0_XT12_EXT4_EXT5_EXT7_EEEPNSA_IT1_XT12_EXT3_EXT5_EXT8_EEEm(target("spirv.CooperativeMatrixKHR", i16, 3, 8, 16, 0), target("spirv.CooperativeMatrixKHR", i16, 3, 16, 16, 1), target("spirv.CooperativeMatrixKHR", float, 3, 8, 16, 2), i64)

declare spir_func void @_Z33__spirv_CooperativeMatrixStoreKHRIU3AS1ffLm8ELm16ELN5__spv9MatrixUseE2ELNS1_12MatrixLayoutE3ELNS1_5Scope4FlagE3EEvPT_PNS1_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEES3_mi(ptr addrspace(1), target("spirv.CooperativeMatrixKHR", float, 3, 8, 16, 2), i32)
