; RUN: llc < %s -mtriple=x86_64-mingw32 | FileCheck %s -check-prefix=M64
; RUN: llc < %s -mtriple=x86_64-mingw64 | FileCheck %s -check-prefix=M64
; RUN: llc < %s -mtriple=x86_64-win32   | FileCheck %s -check-prefix=W64
; PR8777
; PR8778

define i64 @foo(i64 %n, i64 %x) nounwind {
entry:

  %buf0 = alloca i8, i64 4096, align 1

; M64: movq  %rsp, %rbp
; M64:       $4096, %rax
; M64: callq ___chkstk
; M64-NOT:   %rsp

; W64: movq  %rsp, %rbp
; W64:       $4096, %rax
; W64: callq __chkstk
; W64: subq  $4096, %rsp

  %buf1 = alloca i8, i64 %n, align 1

; M64: leaq  15(%rcx), %rax
; M64: andq  $-16, %rax
; M64: callq ___chkstk
; M64-NOT:   %rsp
; M64: movq  %rsp, %rax

; W64: leaq  15(%rcx), %rax
; W64: andq  $-16, %rax
; W64: callq __chkstk
; W64: subq  %rax, %rsp
; W64: movq  %rsp, %rax

  %r = call i64 @bar(i64 %n, i64 %x, i64 %n, i8* %buf0, i8* %buf1) nounwind

; M64: subq  $48, %rsp
; M64: movq  %rax, 32(%rsp)
; M64: leaq  -4096(%rbp), %r9
; M64: callq bar

; W64: subq  $48, %rsp
; W64: movq  %rax, 32(%rsp)
; W64: leaq  -4096(%rbp), %r9
; W64: callq bar

  ret i64 %r

; M64: movq    %rbp, %rsp

; W64: movq    %rbp, %rsp

}

declare i64 @bar(i64, i64, i64, i8* nocapture, i8* nocapture) nounwind
