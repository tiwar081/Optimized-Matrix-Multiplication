.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    #ebreak
    # Prologue
    #16 bytes
    addi sp sp -16
    sw a0 0(sp)
    sw a1 4(sp)
    sw a2 8(sp)
    sw ra 12(sp)
    
    # 1) Read only. a0: file ptr, a1: read only instr. Out: file descriptor.
    li a1 0
    jal ra fopen
    li t0 -1
    beq a0 t0 fopen_err
    #20 bytes
    addi sp sp -4
    sw a0 0(sp)
    
    # 2) a0: file descriptor, a1: ptr to malloc'ed buffer where read bytes will be stored, a2: number of bytes to read from file
    # Out: Number of byte actually read.
    lw a1 8(sp)
    li a2 4
    jal ra fread
    li a2 4
    bne a0 a2 fread_err
    
    lw a0 0(sp)
    lw a1 12(sp)
    jal ra fread
    li a2 4
    bne a0 a2 fread_err
    
    # 3) malloc: a0 byte size. Returns ptr to malloc'ed memory.
    # rows
    lw t0 8(sp)
    lw t0 0(t0)
    # cols
    lw t1 12(sp)
    lw t1 0(t1)
    mul a0 t0 t1
    slli a0 a0 2
    jal ra malloc
    # a0 now contains ptr to matrix in memory
    beq a0 x0 malloc_err
    #24 bytes
    addi sp sp -4
    sw a0 0(sp)
    
    # 4) Read matrix to a0
    #ebreak
    #28 bytes
    addi sp sp -4
    sw s0 0(sp)
    # elem counter
    li s0 0
    
loop_start:
    #ebreak
    # t2 is number of elements
    lw t0 16(sp)
    lw t0 0(t0)
    lw t1 20(sp)
    lw t1 0(t1)
    mul t2 t0 t1
    bge s0 t2 loop_end
    
    #t3 is address of next elem placement
    slli t4 s0 2
    lw t3 4(sp)
    add t3 t3 t4
    
    # a0: file descriptor, a1: ptr to malloc'ed buffer where read bytes will be stored, a2: number of bytes to read from file
    # Out: Number of bytes actually read.
    lw a0 8(sp)
    mv a1 t3
    li a2 4
    jal fread
    li a2 4
    bne a0 a2 fread_err
    
    #increment byte counter
    addi s0 s0 1
    j loop_start

loop_end:
    # 4's Epilogue
    lw s0 0(sp)
    # 24 bytes
    addi sp sp 4
    
    # 5) file close
    lw a0 4(sp)
    jal fclose
    li t0 -1
    beq a0 t0 fclose_err
    
    # 6) Returning matrix ptr
    lw a0 0(sp)
    
    # Epilogue
    lw ra 20(sp)
    addi sp sp 24
    jr ra
    

#Errors
malloc_err:
    li a0 26
    j exit
fopen_err:
    li a0 27
    j exit
fclose_err:
    li a0 28
    j exit
fread_err:
    li a0 29
    j exit