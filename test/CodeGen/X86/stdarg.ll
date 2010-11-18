; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s
; CHECK: testb %al, %al

; RUN: llc < %s -mtriple=x86_64-win32 | FileCheck %s -check-prefix=WIN64
; WIN64: {{^foo:}}
; WIN64:      subq    $56, %rsp
; WIN64-NEXT: movq    %r9, 88(%rsp)
; WIN64-NEXT: movq    %r8, 80(%rsp)
; WIN64-NEXT: movq    %rdx, 72(%rsp)
; WIN64-NEXT: leaq    72(%rsp), %rax
; WIN64-NEXT: movq    %rax, 32(%rsp)
; WIN64-NEXT: leaq    32(%rsp), %rcx
; WIN64-NEXT: callq   bar
; WIN64-NEXT: addq    $56, %rsp
; WIN64-NEXT: ret

%struct.__va_list_tag = type { i32, i32, i8*, i8* }

define void @foo(i32 %x, ...) nounwind {
entry:
  %ap = alloca [1 x %struct.__va_list_tag], align 8; <[1 x %struct.__va_list_tag]*> [#uses=2]
  %ap12 = bitcast [1 x %struct.__va_list_tag]* %ap to i8*; <i8*> [#uses=2]
  call void @llvm.va_start(i8* %ap12)
  %ap3 = getelementptr inbounds [1 x %struct.__va_list_tag]* %ap, i64 0, i64 0; <%struct.__va_list_tag*> [#uses=1]
  call void @bar(%struct.__va_list_tag* %ap3) nounwind
  call void @llvm.va_end(i8* %ap12)
  ret void
}

declare void @llvm.va_start(i8*) nounwind

declare void @bar(%struct.__va_list_tag*)

declare void @llvm.va_end(i8*) nounwind
