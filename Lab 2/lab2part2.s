.data
A: .word 10
B: .word 15
C: .word 6
Z: .word 0

.text

lw t0,A
lw t1,B
lw t2,C
lw t3,Z

addi t6,zero,1 # Comparitive


SLT a0,t0,t1 # A < B
BEQ a0,zero,IFBRANCH2 
SLTI  a1,t2,5 # C < 5
XORI a1,a1,1  # NOT (c < 5)
BEQ a1,zero,IFBRANCH2 
addi t3,zero,1
j CASE

IFBRANCH2:
XORI a0,a0,1
BEQ a0,t6,ZHIT
addi t2,t2,1
addi a2,zero,7
BEQ t2,a2,ZHIT
j ZFAULT

ZHIT:
addi t3,zero,2
j CASE

ZFAULT: 
addi t3,zero,3

CASE:

BEQ t3,t6,CASEBRANCH1
addi t6,t6,1
BEQ t3,t6,CASEBRANCH2
addi t6,t6,1
BEQ t3,t6,CASEBRANCH3
mv t3,zero
j EXIT

CASEBRANCH1:
addi t3,zero,-1
j EXIT
CASEBRANCH2:
addi t3,zero,-2
j EXIT
CASEBRANCH3:
addi t3,zero,-3
j EXIT

EXIT:
sw t3,Z,t4
sw t2,C,t4
sw t1,B,t4
sw t0,A,t4