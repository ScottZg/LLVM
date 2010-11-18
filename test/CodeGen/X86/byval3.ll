; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s -check-prefix=X64
; X64-NOT:     rep
; X64-NOT:     movsq
; X64:     rep;movsq
; X64-NOT:     rep
; X64-NOT:     movsq
; X64:     rep;movsq
; X64-NOT:     rep
; X64-NOT:     movsq

; RUN: llc < %s -mtriple=x86_64-win32 | FileCheck %s -check-prefix=W64
; W64: {{^g:}}
; W64:      subq    $184, %rsp
; W64-NEXT: movq    %rsi, 176(%rsp)
; W64-NEXT: movl    %ecx, 32(%rsp)
; W64-NEXT: movl    %edx, 36(%rsp)
; W64-NEXT: movl    %r8d, 40(%rsp)
; W64-NEXT: movl    %r9d, 44(%rsp)
; W64-NEXT: movl    224(%rsp), %eax
; W64-NEXT: movl    %eax, 48(%rsp)
; W64-NEXT: movl    232(%rsp), %eax
; W64-NEXT: movl    %eax, 52(%rsp)
; W64-NEXT: leaq    32(%rsp), %rsi
; W64-NEXT: movq    %rsi, %rcx
; W64-NEXT: callq   f
; W64-NEXT: movq    %rsi, %rcx
; W64-NEXT: callq   f
; W64-NEXT: movq    176(%rsp), %rsi
; W64-NEXT: addq    $184, %rsp
; W64-NEXT: ret

; RUN: llc < %s -march=x86 | FileCheck %s -check-prefix=X32
; X32-NOT:     rep
; X32-NOT:     movsl
; X32:     rep;movsl
; X32-NOT:     rep
; X32-NOT:     movsl
; X32:     rep;movsl
; X32-NOT:     rep
; X32-NOT:     movsl

%struct.s = type { i32, i32, i32, i32, i32, i32, i32, i32,
                   i32, i32, i32, i32, i32, i32, i32, i32,
                   i32, i32, i32, i32, i32, i32, i32, i32,
                   i32, i32, i32, i32, i32, i32, i32, i32,
                   i32 }

define void @g(i32 %a1, i32 %a2, i32 %a3, i32 %a4, i32 %a5, i32 %a6) nounwind {
entry:
        %d = alloca %struct.s, align 16
        %tmp = getelementptr %struct.s* %d, i32 0, i32 0
        store i32 %a1, i32* %tmp, align 16
        %tmp2 = getelementptr %struct.s* %d, i32 0, i32 1
        store i32 %a2, i32* %tmp2, align 16
        %tmp4 = getelementptr %struct.s* %d, i32 0, i32 2
        store i32 %a3, i32* %tmp4, align 16
        %tmp6 = getelementptr %struct.s* %d, i32 0, i32 3
        store i32 %a4, i32* %tmp6, align 16
        %tmp8 = getelementptr %struct.s* %d, i32 0, i32 4
        store i32 %a5, i32* %tmp8, align 16
        %tmp10 = getelementptr %struct.s* %d, i32 0, i32 5
        store i32 %a6, i32* %tmp10, align 16
        call void @f( %struct.s* %d byval)
        call void @f( %struct.s* %d byval)
        ret void
}

declare void @f(%struct.s* byval)
