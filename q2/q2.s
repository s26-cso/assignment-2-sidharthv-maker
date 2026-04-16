.section .bss
.align 3
arr: .space 8192
result: .space 8192
stack_buf: .space 8192
.section .data
fmt_mid:  .string "%lld "
fmt_last: .string "%lld\n"
.section .text
.globl main
main:
    addi sp, sp, -72
    sd   ra,  0(sp)
    sd   s0,  8(sp)
    sd   s1, 16(sp)
    sd   s2, 24(sp)
    sd   s3, 32(sp)
    sd   s4, 40(sp)
    sd   s5, 48(sp)
    sd   s6, 56(sp)
    sd   s7, 64(sp)
    mv   s7, sp

    mv   s0, a0
    mv   s1, a1
    addi s2, s0, -1
    beq s2, x0, .exit

    slli t0, s2, 3
    li   t1, 3
    mul  t0, t0, t1
    addi t0, t0, 15
    andi t0, t0, -16
    sub  sp, sp, t0

    mv   s3, sp
    slli t0, s2, 3
    add  s4, s3, t0
    add  s5, s4, t0

    li t0, 1

.parse_loop:
    bgt  t0, s2, .parse_done
    slli t1, t0, 3        #offset = index * 8
    add  t1, s1, t1
    ld   a0, 0(t1)

    addi sp, sp, -16
    sd   t0, 0(sp)
    sd   t1, 8(sp)
    call atoi
    ld   t0, 0(sp)
    ld   t1, 8(sp)
    addi sp, sp, 16

    addi t2, t0, -1
    slli t2, t2, 3
    add  t2, s3, t2
    sd   a0, 0(t2)
    addi t0, t0, 1
    j    .parse_loop

.parse_done:
    li   t0, 0
    li   t1, -1

.init_loop:
    bge  t0, s2, .init_done
    slli t2, t0, 3
    add  t2, s4, t2
    sd   t1, 0(t2)
    addi t0, t0, 1
    j    .init_loop

.init_done:
    #arr[stack[bottom]] > ... > arr[stack[top]], so stack.top() is always the nearest-right greater index candidate.
    mv   s6, s5
    addi t0, s2, -1       

.nge_loop:
    blt t0, x0, .nge_done
    # t3 = arr[i]
    slli t1, t0, 3
    add  t1, s3, t1
    ld   t3, 0(t1)

    # while (!empty && arr[stack.top()] <= arr[i]) pop
.pop_loop:
    beq  s6, s5, .pop_done
    ld   t4, -8(s6)
    slli t5, t4, 3
    add  t5, s3, t5
    ld   t5, 0(t5)

    bgt  t5, t3, .pop_done
    addi s6, s6, -8
    j    .pop_loop

.pop_done:
    # if (!empty) result[i] = stack.top()
    beq  s6, s5, .do_push

    ld   t4, -8(s6)
    slli t1, t0, 3
    add  t1, s4, t1
    sd   t4, 0(t1)

.do_push:
    sd   t0, 0(s6)
    addi s6, s6, 8

    addi t0, t0, -1
    j    .nge_loop

.nge_done:
    li   t0, 0
    addi t1, s2, -1

.print_loop:
    bge  t0, s2, .print_done

    slli t2, t0, 3
    add  t2, s4, t2
    ld   a1, 0(t2)

    beq  t0, t1, .use_last_fmt
    la   a0, fmt_mid
    j    .do_printf

.use_last_fmt:
    la   a0, fmt_last

.do_printf:
    addi sp, sp, -16
    sd   t0, 0(sp)
    sd   t1, 8(sp)
    call printf
    ld   t0, 0(sp)
    ld   t1, 8(sp)
    addi sp, sp, 16

    addi t0, t0, 1
    j    .print_loop

.print_done:

.exit:
    li   a0, 0
    ld   ra,  0(s7)
    ld   s0,  8(s7)
    ld   s1, 16(s7)
    ld   s2, 24(s7)
    ld   s3, 32(s7)
    ld   s4, 40(s7)
    ld   s5, 48(s7)
    ld   s6, 56(s7)
    ld   s7, 64(s7)
    mv   sp, s7
    addi sp, sp, 72
    ret