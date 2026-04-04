.text
.globl make_node
.globl insert
.globl get
.globl getAtMost
# Function: make_node
# Arguments: a0 = val (int)
# Returns: a0 = pointer to new Node
make_node:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    mv s0, a0   
    
    li a0, 24
    call malloc
    # Set node->val = val (4 bytes at offset 0)
    sw s0, 0(a0)
    sd zero, 8(a0)
    sd zero, 16(a0)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

# Function: insert
# Arguments: a0 = root (struct Node*), a1 = val (int)
# Returns: a0 = root (struct Node*)
insert:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    mv s0, a0
    mv s1, a1

    bne s0, zero, insert_not_null
    mv a0, s1
    call make_node
    j insert_done
    
insert_not_null:
    lw t0, 0(s0)
    bge s1, t0, insert_check_right

    ld a0, 8(s0)
    mv a1, s1
    call insert
    sd a0, 8(s0)
    mv a0, s0
    j insert_done
    
insert_check_right:
    ble s1, t0, insert_equal
    ld a0, 16(s0)
    mv a1, s1
    call insert
    sd a0, 16(s0)
    mv a0, s0
    j insert_done
    
insert_equal:
    mv a0, s0
    
insert_done:
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

# Function: get
# Arguments: a0 = root (struct Node*), a1 = val (int)
# Returns: a0 = pointer to node with value val, or NULL if not found
get:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    mv s0, a0
    mv s1, a1

    beq s0, zero, get_not_found
    lw t0, 0(s0)
    beq s1, t0, get_found
    bge s1, t0, get_right
    ld a0, 8(s0)           # a0 = root->left
    mv a1, s1
    call get
    j get_done
    
get_right:
    ld a0, 16(s0)
    mv a1, s1
    call get
    j get_done
    
get_found:
    mv a0, s0
    j get_done
    
get_not_found:
    mv a0, zero
    
get_done:
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

# Function: getAtMost
# Arguments: a0 = val (int), a1 = root (struct Node*)
# Returns: a0 = greatest value in tree <= val, or -1 if none exists
getAtMost:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    sd s2, 0(sp)
    
    mv s0, a0
    mv s1, a1
    li s2, -1
    
getAtMost_loop:
    beq s1, zero, getAtMost_done
    lw t0, 0(s1)
    bgt t0, s0, getAtMost_left
    mv s2, t0
    ld s1, 16(s1)
    j getAtMost_loop
    
getAtMost_left:
    ld s1, 8(s1)
    j getAtMost_loop

getAtMost_done:
    mv a0, s2
    ld s2, 0(sp)
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret
