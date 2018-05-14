


.data

prompt:	.asciz "Please enter a temperature in Fahrenheit: "

tempc:	.asciz "Celsius: "

tempf:	.asciz "\nKelvin: "

celsius: .float 0.0

kelvin: .float 0.0

val1: .float 5.0
val2: .float 9.0
val3: .float -32.0
val4: .float 273.15

.text


main:

	li a7,4		
	la a0, prompt
	ecall

	li a7,6	
	ecall
	
	jal calculate

	li a7 10

	ecall

calculate: 	
	flw f5 val1 t0

	flw f6 val2 t0

	flw f7 val3 t0

	flw f8 val4 t0		

	fadd.s fa1 fa0 f7

	fmul.s fa1 fa1 f5

	fdiv.s fa0 fa1 f6 

	

	li a7,4		#system call for print string

	la a0,tempc

	ecall

	li a7,2		#system call for printing float in ascii

	ecall

	fadd.s fa0 fa0 f8

	li a7,4		#system call for print string

	la a0,tempf

	ecall

	li a7,2		#system call for printing float in ascii
	ecall
	ret

	

	



# END OF PROGRAM