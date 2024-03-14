.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    #20 bytes
    addi sp sp -20
    sw a0 0(sp)
    sw a1 4(sp)
    sw a2 8(sp)
    sw a3 12(sp)
    sw ra 16(sp)
    
    # 1) Write only. a0: file ptr, a1: read only instr. Out: file descriptor.
    li a1 1
    jal ra fopen
    li t0 -1
    beq a0 t0 fopen_err
    #24 bytes
    addi sp sp -4
    sw a0 0(sp)

    # 2) Write rows and cols to file
    # a0: descriptor, a1: ptr to buffer containing what is written, a2: number elements to write, a3: size of each element
    # Returns number of items written to file
    #rows
    addi a1 sp 12
    li a2 1
    li a3 4
    jal fwrite
    li t0 1
    bne t0 a0 fwrite_err
    #cols
    lw a0 0(sp)
    addi a1 sp 16
    li a2 1
    li a3 4
    jal fwrite
    li t0 1
    bne t0 a0 fwrite_err
    
    # 3) Write matrix data to file
    lw a0 0(sp)
    lw a1 8(sp)
    lw t0 12(sp)
    lw t1 16(sp)
    mul a2 t0 t1
    li a3 4
    jal fwrite
    lw t0 12(sp)
    lw t1 16(sp)
    mul t2 t0 t1
    bne t2 a0 fwrite_err
    
    # 4) file close
    lw a0 0(sp)
    jal fclose
    li t0 -1
    beq a0 t0 fclose_err

    # Epilogue
    lw ra 20(sp)
    addi sp sp 24

    jr ra

fopen_err:
    li a0 27
    j exit
fclose_err:
    li a0 28
    j exit
fwrite_err:
    li a0 30
    j exit