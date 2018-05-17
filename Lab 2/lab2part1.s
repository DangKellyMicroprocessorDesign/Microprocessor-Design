addi t0, zero, 15 #A
addi t1, zero, 10 #B
addi t2, zero, 5  #C
addi t3, zero, 2  #D
addi t4, zero, 18	#E
addi t5, zero, -3	#F

sub a0, t0, t1 #A - B
MUL a1, t2, t3 #C * D
sub a2, t4, t5 #E - F
DIV a3, t0, t2 #A / C

add t6, a0, a1
add t6, t6, a2
sub t6, t6, a3

sw t6,0(sp)
