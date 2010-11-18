; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s
; CHECK-NOT:     movapd
; CHECK:     movaps
; CHECK-NOT:     movaps
; CHECK:     movapd
; CHECK-NOT:     movap

; RUN: llc < %s -mtriple=x86_64-win32 -asm-verbose=false | FileCheck %s -check-prefix=WIN64

define void @foo(<4 x float>* %p, <4 x float> %x) nounwind {
  store <4 x float> %x, <4 x float>* %p
  ret void
}

; WIN64: foo:
; WIN64-NEXT: movaps  (%rdx), %xmm0
; WIN64-NEXT: movaps  %xmm0, (%rcx)
; WIN64-NEXT: ret

define void @bar(<2 x double>* %p, <2 x double> %x) nounwind {
  store <2 x double> %x, <2 x double>* %p
  ret void
}

; WIN64: bar:
; WIN64-NEXT: movapd  (%rdx), %xmm0
; WIN64-NEXT: movapd  %xmm0, (%rcx)
; WIN64-NEXT: ret
