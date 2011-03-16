; RUN: llc < %s -mtriple=x86_64-linux   | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-win32   | FileCheck %s
; RUN: llc < %s -march=x86 -mattr=+sse2 | FileCheck %s
; CHECK:     LCPI
; CHECK:     LCPI
; CHECK:     LCPI
; CHECK-NOT: LCPI

; RUN: llc < %s -mtriple=x86_64-linux -o /dev/null -stats -info-output-file - | FileCheck %s -check-prefix=X64stat
; X64stat: 4 asm-printer

; RUN: llc < %s -march=x86 -mattr=+sse2 -o /dev/null -stats -info-output-file - | FileCheck %s -check-prefix=X32stat
; X32stat: 9 asm-printer

declare float @qux(float %y)

define float @array(float %a) nounwind {
  %n = fmul float %a, 9.0

  %m = call float asm "nop", "=x,x,~{xmm1},~{xmm2},~{xmm3},~{xmm4},~{xmm5},~{xmm6},~{xmm7},~{xmm8},~{xmm9},~{xmm10},~{xmm11},~{xmm12},~{xmm13},~{xmm14},~{xmm15},~{dirflag},~{fpsr},~{flags}"(float %n) nounwind

  %o = fmul float %m, 9.0
  ret float %o
}
