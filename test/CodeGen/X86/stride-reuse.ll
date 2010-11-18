; RUN: llc < %s -march=x86            | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s
; CHECK-NOT:     lea

@B = external global [1000 x float], align 32
@A = external global [1000 x float], align 32
@P = external global [1000 x i32], align 32

define void @foo(i32 %m) nounwind {
entry:
	%tmp1 = icmp sgt i32 %m, 0
	br i1 %tmp1, label %bb, label %return

bb:
	%i.019.0 = phi i32 [ %indvar.next, %bb ], [ 0, %entry ]
	%tmp2 = getelementptr [1000 x float]* @B, i32 0, i32 %i.019.0
	%tmp3 = load float* %tmp2, align 4
	%tmp4 = fmul float %tmp3, 2.000000e+00
	%tmp5 = getelementptr [1000 x float]* @A, i32 0, i32 %i.019.0
	store float %tmp4, float* %tmp5, align 4
	%tmp8 = shl i32 %i.019.0, 1
	%tmp9 = add i32 %tmp8, 64
	%tmp10 = getelementptr [1000 x i32]* @P, i32 0, i32 %i.019.0
	store i32 %tmp9, i32* %tmp10, align 4
	%indvar.next = add i32 %i.019.0, 1
	%exitcond = icmp eq i32 %indvar.next, %m
	br i1 %exitcond, label %return, label %bb

return:
	ret void
}

; RUN: llc < %s -mtriple=x86_64-win32 -asm-verbose=false | FileCheck %s -check-prefix=WIN64
; WIN64: foo:
; WIN64:      subq    $16, %rsp
; WIN64-NEXT: movq    %rsi, (%rsp)
; WIN64-NEXT: movq    %rdi, 8(%rsp)
; WIN64-NEXT: testl   %ecx, %ecx
; WIN64-NEXT: jle     .LBB0_3
; WIN64-NEXT: xorl    %eax, %eax
; WIN64-NEXT: movl    $64, %edx
; WIN64-NEXT: leaq    B(%rip), %rsi
; WIN64-NEXT: leaq    A(%rip), %rdi
; WIN64-NEXT: leaq    P(%rip), %r8
; WIN64: .LBB0_2:
; WIN64-NEXT: movslq  %eax, %rax
; WIN64-NEXT: movss   (%rsi,%rax,4), %xmm0
; WIN64-NEXT: addss   %xmm0, %xmm0
; WIN64-NEXT: movss   %xmm0, (%rdi,%rax,4)
; WIN64-NEXT: movl    %edx, (%r8,%rax,4)
; WIN64-NEXT: addl    $2, %edx
; WIN64-NEXT: incl    %eax
; WIN64-NEXT: cmpl    %eax, %ecx
; WIN64-NEXT: jne     .LBB0_2
; WIN64-NEXT: .LBB0_3:
; WIN64-NEXT: movq    8(%rsp), %rdi
; WIN64-NEXT: movq    (%rsp), %rsi
; WIN64-NEXT: addq    $16, %rsp
; WIN64-NEXT: ret
