.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    addi t0 x0 1
    blt a1 t0 err
    # Prologue
    
loop_start:
    #t0 is index counter
    li t0 0
    #t4 is current maximum
    lw t4 0(a0)
    #t5 is current maximum index
    li t5 0

loop_continue:
    addi t0 t0 1
    bge t0 a1 loop_end
    # t1 is position of current elem in memory after a0
    slli t1 t0 2
    # t2 is address of current elem
    add t2 t1 a0
    #t3 is current elem
    lw t3 0(t2)
    
    bge t4 t3 loop_continue
    
    #In this case, the current element is larger than the previous max
    mv t4 t3
    mv t5 t0
    j loop_continue

loop_end:
    # Epilogue
    mv a0 t5
    jr ra

err:
    li a0 36
    j exit