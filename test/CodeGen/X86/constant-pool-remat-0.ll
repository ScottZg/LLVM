; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s -check-prefix=X64
; X64:     LCPI
; X64:     LCPI
; X64:     LCPI
; X64-NOT: LCPI

; RUN: llc < %s -mtriple=x86_64-linux -o /dev/null -stats -info-output-file - | FileCheck %s -check-prefix=X64stat
; X64stat: 6 asm-printer

; It seems rematerialization would not be needed on win64.
; RUN: llc < %s -mtriple=x86_64-win32 | FileCheck %s -check-prefix=W64
; W64: .LCPI0_0:
; W64: array:
; W64:      subq    $56, %rsp
; W64-NEXT: movaps  %xmm6, 32(%rsp)
; W64-NEXT: movss   .LCPI0_0(%rip), %xmm6
; W64-NEXT: mulss   %xmm6, %xmm0
; W64-NEXT: callq   qux
; W64-NEXT: mulss   %xmm6, %xmm0
; W64-NEXT: movaps  32(%rsp), %xmm6
; W64-NEXT: addq    $56, %rsp
; W64-NEXT: ret

; RUN: llc < %s -march=x86 -mattr=+sse2 | FileCheck %s -check-prefix=X32
; X32:     LCPI
; X32:     LCPI
; X32:     LCPI
; X32-NOT: LCPI

; RUN: llc < %s -march=x86 -mattr=+sse2 -o /dev/null -stats -info-output-file - | FileCheck %s -check-prefix=X32stat
; X32stat: 12 asm-printer

declare float @qux(float %y)

define float @array(float %a) nounwind {
  %n = fmul float %a, 9.0
  %m = call float @qux(float %n)
  %o = fmul float %m, 9.0
  ret float %o
}
