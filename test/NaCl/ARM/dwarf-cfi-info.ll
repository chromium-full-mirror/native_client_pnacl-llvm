; RUN: pnacl-llc -mtriple=armv7a-unknown-nacl-gnueabi -float-abi=hard \
; RUN:   -filetype=asm %s -o - | FileCheck %s

declare void @callee()

define void @simple_func() {
  call void @callee()
  ret void
}
; CHECK: simple_func:
; CHECK: .cfi_startproc
; CHECK: push {lr}
; CHECK: .cfi_def_cfa_offset 4
; CHECK: .cfi_offset lr, -4
; Adjusts for ARM NaCl's 16-byte stack alignment:
; CHECK: sub sp, sp, #12
; CHECK: .cfi_def_cfa_offset 16
; CHECK: .cfi_endproc


declare i32 @get_int_val()
declare void @use_int_val(i32)

define void @save_one_int_reg() {
  %val = call i32 @get_int_val()
  call i32 @get_int_val()
  call void @use_int_val(i32 %val)
  ret void
}
; CHECK: save_one_int_reg:
; CHECK: .cfi_startproc
; CHECK: push {r4, lr}
; CHECK: .cfi_def_cfa_offset 8
; CHECK: .cfi_offset lr, -4
; CHECK: .cfi_offset r4, -8
; CHECK: sub sp, sp, #8
; CHECK: .cfi_def_cfa_offset 16
; CHECK: .cfi_endproc


declare double @get_fp_val()
declare void @use_fp_val(double)

define void @save_one_fp_reg() {
  %val = call double @get_fp_val()
  call double @get_fp_val()
  call void @use_fp_val(double %val)
  ret void
}
; CHECK: save_one_fp_reg:
; CHECK: .cfi_startproc
; CHECK: push {lr}
; CHECK: .cfi_def_cfa_offset 4
; CHECK: .cfi_offset lr, -4
; CHECK: vpush {d8}
; CHECK: .cfi_def_cfa_offset 12
; CHECK: .cfi_offset d8, -12
; CHECK: .cfi_endproc


declare void @use_addr(i8*)

; Force use of a frame pointer by using a dynamic alloca.
define void @dynamic_alloca(i32 %size) {
  %addr = alloca i8, i32 %size
  call void @use_addr(i8* %addr)
  ret void
}
; CHECK: dynamic_alloca:
; CHECK: push {r4, r5, r6, r7, r11, lr}
; CHECK: .cfi_def_cfa_offset 24
; Move .cfi_offset decls, elided...
; CHECK: add r11, sp, #16
; CHECK: .cfi_def_cfa r11, 8
