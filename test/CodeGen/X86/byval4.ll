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
; W64-NEXT: movw    %cx, 32(%rsp)
; W64-NEXT: movw    %dx, 34(%rsp)
; W64-NEXT: movw    %r8w, 36(%rsp)
; W64-NEXT: movw    %r9w, 38(%rsp)
; W64-NEXT: movw    224(%rsp), %ax
; W64-NEXT: movw    %ax, 40(%rsp)
; W64-NEXT: movw    232(%rsp), %ax
; W64-NEXT: movw    %ax, 42(%rsp)
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

%struct.s = type { i16, i16, i16, i16, i16, i16, i16, i16,
                   i16, i16, i16, i16, i16, i16, i16, i16,
                   i16, i16, i16, i16, i16, i16, i16, i16,
                   i16, i16, i16, i16, i16, i16, i16, i16,
                   i16, i16, i16, i16, i16, i16, i16, i16,
                   i16, i16, i16, i16, i16, i16, i16, i16,
                   i16, i16, i16, i16, i16, i16, i16, i16,
                   i16, i16, i16, i16, i16, i16, i16, i16,
                   i16 }


define void @g(i16 signext  %a1, i16 signext  %a2, i16 signext  %a3,
	 i16 signext  %a4, i16 signext  %a5, i16 signext  %a6) nounwind {
entry:
        %a = alloca %struct.s, align 16
        %tmp = getelementptr %struct.s* %a, i32 0, i32 0
        store i16 %a1, i16* %tmp, align 16
        %tmp2 = getelementptr %struct.s* %a, i32 0, i32 1
        store i16 %a2, i16* %tmp2, align 16
        %tmp4 = getelementptr %struct.s* %a, i32 0, i32 2
        store i16 %a3, i16* %tmp4, align 16
        %tmp6 = getelementptr %struct.s* %a, i32 0, i32 3
        store i16 %a4, i16* %tmp6, align 16
        %tmp8 = getelementptr %struct.s* %a, i32 0, i32 4
        store i16 %a5, i16* %tmp8, align 16
        %tmp10 = getelementptr %struct.s* %a, i32 0, i32 5
        store i16 %a6, i16* %tmp10, align 16
        call void @f( %struct.s* %a byval )
        call void @f( %struct.s* %a byval )
        ret void
}

declare void @f(%struct.s* byval)
