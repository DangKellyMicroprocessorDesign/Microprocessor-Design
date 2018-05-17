.data
I: .word 0
Z: .word 2


.text

addi t2, zero, 20 #20 in t2
addi t3, zero, 100 #100 in t3

Alpha: 
BGT t1, t2, Beta # i <= 20 
lw t0,Z
lw t1,I
addi t0, t0, 1
addi t1, t1, 2
la t4, Z
la t5, I
sw t0, 0(t4)
sw t1, 0(t5)

j Alpha


Beta: 
lw t0,Z
addi t0, t0, 1
BGE t0, t3, Zeta # If i > 100 then do loop, else jump to Zeta if i >= 100
la t4, Z
sw t0, 0(t4)
j Beta


Zeta: BEQ t1, zero, Exit # Jump to Exit if I is equal to 0
lw t0,Z
lw t1,I
addi t0, t0, -1
addi t1, t1, -1
la t4, Z
la t5, I
sw t0, 0(t4)
sw t1, 0(t5)
j Zeta

Exit: 

sw t0, 0(sp)