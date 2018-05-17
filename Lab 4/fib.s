###################################################
# @file - fib.asm -  Lab 4 Fibonacci Calculator ###
# @Authors - Brigid Kelly, Don Dang             ###
# @See "Seattle University ECEGR2220 SPRING2018 ###
###################################################
.data
A: .word 0
B: .word 0
C: .word 0
.text

la t2, A
lw a4, 0(t2)
li a0, 3  #Fibonacci(3)  #a0 @param
jal fibonacci

li t3, 2  #store 2 for comparison register
li t4, 1  #store 1 for comparison register for recursion condition

#@VARS:
################################################
# Register  Param          Purpose             #
#  a0        n       input param to function   #
#  a4      value     return value              #
#  t0       n-1           holds n-1            #
#  t1       n-2      Working register          #
#  t3        2	     comaprison register       #
################################################
fibonacci:
       mv a4, a0  #bring n to return value	
       blt a0, t3, endloop
       li t0, 0
       li a4, 1
       
recursion:
	add t1, t0, a4
	mv t0, a4  #update n-2
	mv a4, t1  #update most recently calculated value
	addi a0, a0, -1  #update n to n-1
	bgt a0,t4, recursion #will exit and return when n = 1

endloop:  
	j 
