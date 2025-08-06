//===-- interception_test_main.cpp ----------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of AddressSanitizer, an address sanity checker.
//
// Testing the machinery for providing replacements/wrappers for system
// functions.
//===----------------------------------------------------------------------===//

#include "gtest/gtest.h"

int main(int argc, char **argv) {
  testing::GTEST_FLAG(death_test_style) = "threadsafe";
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}

// Ugly workaround against a link error with clang++ at i686
// Avoids error:
//     msvcrt.lib(chandler4gs.obj) : error LNK2019: unresolved external symbol __except_handler4_common referenced in function __except_handler4
#if defined(_WIN32) && defined(__i386__)
extern "C" int _except_handler4(void *, void *, void *, void *);
extern "C" {
int _except_handler4_common(void *a, void *b, void *c, void *d) {
  return _except_handler4(a, b, c, d);
}
}
#endif
