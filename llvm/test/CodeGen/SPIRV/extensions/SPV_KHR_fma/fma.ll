; RUN: llc -verify-machineinstrs -mtriple=spirv32-unknown-unknown --spirv-ext=+SPV_KHR_fma < %s | FileCheck --check-prefixes=CHECK,EXT %s
; RUN: llc -verify-machineinstrs -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_KHR_fma < %s | FileCheck --check-prefixes=CHECK,EXT %s
; RUN: llc -verify-machineinstrs -mtriple=spirv32-unknown-unknown < %s | FileCheck --check-prefixes=CHECK,NOEXT %s
; RUN: llc -verify-machineinstrs -mtriple=spirv64-unknown-unknown < %s | FileCheck --check-prefixes=CHECK,NOEXT %s

; EXT:      OpCapability FmaKHR
; EXT-NEXT: OpExtension "SPV_KHR_fma"
; NOEXT-NOT:  OpCapability FmaKHR
; NOEXT-NOT:  OpExtension "SPV_KHR_fma"

; EXT-DAG: %[[#extinst_id:]] = OpExtInstImport "OpenCL.std"
; NOEXT-DAG: %[[#extinst_id:]] = OpExtInstImport "OpenCL.std"

; CHECK: %[[#float_ty:]] = OpTypeFloat 32
; CHECK: %[[#double_ty:]] = OpTypeFloat 64

; EXT: OpFunction
; EXT: %[[#a:]] = OpFunctionParameter %[[#float_ty]]
; EXT: %[[#b:]] = OpFunctionParameter %[[#float_ty]]
; EXT: %[[#c:]] = OpFunctionParameter %[[#float_ty]]
; EXT: %[[#res:]] = OpFmaKHR %[[#float_ty]] %[[#a]] %[[#b]] %[[#c]]
; EXT: OpReturnValue %[[#res]]

; NOEXT: OpFunction
; NOEXT: %[[#a:]] = OpFunctionParameter %[[#float_ty]]
; NOEXT: %[[#b:]] = OpFunctionParameter %[[#float_ty]]
; NOEXT: %[[#c:]] = OpFunctionParameter %[[#float_ty]]
; NOEXT: %[[#res:]] = OpExtInst %[[#float_ty]] %[[#extinst_id]] fma %[[#a]] %[[#b]] %[[#c]]
; NOEXT: OpReturnValue %[[#res]]

define spir_func float @test_fma_f32(float %a, float %b, float %c) {
entry:
  %fma = call float @llvm.fma.f32(float %a, float %b, float %c)
  ret float %fma
}

; EXT: OpFunction
; EXT: %[[#a:]] = OpFunctionParameter %[[#double_ty]]
; EXT: %[[#b:]] = OpFunctionParameter %[[#double_ty]]
; EXT: %[[#c:]] = OpFunctionParameter %[[#double_ty]]
; EXT: %[[#res:]] = OpFmaKHR %[[#double_ty]] %[[#a]] %[[#b]] %[[#c]]
; EXT: OpReturnValue %[[#res]]

; NOEXT: OpFunction
; NOEXT: %[[#a:]] = OpFunctionParameter %[[#double_ty]]
; NOEXT: %[[#b:]] = OpFunctionParameter %[[#double_ty]]
; NOEXT: %[[#c:]] = OpFunctionParameter %[[#double_ty]]
; NOEXT: %[[#res:]] = OpExtInst %[[#double_ty]] %[[#extinst_id]] fma %[[#a]] %[[#b]] %[[#c]]
; NOEXT: OpReturnValue %[[#res]]

define spir_func double @test_fma_f64(double %a, double %b, double %c) {
entry:
  %fma = call double @llvm.fma.f64(double %a, double %b, double %c)
  ret double %fma
}

declare float @llvm.fma.f32(float, float, float)
declare double @llvm.fma.f64(double, double, double)
