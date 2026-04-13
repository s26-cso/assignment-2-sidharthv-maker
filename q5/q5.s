.section .data
filename: .string "input.txt"
mode:     .string "r"
yes:      .string "Yes\n"
no:       .string "No\n"
.section .text
.globl main

main:
    addi sp, sp, -40
    sd   ra,  0(sp)
    sd   s0,  8(sp)      # fpointer
    sd   s1, 16(sp)
    sd   s2, 24(sp)
    sd   s3, 32(sp)

    # fopen("input.txt", "r")
    la   a0, filename
    la   a1, mode
    call fopen
    add  s0, a0, x0
    
    add  a0, s0, x0
    add  a1, x0, x0
    addi a2, x0, 2
    call fseek

    add  a0, s0, x0
    call ftell
    add  s1, a0, x0
    add  s2, x0, x0

ispalindrome:
    srli t0, s1, 1
    bge  s2, t0, printyes

    add  a0, s0, x0
    add  a1, s2, x0
    add  a2, x0, x0
    call fseek
    add  a0, s0, x0
    call fgetc
    add  s3, a0, x0

    add  a0, s0, x0
    addi t0, s2, 1
    sub  a1, x0, t0
    addi a2, x0, 2
    call fseek
    add  a0, s0, x0
    call fgetc

    bne  s3, a0, printno     

    addi s2, s2, 1
    jal x0, ispalindrome

printyes:
    la   a0, yes
    call printf
    jal x0, exit

printno:
    la   a0, no
    call printf

exit:
    ld   ra,  0(sp)
    ld   s0,  8(sp)
    ld   s1, 16(sp)
    ld   s2, 24(sp)
    ld   s3, 32(sp)
    addi sp, sp, 40
    ret
