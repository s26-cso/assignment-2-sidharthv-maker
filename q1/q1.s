.data
heap_ptr: .word 0x10010000
.text
.globl make_node
.globl insert
.globl get
.globl getAtMost

# Function: make_node
# Arguments: a0 = val (int)
# Returns: a0 = pointer to new Node
# Creates a new node with given value, left and right set to NULL
make_node:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    mv s0, a0
    li a0, 12
    jal allocate_memory
    mv s1, a0

    # Set node->val = val
    sw s0, 0(s1)

    # Set node->left = NULL
    sw zero, 4(s1)

    # Set node->right = NULL
    sw zero, 8(s1)

    mv a0, s1              # Return pointer to node
    
    lw s1, 4(sp)
    lw s0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    ret
# Function: insert
# Arguments: a0 = root (struct Node*), a1 = val (int)
# Returns: a0 = root (struct Node*)
# Inserts a node with value val into the BST
insert:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)
    mv s0, a0
    mv s1, a1
    # If root == NULL, create new node
    bne s0, zero, insert_not_null
    mv a0, s1
    jal make_node
    j insert_done
    
insert_not_null:
    # Load root->val
    lw t0, 0(s0)
    bge s1, t0, insert_check_right
    lw a0, 4(s0)           
    mv a1,s1
    jal insert
    sw a0, 4(s0)           
    mv a0, s0              
    j insert_done
    
insert_check_right:
    lw a0, 8(s0)          
    mv a1, s1
    jal insert
    sw a0, 8(s0)
    mv a0, s0
    j insert_done
    
insert_equal:
    mv a0, s0
    
insert_done:
    lw s2, 0(sp)
    lw s1, 4(sp)
    lw s0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

# Function: get
# Arguments: a0 = root (struct Node*), a1 = val (int)
# Returns: a0 = pointer to node with value val, or NULL if not found
get:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    mv s0, a0
    mv s1, a1
    beq s0, zero, get_not_found
    lw t0, 0(s0)
    beq s1, t0, get_found
    bge s1, t0, get_right
    lw a0, 4(s0)
    mv a1, s1
    jal get
    j get_done
get_right:
    lw a0, 8(s0)
    mv a1, s1
    jal get
    j get_done
get_found:
    mv a0, s0
    j get_done
get_not_found:
    mv a0, zero
get_done:
    lw s1, 4(sp)
    lw s0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

# Function: getAtMost
# Arguments: a0 = val (int), a1 = root (struct Node*)
# Returns: a0 = greatest value in tree <= val, or -1 if none exists
getAtMost:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)
    mv s0, a0
    mv s1, a1
    li s2, -1
    j getAtMost_helper
    
getAtMost_helper:
    beq s1, zero, getAtMost_done
    lw t0, 0(s1)
    bgt t0, s0, getAtMost_left
    mv s2, t0
    lw s1, 8(s1)
    j getAtMost_helper
    
getAtMost_left:
    lw s1, 4(s1)
    j getAtMost_helper
    
getAtMost_done:
    mv a0, s2
    lw s2, 0(sp)
    lw s1, 4(sp)
    lw s0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

# Helper function: allocate_memory
# Arguments: a0 = number of bytes to allocate
# Returns: a0 = pointer to allocated memory
allocate_memory:
    la t0, heap_ptr
    lw t1, 0(t0)           # t1 = current heap pointer
    mv t2, t1              # t2 = pointer to return
    add t1, t1, a0         # Advance heap pointer
    sw t1, 0(t0)           # Save new heap pointer
    mv a0, t2              # Return old heap pointer
    ret
