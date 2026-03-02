; RUN: not llc -O0 -mtriple=spirv64-unknown-unknown %s -o %t.spvt 2>&1 | FileCheck %s --check-prefix=CHECK-ERROR

; RUN: llc -verify-machineinstrs -O0 -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_INTEL_16bit_atomics %s -o - | FileCheck %s

; CHECK-ERROR: LLVM ERROR: 16-bit integer atomic operations require the following SPIR-V extension: SPV_INTEL_16bit_atomics

; CHECK: Capability Int16
; CHECK: Capability Int16AtomicsINTEL
; CHECK: Extension "SPV_INTEL_16bit_atomics"
; CHECK-DAG: %[[TyInt16:[0-9]+]] = OpTypeInt 16 0
; CHECK-DAG: %[[TyInt16Ptr:[0-9]+]] = OpTypePointer {{[a-zA-Z]+}} %[[TyInt16]]
; CHECK-DAG: %[[TyInt32:[0-9]+]] = OpTypeInt 32 0
; CHECK-DAG: %[[Value5:[0-9]+]] = OpConstant %[[TyInt16]] 5{{$}}
; CHECK-DAG: %[[Const0:[0-9]+]] = OpConstantNull %[[TyInt16]]
; CHECK-DAG: %[[Int16Ptr:[0-9]+]] = OpVariable %[[TyInt16Ptr]] CrossWorkgroup %[[Const0]]
; CHECK-DAG: %[[Scope:[0-9]+]] = OpConstantNull %[[TyInt32]]
; CHECK-DAG: %[[MemSeqCst:[0-9]+]] = OpConstant %[[TyInt32]] 16{{$}}

; Test OpAtomicIAdd
; CHECK: OpAtomicIAdd %[[TyInt16]] %[[Int16Ptr]] %[[Scope]] %[[MemSeqCst]] %[[Value5]]

; Test OpAtomicISub
; CHECK: OpAtomicISub %[[TyInt16]] %[[Int16Ptr]] %[[Scope]] %[[MemSeqCst]] %[[Value5]]

; Test OpAtomicUMin
; CHECK: OpAtomicUMin %[[TyInt16]] %[[Int16Ptr]] %[[Scope]] %[[MemSeqCst]] %[[Value5]]

; Test OpAtomicUMax
; CHECK: OpAtomicUMax %[[TyInt16]] %[[Int16Ptr]] %[[Scope]] %[[MemSeqCst]] %[[Value5]]

; Test OpAtomicSMin
; CHECK: OpAtomicSMin %[[TyInt16]] %[[Int16Ptr]] %[[Scope]] %[[MemSeqCst]] %[[Value5]]

; Test OpAtomicSMax
; CHECK: OpAtomicSMax %[[TyInt16]] %[[Int16Ptr]] %[[Scope]] %[[MemSeqCst]] %[[Value5]]

; Test OpAtomicAnd
; CHECK: OpAtomicAnd %[[TyInt16]] %[[Int16Ptr]] %[[Scope]] %[[MemSeqCst]] %[[Value5]]

; Test OpAtomicOr
; CHECK: OpAtomicOr %[[TyInt16]] %[[Int16Ptr]] %[[Scope]] %[[MemSeqCst]] %[[Value5]]

; Test OpAtomicXor
; CHECK: OpAtomicXor %[[TyInt16]] %[[Int16Ptr]] %[[Scope]] %[[MemSeqCst]] %[[Value5]]


@val = common dso_local local_unnamed_addr addrspace(1) global i16 0, align 2

define dso_local spir_func void @test_atomic_int16_arithmetic() local_unnamed_addr {
entry:
  ; Test atomic add
  %add = atomicrmw add ptr addrspace(1) @val, i16 5 seq_cst

  ; Test atomic sub
  %sub = atomicrmw sub ptr addrspace(1) @val, i16 5 seq_cst

  ; Test atomic umin
  %umin = atomicrmw umin ptr addrspace(1) @val, i16 5 seq_cst

  ; Test atomic umax
  %umax = atomicrmw umax ptr addrspace(1) @val, i16 5 seq_cst

  ; Test atomic smin
  %smin = atomicrmw min ptr addrspace(1) @val, i16 5 seq_cst

  ; Test atomic smax
  %smax = atomicrmw max ptr addrspace(1) @val, i16 5 seq_cst

  ; Test atomic and
  %and = atomicrmw and ptr addrspace(1) @val, i16 5 seq_cst

  ; Test atomic or
  %or = atomicrmw or ptr addrspace(1) @val, i16 5 seq_cst

  ; Test atomic xor
  %xor = atomicrmw xor ptr addrspace(1) @val, i16 5 seq_cst

  ret void
}
