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
; W64:      movq    %rsi, 176(%rsp)
; W64-NEXT: movb    %cl, 40(%rsp)
; W64-NEXT: movb    %dl, 41(%rsp)
; W64-NEXT: movb    %r8b, 42(%rsp)
; W64-NEXT: movb    %r9b, 43(%rsp)
; W64-NEXT: movb    224(%rsp), %al
; W64-NEXT: movb    %al, 44(%rsp)
; W64-NEXT: movb    232(%rsp), %al
; W64-NEXT: movb    %al, 45(%rsp)
; W64-NEXT: leaq    40(%rsp), %rsi
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

%struct.s = type { i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8 }


define void @g(i8 signext  %a1, i8 signext  %a2, i8 signext  %a3,
	 i8 signext  %a4, i8 signext  %a5, i8 signext  %a6) {
entry:
        %a = alloca %struct.s
        %tmp = getelementptr %struct.s* %a, i32 0, i32 0
        store i8 %a1, i8* %tmp, align 8
        %tmp2 = getelementptr %struct.s* %a, i32 0, i32 1
        store i8 %a2, i8* %tmp2, align 8
        %tmp4 = getelementptr %struct.s* %a, i32 0, i32 2
        store i8 %a3, i8* %tmp4, align 8
        %tmp6 = getelementptr %struct.s* %a, i32 0, i32 3
        store i8 %a4, i8* %tmp6, align 8
        %tmp8 = getelementptr %struct.s* %a, i32 0, i32 4
        store i8 %a5, i8* %tmp8, align 8
        %tmp10 = getelementptr %struct.s* %a, i32 0, i32 5
        store i8 %a6, i8* %tmp10, align 8
        call void @f( %struct.s* %a byval )
        call void @f( %struct.s* %a byval )
        ret void
}

declare void @f(%struct.s* byval)
