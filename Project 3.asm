TITLE Combine and Conquer     (Project 3.asm)

; Author:					Nathan Shelby
; Last Modified:			2/7/20
; OSU email address: 		shelbyn@oregonstate.edu
; Course number/section:	271-400
; Project Number:  			3               
;Due Date:					2/9/20
; Description:				Take numbers between certain values and return the count, sum, min, max, and average of those numbers.

INCLUDE Irvine32.inc

; Initialize all of the constant definitions including my name, the project name, the requests for the user,
; variables to hold the numbers we will be using, and a goodbye message

.data
MAX					DWORD		32
my_name				BYTE		"Nathan Shelby     ", 0
my_prj				BYTE		"Combine and Conquer", 0
avrg				BYTE		"Rounded average: ", 0
numbers_entered		BYTE		"Numbers entered: ", 0
no_numbers			BYTE		"No valid numbers!", 0
number_sum			BYTE		"Sum: ", 0
number_max			BYTE		"Max: ", 0
number_min			BYTE		"Min: ", 0
user_name			BYTE		"What is your name? ", 0
greeting_1			BYTE		"Hello, ", 0
user_prompt			BYTE		"Please enter an integer in the range [-88 to -55] or [-40 to -1].", 0
user_prompt_2		BYTE		"Enter a non-negative number when you are finished to see results.", 0
user_prompt_3		BYTE		"Enter a number:  ", 0
bad_answer			BYTE		"Invalid Number!", 0
dump_space			BYTE		" ", 0
user_goodbye		BYTE		"Hope you have a great day ", 0
Extra_Credit		BYTE		"**EC: The lines will increment", 0
us_nam				DWORD		33 DUP (?)
Low_Range_1			DWORD		-88
High_Range_1		DWORD		-55
Low_Range_2			DWORD		-40
High_Range_2		DWORD		-1
Total_Count			DWORD		0
Min_Numb			DWORD		0
Max_Numb			DWORD		0
Total_Sum			DWORD		0
Avg_Numb			DWORD		0
Remainder			DWORD		0
Half				DWORD		0
Line_Number			DWORD		0

.code


; Introduction


; The entry point of the program.  Print my name and the project name as well as the extra credit messge.

main	PROC
mov		edx, OFFSET my_name
call	WriteString
mov		edx, OFFSET my_prj
call	WriteString
call	CrLf
mov		edx, OFFSET Extra_Credit
call	WriteString
call	Crlf


; User instructions and Get user data


; Ask the user for their name

mov		edx, OFFSET user_name
call	WriteString
mov		edx, OFFSET us_nam
mov		ecx, MAX
call	ReadString

; Greet the user with their name

mov		edx, OFFSET greeting_1
call	WriteString
mov		edx, OFFSET us_nam
call	WriteString
call	CrLf

; Display the prompt

mov edx, OFFSET user_prompt
call	WriteString
call	Crlf
mov		edx, OFFSET user_prompt_2
call	WriteString
call	Crlf


; Do the Math


; Write a line number and ask the user to enter a number.  Compare that number to 0 to make sure it's negative.  If it's positive,
; Jump to the "Positive" label. If the number is less than the lowest number in the range, jump to the "Wrong" label, else jump to the
; Range_Check label

Start:
mov			eax, Line_Number			; Write a line number
call		WriteDec
mov			edx, OFFSET dump_space		; Create space between the line number and the prompt
call		WriteString
mov			edx, OFFSET user_prompt_3
call		WriteString
call		ReadInt
jns			Positive					; Jump if sign flag is NOT set
cmp			eax, Low_Range_1
jl			Wrong						; Jump if not in range
jmp			Range_Check

; Tell the user the number they have input is not in the accepted range and jump to "Start" label

Wrong:
mov		edx, OFFSET bad_answer
call	WriteString
call	CrLf
jmp		Start

; Compare the user input to the highest number in the first range. If it's less than or equal to that, jump to the "Count_Check" label,
; Else compare the input to the lowest number of the second range.  If it's less than that, jump to the "Wrong" label, else compare
; The input to the highest number of the second range.  If it's greater than that, jump to the "Wrong" label, else continue.

Range_Check:
cmp		eax, High_Range_1	; Check if higher than the first range
jle		Count_Check

cmp		eax, Low_Range_2	; Check if lower than the second range
jl		Wrong

cmp		eax, High_Range_2	; Check if higher than the second range
Jg		Wrong

; Checks to see if the count is at 0.  If so, skip to the "Value_Set" label, else compare the input to the minimum number.
; If it is greater than that, jump to the "Max_Compare" label, else make the Min_Numb the input, add the input to the Total_Sum,
; Increase the Total_count by one, increment the Line_Number, and jump back to the "Start" label.

Count_Check:
cmp		Total_Count, 0
je		Value_Set

cmp		eax, Min_Numb	; Check to see if we have a new smallest number
jg		Max_Compare
mov		Min_Numb, eax
add		Total_Sum, eax
add		Total_Count, 1
inc		Line_Number
jmp		Start

Value_Set:
mov		Min_Numb, eax	; Make the input the smallest number
mov		Max_Numb, eax	; Make the input the largest number
add		Total_Sum, eax	; Make the input the sum
add		Total_Count, 1
inc		Line_Number
jmp		Start

; Compare the input to the Max_Numb.  If it's less than that, jump to the "Mid_Range" label, else make the Max_Numb the input, 
; Add the input to the Total_Sum, increase the Total_count by one, increment the Line_Number, and jump back to the "Start" label.

Max_Compare:
cmp		eax, Max_Numb	; Check to see if we have a new largest number
jl		Mid_Range
mov		Max_Numb, eax
add		Total_Sum, eax
add		Total_Count, 1
inc		Line_Number
jmp		Start

; Add the input to Total_Sum, add 1 to the Total_Count, increment the Line_Number, and jump back to the "Start" label

Mid_Range:
add		Total_Sum, eax
add		Total_Count, 1
inc		Line_Number
jmp		Start

; If the number was zero or positive, check to see if there have been any valid inputs.  If so, jump to the "Valid" label,
; Else, print the custom message and jump to the "Final" label.

Positive:
cmp		Total_Count, 0
jg		Valid

mov		edx, OFFSET no_numbers	; Display custom message
call	WriteString
jmp		Final

; Calculate the average by dividing Total_Sum by Total_Count and checking to see if we should round up or down.

Valid:
mov		eax, Total_Sum	
cdq							; Sign exted Total_Sum into edx
mov		ebx, Total_Count
idiv	ebx					; Divide edx:eax by ebx
mov		Avg_Numb, eax		; Move the total to eax
mov		Remainder, edx		; Move the remainder to a variable

; Divide the Total_Count by half and make it negative to see if we should round up or down

mov		eax, Total_Count	; Move the Total_Count to eax
cdq							; Sign extend eax into edx
mov		ebx, 2
idiv	ebx					; Divide the count in half
mov		Half, eax			; Move the whole number of the half into a variable
add		Half, edx			; Add the remainder to the whole number in the variable
mov		eax, Half		
cdq
imul	eax, -1				; Make the half number negative
mov		Half, eax
add		Half, edx			; Rejoin the half number
mov		eax, Remainder
mov		ebx, Half
cmp		eax, ebx			; See if the remainder of the initial division is greater than or less than .5 for rounding
jg		No_Round			; Since it's negative, if greater, skip to No_Round
add		Avg_Numb, -1		; Round the number up


; Display the results


; Display the Total_Count, Total_Sum, Max_Numb, Min_Numb, and Avg_Numb

No_Round:
mov		edx, OFFSET numbers_entered
call	WriteString
mov		eax,Total_Count
call	WriteDec
call	Crlf
mov		edx, OFFSET number_sum
call	WriteString
mov		eax, Total_Sum
call	WriteInt
call	Crlf
mov		edx, OFFSET number_max
call	WriteString
mov		eax, Max_Numb
call	WriteInt
call	Crlf
mov		edx, OFFSET number_min
call	WriteString
mov		eax, Min_Numb
call	WriteInt
call	Crlf
mov		edx, OFFSET avrg
call	WriteString
mov		eax, Avg_Numb
call	WriteInt
call	Crlf


; Farewell


; Display the farewell message with the user's name

Final:
call	CrLf
mov		edx, OFFSET user_goodbye
call	WriteString
mov		edx, OFFSET us_nam
call	WriteString


; End Program


exit
main	ENDP


END main
