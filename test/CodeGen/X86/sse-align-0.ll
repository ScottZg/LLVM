; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s
; CHECK-NOT:     mov

; RUN: llc < %s -mtriple=x86_64-win32 -asm-verbose=false | FileCheck %s -check-prefix=WIN64

define <4 x float> @foo(<4 x float>* %p, <4 x float> %x) nounwind {
  %t = load <4 x float>* %p
  %z = fmul <4 x float> %t, %x
  ret <4 x float> %z
}

; WIN64:  foo:
; WIN64-NEXT: movaps  (%rcx), %xmm0
; WIN64-NEXT: mulps   (%rdx), %xmm0
; WIN64-NEXT: ret

define <2 x double> @bar(<2 x double>* %p, <2 x double> %x) nounwind {
  %t = load <2 x double>* %p
  %z = fmul <2 x double> %t, %x
  ret <2 x double> %z
}

; WIN64:  bar:
; WIN64-NEXT: movapd  (%rcx), %xmm0
; WIN64-NEXT: mulpd   (%rdx), %xmm0
; WIN64-NEXT: ret
