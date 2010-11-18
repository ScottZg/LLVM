; RUN: llc -mtriple=x86_64-linux < %s | FileCheck %s

; Commute the comparison to avoid a move.
; PR7500.

; CHECK: a:
; CHECK-NOT: mov
; CHECK:     pcmpeqd
define <2 x double> @a(<2 x double>, <2 x double>) nounwind readnone {
entry:
  %tmp6 = bitcast <2 x double> %0 to <4 x i32>    ; <<4 x i32>> [#uses=2]
  %tmp4 = bitcast <2 x double> %1 to <4 x i32>    ; <<4 x i32>> [#uses=1]
  %cmp = icmp eq <4 x i32> %tmp6, %tmp4           ; <<4 x i1>> [#uses=1]
  %sext = sext <4 x i1> %cmp to <4 x i32>         ; <<4 x i32>> [#uses=1]
  %and = and <4 x i32> %tmp6, %sext               ; <<4 x i32>> [#uses=1]
  %tmp8 = bitcast <4 x i32> %and to <2 x double>  ; <<2 x double>> [#uses=1]
  ret <2 x double> %tmp8
}

; RUN: llc -mtriple=x86_64-win32 -asm-verbose=false < %s | FileCheck %s -check-prefix=WIN64
; WIN64: a:
; WIN64-NEXT: movdqa  (%rdx), %xmm0
; WIN64-NEXT: movdqa  (%rcx), %xmm1
; WIN64-NEXT: pcmpeqd %xmm1, %xmm0
; WIN64-NEXT: pand    %xmm1, %xmm0
; WIN64-NEXT: ret
