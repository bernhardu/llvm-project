// RUN: %clang_cl_asan %Od %s %Fe%t
// RUN: not %run %t 2>&1 | FileCheck %s

#include <malloc.h>

int main() {
  while (true) {
    void *ptr = malloc(200 * 1024 * 1024);  // 200MB
  }
// CHECK: SUMMARY: AddressSanitizer: out-of-memory
}
