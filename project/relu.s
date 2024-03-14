.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================

relu:
    #ebreak
    addi t0 x0 1
    blt a1 t0 err
    # Prologue
    
loop_start:
    #t0 is a counter
    li t0 -1

loop_continue:
    addi t0 t0 1
    bge t0 a1 loop_end
    # t1 is position of next elem in memory after a0
    slli t1 t0 2
    # t2 is address of next elem
    add t2 t1 a0
    #t3 is next elem
    lw t3 0(t2)
    
    bge t3 x0 loop_continue
    sw x0 0(t2)
    j loop_continue
    
loop_end:


    # Epilogue


    jr ra

err:
    li a0 36
    j exit
