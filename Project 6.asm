TITLE:						String C-C-C-Conversion     (Project 6.asm)

; Author:					Nathan Shelby
; Last Modified:			3/14/20
; OSU email address: 		shelbyn@oregonstate.edu
; Course number/section:	271-400
; Project Number:  			6             
;Due Date:					3/15/20
; Description:				Take 10 numbers entered by the user, convert them from string to numeric to validate them, convert back to numeric, and calculate the sum and average of the list.

INCLUDE Irvine32.inc

; Create a macro called displayString that prints the string stored in a membory location

displayString	MACRO	memory_location
	push	edx							; Save the edx register
	mov		edx, memory_location	
	call	WriteString
	pop		edx							; Restore edx
ENDM

getString		MACRO	user_input, len_input, letter_count
	push	ecx							
	push	edx				
	push	eax
	mov		edx, user_input
	mov		ecx, len_input				
	call	ReadString
	mov		letter_count, eax			
	pop		eax							
	pop		edx							
	pop		ecx	
ENDM

; Initialize all of the constant definitions including my name, the project name, the instructions, the titles of the sections,
; variables to hold the numbers we will be using, and an array to hold the count of each integer in the main array.

.data

my_name					BYTE	"Nathan Shelby          ", 0
my_prj					BYTE	"String C-C-C-Conversion", 0
dump_space				BYTE	"  ", 0
instruction_set_1		BYTE	"Please provide 10 signed decimal integers.", 0
instruction_set_2		BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
instruction_set_3		BYTE	"After you have finished inputting the raw numbers", 0
instruction_set_4		BYTE	"I will display a list of the integers, their sum, and their average value.", 0
prompt					BYTE	"Please enter a signed number: ", 0
bad_answer				BYTE	"ERROR: You did not enter a signed number or your number was too big.", 0
prompt_retry			BYTE	"Please try again: ", 0
final_numbers			BYTE	"You entered the following numbers: ", 0
sum_numbers				BYTE	"The sum of these numbers is: ", 0
avg_numbers				BYTE	"The average is: ", 0
goodbye_msg				BYTE	"Thanks for playing! Come back soon!", 0
dump_space_2			BYTE	", ", 0

letter_count	DWORD	?
user_input		BYTE	21 DUP(?)				
number_array	DWORD	10 DUP(?)		
sum				DWORD	?
avg				DWORD	?
sign_check		DWORD	0


.code
main PROC

	push	OFFSET my_name					; Push the reference to the addres of my_name onto the stack
	push	OFFSET my_prj					; Push the reference to the address of my_prj onto the stack
	push	OFFSET instruction_set_1		; Push the reference to the address of instruction_set_1 onto the stack
	push	OFFSET instruction_set_2		; Push the reference to the address of instruction_set_2 onto the stack
	push	OFFSET instruction_set_3		; Push the reference to the address of instruction_set_3 onto the stack
	push	OFFSET instruction_set_4		; Push the reference to the address of instruction_set )4 onto the stack
	call	introduction					; Print out my name, the project name, and all the instructions for the user

	push	OFFSET bad_answer		
	push	OFFSET number_array		
	push	OFFSET prompt			
	push	OFFSET prompt_retry		
	push	OFFSET user_input		
	push	SIZEOF user_input		
	push	OFFSET letter_count	
	call	readVal							; Prompt the user and validate their input


	push	OFFSET number_array		
	push	OFFSET sum				
	push	OFFSET avg			
	call	calculations					; Calculate the sum and the average of the numbers in the array	

	push	OFFSET dump_space_2
	push	OFFSET number_array	
	push	OFFSET final_numbers	
	call	printList						; Display the list of numbers

	call	CrLf
	call	CrLf
	displayString	OFFSET sum_numbers
	push	OFFSET sum				
	call	WriteVal						; Display the sum of the numbers
	call	CrLf
	displayString	OFFSET avg_numbers
	push	OFFSET avg				
	call	WriteVal						; Display the average of the numbers
	call	CrLf

	call	CrLf
	displayString  OFFSET goodbye_msg		; Print the goodbye message
	call	CrLf
	call	CrLf
	exit	; exit to operating system
main ENDP





; Description: Introduces the program and instructions
; Receivers: The address of my_name, my_prj, and the instructions from the stack
; Returns: Prints my_name, my_prj, and the instructions to the console
; Preconditions: The code is free of errors 
; Postconditions: my_name, my_prj, and the instructions are displayed on the console
; Registers changed: ebp, esp, esi

introduction PROC
	push	ebp
	mov		ebp, esp
	displayString	[ebp+28]	; Print my_name
	displayString	[ebp+24]	; Print my_prj
	call	CrLf
	call	CrLf
	displayString	[ebp+20]	; Print instruction_set_1
	call	CrLf
	displayString	[ebp+16]	; Print instruction_set_2
	call	CrLf
	displayString	[ebp+12]	; Print instruction_set_3
	call	CrLf
	displayString	[ebp+8]		; Print instruction_set_4
	call	CrLf
	call	CrLf
	pop		ebp
	ret		28
introduction ENDP


; Description: Gets and validates the user's input
; Receivers: address of the instructions, address of the error messaging, adddress to hold the user string, 
;			address of an array to hold the numbers, and address of the variable for the number of characters in the input
; Returns: An error if the input is not signed or if it is too large as well as a prompt asking for a number 10 times
; Preconditions: Code is free of errors and the introduction has been printed
; Postconditions: There has been 10 valid numbers input to the program
; Registers changed: ebp, esp, esi, edi, eax, ebx, ecx, edx, al

readVal PROC,
	string_len:				PTR BYTE,		;	Points to the LENGTHOF input
	string_size:			PTR BYTE,		;	Points to the SIZEOF  input
	string_input:			PTR BYTE,		;	Points to the input
	retry_msg:				PTR BYTE,		;	Points to the retry message
	instruction_set:		PTR BYTE,		;	Points to the instructions
	input_array:			PTR DWORD,		;	Points to the array of numbers
	error_msg:				PTR BYTE,		;	Points to the error message

	pushad									;	Saves the registers




; Set loop counter to get 10 inputs, and set desination Array to EDI
	mov		edi, input_array				
	mov		ecx, 10	
get_numbers:
	push	ecx								;	Save outer loop counter
	displayString	instruction_set			;	Print the instructions to the console

; pass the macro the user input, the size of the input, and the length of the input
get_string:
	getString		string_input, string_size, string_len
			
; Set the loop counter to the length of string, move the string input to esi, and clear the direction flag
	mov		ecx, string_len			
	mov		esi, string_input		
	cld								

; See if the string is too long.  If so, jump to the error
	cmp		ecx, 10					; if string_len > 10 chars long, the number is too large to fit in a 32 bit register
	JA		wrong_answer	

validation_loop:	
	
	; Multiply the number by 10
	mov		eax, [edi]			; Move the array spot to eax
	mov		ebx, 10			
	mul		ebx					; multiply by 10
	mov		[edi], eax			; Move eax back to the array spot
	
	; Check the current byte
	xor		eax, eax			; Clear eax
	lodsb						; Loads byte and puts into al, then increments esi to the next byte
	cmp		al, 43
	JE		positive_symbol		; Check to see if the first byte is a '+' sign.  If so, jump to the end of the loop and load the next byte 
	cmp		al, 45
	JE		negative_symbol		; Check to see if the first byte is a '-' sign.  If so, jump to the negative number loop.
	sub		al, 48				; Convert ASCII to numeric
	cmp		al, 0				
	JB		wrong_answer		; If al < 0, jump to the error message
	cmp		al, 9				
	JA		wrong_answer		; If al > 9, jump to the error message
	add		[edi], al			; Else add to value in ebx
	positive_symbol:
	loop	validation_loop		; get next byte in string
	jmp		endReadVal


wrong_answer:
	push	eax
	xor		eax, eax			
	mov		[edi], eax			; Clear the spot in the array
	pop		eax

	displayString  error_msg	; Print the error
	call	CrLf
	displayString	retry_msg	; Print the retry message
	JMP		get_string

endReadVal:
	pop		ecx					;	Restore outer loop counter
	mov		eax,	[edi]
	add		edi, 4				; Increment EDI to the next aray spot
	loop	get_numbers
	jmp		end_retreival

negative_symbol:
	push	eax
	mov		eax, sign_check
	add		eax, 1
	mov		sign_check, eax		; Raise our custom sign_check flag
	pop		eax
	jmp		start_symbol		; Jump to the end of the loop to skip past the '-' symbol

	neg_validation_loop:

	; multiply the number by 10
	mov		eax, [edi]				; move the array spot to eax
	mov		ebx, 10		
	mul		ebx						; multiply by 10
	mov		[edi], eax				; move eax to the array spot
	
	; uses the same validation logic as the positive validation loop
	xor		eax, eax				
	lodsb							
	sub		al, 48					
	cmp		al, 0				
	JB		wrong_answer			
	cmp		al, 9				
	JA		wrong_answer			
	add		[edi], al				
	start_symbol:
	loop	neg_validation_loop		
	push	ebx
	push	eax
	mov		ebx, -1
	mov		eax, [edi]
	mul		ebx						; Takes the numeric value we have constructed and multiplies it by -1, making it negative
	mov		[edi], eax
	pop		eax
	pop		ebx
	jmp		endReadVal

end_retreival:

	popad
	ret	32
readVal ENDP

; Description: calculate the sum and average of the numbers
; Receivers: address of the number array, address of the sum variable, and address of the avg variable
; Returns: sum and avg
; Preconditions: The code is free of errors, there are valid numbers in our array
; Postconditions: The sum and avg variables will hold the relevant information
; Registers changed: ebp, esi, eax, ebx, ecx

calculations	PROC,
	avg_number:		PTR DWORD,
	sum_number:		PTR DWORD,
	num_array:	PTR DWORD
	pushad

	mov		esi, num_array
	mov		ecx, 10	
	mov		eax, 0				; Set accumulator to 0
	
array_loop:
	add		eax, [esi]			; Add current element to eax
	add		esi, 4				; Move to next element
	loop	array_loop
		
	mov		ebx, sum_number		
	mov		[ebx], eax			; Store the sum held in eax in sum_number
	
	xor		edx, edx					
	mov		ebx, 10 			
	cdq
	idiv		ebx				; Quotient in EAX, remainder in EDX
	mov		ebx, avg_number
	mov		[ebx], eax			; Store quotient in avg_number
	popad
	ret 16
calculations	ENDP


; Description: convert a numeric value to string, then display it
; Receivers: address of a number
; Returns: The string of the number it has converted
; Preconditions: The array it points to has numbers in it
; Postcondition: The numbers are all converted to strings and displayed
; Registers changed: ebp, esi, edi, eax, ebx, ecx, edx

writeVal	PROC,
	num:	PTR					DWORD			; Points to the number
	LOCAL	numb_len:			DWORD			; Holds the len of the number
	LOCAL	string_hold [20]:	BYTE			; Holds the current string
	pushad										


	; Get the length of the number including symbols
			
	mov		numb_len, 0				; Counter is 0
	mov		eax, [num]				; Address of the number to eax
	mov		eax, [eax]				; Move the number to eax
	cdq								; Sign extend the number
	cmp		edx, 0					; Check to see if the number is negative
	JL		neg_len_counter			; If so, jump to the neg_string_builder
	mov		ebx, 10					; Otherwise, set the divisor

pos_len_counter:
	xor		edx, edx	
	cmp		eax, 0
	JE		end_pos					; If eax is 0, don't increment length counter
	div		ebx						; Divide the number by 10
	cdq
	inc		numb_len				; Increase the length counter
	jmp		pos_len_counter

end_pos:
	mov		ecx, numb_len			
	cmp		ecx, 0					; If length was 0, jump to the zero printer
	JE		zero_numb
	lea		edi, string_hold		; Set the source for STOSB
	add		edi, numb_len			; Add the number of bytes we need to convert
					
	;	add 0 at the end of the string and set the direction flag
	std
	push	ecx
	mov		al, 0
	stosb
	pop		ecx

	mov		eax, num			; Move address of number to eax
	mov		eax, [eax]			; Move number to eax
	mov		ebx, 10				; Set our divisor
	
pos_string_builder:
	xor		edx, edx		
	mov		ebx, 10			
	cdq
	idiv		ebx						
	add		edx, 48d					; Convert the remainder to ASCII character
	push	eax							; Save eax
	mov		eax, edx					; Move new ASCII character to eax
	stosb								; Store ASCII
	pop		eax							; Restore eax
	cmp		eax, 0			
	JE		printString					; If eax = 0, we have looked at all digits in number
	JMP		pos_string_builder

neg_len_counter:
	mov		ebx, -10					; Load our divisor
	inc		numb_len					; Skip the '-' symbol
neg_len_loop:
	cmp		eax, 0
	JE		end_neg						; If eax = 0, don't increment length counter
	cdq									; Sign extend
	idiv		ebx						
	cdq
	inc		numb_len					; Increase the length counter
	mov		ebx, 10						; Now that the number left is not negative, continue to divide by 10
	jmp		neg_len_loop

end_neg:
	mov		ecx, numb_len			
	cmp		ecx, 0						; If length was 0, the number was 0 and we just need to print that number
	JE		zero_numb
	lea		edi, string_hold			; Set the source for STOSB
	add		edi, numb_len				; Add the number of bytes we need to convert
				
	
	; Add 0 at the end of the string
	std
	push	ecx
	mov		al, 0
	stosb
	pop		ecx

	mov		eax, num			; Move address of number to eax
	mov		eax, [eax]			; Move number to eax
	mov		ebx, -1				; Set our divisor
	cdq							; Sign extend
	idiv	ebx					; The number is now negative
	mov		ebx, 10

neg_string_builder:
	cdq
	idiv	ebx				
	add		edx, 48				; Convert the remainder to ASCII
	push	eax					; Save eax
	mov		eax, edx			; Move the ASCII character to eax
	stosb						; Store the ASCII character
	pop		eax					; Restore eax
	cmp		eax, 0			
	JE		neg_String			; if EAX = 0 then we are done
	JMP		neg_string_builder	

zero_numb:
	push	ecx
	mov		ecx, 2
	xor		eax, eax		; Clear eax so that it is 0
	add		eax, 48			; Convert 0 to ASCII
	push	eax
	mov		al, '0'
	call	WriteChar
	pop		eax
	pop		ecx

	JMP		end_write

neg_String:
	mov		eax, 45			; Add a '-' symbol to the front of the string
	stosb

printString:
	lea		eax, string_hold
	displayString  eax
end_write:
	popad					; restore registers
	ret		
writeVal	ENDP

; Description: Prints the values store in an array of numbers
; Receivers: The address of an array
; Returns: The string of the numbers in the array
; Preconditions: The array has numbers in it
; Postconditions: The values in the array are printed
; Registers changed: ebp, esi, ecx, edx

printList	PROC,
	number_results:		PTR BYTE,
	array_loc:			PTR DWORD
	pushad

	call	CrLf
	displayString number_results
	call	CrLf

	mov		ecx, 10				; Set the loop counter
	mov		esi, array_loc		; Point to the first item in the array
display_loop:
	push	esi
	call	WriteVal
	add		esi, 4
	cmp		ecx, 1
	JE		end_display
	mov		edx, [ebp + 16]
	call	WriteString
	loop	display_loop

end_display:

	popad
	ret 16
printList	ENDP


END main