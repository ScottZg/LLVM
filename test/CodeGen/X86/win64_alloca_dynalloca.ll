; RUN: llc < %s -mtriple=x86_64-mingw32 | FileCheck %s -check-prefix=M64
; RUN: llc < %s -mtriple=x86_64-win32   | FileCheck %s -check-prefix=W64
; PR8777
; PR8778

define i64 @foo(i64 %n, i64 %x) nounwind {
entry:

  %buf0 = alloca i8, i64 4096, align 1

; M64:      movq  %rsp, %rbp
; M64-NEXT:       $4096, %rax
; M64-NEXT: callq ___chkstk

; W64:      movq  %rsp, %rbp
; W64-NEXT:       $4096, %rax
; W64-NEXT: callq __chkstk
; W64-NEXT: subq  $4096, %rsp

  %buf1 = alloca i8, i64 %n, align 1

; M64-NEXT: leaq  15(%rcx), %rax
; M64-NEXT: andq  $-16, %rax
; M64-NEXT: callq ___chkstk
; M64-NEXT: movq  %rsp, %rax

; W64-NEXT: leaq  15(%rcx), %rax
; W64-NEXT: andq  $-16, %rax
; W64-NEXT: callq __chkstk
; W64-NEXT: subq  %rax, %rsp
; W64-NEXT: movq  %rsp, %rax

  %r = call i64 @bar(i64 %n, i64 %x, i64 %n, i8* %buf0, i8* %buf1) nounwind

; M64-NEXT: subq  $48, %rsp
; M64-NEXT: leaq  -4096(%rbp), %r9
; M64-NEXT: movq  %rax, 32(%rsp)
; M64-NEXT: movq  %rcx, %r8
; M64-NEXT: callq bar

; W64-NEXT: subq  $48, %rsp
; W64-NEXT: leaq  -4096(%rbp), %r9
; W64-NEXT: movq  %rax, 32(%rsp)
; W64-NEXT: movq  %rcx, %r8
; W64-NEXT: callq bar

  ret i64 %r

; M64-NEXT: movq    %rbp, %rsp

; W64-NEXT: movq    %rbp, %rsp

}

declare i64 @bar(i64, i64, i64, i8* nocapture, i8* nocapture) nounwind
