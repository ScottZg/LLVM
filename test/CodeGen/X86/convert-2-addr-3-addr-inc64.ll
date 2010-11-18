; RUN: llc < %s -mtriple=x86_64-linux -o /dev/null -stats |& FileCheck %s -check-prefix=X64stat
; X64stat: 9 asm-printer
; RUN: llc < %s -mtriple=x86_64-win32 -o /dev/null -stats |& FileCheck %s -check-prefix=W64stat
; W64stat: 9 asm-printer

; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s -check-prefix=X64
; X64: leal 1(%rsi),
; RUN: llc < %s -mtriple=x86_64-win32 | FileCheck %s -check-prefix=W64
; W64: leal 1(%rdx),

define fastcc zeroext i8 @fullGtU(i32 %i1, i32 %i2, i8* %ptr) nounwind optsize {
entry:
  %0 = add i32 %i2, 1           ; <i32> [#uses=1]
  %1 = sext i32 %0 to i64               ; <i64> [#uses=1]
  %2 = getelementptr i8* %ptr, i64 %1           ; <i8*> [#uses=1]
  %3 = load i8* %2, align 1             ; <i8> [#uses=1]
  %4 = icmp eq i8 0, %3         ; <i1> [#uses=1]
  br i1 %4, label %bb3, label %bb34

bb3:            ; preds = %entry
  %5 = add i32 %i2, 4           ; <i32> [#uses=0]
  %6 = trunc i32 %5 to i8
  ret i8 %6

bb34:           ; preds = %entry
  ret i8 0
}

