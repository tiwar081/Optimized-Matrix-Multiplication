.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    #ebreak
    # Error checks
    li t0 1
    blt a1 t0 err
    blt a2 t0 err
    blt a4 t0 err
    blt a5 t0 err
    bne a2 a4 err
    # Prologue: sp adjustment, s registers, ra
    addi sp sp -16
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)

    #i
    li s0 0
    #j
    li s1 0
    #counter
    li s2 0
outer_loop_start:
    bge s0 a1 outer_loop_end


inner_loop_start:
    bge s1 a5 inner_loop_end
    #ebreak
    
    addi sp sp -28
    sw a0 0(sp)
    sw a1 4(sp)
    sw a2 8(sp)
    sw a3 12(sp)
    sw a4 16(sp)
    sw a5 20(sp)
    sw a6 24(sp)
    # getting matrix value, putting it in t0
    #parameters of dot
    mul t1 s0 a2
    slli t1 t1 2
    add a0 a0 t1 #p1
    slli t2 s1 2
    add a1 a3 t2 #p2
    #number elems in dot product already is a2! p3
    li a3 1 #p4
    mv a4 a5 #p5
    jal ra, dot
    #dot product result in t0
    mv t0 a0
    
    lw a0 0(sp)
    lw a1 4(sp)
    lw a2 8(sp)
    lw a3 12(sp)
    lw a4 16(sp)
    lw a5 20(sp)
    lw a6 24(sp)
    addi sp sp 28
    
    # t1 is address of storage
    slli t1 s2 2
    add t1 a6 t1
    # save matrix val
    sw t0 0(t1)
    
    #increment counter
    addi s2 s2 1

    #increment col
    addi s1 s1 1
    j inner_loop_start


inner_loop_end:
    #reset col counter
    li s1 0
    #increment row
    addi s0 s0 1
    j outer_loop_start


outer_loop_end:


    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    addi sp sp 16

    jr ra

err:
    li a0 38
    j exit
