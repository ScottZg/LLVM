; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s
; CHECK:     movaps
; CHECK-NOT:     movaps

; RUN: llc < %s -mtriple=x86_64-win32 | FileCheck %s -check-prefix=WIN64
; WIN64: movaps (%rdx), [[XMM:%xmm[0-7]+]]
; WIN64: movaps [[XMM]], (%rcx)

define void @bar(<2 x i64>* %p, <2 x i64> %x) nounwind {
  store <2 x i64> %x, <2 x i64>* %p
  ret void
}
