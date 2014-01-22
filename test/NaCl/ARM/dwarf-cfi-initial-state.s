# XXX: remove "nacl" from here, use "linux"
# RUN: llvm-mc %s -triple=armv7-unknown-nacl-gnueabi -filetype=obj -o - \
# RUN:     | llvm-dwarfdump - | FileCheck %s

.cfi_sections .debug_frame
.cfi_startproc
simple_func:
bx lr
.cfi_endproc

# CHECK: CIE
# CHECK-NOT: DW_CFA_nop
# CHECK: DW_CFA_def_cfa:
# CHECK-NOT: DW_CFA_nop
# CHECK: FDE
