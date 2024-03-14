.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    ebreak
    # Check the number of arguments
    li t0, 5
    bne a0, t0, err_numargs
    
    # Prologue
    # stack 24
    addi sp sp -24
    addi t0 a1 4
    lw t0 0(t0)
    sw t0 0(sp)
    addi t0 a1 8
    lw t0 0(t0)
    sw t0 4(sp)
    addi t0 a1 12
    lw t0 0(t0)
    sw t0 8(sp)
    addi t0 a1 16
    lw t0 0(t0)
    sw t0 12(sp)
    sw a2 16(sp)
    sw ra 20(sp)
    
    #1)
    # Read m0
    # stack 36
    addi sp sp -12
    lw a0 12(sp) # ptr m0 file
    addi a1 sp 4 # ptr rws
    addi a2 sp 8 # ptr cols
    jal read_matrix
    sw a0 0(sp) # Save pointer to m0
    
    # Read m1
    # stack 48
    addi sp sp -12
    lw a0 28(sp) # ptr m1 file
    addi a1 sp 4 # ptr rws
    addi a2 sp 8 # ptr cols
    jal read_matrix
    sw a0 0(sp) # Save pointer to m1
    
    # Read input
    # stack 60
    addi sp sp -12
    lw a0 44(sp) # ptr input file
    addi a1 sp 4 # ptr rws
    addi a2 sp 8 # ptr cols
    jal read_matrix
    sw a0 0(sp) # Save pointer to input
    
    # 2) Compute h = matmul(m0, input)
    # malloc for h
    lw t0 28(sp)
    lw t1 8(sp)
    mul a0 t0 t1
    slli a0 a0 2
    jal malloc
    beq a0 x0 err_malloc
    # Stack 64
    addi sp sp -4
    sw a0 0(sp) # h ptr
    
    lw a0 28(sp)
    lw a1 32(sp)
    lw a2 36(sp) #m0
    lw a3 4(sp)
    lw a4 8(sp)
    lw a5 12(sp) #inp
    lw a6 0(sp)
    jal matmul
    
    # 3) Compute h = relu(h)
    lw a0 0(sp)
    lw t0 32(sp)
    lw t1 12(sp)
    mul a1 t0 t1
    jal relu
    
    # 4) Compute o = matmul(m1, h). Write o to output file.
    # malloc for o
    lw t0 20(sp)
    lw t1 12(sp)
    mul a0 t0 t1
    slli a0 a0 2
    jal malloc
    beq a0 x0 err_malloc
    # Stack 68
    addi sp sp -4
    sw a0 0(sp) # o ptr
    
    # executing multiplication
    lw a0 20(sp)
    lw a1 24(sp)
    lw a2 28(sp) #m1
    lw a3 4(sp)
    lw a4 36(sp)
    lw a5 16(sp) #h
    lw a6 0(sp)
    jal matmul
    
    # Writing o. a0: ptr filename. a1: ptr matrix. a2: rows. a3: cols.
    lw a0 56(sp)
    lw a1 0(sp)
    lw a2 24(sp)
    lw a3 16(sp)
    jal write_matrix
    
    # 5) Compute argmax(o), print if print arg indicates. a0: array ptr. a1: array length. a0 return: argmax.
    lw a0 0(sp)
    lw t0 24(sp)
    lw t1 16(sp)
    mul a1 t0 t1
    jal argmax
    # Stack 72
    addi sp sp -4
    sw a0 0(sp) #save argmax to stack
    lw t0 64(sp) #load print arg
    beq t0 x0 print_argmax
    
finish_prog:
    # 6) Free allocated data. a0: memory ptr.
    lw a0 4(sp) #o
    jal free
    lw a0 8(sp) #h
    jal free
    lw a0 12(sp) #inp
    jal free
    lw a0 24(sp) #m1
    jal free
    lw a0 36(sp) #m0
    jal free
    
    # 7) Return argmax(o).
    lw a0 0(sp)
    
    # Epilogue
    lw ra 68(sp)
    addi sp sp 72
    
    # Exit the program
    jr ra
    
err_malloc:
    li a0, 26 # Error code 26 (malloc failure)
    j exit
    
err_numargs:
    li a0, 31 # Error code 31 (incorrect number of args)
    j exit

print_argmax:
    lw a0 0(sp)
    jal print_int
    li a0 '\n'
    jal print_char
    j finish_prog