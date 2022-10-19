
.data
	sir_citit: .space 101
	sir_copiat: .space 101
	printf_format: .asciz "%d\n"
	scanf_format: .asciz "%300[^\n]"
	delimitator: .asciz " "
	result: .space 4
	string_ca_sa_existe_cel_putin_un_let: .asciz " _ 1 let"
//pun acest string la sfarsitul lui sir_copiat si pt cazul in care nu
//niciun let in sir_citit
	primul_numar: .space 4
	variabile: .space 1024

.text
.global main
main:
	pushl $sir_citit
	pushl $scanf_format
	call scanf
	popl %ebx
	popl %ebx

	pushl $sir_citit
	pushl $sir_copiat
	call strcpy
	popl %ebx
	popl %ebx

	pushl $string_ca_sa_existe_cel_putin_un_let
	pushl $sir_copiat
	call strcat
	popl %ebx
	popl %ebx

	pushl $delimitator
	pushl $sir_copiat
	call strtok
	popl %ebx
	popl %ebx

	movl %eax, result
	pushl result
	call atoi
	popl %ebx
	cmp $0, %eax
	jne cazul2



cazul1:
	xorl %edx, %edx
	movl result, %ebx
	movb (%ebx, %edx, 1), %dl
	pushl %edx

	pushl $delimitator
	pushl $0
	call strtok
	popl %ebx
	popl %ebx

	movl %eax, result
	pushl result
	call atoi
	popl %ebx

	pushl %eax
	movl $variabile, %edi
	jmp let_loop_begin

cazul2:
	pushl $delimitator
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	
	movl %eax, result
	pushl result
	call atoi
	popl %ebx
	cmp $0, %eax
	jne cazul2

	xorl %edx, %edx
	movl result, %ebx
	movb (%ebx, %edx, 1), %dl
	pushl %edx

	pushl $delimitator
	pushl $0
	call strtok
	popl %ebx
	popl %ebx

	movl %eax, result
	pushl result
	call atoi
	popl %ebx

	pushl %eax
	movl $variabile, %edi
	jmp let_loop_begin




let_loop_begin:
	pushl $delimitator
	pushl $0
	call strtok
	popl %ebx
	popl %ebx

	cmp $0, %eax
	je efectuarea_operatiilor

	movl %eax, result
	movl result, %esi
	xorl %ecx, %ecx
	movb (%esi, %ecx, 1), %al
	cmp $108, %al
	je continuare1
	jmp let_loop_end
	continuare1:
	incl %ecx
	movb (%esi, %ecx, 1), %al
	cmp $101, %al
	je continuare2
	jmp let_loop_end
	continuare2:
	popl %eax
	popl %edx
	movl %eax, (%edi, %edx, 4)
	pushl %edx
	pushl %eax
jmp let_loop_begin

let_loop_end:

	pushl result
	call atoi
	popl %ebx
	xorl %edx, %edx
	movl result, %ebx
	movb (%ebx, %edx, 1), %dl

	cmp $0, %eax
	je este_char
	jmp este_numar


este_char:
popl %eax
popl %ebx
pushl %edx
pushl %eax
jmp let_loop_begin

este_numar:
popl %ebx
pushl %eax
jmp let_loop_begin


//aici stim care sunt valorile variabilelor
efectuarea_operatiilor:
	popl %ebx
	popl %ebx


	pushl $delimitator
	pushl $sir_citit
	call strtok
	popl %ebx
	popl %ebx

	movl %eax, result

	pushl result
	call atoi
	popl %ebx
	xorl %edx, %edx
	movl result, %ebx
	movb (%ebx, %edx, 1), %dl
	cmp $0, %eax
	je variabila
	jmp numar


loop_begin:

	pushl $delimitator
	pushl $0
	call strtok
	popl %ebx
	popl %ebx

	cmp $0, %eax
	je exit

	movl %eax, result

	pushl result
	call atoi
	popl %ebx

	xorl %edx, %edx
	movl result, %ebx
	movb (%ebx, %edx, 1), %dl

	cmp $0, %eax
		jne numar
	cmp $122, %edx
		jg numar
	cmp $97, %edx
		jl numar
	jmp operatie_sau_variabila
	


operatie_sau_variabila:
	pushl %edx
	pushl %eax
	pushl result
	call strlen
	popl %ebx
	movl %eax, %ebx
	popl %eax
	popl %edx
	cmp $1, %ebx
	jg operatie
	jmp variabila



operatie:

	cmp $97, %edx
	je adunare
	cmp $115, %edx
	je scadere
	cmp $109, %edx
	je inmultire
	cmp $100, %edx
	je impartire
	cmp $108, %edx
	je let
	jmp numar

adunare:
	popl %eax
	popl %edx
	addl %edx, %eax
	pushl %eax
	jmp loop_begin
scadere:
	popl %edx
	popl %eax
	subl %edx, %eax
	pushl %eax
	jmp loop_begin
inmultire:
	popl %eax
	popl %edx
	mull %edx
	pushl %eax
	jmp loop_begin
impartire:
	popl %ebx
	popl %eax
	xorl %edx, %edx
	divl %ebx
	pushl %eax
	jmp loop_begin

variabila:
	movl (%edi, %edx, 4), %eax
	pushl %eax
	jmp loop_begin
	
let:
	popl %ebx
	popl %ebx
	jmp loop_begin
numar:
	pushl %eax
jmp loop_begin

exit:

pushl $printf_format
call printf
popl %ebx



mov $1, %eax
mov $0, %ebx
int $0x80
