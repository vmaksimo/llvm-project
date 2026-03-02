; RUN: not llc -O0 -mtriple=spirv64-unknown-unknown %s -o %t.spvt 2>&1 | FileCheck %s --check-prefix=CHECK-ERROR

; RUN: llc -verify-machineinstrs -O0 -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_INTEL_16bit_atomics %s -o - | FileCheck %s

; CHECK-ERROR: LLVM ERROR: 16-bit integer atomic operations require the following SPIR-V extension: SPV_INTEL_16bit_atomics

; CHECK: Capability Int16
; CHECK: Capability AtomicInt16CompareExchangeINTEL
; CHECK: Extension "SPV_INTEL_16bit_atomics"
; CHECK-DAG: %[[TyInt16:[0-9]+]] = OpTypeInt 16 0
; CHECK-DAG: %[[TyInt16Ptr:[0-9]+]] = OpTypePointer {{[a-zA-Z]+}} %[[TyInt16]]
; CHECK-DAG: %[[TyInt32:[0-9]+]] = OpTypeInt 32 0
; CHECK-DAG: %[[Value1:[0-9]+]] = OpConstant %[[TyInt16]] 1{{$}}
; CHECK-DAG: %[[Value42:[0-9]+]] = OpConstant %[[TyInt16]] 42{{$}}
; CHECK-DAG: %[[Const0:[0-9]+]] = OpConstantNull %[[TyInt16]]
; CHECK-DAG: %[[Int16Ptr:[0-9]+]] = OpVariable %[[TyInt16Ptr]] CrossWorkgroup %[[Const0]]
; CHECK-DAG: %[[Scope:[0-9]+]] = OpConstantNull %[[TyInt32]]
; CHECK-DAG: %[[MemSeqCst:[0-9]+]] = OpConstant %[[TyInt32]] 16{{$}}

; Test OpAtomicExchange
; CHECK: %[[XchgResult:[0-9]+]] = OpAtomicExchange %[[TyInt16]] %[[Int16Ptr]] %[[Scope]] %[[MemSeqCst]] %[[Value42]]

; Test OpAtomicCompareExchange
; CHECK: OpAtomicCompareExchange %[[TyInt16]] %{{[0-9]+}} %[[Scope]] %[[MemSeqCst]] %[[MemSeqCst]] %[[Value42]] %[[Value1]]


@val = common dso_local local_unnamed_addr addrspace(1) global i16 0, align 2

define dso_local spir_func void @test_atomic_int16_basic() local_unnamed_addr {
entry:
  ; Test atomic load
  %load = load atomic i16, ptr addrspace(1) @val seq_cst, align 2

  ; Test atomic store
  store atomic i16 42, ptr addrspace(1) @val seq_cst, align 2

  ; Test atomic exchange
  %xchg = atomicrmw xchg ptr addrspace(1) @val, i16 42 seq_cst

  ; Test atomic compare-exchange
  %cmpxchg = cmpxchg ptr addrspace(1) @val, i16 1, i16 42 seq_cst seq_cst

  ret void
}
