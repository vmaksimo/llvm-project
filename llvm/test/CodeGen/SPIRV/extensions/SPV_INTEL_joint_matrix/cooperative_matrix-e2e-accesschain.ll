; This test verifies we correctly demangle real-life cooperative matrix usage
; into SPIR-V instructions.
; Test case reduced from intel/llvm/sycl/test-e2e/Matrix/element_wise_abc.cpp

; RUN: llc -O0 -mtriple=spirv64-unknown-unknown --spirv-ext=+SPV_KHR_cooperative_matrix,+SPV_INTEL_joint_matrix %s -o %t.spvasm
; RUN: FileCheck < %t.spvasm %s

; CHECK-DAG: OpCapability CooperativeMatrixKHR
; CHECK-DAG: OpCapability PackedCooperativeMatrixINTEL
; CHECK-DAG: Extension "SPV_KHR_cooperative_matrix"
; CHECK-DAG: Extension "SPV_INTEL_joint_matrix"

; CHECK: OpCooperativeMatrixLoadKHR
; CHECK: OpCooperativeMatrixLengthKHR
; CHECK: OpCooperativeMatrixLoadKHR
; CHECK: OpCooperativeMatrixLengthKHR

%"class.sycl::_V1::range" = type { %"class.sycl::_V1::detail::array" }
%"class.sycl::_V1::detail::array" = type { [2 x i64] }
%"struct.sycl::_V1::ext::oneapi::experimental::matrix::joint_matrix.24" = type { target("spirv.CooperativeMatrixKHR", i8, 3, 8, 32, 0) }
%"struct.sycl::_V1::ext::oneapi::experimental::matrix::joint_matrix.40" = type { target("spirv.CooperativeMatrixKHR", i8, 3, 32, 8, 1) }
%"struct.sycl::_V1::ext::oneapi::experimental::matrix::joint_matrix.41" = type { target("spirv.CooperativeMatrixKHR", i32, 3, 8, 8, 2) }

$_ZTS3addILm8ELm8ELm32ELi4EE = comdat any

@__spirv_BuiltInGlobalInvocationId = external dso_local local_unnamed_addr addrspace(1) constant <3 x i64>, align 32
@__spirv_BuiltInLocalInvocationId = external dso_local local_unnamed_addr addrspace(1) constant <3 x i64>, align 32

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #0

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: convergent nounwind
declare dso_local spir_func noundef target("spirv.CooperativeMatrixKHR", i8, 3, 8, 32, 0) @_Z32__spirv_CooperativeMatrixLoadKHRIU3AS1aaLm8ELm32ELN5__spv9MatrixUseE0ELNS1_12MatrixLayoutE0ELNS1_5Scope4FlagE3EEPNS1_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEEPT_S3_mi(ptr addrspace(1) noundef, i32 noundef, i64 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: convergent nounwind
declare dso_local spir_func noundef i64 @_Z34__spirv_CooperativeMatrixLengthKHRIaLm8ELm32ELN5__spv9MatrixUseE0ELNS0_12MatrixLayoutE0ELNS0_5Scope4FlagE3EEmPNS0_28__spirv_CooperativeMatrixKHRIT_XT4_EXT0_EXT1_EXT2_EEE(target("spirv.CooperativeMatrixKHR", i8, 3, 8, 32, 0) noundef) local_unnamed_addr #2

; Function Attrs: convergent nounwind
declare dso_local spir_func noundef ptr addrspace(4) @_Z19__spirv_AccessChainIaaLm8ELm32ELN5__spv9MatrixUseE0ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4) noundef, i64 noundef) local_unnamed_addr #2

; Function Attrs: convergent mustprogress norecurse nounwind
define weak_odr dso_local spir_kernel void @_ZTS3addILm8ELm8ELm32ELi4EE(ptr addrspace(1) noundef align 1 %_arg_accA, ptr noundef byval(%"class.sycl::_V1::range") align 8 %_arg_accA2, ptr noundef byval(%"class.sycl::_V1::range") align 8 %_arg_accA3, ptr addrspace(1) noundef align 1 %_arg_accB, ptr noundef byval(%"class.sycl::_V1::range") align 8 %_arg_accB5, ptr noundef byval(%"class.sycl::_V1::range") align 8 %_arg_accB6, i64 noundef %_arg_sg_size, ptr addrspace(1) noundef align 4 %_arg_accC, ptr noundef byval(%"class.sycl::_V1::range") align 8 %_arg_accC8, ptr noundef byval(%"class.sycl::_V1::range") align 8 %_arg_accC9) local_unnamed_addr #3 comdat !kernel_arg_buffer_location !7 !kernel_arg_runtime_aligned !8 !kernel_arg_exclusive_ptr !8 !sycl_fixed_targets !9 !sycl_joint_matrix !10 !sycl_kernel_omit_args !11 {
entry:
  %sub_a.i = alloca target("spirv.CooperativeMatrixKHR", i8, 3, 8, 32, 0), align 8
  %sub_b.i = alloca target("spirv.CooperativeMatrixKHR", i8, 3, 32, 8, 1), align 8
  %sub_c.i = alloca target("spirv.CooperativeMatrixKHR", i32, 3, 8, 8, 2), align 8
  %agg.tmp11.sroa.0.sroa.2.0._arg_accA2.ascast.sroa_idx = getelementptr inbounds i64, ptr %_arg_accA2, i64 1
  %agg.tmp11.sroa.0.sroa.2.0.copyload = load i64, ptr %agg.tmp11.sroa.0.sroa.2.0._arg_accA2.ascast.sroa_idx, align 8
  %agg.tmp12.sroa.0.sroa.0.0.copyload = load i64, ptr %_arg_accA3, align 8
  %agg.tmp12.sroa.0.sroa.2.0._arg_accA3.ascast.sroa_idx = getelementptr inbounds i64, ptr %_arg_accA3, i64 1
  %agg.tmp12.sroa.0.sroa.2.0.copyload = load i64, ptr %agg.tmp12.sroa.0.sroa.2.0._arg_accA3.ascast.sroa_idx, align 8
  %mul.i7.i.i.i.i = mul i64 %agg.tmp12.sroa.0.sroa.0.0.copyload, %agg.tmp11.sroa.0.sroa.2.0.copyload
  %0 = getelementptr i8, ptr addrspace(1) %_arg_accA, i64 %mul.i7.i.i.i.i
  %add.ptr.i = getelementptr i8, ptr addrspace(1) %0, i64 %agg.tmp12.sroa.0.sroa.2.0.copyload
  %agg.tmp15.sroa.0.sroa.2.0._arg_accB5.ascast.sroa_idx = getelementptr inbounds i64, ptr %_arg_accB5, i64 1
  %agg.tmp15.sroa.0.sroa.2.0.copyload = load i64, ptr %agg.tmp15.sroa.0.sroa.2.0._arg_accB5.ascast.sroa_idx, align 8
  %agg.tmp16.sroa.0.sroa.0.0.copyload = load i64, ptr %_arg_accB6, align 8
  %agg.tmp16.sroa.0.sroa.2.0._arg_accB6.ascast.sroa_idx = getelementptr inbounds i64, ptr %_arg_accB6, i64 1
  %agg.tmp16.sroa.0.sroa.2.0.copyload = load i64, ptr %agg.tmp16.sroa.0.sroa.2.0._arg_accB6.ascast.sroa_idx, align 8
  %mul.i7.i.i.i.i109 = mul i64 %agg.tmp16.sroa.0.sroa.0.0.copyload, %agg.tmp15.sroa.0.sroa.2.0.copyload
  %1 = getelementptr i8, ptr addrspace(1) %_arg_accB, i64 %mul.i7.i.i.i.i109
  %add.ptr.i110 = getelementptr i8, ptr addrspace(1) %1, i64 %agg.tmp16.sroa.0.sroa.2.0.copyload
  %agg.tmp19.sroa.0.sroa.2.0._arg_accC8.ascast.sroa_idx = getelementptr inbounds i64, ptr %_arg_accC8, i64 1
  %agg.tmp19.sroa.0.sroa.2.0.copyload = load i64, ptr %agg.tmp19.sroa.0.sroa.2.0._arg_accC8.ascast.sroa_idx, align 8
  %agg.tmp20.sroa.0.sroa.0.0.copyload = load i64, ptr %_arg_accC9, align 8
  %agg.tmp20.sroa.0.sroa.2.0._arg_accC9.ascast.sroa_idx = getelementptr inbounds i64, ptr %_arg_accC9, i64 1
  %agg.tmp20.sroa.0.sroa.2.0.copyload = load i64, ptr %agg.tmp20.sroa.0.sroa.2.0._arg_accC9.ascast.sroa_idx, align 8
  %mul.i7.i.i.i.i129 = mul i64 %agg.tmp20.sroa.0.sroa.0.0.copyload, %agg.tmp19.sroa.0.sroa.2.0.copyload
  %2 = getelementptr i32, ptr addrspace(1) %_arg_accC, i64 %mul.i7.i.i.i.i129
  %add.ptr.i130 = getelementptr i32, ptr addrspace(1) %2, i64 %agg.tmp20.sroa.0.sroa.2.0.copyload
  %3 = load i64, ptr addrspace(1) getelementptr inbounds (i8, ptr addrspace(1) @__spirv_BuiltInGlobalInvocationId, i64 8), align 8, !noalias !12
  %cmp.i33.i = icmp ult i64 %3, 2147483648
  tail call void @llvm.assume(i1 %cmp.i33.i)
  %4 = load i64, ptr addrspace(1) @__spirv_BuiltInGlobalInvocationId, align 32, !noalias !19
  %cmp.i.i = icmp ult i64 %4, 2147483648
  tail call void @llvm.assume(i1 %cmp.i.i)
  %5 = load i64, ptr addrspace(1) getelementptr inbounds (i8, ptr addrspace(1) @__spirv_BuiltInLocalInvocationId, i64 8), align 8, !noalias !26
  %cmp.i41.i = icmp ult i64 %5, 2147483648
  tail call void @llvm.assume(i1 %cmp.i41.i)
  %sub.i = sub nsw i64 %3, %5
  %6 = load i64, ptr addrspace(1) @__spirv_BuiltInLocalInvocationId, align 32, !noalias !33
  %cmp.i37.i = icmp ult i64 %6, 2147483648
  tail call void @llvm.assume(i1 %cmp.i37.i)
  %sub5.i = sub nsw i64 %4, %6
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %sub_a.i) #4
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %sub_b.i) #4
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %sub_c.i) #4
  %add.i9.i.i.i.i.i = add i64 %mul.i7.i.i.i.i, %agg.tmp12.sroa.0.sroa.2.0.copyload
  %idx.neg.i.i = sub i64 0, %add.i9.i.i.i.i.i
  %add.ptr.i.i = getelementptr inbounds i8, ptr addrspace(1) %add.ptr.i, i64 %idx.neg.i.i
  %mul7.i = shl nsw i64 %sub.i, 8
  %add.ptr.i141 = getelementptr inbounds i8, ptr addrspace(1) %add.ptr.i.i, i64 %mul7.i
  %call2.i.i = tail call spir_func noundef target("spirv.CooperativeMatrixKHR", i8, 3, 8, 32, 0) @_Z32__spirv_CooperativeMatrixLoadKHRIU3AS1aaLm8ELm32ELN5__spv9MatrixUseE0ELNS1_12MatrixLayoutE0ELNS1_5Scope4FlagE3EEPNS1_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEEPT_S3_mi(ptr addrspace(1) noundef %add.ptr.i141, i32 noundef 0, i64 noundef 32, i32 noundef 0) #5
  %spvm.i.i = getelementptr inbounds %"struct.sycl::_V1::ext::oneapi::experimental::matrix::joint_matrix.24", ptr %sub_a.i, i64 0, i32 0
  %7 = addrspacecast ptr %spvm.i.i to ptr addrspace(4)
  %8 = addrspacecast ptr %spvm.i.i to ptr addrspace(4)
  store target("spirv.CooperativeMatrixKHR", i8, 3, 8, 32, 0) %call2.i.i, ptr %spvm.i.i, align 8, !tbaa !40
  br label %for.cond.i

for.cond.i:                                       ; preds = %for.body.i, %entry
  %9 = phi target("spirv.CooperativeMatrixKHR", i8, 3, 8, 32, 0) [ %call2.i.i, %entry ], [ %.pre, %for.body.i ]
  %i.0.i = phi i32 [ 0, %entry ], [ %inc.i, %for.body.i ]
  %conv.i = sext i32 %i.0.i to i64
  %call.i146 = call spir_func noundef i64 @_Z34__spirv_CooperativeMatrixLengthKHRIaLm8ELm32ELN5__spv9MatrixUseE0ELNS0_12MatrixLayoutE0ELNS0_5Scope4FlagE3EEmPNS0_28__spirv_CooperativeMatrixKHRIT_XT4_EXT0_EXT1_EXT2_EEE(target("spirv.CooperativeMatrixKHR", i8, 3, 8, 32, 0) noundef %9) #5
  %cmp.i = icmp ugt i64 %call.i146, %conv.i
  br i1 %cmp.i, label %for.body.i, label %_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEaLNS4_3useE0ELm8ELm32ELNS4_6layoutE0EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRaE_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit

for.body.i:                                       ; preds = %for.cond.i
  %call.i = call spir_func noundef ptr addrspace(4) @_Z19__spirv_AccessChainIaaLm8ELm32ELN5__spv9MatrixUseE0ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4) noundef %7, i64 noundef %conv.i) #5
  %10 = load i8, ptr addrspace(4) %call.i, align 1, !tbaa !46
  %add.i = add i8 %10, 1
  %call.i155 = call spir_func noundef ptr addrspace(4) @_Z19__spirv_AccessChainIaaLm8ELm32ELN5__spv9MatrixUseE0ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4) noundef %8, i64 noundef %conv.i) #5
  store i8 %add.i, ptr addrspace(4) %call.i155, align 1, !tbaa !46
  %inc.i = add nuw nsw i32 %i.0.i, 1
  %.pre = load target("spirv.CooperativeMatrixKHR", i8, 3, 8, 32, 0), ptr %spvm.i.i, align 8, !tbaa !40
  br label %for.cond.i, !llvm.loop !47

_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEaLNS4_3useE0ELm8ELm32ELNS4_6layoutE0EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRaE_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit: ; preds = %for.cond.i
  %add.i9.i.i.i.i.i160 = add i64 %mul.i7.i.i.i.i109, %agg.tmp16.sroa.0.sroa.2.0.copyload
  %idx.neg.i.i161 = sub i64 0, %add.i9.i.i.i.i.i160
  %add.ptr.i.i162 = getelementptr inbounds i8, ptr addrspace(1) %add.ptr.i110, i64 %idx.neg.i.i161
  %div.i = udiv i64 %sub5.i, %_arg_sg_size
  %mul14.i = shl i64 %div.i, 5
  %add.ptr.i165 = getelementptr inbounds i8, ptr addrspace(1) %add.ptr.i.i162, i64 %mul14.i
  %call2.i32 = call spir_func noundef target("spirv.CooperativeMatrixKHR", i8, 3, 32, 8, 1) @_Z32__spirv_CooperativeMatrixLoadKHRIU3AS1aaLm32ELm8ELN5__spv9MatrixUseE1ELNS1_12MatrixLayoutE2ELNS1_5Scope4FlagE3EEPNS1_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEEPT_S3_mi(ptr addrspace(1) noundef %add.ptr.i165, i32 noundef 2, i64 noundef 32, i32 noundef 0) #5
  %spvm.i = getelementptr inbounds %"struct.sycl::_V1::ext::oneapi::experimental::matrix::joint_matrix.40", ptr %sub_b.i, i64 0, i32 0
  %11 = addrspacecast ptr %spvm.i to ptr addrspace(4)
  %12 = addrspacecast ptr %spvm.i to ptr addrspace(4)
  store target("spirv.CooperativeMatrixKHR", i8, 3, 32, 8, 1) %call2.i32, ptr %spvm.i, align 8, !tbaa !49
  br label %for.cond.i43

for.cond.i43:                                     ; preds = %for.body.i48, %_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEaLNS4_3useE0ELm8ELm32ELNS4_6layoutE0EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRaE_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit
  %13 = phi target("spirv.CooperativeMatrixKHR", i8, 3, 32, 8, 1) [ %call2.i32, %_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEaLNS4_3useE0ELm8ELm32ELNS4_6layoutE0EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRaE_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit ], [ %.pre235, %for.body.i48 ]
  %i.0.i44 = phi i32 [ 0, %_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEaLNS4_3useE0ELm8ELm32ELNS4_6layoutE0EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRaE_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit ], [ %inc.i51, %for.body.i48 ]
  %conv.i45 = sext i32 %i.0.i44 to i64
  %call.i173 = call spir_func noundef i64 @_Z34__spirv_CooperativeMatrixLengthKHRIaLm32ELm8ELN5__spv9MatrixUseE1ELNS0_12MatrixLayoutE0ELNS0_5Scope4FlagE3EEmPNS0_28__spirv_CooperativeMatrixKHRIT_XT4_EXT0_EXT1_EXT2_EEE(target("spirv.CooperativeMatrixKHR", i8, 3, 32, 8, 1) noundef %13) #5
  %cmp.i47 = icmp ugt i64 %call.i173, %conv.i45
  br i1 %cmp.i47, label %for.body.i48, label %_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEaLNS4_3useE1ELm32ELm8ELNS4_6layoutE2EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRaE0_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit

for.body.i48:                                     ; preds = %for.cond.i43
  %call.i180 = call spir_func noundef ptr addrspace(4) @_Z19__spirv_AccessChainIaaLm32ELm8ELN5__spv9MatrixUseE1ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4) noundef %11, i64 noundef %conv.i45) #5
  %14 = load i8, ptr addrspace(4) %call.i180, align 1, !tbaa !46
  %add.i181 = add i8 %14, 1
  %call.i188 = call spir_func noundef ptr addrspace(4) @_Z19__spirv_AccessChainIaaLm32ELm8ELN5__spv9MatrixUseE1ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4) noundef %12, i64 noundef %conv.i45) #5
  store i8 %add.i181, ptr addrspace(4) %call.i188, align 1, !tbaa !46
  %inc.i51 = add nuw nsw i32 %i.0.i44, 1
  %.pre235 = load target("spirv.CooperativeMatrixKHR", i8, 3, 32, 8, 1), ptr %spvm.i, align 8, !tbaa !49
  br label %for.cond.i43, !llvm.loop !52

_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEaLNS4_3useE1ELm32ELm8ELNS4_6layoutE2EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRaE0_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit: ; preds = %for.cond.i43
  %add.i9.i.i.i.i.i193 = add i64 %mul.i7.i.i.i.i129, %agg.tmp20.sroa.0.sroa.2.0.copyload
  %idx.neg.i.i194 = sub i64 0, %add.i9.i.i.i.i.i193
  %add.ptr.i.i195 = getelementptr inbounds i32, ptr addrspace(1) %add.ptr.i130, i64 %idx.neg.i.i194
  %mul22.i = shl nsw i64 %sub.i, 6
  %add.ptr.i198 = getelementptr inbounds i32, ptr addrspace(1) %add.ptr.i.i195, i64 %mul22.i
  %mul25.i = shl i64 %div.i, 3
  %add.ptr.i201 = getelementptr inbounds i32, ptr addrspace(1) %add.ptr.i198, i64 %mul25.i
  %call3.i = call spir_func noundef target("spirv.CooperativeMatrixKHR", i32, 3, 8, 8, 2) @_Z32__spirv_CooperativeMatrixLoadKHRIU3AS1iiLm8ELm8ELN5__spv9MatrixUseE2ELNS1_12MatrixLayoutE3ELNS1_5Scope4FlagE3EEPNS1_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEEPT_S3_mi(ptr addrspace(1) noundef %add.ptr.i201, i32 noundef 0, i64 noundef 8, i32 noundef 0) #5
  %spvm.i59 = getelementptr inbounds %"struct.sycl::_V1::ext::oneapi::experimental::matrix::joint_matrix.41", ptr %sub_c.i, i64 0, i32 0
  %15 = addrspacecast ptr %spvm.i59 to ptr addrspace(4)
  %16 = addrspacecast ptr %spvm.i59 to ptr addrspace(4)
  store target("spirv.CooperativeMatrixKHR", i32, 3, 8, 8, 2) %call3.i, ptr %spvm.i59, align 8, !tbaa !53
  br label %for.cond.i70

for.cond.i70:                                     ; preds = %for.body.i75, %_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEaLNS4_3useE1ELm32ELm8ELNS4_6layoutE2EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRaE0_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit
  %17 = phi target("spirv.CooperativeMatrixKHR", i32, 3, 8, 8, 2) [ %call3.i, %_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEaLNS4_3useE1ELm32ELm8ELNS4_6layoutE2EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRaE0_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit ], [ %.pre236, %for.body.i75 ]
  %i.0.i71 = phi i32 [ 0, %_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEaLNS4_3useE1ELm32ELm8ELNS4_6layoutE2EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRaE0_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit ], [ %inc.i78, %for.body.i75 ]
  %conv.i72 = sext i32 %i.0.i71 to i64
  %call.i209 = call spir_func noundef i64 @_Z34__spirv_CooperativeMatrixLengthKHRIiLm8ELm8ELN5__spv9MatrixUseE2ELNS0_12MatrixLayoutE0ELNS0_5Scope4FlagE3EEmPNS0_28__spirv_CooperativeMatrixKHRIT_XT4_EXT0_EXT1_EXT2_EEE(target("spirv.CooperativeMatrixKHR", i32, 3, 8, 8, 2) noundef %17) #5
  %cmp.i74 = icmp ugt i64 %call.i209, %conv.i72
  br i1 %cmp.i74, label %for.body.i75, label %_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEiLNS4_3useE2ELm8ELm8ELNS4_6layoutE3EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRiE_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit

for.body.i75:                                     ; preds = %for.cond.i70
  %call.i216 = call spir_func noundef ptr addrspace(4) @_Z19__spirv_AccessChainIiiLm8ELm8ELN5__spv9MatrixUseE2ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4) noundef %15, i64 noundef %conv.i72) #5
  %18 = load i32, ptr addrspace(4) %call.i216, align 4, !tbaa !56
  %add.i217 = add nsw i32 %18, 1
  %call.i224 = call spir_func noundef ptr addrspace(4) @_Z19__spirv_AccessChainIiiLm8ELm8ELN5__spv9MatrixUseE2ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4) noundef %16, i64 noundef %conv.i72) #5
  store i32 %add.i217, ptr addrspace(4) %call.i224, align 4, !tbaa !56
  %inc.i78 = add nuw nsw i32 %i.0.i71, 1
  %.pre236 = load target("spirv.CooperativeMatrixKHR", i32, 3, 8, 8, 2), ptr %spvm.i59, align 8, !tbaa !53
  br label %for.cond.i70, !llvm.loop !58

_ZN4sycl3_V13ext6oneapi12experimental6matrix18joint_matrix_applyINS0_9sub_groupEiLNS4_3useE2ELm8ELm8ELNS4_6layoutE3EZZZ20matrix_elem_wise_opsIiaLm8ELm8ELm32ELi4EEvR10big_matrixIT_XT1_EXT2_EERSA_IT0_XT1_EXT3_EERSA_ISE_XdvT3_T4_EXmlT2_T4_EEENKUlRNS0_7handlerEE_clESK_ENKUlNS0_7nd_itemILi2EEEE_clESN_EUlRiE_EEvSB_RNS4_12joint_matrixISB_SE_XT1_EXT2_EXT3_EXT4_EEEOT5_.exit: ; preds = %for.cond.i70
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %sub_c.i) #4
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %sub_b.i) #4
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %sub_a.i) #4
  ret void
}

; Function Attrs: convergent nounwind
declare dso_local spir_func noundef target("spirv.CooperativeMatrixKHR", i8, 3, 32, 8, 1) @_Z32__spirv_CooperativeMatrixLoadKHRIU3AS1aaLm32ELm8ELN5__spv9MatrixUseE1ELNS1_12MatrixLayoutE2ELNS1_5Scope4FlagE3EEPNS1_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEEPT_S3_mi(ptr addrspace(1) noundef, i32 noundef, i64 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: convergent nounwind
declare dso_local spir_func noundef i64 @_Z34__spirv_CooperativeMatrixLengthKHRIaLm32ELm8ELN5__spv9MatrixUseE1ELNS0_12MatrixLayoutE0ELNS0_5Scope4FlagE3EEmPNS0_28__spirv_CooperativeMatrixKHRIT_XT4_EXT0_EXT1_EXT2_EEE(target("spirv.CooperativeMatrixKHR", i8, 3, 32, 8, 1) noundef) local_unnamed_addr #2

; Function Attrs: convergent nounwind
declare dso_local spir_func noundef ptr addrspace(4) @_Z19__spirv_AccessChainIaaLm32ELm8ELN5__spv9MatrixUseE1ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4) noundef, i64 noundef) local_unnamed_addr #2

; Function Attrs: convergent nounwind
declare dso_local spir_func noundef target("spirv.CooperativeMatrixKHR", i32, 3, 8, 8, 2) @_Z32__spirv_CooperativeMatrixLoadKHRIU3AS1iiLm8ELm8ELN5__spv9MatrixUseE2ELNS1_12MatrixLayoutE3ELNS1_5Scope4FlagE3EEPNS1_28__spirv_CooperativeMatrixKHRIT0_XT5_EXT1_EXT2_EXT3_EEEPT_S3_mi(ptr addrspace(1) noundef, i32 noundef, i64 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: convergent nounwind
declare dso_local spir_func noundef i64 @_Z34__spirv_CooperativeMatrixLengthKHRIiLm8ELm8ELN5__spv9MatrixUseE2ELNS0_12MatrixLayoutE0ELNS0_5Scope4FlagE3EEmPNS0_28__spirv_CooperativeMatrixKHRIT_XT4_EXT0_EXT1_EXT2_EEE(target("spirv.CooperativeMatrixKHR", i32, 3, 8, 8, 2) noundef) local_unnamed_addr #2

; Function Attrs: convergent nounwind
declare dso_local spir_func noundef ptr addrspace(4) @_Z19__spirv_AccessChainIiiLm8ELm8ELN5__spv9MatrixUseE2ELNS0_5Scope4FlagE3EEPT_PPNS0_28__spirv_CooperativeMatrixKHRIT0_XT4_EXT1_EXT2_EXT3_EEEm(ptr addrspace(4) noundef, i64 noundef) local_unnamed_addr #2

attributes #0 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { convergent nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #3 = { convergent mustprogress norecurse nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "sycl-entry-point" "sycl-module-id"="/iusers/vmaksimo/xmain/llvm/sycl/test-e2e/Matrix/element_wise_abc.cpp" "sycl-optlevel"="2" "uniform-work-group-size"="true" }
attributes #4 = { nounwind }
attributes #5 = { convergent nounwind }

!opencl.spir.version = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!spirv.Source = !{!1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1, !1}
!llvm.ident = !{!2, !2, !2, !2, !2, !2, !2, !2, !2, !2, !2, !2, !2, !2, !2, !2, !2, !2, !2, !2, !2}
!llvm.module.flags = !{!3, !4, !5}
!sycl.specialization-constants = !{}
!sycl.specialization-constants-default-values = !{}
!sycl-esimd-split-status = !{!6}

!0 = !{i32 1, i32 2}
!1 = !{i32 4, i32 100000}
!2 = !{!"Intel(R) oneAPI DPC++/C++ Compiler 2025.3.0 (2025.x.0.YYYYMMDD)"}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{i32 1, !"sycl-device", i32 1}
!5 = !{i32 7, !"frame-pointer", i32 2}
!6 = !{i8 0}
!7 = !{i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1}
!8 = !{i1 true, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false}
!9 = !{}
!10 = !{!"matrix_type::sint32,use::accumulator,8,8;matrix_type::sint8,use::a,8,32;matrix_type::sint8,use::b,32,8"}
!11 = !{i1 false, i1 true, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false, i1 false, i1 false, i1 true, i1 false, i1 false}
!12 = !{!13, !15, !17}
!13 = distinct !{!13, !14, !"_ZN7__spirv29InitSizesSTGlobalInvocationIdILi2EN4sycl3_V12idILi2EEEE8initSizeEv: %agg.result"}
!14 = distinct !{!14, !"_ZN7__spirv29InitSizesSTGlobalInvocationIdILi2EN4sycl3_V12idILi2EEEE8initSizeEv"}
!15 = distinct !{!15, !16, !"_ZN7__spirv22initGlobalInvocationIdILi2EN4sycl3_V12idILi2EEEEET0_v: %agg.result"}
!16 = distinct !{!16, !"_ZN7__spirv22initGlobalInvocationIdILi2EN4sycl3_V12idILi2EEEEET0_v"}
!17 = distinct !{!17, !18, !"_ZNK4sycl3_V17nd_itemILi2EE13get_global_idEv: %agg.result"}
!18 = distinct !{!18, !"_ZNK4sycl3_V17nd_itemILi2EE13get_global_idEv"}
!19 = !{!20, !22, !24}
!20 = distinct !{!20, !21, !"_ZN7__spirv29InitSizesSTGlobalInvocationIdILi2EN4sycl3_V12idILi2EEEE8initSizeEv: %agg.result"}
!21 = distinct !{!21, !"_ZN7__spirv29InitSizesSTGlobalInvocationIdILi2EN4sycl3_V12idILi2EEEE8initSizeEv"}
!22 = distinct !{!22, !23, !"_ZN7__spirv22initGlobalInvocationIdILi2EN4sycl3_V12idILi2EEEEET0_v: %agg.result"}
!23 = distinct !{!23, !"_ZN7__spirv22initGlobalInvocationIdILi2EN4sycl3_V12idILi2EEEEET0_v"}
!24 = distinct !{!24, !25, !"_ZNK4sycl3_V17nd_itemILi2EE13get_global_idEv: %agg.result"}
!25 = distinct !{!25, !"_ZNK4sycl3_V17nd_itemILi2EE13get_global_idEv"}
!26 = !{!27, !29, !31}
!27 = distinct !{!27, !28, !"_ZN7__spirv28InitSizesSTLocalInvocationIdILi2EN4sycl3_V12idILi2EEEE8initSizeEv: %agg.result"}
!28 = distinct !{!28, !"_ZN7__spirv28InitSizesSTLocalInvocationIdILi2EN4sycl3_V12idILi2EEEE8initSizeEv"}
!29 = distinct !{!29, !30, !"_ZN7__spirv21initLocalInvocationIdILi2EN4sycl3_V12idILi2EEEEET0_v: %agg.result"}
!30 = distinct !{!30, !"_ZN7__spirv21initLocalInvocationIdILi2EN4sycl3_V12idILi2EEEEET0_v"}
!31 = distinct !{!31, !32, !"_ZNK4sycl3_V17nd_itemILi2EE12get_local_idEv: %agg.result"}
!32 = distinct !{!32, !"_ZNK4sycl3_V17nd_itemILi2EE12get_local_idEv"}
!33 = !{!34, !36, !38}
!34 = distinct !{!34, !35, !"_ZN7__spirv28InitSizesSTLocalInvocationIdILi2EN4sycl3_V12idILi2EEEE8initSizeEv: %agg.result"}
!35 = distinct !{!35, !"_ZN7__spirv28InitSizesSTLocalInvocationIdILi2EN4sycl3_V12idILi2EEEE8initSizeEv"}
!36 = distinct !{!36, !37, !"_ZN7__spirv21initLocalInvocationIdILi2EN4sycl3_V12idILi2EEEEET0_v: %agg.result"}
!37 = distinct !{!37, !"_ZN7__spirv21initLocalInvocationIdILi2EN4sycl3_V12idILi2EEEEET0_v"}
!38 = distinct !{!38, !39, !"_ZNK4sycl3_V17nd_itemILi2EE12get_local_idEv: %agg.result"}
!39 = distinct !{!39, !"_ZNK4sycl3_V17nd_itemILi2EE12get_local_idEv"}
!40 = !{!41, !42, i64 0}
!41 = !{!"_ZTSN4sycl3_V13ext6oneapi12experimental6matrix12joint_matrixINS0_9sub_groupEaLNS4_3useE0ELm8ELm32ELNS4_6layoutE0EEE", !42, i64 0}
!42 = !{!"p1 _ZTSN5__spv28__spirv_CooperativeMatrixKHRIaLNS_5Scope4FlagE3ELm8ELm32ELNS_9MatrixUseE0EEE", !43, i64 0}
!43 = !{!"any pointer", !44, i64 0}
!44 = !{!"omnipotent char", !45, i64 0}
!45 = !{!"Simple C++ TBAA"}
!46 = !{!44, !44, i64 0}
!47 = distinct !{!47, !48}
!48 = !{!"llvm.loop.mustprogress"}
!49 = !{!50, !51, i64 0}
!50 = !{!"_ZTSN4sycl3_V13ext6oneapi12experimental6matrix12joint_matrixINS0_9sub_groupEaLNS4_3useE1ELm32ELm8ELNS4_6layoutE2EEE", !51, i64 0}
!51 = !{!"p1 _ZTSN5__spv28__spirv_CooperativeMatrixKHRIaLNS_5Scope4FlagE3ELm32ELm8ELNS_9MatrixUseE1EEE", !43, i64 0}
!52 = distinct !{!52, !48}
!53 = !{!54, !55, i64 0}
!54 = !{!"_ZTSN4sycl3_V13ext6oneapi12experimental6matrix12joint_matrixINS0_9sub_groupEiLNS4_3useE2ELm8ELm8ELNS4_6layoutE3EEE", !55, i64 0}
!55 = !{!"p1 _ZTSN5__spv28__spirv_CooperativeMatrixKHRIiLNS_5Scope4FlagE3ELm8ELm8ELNS_9MatrixUseE2EEE", !43, i64 0}
!56 = !{!57, !57, i64 0}
!57 = !{!"int", !44, i64 0}
!58 = distinct !{!58, !48}
