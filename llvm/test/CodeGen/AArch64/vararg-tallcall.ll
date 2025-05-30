; RUN: llc -mtriple=aarch64-windows-msvc %s -o - | FileCheck %s
; RUN: llc -mtriple=aarch64-linux-gnu %s -o - | FileCheck %s
; RUN: llc -mtriple=arm64ec-windows-msvc %s -o - | FileCheck %s --check-prefixes=CHECK-EC
; RUN: llc -global-isel -global-isel-abort=2 -verify-machineinstrs -mtriple=aarch64-windows-msvc %s -o - | FileCheck %s
; RUN: llc -global-isel -global-isel-abort=2 -verify-machineinstrs -mtriple=aarch64-linux-gnu %s -o - | FileCheck %s

target datalayout = "e-m:w-p:64:64-i32:32-i64:64-i128:128-n32:64-S128"

%class.X = type { i8 }
%struct.B = type { ptr }
%struct.__va_list = type { ptr, ptr, ptr, i32, i32 }

$"??_9B@@$BA@AA" = comdat any

; Function Attrs: noinline optnone
define linkonce_odr void @"??_9B@@$BA@AA"(ptr %this, ...) #1 comdat align 2  {
entry:
  %valist = alloca %struct.__va_list
  call void @llvm.va_start.p0(ptr %valist)
  %this.addr = alloca ptr, align 8
  store ptr %this, ptr %this.addr, align 8
  %this1 = load ptr, ptr %this.addr, align 8
  call void asm sideeffect "", "~{d0}"()
  %vtable = load ptr, ptr %this1, align 8
  %0 = load ptr, ptr %vtable, align 8
  call void @llvm.va_end.p0(ptr %valist)
  musttail call void (ptr, ...) %0(ptr %this1, ...)
  ret void
                                                  ; No predecessors!
  ret void
}

attributes #1 = { noinline optnone "thunk" }

; CHECK: mov     v16.16b, v0.16b
; CHECK: ldr     x9, [x0]
; CHECK: ldr     x9, [x9]
; CHECK: mov     v0.16b, v16.16b
; CHECK: br      x9
; CHECK-EC:      mov     v7.16b, v0.16b
; CHECK-EC:      ldr     x9, [x0]
; CHECK-EC:      ldr     x11, [x9]
; CHECK-EC:      blr     x9
; CHECK-EC-NEXT: mov     v0.16b, v7.16b
; CHECK-EC-NEXT: ldr     q7, [sp]
; CHECK-EC-NEXT: .seh_startepilogue
; CHECK-EC-NEXT: ldr     x30, [sp, #48]
; CHECK-EC-NEXT: .seh_save_reg x30, 48
; CHECK-EC-NEXT: add     sp, sp, #96
; CHECK-EC-NEXT: .seh_stackalloc 96
; CHECK-EC-NEXT: .seh_endepilogue
; CHECK-EC-NEXT: br      x11
