; Check that reassoc without the full set of fast-math flags does not imply
; NotNaN/NotInf. icpx emits `reassoc nsz arcp contract afn` by default.

; RUN: llc -O0 -mtriple=spirv64-unknown-unknown %s -o - | FileCheck %s --check-prefix=CHECK-SPIRV
; RUN: llc -O0 -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_KHR_float_controls2 %s -o - | FileCheck %s --check-prefix=CHECK-FC2
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv64-unknown-unknown %s -o - -filetype=obj | spirv-val %}
; RUN: %if spirv-tools %{ llc -O0 -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_KHR_float_controls2 %s -o - -filetype=obj | spirv-val %}

; CHECK-SPIRV-NOT: FPFastMathMode
; CHECK-SPIRV: OpDecorate %[[#Partial:]] FPFastMathMode NSZ|AllowRecip{{$}}
; CHECK-SPIRV: OpDecorate %[[#Fast:]] FPFastMathMode NotNaN|NotInf|NSZ|AllowRecip|Fast
; CHECK-SPIRV-NOT: FPFastMathMode
; CHECK-SPIRV: OpFAdd
; CHECK-SPIRV: %[[#Partial]] = OpFMul
; CHECK-SPIRV: %[[#Fast]] = OpFSub

; CHECK-FC2-DAG: OpDecorate %[[#Reassoc:]] FPFastMathMode AllowContract|AllowReassoc|AllowTransform
; CHECK-FC2-DAG: OpDecorate %[[#Partial:]] FPFastMathMode NSZ|AllowRecip|AllowContract|AllowReassoc|AllowTransform
; CHECK-FC2-DAG: OpDecorate %[[#Fast:]] FPFastMathMode NotNaN|NotInf|NSZ|AllowRecip|AllowContract|AllowReassoc|AllowTransform
; CHECK-FC2: %[[#Reassoc]] = OpFAdd
; CHECK-FC2: %[[#Partial]] = OpFMul
; CHECK-FC2: %[[#Fast]] = OpFSub

define spir_kernel void @test(float %a, float %b, ptr addrspace(1) %out) {
entry:
  %add = fadd reassoc float %a, %b
  store float %add, ptr addrspace(1) %out
  %mul = fmul reassoc nsz arcp contract afn float %a, %b
  store float %mul, ptr addrspace(1) %out
  %sub = fsub fast float %a, %b
  store float %sub, ptr addrspace(1) %out
  ret void
}
