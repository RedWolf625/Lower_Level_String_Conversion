TITLE:						Random no more     (Project 5.asm)

; Author:					Nathan Shelby
; Last Modified:			2/29/20
; OSU email address: 		shelbyn@oregonstate.edu
; Course number/section:	271-400
; Project Number:  			5               
;Due Date:					3/1/20
; Description:				Generate a random array of 200 integers between 10 and 29, display the median, sort the array, and list the number of times each integer appears.

INCLUDE Irvine32.inc

; Initialize the global constants for the low end of our range, the high end of our range, and the size of our array. 

LO			EQU		10
HI			EQU		29
ARRAYSIZE	EQU		200

; Initialize all of the constant definitions including my name, the project name, the instructions, the titles of the sections,
; variables to hold the numbers we will be using, and an array to hold the count of each integer in the main array.

.data
my_name				BYTE		"Nathan Shelby          ", 0
my_prj				BYTE		"Random No More", 0
dump_space			BYTE		"  ", 0
median_numb			BYTE		"List Median:  ", 0
unsort_title		BYTE		"Your unsorted random numbers:", 0
sort_title			BYTE		"Your sorted random numbers:",0
count_title			BYTE		"Your list of instances of each generated number, starting with the number of 10s:",0
instruction_set		BYTE		"This program generates 200 random numbers in the range [10 ... 29], displays the original list,", 0
instruction_set_2	BYTE		"sorts the list, displays the median value, displays the list sorted in ascending order,", 0
instruction_set_3	BYTE		"then displays the number of instances of each generated value.", 0

Low_Range			DWORD		LO							; Cast the global constant LO into a variable
High_Range			DWORD		HI							; Cast the global constant HI into a variable
Line_Count			DWORD		20
Hold_Count			DWORD		0
Compare_Count		DWORD		0
Count_Count			DWORD		1
Array_Count			DWORD		0
Random_Array		DWORD		ARRAYSIZE DUP(?)			; Create a Random Array the size of the global constant ARRAYSIZE
counts				DWORD		20 Dup(?)
counts_Length		DWORD		20



.code

; The entry point of the program.  Call the procedures that will run in this program 
; and push the constants that they will be using for indirect addrsssing.

main	PROC
	call	Randomize							; Makes the random integers that are created truly more random
	push	ebp									; Push the current value of ebp onto the system stack
	push	OFFSET		instruction_set_3		; Push the reference of the address of the 3rd instruction set onto the system stack
	push	OFFSET		instruction_set_2		; Push the reference of the address of the 2nd instruction set onto the system stack
	push	OFFSET		instruction_set			; Push the reference of the address of the instruction set onto the system stack
	push	OFFSET		my_name					; Push the reference of the address of my_name onto the system stack
	push	OFFSET		my_prj					; Push the reference of the address of my_prj onto the system stack
	mov		ebp, esp							; Moves ebp (base pointer) to the current location of esp (stack pointer)
	call	introduction						; Call the introduction procedure
	pop		ebp									; Pop everything down to and including ebp off the stack

	push	ebp									
	push	OFFSET		Random_Array			
	push	ARRAYSIZE							; Push the value of ARRAYSIZE onto the system stack
	push	Low_Range						
	push	High_Range							
	mov		ebp, esp							
	call	fillArray							; Call fillArray				
	pop		ebp									

	push	ebp
	push	OFFSET		median_numb
	push	OFFSET		unsort_title
	push	OFFSET		Random_Array
	push	OFFSET		dump_space
	push	Compare_Count
	push	ARRAYSIZE
	push	Line_Count
	mov		ebp, esp
	call	displayList							; Call displayList

	call	sortList							; Call sortList

	call	displayMedian						; Call displayMedian
	pop		ebp

	push	ebp
	push	OFFSET		sort_title
	push	OFFSET		Random_Array
	push	OFFSET		dump_space
	push	Compare_Count
	push	ARRAYSIZE
	push	Line_Count
	mov		ebp, esp
	call	displayList							; Call displayList
	pop		ebp

	push	ebp
	push	Array_Count
	push	ARRAYSIZE
	push	OFFSET		Random_Array
	push	OFFSET		counts
	push	Count_Count
	mov		ebp, esp
	call	countList							; Call countList
	pop		ebp

	push	ebp
	push	OFFSET		count_title
	push	OFFSET		counts
	push	OFFSET		dump_space
	push	Compare_Count
	push	counts_Length
	push	Line_Count
	mov		ebp, esp
	call	displayList							; Call displayList
	pop		ebp
exit
main	ENDP


; Description:			Return my name, the project name, and write out the program instructions
; Receivers:			edx will receive the reference to the variables that hold my name, the project name, and the instructions
; Returns:				my_name is my name, my_prj is project name, instruction_set are the instructions
; Preconditions:		Code is free of syntax errors
; Postconditions:		my name, the project name, and the program instructions will have been displayed
; Registers changed:	edx, esp, ebp, eip


introduction		PROC
mov		edx, [EBP + 4]
call	WriteString
mov		edx, [EBP]
call	WriteString
call	CrLf
mov		edx, [EBP + 8]
call	WriteString
call	CrLf
mov		edx, [EBP + 12]
call	WriteString
call	CrLf
mov		edx, [EBP + 16]
call	WriteString
call	CrLf
call	CrLf

	ret							; Return the stack pointer back to where it was before the procedure
introduction		ENDP


; Description:			Fill an array with 200 random integers between 10 and 29.
; Receivers:			esi receives the start of Random_Array that will receive the integers that are generated in eax and ecx holds the loop counter 
; Returns:				Nothing is printed to the console, but you will have an array filled with 200 random integers between 10 and 29
; Preconditions:		Code is free of syntax errors, the base pointer is correctly pointing to the start of Random Array, 
;						and the global constants for the low end and high end of the range have been declared
; Postconditions:		You will have an array filled with 200 random integers between 10 and 29
; Registers changed:	ecx, eax, esi, esp, ebp, eip


fillArray			PROC

mov		ecx, [EBP + 8]				; Create a loop counter with the value of ARRAYSIZE
mov		esi, [EBP + 12]				; Move esi to the start of the Random_Array

Array_Generator:
mov		eax, [EBP]					; Move the value of High_Range to eax
sub		eax, [EBP + 4]				; Subtract the value of Low_Range
inc		eax							; Increase eax by 1
call	RandomRange					; Call the RandomRange procedure which generates a random integer from 0 to the number in eax
add		eax, [EBP + 4]				; Add the value of Low_Range to move the value of eax into the accepted range
mov		[esi], eax					; Move to the current spot in Random_Array the integer in eax
add		esi, 4						; Move to the next spot in Random Array
loop	Array_Generator				; Loop back to the start of the Array_Generator

	ret
fillArray			ENDP


; Description:			Take the array in the stack and print out each integer in that array one by one, 20 per line, 
;						with two spaces in between integers
; Receivers:			edx receives the reference to unsort_title, esi gets pointed to the start of the array, edx receives dump_space, 
;						ecx receives the value of ARRAYSIZE, and ebx receives the value of Line_Count.
; Returns:				20 integers per line with two spaces in between them of every integer in the array in the system stack
; Preconditions:		Code is free of syntax errors and the array is full of integers
; Postconditions:		200 random integers of Random_Array have been displayed to the console
; Registers changed:	eax, ebx, ecx, edx, ebp, esp, eip


displayList			PROC
mov		edx, [EBP + 20]
call	WriteString				; Print the title of the array
call	CrLf
mov		esi, [EBP + 16]			; Point to the start of the array
mov		edx, [EBP + 12]			; Hold the two spaces
mov		ecx, [EBP + 4]			; Set a loop counter to ARRAYSIZE
mov		ebx, [EBP]				; Set a secondary counter to 20 for the integers per line

Print_Array:
mov		eax, [esi]				; Take the value pointed to by esi and put it in eax
call	WriteDec				; Print that value to the console
call	WriteString				; Print two spaces
dec		ebx						; Move our indentation counter down 1
cmp		ebx, 0					; Check to see if we have gone from 20 to 0 and thus displayed 20 numbers yet
jg		Continue				; If not, skip to the end of this loop
mov		ebx, 20					; If so, reset the indentation loop counter to 20
call	Crlf					; Move to the next line

Continue:
add		esi, 4					; Move to the next item in the array
loop	Print_Array				; Loop the array printer 
call	CrLf

	ret
displayList			ENDP


; Description:			Sort the items in the array pointed to by the system stack using an insertion sort
; Receivers:			ecx receives ARRAYSIZE, esi receives the start address of the array, edx receives 4 and 
;						a loop counter for comparisons, and eax and ebx receive values from the array
; Returns:				Nothing is printed to the console, but the array will have been sorted
; Preconditions:		Code is free of syntax errors, there is an array with integers in the system stack
; Postconditions:		The array will have been sorted
; Registers changed:	eax, ebx, ecx, edx, ebp, esp, esi, eip


sortList			PROC

mov		ecx, [EBP + 4]				; Create a loop counter of ARRAYSIZE
dec		ecx							
mov		esi, [EBP + 16]				; Point esi to the start of the array
mov		edx, 4

Sort_Array:
mov		eax, [esi]					; Move the value pointed to by esi into eax
mov		ebx, [esi + edx]			; Take esi and add to it the value of edx.  Take the integer in that spot and move it to ebx
cmp		ebx, eax					
jge		Loop_Reset					; If ebx is greater than or equal to eax, jump to the end of the loop
call	exchangeElements			; Else, call the exchangeElements procedure

Loop_Reset:
mov		edx, [ebp + 8]				; Move the value of Compare_Count to edx
inc		edx							; Add 1 to edx
mov		[ebp + 8], edx				; Make that integer the new value of Compare_Count
mov		edx, 4						; Reset edx to 4
add		esi, 4						; Point esi to the next integer in the list
loop	Sort_Array

	ret
sortList			ENDP


; Description:			Exchange the items passed from sortList and then take the value pointed to by esi and 
;						keep sending it back in the list until it is in order
; Receivers:			eax and ecx will receive the compare counter for comparisons that go from esi backwards, eax will also receive the 
;						new values for comparison as the loop iterates backwards through the array
; Returns:				Nothing is printed to the console, but the items passed from sortList will have been swapped 
;						and all the elements below the value of esi will be in order 
; Preconditions:		Code is free of syntax errors and the items passed from sortList are valid
; Postconditions:		The elements passed from sortList will have been exchanged, 
;						and all the elements below the current value of esi will be in order
; Registers changed:	eax, ebx, ecx, edx, ebp, esp, esi, eip


exchangeElements	PROC

mov		[esi], ebx						; Move to the spot pointed to by esi the value of ebx
mov		[esi + edx], eax				; Move to the spot pointed to by esi + edx the value of eax
mov		eax, [ebp + 8]					; Move to eax our Compare_Count counter
cmp		eax, 0							; Check to see if we have 0 other integers to check
jle		End_Switch						; If so, jump to the end of the loop
push	ecx								; Else, push the value of our outer loop counter
mov		ecx, [ebp + 8]					; Move the Compare_Count counter to ecx
sub		edx, 8							; Subtract 8 from edx
mov		eax, [esi + edx]				; Move to eax the value behind esi in the array
cmp		ebx, eax						; Check to see if ebx is still larger than the integer behind it
jge		In_Order						; If so, jump to the end of the loop

Check_Back:
mov		eax, [esi + edx]				; Else, move to eax the value behind esi in the array
mov		[esi + edx], ebx				; Move the value of ebx to the spot pointed to by esi + edx
add		edx, 4							
mov		[esi + edx], eax				; Move the value of eax to the spot pointed to by esi + edx
cmp		ecx, 0							; Check to see if we are at the end of our counter
jle		In_Order						; If so, jump to the end of the loop
sub		edx, 8							; Else, keep going backwards in the array
mov		eax, [esi + edx]
cmp		ebx, eax
jge		In_Order
loop	Check_Back

In_Order:
pop		ecx								; Return the value of our outer loop counter

End_Switch:
	ret
exchangeElements	ENDP


; Description:			Display the median value in the sorted array
; Receivers:			edx receives the median_numb and the remainder of dividing the middle two integers in the array, 
;						esi receives the starting address of Random Array, eax and ebx receive the two middle integers and eax receives
;						the value of dividing those two integers
; Returns:				median_numb followed by the median number in the list
; Preconditions:		Code is free of syntax errors and Random Array has been sorted
; Postconditions:		A message will display what the median number in the array is
; Registers changed:	eax, ebx, ecx, edx, ebp, esp, esi, eip


displayMedian		PROC
mov		edx, [ebp + 24]
call	WriteString					; Print the median_numb message to the console
mov		edx, 0						; Clear edx
mov		esi, [EBP + 16]				; Point esi to the address of Random Array
mov		eax, [esi + 396]
mov		ebx, eax
mov		eax, [esi + 400]			; Take the two middle numbers from the Array and put them in ebx and eax
add		eax, ebx					; Add those numbers together
mov		ebx, 2						
div		ebx							; Divide by 2
cmp		edx, 0						; Check to see if there was a remainder
je		End_Median					; If not, jump to End_Median
inc		eax							; If so, since we are dividing by 2, that remainder must be 1 (aka .5), so round up


End_Median:
call	WriteDec					; Write the median to the console
call	CrLf
call	CrLf

	ret
displayMedian		ENDP


; Description:			Count the occurance of each integer in the array
; Receivers:			edx holds the counter for the number of occurances, esi holds the starting location of the Random_Array and
;						the counts array, eax and ebx hold the values in the Random array, eax will also hold the spot we are in 
;						in the counts array, ecx holds the loop counter for Random_Array and the counts array
; Returns:				Nothing is printed to the console, but the counts array will hold the number of occurances of each integer in the array
; Preconditions:		Code is free of syntax errors, the Random_Array has been sorted
; Postconditions:		The counts array will hold the number of occurances of each integer in the array
; Registers changed:	eax, ebx, ecx, edx, ebp, esp, esi, eip


countList			PROC

mov		edx, [EBP]					; edx is the counter for occurances of the integer
mov		esi, [EBP + 8]				; Point esi to the start of Random_Array
mov		ecx, [ebp + 12]				; Set the loop counter to ARRAYSIZE
dec		ecx							; Subract 1 from the loop counter

List_Counter:
mov		eax, [esi]					; Move to eax the value pointed to by esi
mov		ebx, [esi + 4]				; Move to ebx the next value in the list
cmp		eax, ebx					; Check to see if they are the same
je		Equal_Numbs					; If so, jump to Equal_Numbs
push	esi							; Else, push the current address of the Random_Array
mov		eax, [ebp + 16]				; Move to eax where we are in the counts array
mov		esi, [ebp + 4]				; Move to esi the start of the counts array
mov		[esi + eax], edx			; Move to the spot we are in the counts array, the number of occurances of the integer we were counting
mov		edx, 1						; Reset the occurances counter
add		eax, 4						; Point eax to the next spot in the counts array
mov		[ebp + 16], eax				; Save that value to the Array_Count variable in the stack
pop		esi							; Point esi back to the spot we were in Random_Array
jmp		End_Final					; Jump to the end of the loop

Equal_Numbs:
inc		edx							; Add 1 to our occurances counter

End_Final:
add		esi, 4						; Move to the next integer in Random_Array
loop	List_Counter

push	esi							; This takes the count of the final integer and puts it at the end of the counts array
mov		eax, [ebp + 16]
mov		esi, [ebp + 4]
mov		[esi + eax], edx
mov		eax, [ebp + 16]
mov		edx, 1
add		eax, 4
mov		[ebp + 16], eax
pop		esi

	ret
countList			ENDP

; End Program
END main