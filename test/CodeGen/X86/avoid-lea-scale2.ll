; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s
; CHECK: leal -2(%rdi,%rdi)
; RUN: llc < %s -mtriple=x86_64-win32 | FileCheck %s -check-prefix=WIN64
; WIN64: leal -2(%rcx,%rcx)

define i32 @foo(i32 %x) nounwind readnone {
  %t0 = shl i32 %x, 1
  %t1 = add i32 %t0, -2
  ret i32 %t1
}

