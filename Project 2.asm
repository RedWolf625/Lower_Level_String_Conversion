TITLE Fibonacci Sequence     (Project 2.asm)

; Author: Nathan Shelby
; Last Modified: 1/24/20
; OSU email address: shelbyn@oregonstate.edu 
; Course number/section: 271-400
; Project Number:  2               Due Date: 1/26/20
; Description: Calculate and display the Fibonacci Sequence to the number of terms the user decides

INCLUDE Irvine32.inc

; Initialize all of the constant definitions including my name, the project name, the requests for the user, 
; variables to hold the numbers we will be using, and a goodbye message

.data
MAX		DWORD	32
nam		BYTE	"Nathan Shelby     ", 0
prj		BYTE	"Fibonacci Sequence", 0
fib		BYTE	"We are going to calculate the Fibbonacci Sequence today! ", 0
usr		BYTE	"What is your name? ", 0
grt1	BYTE	"Hello, ", 0
prmpt	BYTE	"Please enter an integer in the range 1-46:   ", 0
bad		BYTE	"This is not a number in the range 1-46.", 0
ta		BYTE	"   ", 0
gdby	BYTE	"Goodbye, ", 0
v1		DWORD	33 DUP (?)
v2		DWORD	0
v3		DWORD	1
v4		DWORD	1
v5		DWORD	2
v6		DWORD	5

.code

; Introduction

; The entry point of the program.  Print my name andthe project name

main PROC
	mov edx, OFFSET nam
	call WriteString
	mov edx, OFFSET prj
	call WriteString
	call CrLf

; User instructions and Get user data

; Ask the user for their name

	mov edx, OFFSET usr
	call WriteString
	mov edx, OFFSET v1
	mov ecx, MAX
	call ReadString

; Greet the user with their name
	
	mov edx, OFFSET grt1
	call WriteString
	mov edx, OFFSET v1
	call WriteString
	call CrLf

; Tell the user we are calculating the Fibonacci Sequence

	mov edx, OFFSET fib
	call WriteString
	call CrLf

; Create a lable for later use.  As the user to enter a number in the accepted range and compare the imput to 46
; If the imput is greater than 46, jump to label 2, else jump to label 3

L1:
	mov edx, OFFSET prmpt
	call WriteString
	call ReadInt
	cmp eax, 46
	jg	L2
	jle L3

; Tell the user the number they have input is not in the accepted range and jump to lable 1

L2:
	mov edx, OFFSET bad
	call WriteString
	call CrLf
	jmp L1

; Compare the user input to 0.  If it is less than or equal to 0, send them to label 2, else continue

L3:
	cmp eax, 0
	jle L2

; Store the user input in a variable and in the ecx counter to act as a loop counter 
; If the number is less than or equal to 2, jump to label 10

L4:
	mov v2, eax
	mov ecx, v2
	cmp ecx, 2
	jle L10

; display Fibs

; Reduce the variables v5, v6, and the ecx register by 1.  Print out the variable V4 which is 1 
; The v5 variable acts as a counter to help make the first two printed numbers 1
; The v6 variable acts as a counter to help each line be equal to 5 numbers
; If v5 is above 0, jump back to lable 5, else jump to label 7

L5:
	dec v5
	mov eax, v6
	mov ebx, 1
	sub eax, ebx
	mov v6, eax
	dec	ecx
	mov eax, v4
	call WriteDec
	mov edx, OFFSET ta
	call WriteString
	cmp v5, 0
	jg	L5
	jle	L6

; A lable that will allow us to reset the v6 counter for line items to 5

	L6:
		cmp v6, 0
		jg	L7
		mov eax, 5
		mov v6, eax
		call CrLf

; Compare the v6 counter to 0.  If it is equal to 0, jump up to label 6
; Reduce the v6 variable and the ecx register by 1
; Move v3 and v4 to eax and ebx respectively.  Add ebx to eax and print the result
; move to the variable v4 the result of the addition
; Check the ecx loop counter.  If it is at 0, jump to label 11, else jump to label 9

L7:
	mov eax, v6
	mov ebx, 1
	sub eax, ebx
	mov v6, eax
	mov eax, v3
	mov ebx, v4
	add eax, ebx
	call	WriteDec
	mov edx, OFFSET ta
	call	WriteString
	cmp v3, v4
	jg
	mov v4, eax
	
je	L12

; A lable that will allow us to reset the v6 counter for line items to 5

L8:
	mov eax, 5
	mov v6, eax
	call CrLf

; Compare the v6 counter to 0.  If it is equal to 0, jump up to label 8
; Reduce the v6 variable and the ecx register by 1
; Move v3 and v4 to eax and ebx respectively.  Add ebx to eax and print the result
; move to the variable v3 the result of the addition
; Check the ecx loop counter.  If it is at 0, jump to label 11, else jump to label 7
	

L9:
	cmp v6, 0
	je	L8
	dec ecx
	mov eax, v6
	mov ebx, 1
	sub eax, ebx
	mov v6, eax
	mov eax, v3
	mov ebx, v4
	add eax, ebx
	call WriteDec
	mov edx, OFFSET ta
	call WriteString
L10: 
	mov v3, eax


	je L12

; Decrease the ecx loop counter by 1 and print out the contents of variable 4
; Compare the ecx loop counter to 0.  If it is greater than 0, jump back to label 10, else continue


L11:
	mov eax, v4
	call WriteDec
	mov edx, OFFSET ta
	call WriteString
	loop L11

; farewell

; Print off the goodbye message with the user's name and exit the program

L12:
	call CrLf
	mov edx, OFFSET gdby
	call WriteString
	mov edx, OFFSET v1
	call WriteString



	exit
main ENDP


END main
