; RUN: not llc -O0 -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_KHR_bfloat16 %s -o %t.spvt 2>&1 | FileCheck %s --check-prefix=CHECK-ERROR

; RUN: llc -verify-machineinstrs -O0 -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_INTEL_16bit_atomics,+SPV_KHR_bfloat16 %s -o - | FileCheck %s

; CHECK-ERROR: LLVM ERROR: The atomic bfloat16 instruction requires the following SPIR-V extension: SPV_INTEL_16bit_atomics

; CHECK: Capability BFloat16TypeKHR
; CHECK: Capability AtomicBFloat16LoadStoreINTEL
; CHECK: Extension "SPV_KHR_bfloat16"
; CHECK: Extension "SPV_INTEL_16bit_atomics"
; CHECK-DAG: %[[TyBF16:[0-9]+]] = OpTypeFloat 16 0
; CHECK-DAG: %[[TyBF16Ptr:[0-9]+]] = OpTypePointer {{[a-zA-Z]+}} %[[TyBF16]]
; CHECK-DAG: %[[TyInt32:[0-9]+]] = OpTypeInt 32 0
; CHECK-DAG: %[[Value42:[0-9]+]] = OpConstant %[[TyBF16]] 16936{{$}}
; CHECK-DAG: %[[Const0:[0-9]+]] = OpConstantNull %[[TyBF16]]
; CHECK-DAG: %[[BF16Ptr:[0-9]+]] = OpVariable %[[TyBF16Ptr]] CrossWorkgroup %[[Const0]]
; CHECK-DAG: %[[Scope:[0-9]+]] = OpConstantNull %[[TyInt32]]
; CHECK-DAG: %[[MemSeqCst:[0-9]+]] = OpConstant %[[TyInt32]] 16{{$}}

; Test OpAtomicExchange
; CHECK: OpAtomicExchange %[[TyBF16]] %[[BF16Ptr]] %[[Scope]] %[[MemSeqCst]] %[[Value42]]


@val = common dso_local local_unnamed_addr addrspace(1) global bfloat 0.000000e+00, align 2

define dso_local spir_func void @test_atomic_bfloat16_load_store_xchg() local_unnamed_addr {
entry:
  ; Test atomic load
  %load = load atomic bfloat, ptr addrspace(1) @val seq_cst, align 2

  ; Test atomic store
  store atomic bfloat 42.000000e+00, ptr addrspace(1) @val seq_cst, align 2

  ; Test atomic exchange
  %xchg = atomicrmw xchg ptr addrspace(1) @val, bfloat 42.000000e+00 seq_cst

  ret void
}
