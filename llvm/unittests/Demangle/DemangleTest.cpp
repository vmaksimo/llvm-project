//===-- DemangleTest.cpp --------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/Demangle/Demangle.h"
#include "gmock/gmock.h"

using namespace llvm;

TEST(Demangle, demangleTest) {
  EXPECT_EQ(demangle("_"), "_");
  EXPECT_EQ(demangle("_Z3fooi"), "foo(int)");
  EXPECT_EQ(demangle("__Z3fooi"), "foo(int)");
  EXPECT_EQ(demangle("___Z3fooi_block_invoke"),
            "invocation function for block in foo(int)");
  EXPECT_EQ(demangle("____Z3fooi_block_invoke"),
            "invocation function for block in foo(int)");
  EXPECT_EQ(demangle("?foo@@YAXH@Z"), "void __cdecl foo(int)");
  EXPECT_EQ(demangle("foo"), "foo");
  EXPECT_EQ(demangle("_RNvC3foo3bar"), "foo::bar");
  EXPECT_EQ(demangle("__RNvC3foo3bar"), "foo::bar");
  EXPECT_EQ(demangle("_Dmain"), "D main");

  // Regression test for demangling of optional template-args for vendor
  // extended type qualifier (https://bugs.llvm.org/show_bug.cgi?id=48009)
  EXPECT_EQ(demangle("_Z3fooILi79EEbU7_ExtIntIXT_EEi"),
            "bool foo<79>(int _ExtInt<79>)");

  // Regression tests for CV-qualified types inside vendor-extended qualifier
  // chains not being added to the substitution table. In these names,
  // U3AS3VU7_Atomici encodes "int _Atomic volatile AS3*"; the intermediate
  // QualType "volatile _Atomic int" must be in the substitution table so that
  // the back-reference S4_ correctly resolves to the later "memory_order"
  // parameter rather than failing.
  EXPECT_EQ(
      demangle("_Z37atomic_compare_exchange_weak_explicit"
               "PU3AS3VU7_AtomiciPii12memory_orderS4_12memory_scope"),
      "atomic_compare_exchange_weak_explicit(int _Atomic volatile AS3*, "
      "int*, int, memory_order, memory_order, memory_scope)");
  EXPECT_EQ(
      demangle("_Z39atomic_compare_exchange_strong_explicit"
               "PU3AS3VU7_AtomiciPii12memory_orderS4_12memory_scope"),
      "atomic_compare_exchange_strong_explicit(int _Atomic volatile AS3*, "
      "int*, int, memory_order, memory_order, memory_scope)");

  // Regression tests for const (K) and restrict (r) CV qualifiers inside
  // vendor-extended qualifier chains. S_ resolves to Subs[0] which must be the
  // QualType node (e.g. "int const"), not the enclosing VendorExtQualType.
  EXPECT_EQ(demangle("_Z1fPU3AS1KiS_"), "f(int const AS1*, int const)");
  EXPECT_EQ(demangle("_Z1fPU3AS1riS_"), "f(int restrict AS1*, int restrict)");
}
