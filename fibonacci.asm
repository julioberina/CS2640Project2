# Who:  Julio Berina
# What: fibonacci.asm
# Why:  Calculate the Fibonacci number for the nth term
# When: 10/19/18
# How:  Calculate and store each term in an array

.data
array:    .space  192    # 48 (Fibonacci elements that can fit in 32-bit integer) * 4
bigfib:   .asciiz "2971215073\n" # Since emulator only allows signed integers
terpri:   .asciiz "\n"
input:    .asciiz "Enter n:  "
thenth:   .asciiz "The nth fibonacci number is "

.text
.globl main


main:
    li $s0, 0
    la $a0, input
    li $v0, 4
    syscall

    li $v0, 5
    syscall

    move $s0, $v0

    # check if negative or zero
    slti $t0, $s0, 1
    beq $t0, 1, exit

    # check if bigger than 48
    li $t1, 48
    slt $t0, $t1, $s0
    beq $t0, 1, exit

    la $a0, terpri
    li $v0, 4
    syscall

    # Get registers ready for fibloop
    li $t1, 0    # temp
    li $t2, 0    # a
    li $t3, 1    # b
    li $t4, 0    # for array iterating
    li $t5, 4
    la $s1, array
    mult $s0, $t5
    mflo $s0

fibloop:
    beq $t4, $s0, nth
    li $t1, 0        # temp = 0
    move $t1, $t2    # temp = a

    sw $t2, 0($s1)   # store a to current index of array

    li $t2, 0
    move $t2, $t3    # a = b

    addu $t3, $t3, $t1   # b = b + temp
    addi $s1, $s1, 4
    addi $t4, $t4, 4

    j fibloop

nth:
    beq $s0, 192, printbigfib
    addi $s1, $s1, -4

    la $a0, thenth
    li $v0, 4
    syscall

    lw $a0, 0($s1)
    li $v0, 1
    syscall

    la $a0, terpri
    li $v0, 4
    syscall

    j setup

printbigfib:
    la $a0, thenth
    li $v0, 4
    syscall

    la $a0, bigfib
    li $v0, 4
    syscall

setup:
    li $t0, 0       # array iterator
    la $s1, array   # reset at index 0

display:
    beq $t0, $s0, exit
    beq $t0, 188, ifbigfib

    lw $a0, 0($s1)
    li $v0, 1
    syscall

    la $a0, terpri
    li $v0, 4
    syscall

    addi $s1, $s1, 4
    addi $t0, $t0, 4

    j display

ifbigfib:
    la $a0, bigfib
    li $v0, 4
    syscall

exit:
    li $v0, 10
    syscall
