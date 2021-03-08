TITLE Modding Numbers     (Project 1.asm)

; Author: Nathan
; Last Modified: 1/18/20
; OSU email address: shelbyn@oregonstate.edu
; Course number/section: CS 271-400
; Project Number:  1               Due Date:1/19
; Description: Take three numbers from the User and add or subtract them from each other

INCLUDE Irvine32.inc

; initialize all the constant definitions including the greeting request for 3 numbers, the values that will store the
; results of adding and subtracting, my name and project name, constants to display the operation we are doing, and a
; goodbye message

.data
nam		BYTE "Nathan Shelby		", 0
prj		BYTE "Modding Numbers", 0
ext		BYTE "PER EXTRA CREDIT", 0
exp		BYTE "The numbers handle negatives", 0
desc	BYTE "Enter three numbers in descending order", 0
greeting1	BYTE "Enter the first of three numbers: ", 0
greeting2	BYTE "Enter the second of three numbers: ", 0
greeting3	BYTE "Enter the thrid of three numbers: ", 0
goodbye1	BYTE "This was fun!  Farewell",0
su		BYTE " + ",  0
total	BYTE " = ", 0
ub		Byte " - ", 0
v1		DWORD 0
v2		DWORD 0
v3		DWORD 0
v4		DWORD 0
v5		DWORD 0
v6		DWORD 0
v7		DWORD 0
v8		DWORD 0
v9		DWORD 0
v10		DWORD 0
v11		DWORD 0
Num1	DWORD ?
Num2	DWORD ?
Num3	DWORD ?
; (insert variable definitions here)

.code


; Introduction


; The entry point of the program where my name and the project name are displayed
main	PROC
mov		edx, OFFSET nam
call	WriteString
mov		edx, OFFSET prj
call	WriteString
call	CrLf

; Get the Data


; Display the greeting and request the first number from the user

mov		edx, OFFSET desc
call	WriteString
call	CrLF
mov		edx, OFFSET greeting1
call	WriteString
call	ReadInt
mov		Num1, eax

; Display the greeting and request the second number from the user

mov		edx, OFFSET greeting2
call	WriteString
call	ReadInt
mov		Num2, eax

; Display the greeting and request the third number from the user

mov		edx, OFFSET greeting3
call	WriteString
call	ReadInt
mov		Num3, eax


; Calculate the requred values and Display the results


; Complete the operation of adding the first and second numbers, storing the result, and displaying the operation

mov		eax, Num1
call	WriteDec
mov		edx, OFFSET su
call	WriteString
mov		eax, Num2
call	WriteDec
mov		eax, Num1
mov		ebx, Num2
add		eax, ebx
mov		v1, eax
mov		edx, OFFSET total
call	WriteString
call	WriteDec
call	CrLf

; Complete the operation of subtracting the first and second numbers, storing the result, and displaying the operation

mov		eax, Num1
call	WriteDec
mov		edx, OFFSET ub
call	WriteString
mov		eax, Num2
call	WriteDec
mov		eax, Num1
mov		ebx, Num2
sub		eax, ebx
mov		v2, eax
mov		edx, OFFSET total
call	WriteString
call	WriteDec
call	CrLf

; Complete the operation of adding the first and third numbers, storing the result, and displaying the operation

mov		eax, Num1
call	WriteDec
mov		edx, OFFSET su
call	WriteString
mov		eax, Num3
call	WriteDec
mov		eax, Num1
mov		ebx, Num3
add		eax, ebx
mov		v3, eax
mov		edx, OFFSET total
call	WriteString
call	WriteDec
call	CrLf

; Complete the operation of subteacting the first and third numbers, storing the result, and displaying the operation

mov		eax, Num1
call	WriteDec
mov		edx, OFFSET ub
call	WriteString
mov		eax, Num3
call	WriteDec
mov		eax, Num1
mov		ebx, Num3
sub		eax, ebx
mov		v4, eax
mov		edx, OFFSET total
call	WriteString
call	WriteDec
call	CrLf

; Complete the operation of adding the second and third numbers, storing the result, and displaying the operation

mov		eax, Num2
call	WriteDec
mov		edx, OFFSET su
call	WriteString
mov		eax, Num3
call	WriteDec
mov		eax, Num2
mov		ebx, Num3
add		eax, ebx
mov		v5, eax
mov		edx, OFFSET total
call	WriteString
call	WriteDec
call	CrLf

; Complete the operation of subtracting the second and third numbers, storing the result, and displaying the operation

mov		eax, Num2
call	WriteDec
mov		edx, OFFSET ub
call	WriteString
mov		eax, Num3
call	WriteDec
mov		eax, Num2
mov		ebx, Num3
sub		eax, ebx
mov		v6, eax
mov		edx, OFFSET total
call	WriteString
call	WriteDec
call	CrLf

; Complete the operation of adding all three numbers, storing the result, and displaying the operation

mov		eax, Num1
call	WriteDec
mov		edx, OFFSET su
call	WriteString
mov		eax, Num2
call	WriteDec
mov		edx, OFFSET su
call	WriteString
mov		eax, Num3
call	WriteDec
mov		eax, Num1
mov		ebx, Num2
add		eax, ebx
mov		ebx, Num3
add		eax, ebx
mov		v7, eax
mov		edx, OFFSET total
call	WriteString
call	WriteDec
call	CrLf

; Display the message that we are going for extra credit

mov		edx, OFFSET ext
call	WriteString
call	CrLf

; Display the message that the above operations handle negatives

mov		edx, OFFSET exp
call	WriteString
call	CrLF

; Complete the operation of subtracting the second and first numbers, storing the result, and displaying the operation

mov		eax, Num2
call	WriteDec
mov		edx, OFFSET ub
call	WriteString
mov		eax, Num1
call	WriteDec
mov		eax, Num2
mov		ebx, Num1
sub		eax, ebx
mov		v8, eax
mov		edx, OFFSET total
call	WriteString
call	WriteInt
call	CrLf

; Complete the operation of subtracting the third and first numbers, storing the result, and displaying the operation

mov		eax, Num3
call	WriteDec
mov		edx, OFFSET ub
call	WriteString
mov		eax, Num1
call	WriteDec
mov		eax, Num3
mov		ebx, Num1
sub		eax, ebx
mov		v9, eax
mov		edx, OFFSET total
call	WriteString
call	WriteInt
call	CrLf

; Complete the operation of subtracting the third and second numbers, storing the result, and displaying the operation

mov		eax, Num3
call	WriteDec
mov		edx, OFFSET ub
call	WriteString
mov		eax, Num2
call	WriteDec
mov		eax, Num3
mov		ebx, Num2
sub		eax, ebx
mov		v10, eax
mov		edx, OFFSET total
call	WriteString
call	WriteInt
call	CrLf

; Complete the operation of subtracting all three numbers, storing the result, and displaying the operation

mov		eax, Num3
call	WriteDec
mov		edx, OFFSET ub
call	WriteString
mov		eax, Num2
call	WriteDec
mov		edx, OFFSET ub
call	WriteString
mov		eax, Num1
call	WriteDec
mov		eax, Num3
mov		ebx, Num2
sub		eax, ebx
mov		ebx, Num1
sub		eax, ebx
mov		v11, eax
mov		edx, OFFSET total
call	WriteString
call	WriteInt
call	CrLf


; Say Goodbye


; Displays the goodbye message

mov		edx, OFFSET goodbye1
call	WriteString
call	CrLf

; Ends the program

INVOKE	ExitProcess, 0

	exit	; exit to operating system
main	ENDP

END		main
