; RUN: llc -verify-machineinstrs -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_KHR_fma < %s | FileCheck --check-prefix=CHECK-SPIRV %s
; RUN: llc -verify-machineinstrs -mtriple=spirv64-unknown-unknown < %s | FileCheck --check-prefix=CHECK-SPIRV-NO-EXT %s
; TODO: Add spirv-val validation once the extension is supported.

; CHECK-SPIRV: OpCapability FmaKHR
; CHECK-SPIRV: OpExtension "SPV_KHR_fma"
; CHECK-SPIRV: OpTypeFloat [[#TYPE_FLOAT:]] 32
; CHECK-SPIRV: OpTypeVector [[#TYPE_VEC:]] [[#TYPE_FLOAT]] 4
; CHECK-SPIRV: OpFmaKHR [[#TYPE_FLOAT]] [[#]]
; CHECK-SPIRV: OpFmaKHR [[#TYPE_VEC]] [[#]]

; CHECK-SPIRV-NO-EXT-NOT: OpCapability FmaKHR
; CHECK-SPIRV-NO-EXT-NOT: OpExtension "SPV_KHR_fma"
; CHECK-SPIRV-NO-EXT: OpTypeFloat [[#TYPE_FLOAT:]] 32
; CHECK-SPIRV-NO-EXT: OpTypeVector [[#TYPE_VEC:]] [[#TYPE_FLOAT]] 4
; CHECK-SPIRV-NO-EXT: OpExtInst [[#TYPE_FLOAT]] [[#]] [[#]] fma
; CHECK-SPIRV-NO-EXT: OpExtInst [[#TYPE_VEC]] [[#]] [[#]] fma

target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir64-unknown-unknown"

define spir_func float @test_fma_scalar(float %a, float %b, float %c) {
entry:
  %result = call float @llvm.fma.f32(float %a, float %b, float %c)
  ret float %result
}

define spir_func <4 x float> @test_fma_vector(<4 x float> %a, <4 x float> %b, <4 x float> %c) {
entry:
  %result = call <4 x float> @llvm.fma.v4f32(<4 x float> %a, <4 x float> %b, <4 x float> %c)
  ret <4 x float> %result
}

declare float @llvm.fma.f32(float, float, float)
declare <4 x float> @llvm.fma.v4f32(<4 x float>, <4 x float>, <4 x float>)
