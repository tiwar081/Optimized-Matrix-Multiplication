.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    li t0 1
    blt a2 t0 error1
    blt a3 t0 error2
    blt a4 t0 error2
    # Prologue

    #Dot product
    li t0 0
    #Counter
    li t1 0

loop_start:
    bge t1 a2 loop_end
    #t2 is byte-index of first array
    slli t2 t1 2
    mul t2 a3 t2
    add t2 t2 a0
    #t3 is byte-index of second array
    slli t3 t1 2
    mul t3 a4 t3
    add t3 t3 a1
    
    #t4 is value in first array
    lw t4 0(t2)
    #t5, second val
    lw t5 0(t3)

    mul t6 t4 t5
    add t0 t0 t6
    
    addi t1 t1 1
    j loop_start



loop_end:

    mv a0 t0
    # Epilogue


    jr ra

error1:
    li a0 36
    j exit
error2:
    li a0 37
    j exit