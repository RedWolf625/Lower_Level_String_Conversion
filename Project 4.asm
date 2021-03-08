TITLE:						Procedure Procedure     (Project 4.asm)

; Author:					Nathan Shelby
; Last Modified:			2/8/20
; OSU email address: 		shelbyn@oregonstate.edu
; Course number/section:	271-400
; Project Number:  			4               
;Due Date:					2/16/20
; Description:				Take a user entered number in a range and return a number of composite integers equal to that.

INCLUDE Irvine32.inc

; Initialize all of the constant definitions including my name, the project name, the requests for the user,
; variables to hold the numbers we will be using, and a goodbye message

.data
Test_Prompt			BYTE		"Good job, it works", 0
MAX					DWORD		32
my_name				BYTE		"Nathan Shelby          ", 0
my_prj				BYTE		"Procedure Procedure", 0
user_name			BYTE		"What is your name? ", 0
greeting_1			BYTE		"Hello, ", 0
user_prompt			BYTE		"Enter the number of composites you would like to see.", 0
user_prompt_2		BYTE		"I'll accept orders between 1 to 400 composites.", 0
user_prompt_3		BYTE		"Enter the number of composites you would like me to calculate [1..400]: ", 0
bad_answer			BYTE		"Invalid Number!", 0
dump_space			BYTE		"   ", 0
user_goodbye		BYTE		"Hope you have a great day ", 0
us_nam				DWORD		33 DUP (?)
Low_Range			DWORD		1
High_Range			DWORD		400
Line_Count			DWORD		10
User_Numb			DWORD		0
Current_Numb		DWORD		4
Div_Numb			DWORD		1


.code

; The entry point of the program.  Call the procedures that will run in this program.

main	PROC
	call	introduction
	call	getUserData
	call	showComposites
	call	farewell
exit
main	ENDP


; Description:			Return my name, the project name, ask for, store and return the user's name
; Receivers:			us_nam is the holder for the user name
; Returns:				my_name is my name, my_prj is project name, greeting_1 greets the user with us_nam which is their name
; Preconditions:		Code is free of syntax errors
; Postconditions:		A message will have prompted the user for their name and they would have been greeted with their input
; Registers changed:	ecx, edx, esp, eip


introduction	PROC

mov		edx, OFFSET my_name
call	WriteString				; Call methods modify the esp and eip registers
mov		edx, OFFSET my_prj
call	WriteString
call	CrLf

; Ask the user for their name

mov		edx, OFFSET user_name
call	WriteString
mov		edx, OFFSET us_nam
mov		ecx, MAX
call	ReadString				; Store the user's name

; Greet the user with their name

mov		edx, OFFSET greeting_1
call	WriteString
mov		edx, OFFSET us_nam
call	WriteString
call	CrLf
	ret							; Return the stack pointer back to where it was before the procedure
introduction	ENDP


; Description:			Ask for and store the number of composites the user wants us to return
; Receivers:			eax will hold the number the number the user entered
; Returns:				user_prompt, user_prompt_2, and user_prompt_3 lay out specifics of the request of the user
; Preconditions:		The user has entered a valid name
; Postconditions:		The user would have been prompted for a number and they will have entered it	
; Registers changed:	eax, edx, esp, eip


getUserData		PROC

mov edx, OFFSET user_prompt
call	WriteString
call	Crlf
mov		edx, OFFSET user_prompt_2
call	WriteString
call	Crlf
mov		edx, OFFSET	user_prompt_3
call	WriteString
call	ReadInt						; Store the entered number in eax
call	validate					; validate the number

	ret
getUserData		ENDP


; Description:			Validate whether or not the entered number is in the range and store if it is
; Receivers:			eax holds the number and User_Numb will hold a validated number
; Returns:				bad_answer will alert the user to a number not in range
; Preconditions:		The user has entered a number
; Postconditions:		The number will have been validated to be in range and stored, or the user will be notified that the number is not in range
; Registers changed:	edx, esp, eip


validate		PROC

js			Wrong						; Jump if sign flag is set
cmp			eax, Low_Range
jl			Wrong						; Jump if below the low end of the range
cmp eax,	High_Range
jle			Right						; Jump below or equal to the high end of the range

; Tell the user the number they have input is not in the accepted range and jump to "Start" label

Wrong:
mov		edx, OFFSET bad_answer
call	WriteString
call	CrLf
call	getUserData					; Start the getUserData procedure again

Right:
mov		User_Numb, eax				; Move the validated number into a holding variable
	ret
validate		ENDP


; Description:			Loop through the numbers up to User_Numb looking for composites
; Receivers:			ecx acts as a loop counter that will run isComposit User_Numb number of times
; Returns:				A list of composite number equal in count to User_Numb 
; Preconditions:		The user entered a number that has been validated to be in range
; Postconditions:		A User_Numb amount of composite integers will have been displayed
; Registers changed:	ecx, esp, eip


showComposites	PROC

mov		ecx, User_Numb	; Make ecx a loop counter equal to User_Numb

Loop_1:

call	isComposite		; Call the sub-procedure
loop	Loop_1			; Loop through all the numbers to find a User_Numb amount of composites
	ret
showComposites	ENDP


; Description:			Loop through each number from 4 up to User_Numb - 1 to see if it's composite and display the composites
; Receivers:			ecx and eax at various times hold Current_Numb, the number we are currently testing.  ebx holds Div_numb,
;						an incrementing number up to Current_Numb that we divide Current_Numb by to see if Current_Numb is composite.  edx will
;						hold dump_space to place three spaces between numbers
; Returns:				Returns any numbers that are validated as composite
; Preconditions:		User has entered a valid number, the outer loop counter has not yet gone from User_Numb to 0
; Postconditions:		Each number up to Current_Numb will be divided into Current_Numb to test whether it was composite or not with composite numbers being displayed
; Registers changed:	eax, ebx, ecx, edx, esp, eip


isComposite		PROC
push	ecx						; Save the outer loop counter

Start:
mov		ecx, Current_Numb		; Start an inner loop counter to divide Current_Numb by every number from 4 up to Current_Numb
inc		Div_Numb				; Increase the divisor number by 1
mov		eax, Current_Numb
mov		ebx, Div_Numb
cmp		eax, ebx				; Check to see if our divisor is equal to our dividend
je		End_Loop				; If we have reached or divisor, skip to the end of the procedure as every number can be divided by itself

Loop_2:							; Establish a dividing loop
mov		eax, Current_Numb
mov		edx, 0
div		Div_Numb				; Divide the Current_Numb by the divisor
cmp		edx, 0					; Check to see if there is a remainder or not
je		Composite				; If there isn't a remainder, the number is composite.  Jump to the "Composite" lable
inc		Div_Numb				; Else increment the divisor by 1
mov		eax, Current_Numb
mov		ebx, Div_Numb
cmp		eax, ebx				; Check to make see if the dividend and divisor are equal or not
je		Not_Composite			; If they are even, we have divided all the numbers from 4 to Current_Numb and thus the number is not composite.  Jump to the Not_Composite label
mov		ebx, 0
mov		eax, 0					; Clear the registers
loop	Loop_2					; Start our dividing loop again

Composite:						; For numbers found to be composite
mov		eax, Current_Numb
call	WriteDec				; Display that number
mov		edx, OFFSET dump_space
call	WriteString				; Place three spaces after the number
mov		Div_Numb, 1				; Reset the divisor to 1
inc		Current_Numb			; Move our Current_Numb up 1
dec		Line_Count				; Move our indentation counter down 1
mov		eax, Line_Count
cmp		Line_Count, 0			; Check to see if we have gone from 10 to 0 and thus displayed 10 numbers yet
jg		End_Loop				; If not, skip to the end of this loop
mov		Line_Count, 10			; If so, reset the indentation loop counter to 10
call	Crlf					; Move to the next line
jmp		End_Loop				; End the loop

Not_Composite:					; For numbers found to be not composite
mov		ebx, 0					; Clear the ebx register
mov		Div_Numb, 1				; Reset the divisor
inc		Current_Numb			; Move our Current_Numb up 1
jmp		Start					; Go back to the "Start" label at the beginning of the procedure to see if the next number is composite

End_Loop:
pop		ecx						; Restore the outer loop counter
	ret
isComposite		ENDP


; Description:		    Display the farewell message with the user's name
; Receivers:		    edx receives the strings for displaying the messages
; Returns:			    user_goodbye bids the user farewell with their name, us_nam
; Preconditions:	    The program has displayed a User_Numb amount of composites
; Postconditions:		The user would have seen a goodbye message with their name
; Registers changed:    edx


farewell		PROC

call	CrLf
mov		edx, OFFSET user_goodbye
call	WriteString
mov		edx, OFFSET us_nam
call	WriteString
	ret
farewell		ENDP

; End Program
END main