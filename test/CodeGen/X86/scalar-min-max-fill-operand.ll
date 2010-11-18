; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s
; CHECK-NOT:     {{(min|max|mov)}}
; CHECK:     mov
; CHECK-NOT:     {{(min|max|mov)}}
; CHECK:     min
; CHECK-NOT:     {{(min|max|mov)}}
; CHECK:     mov
; CHECK-NOT:     {{(min|max|mov)}}
; CHECK:     max
; CHECK-NOT:     {{(min|max|mov)}}

; RUN: llc < %s -mtriple=x86_64-win32 | FileCheck %s -check-prefix=WIN64
; WIN64: {{^foo:}}
; WIN64:      subq    $56, %rsp
; WIN64-NEXT: movaps  %xmm6, 32(%rsp)
; WIN64-NEXT: movaps  %xmm0, %xmm6
; WIN64-NEXT: callq   bar
; WIN64-NEXT: minss   %xmm6, %xmm0
; WIN64-NEXT: movaps  32(%rsp), %xmm6
; WIN64-NEXT: addq    $56, %rsp
; WIN64-NEXT: ret

; WIN64: {{^hem:}}
; WIN64:      subq    $56, %rsp
; WIN64-NEXT: movaps  %xmm6, 32(%rsp)
; WIN64-NEXT: movaps  %xmm0, %xmm6
; WIN64-NEXT: callq   bar
; WIN64-NEXT: maxss   %xmm6, %xmm0
; WIN64-NEXT: movaps  32(%rsp), %xmm6
; WIN64-NEXT: addq    $56, %rsp
; WIN64-NEXT: ret

declare float @bar()

define float @foo(float %a) nounwind
{
  %s = call float @bar()
  %t = fcmp olt float %s, %a
  %u = select i1 %t, float %s, float %a
  ret float %u
}
define float @hem(float %a) nounwind
{
  %s = call float @bar()
  %t = fcmp ogt float %s, %a
  %u = select i1 %t, float %s, float %a
  ret float %u
}
