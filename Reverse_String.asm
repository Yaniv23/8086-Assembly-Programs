;write an assembly 8086 code who get an input from user and print it in reverse order
;use the logic of polindrome
;use 2 pointer who point at the begining and the end of the string
;change between the 2 pointers and print the string

;========================================================
; Program: Reverse String on 8086

.model small
.stack 100h
.data
    Prompt        db 'Enter a string (max 20 chars):', 13, 10, '$'
    Output_msg    db 'Reversed string:', 13, 10, '$'
    newline       db 13, 10, '$'

    Input_buffer  db 21, 0, 21 dup(0)          ; Input: max 20 chars + CR
    

.code
start:
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Prompt user for input
    mov ah, 09h
    lea dx, Prompt
    int 21h

    ; Read input string
    mov ah, 0Ah
    lea dx, Input_buffer
    int 21h

    ; Prepare for reversing the string
    lea si, Input_buffer + 2   ; SI points to the first character of input
    mov cl, Input_buffer[1]    ; CL = actual length of input string
    xor ch, ch                 ; Clear CH to make CX = CL
    cmp cx, 0                  ; Check if string is empty
    je print_empty             ; If empty, skip reversal
    
    ; Set up two pointers for palindrome-style reversal
    mov bx, si                 ; BX = start pointer (first character)
    lea di, Input_buffer + 2   ; DI = end pointer 
    add di, cx                 ; Move DI to point after last character('$')
    dec di                     ; DI now points to last character
    
reverse_loop:
    ; Check if pointers have crossed (reversal complete)
    cmp bx, di
    jae reversal_done          ; If start >= end, we're done
    
    ; Swap characters at start and end positions
    mov al, [bx]              ; Load character from start
    mov ah, [di]              ; Load character from end
    mov [bx], ah              ; Store end char at start position
    mov [di], al              ; Store start char at end position
    
    ; Move pointers toward center
    inc bx                    ; Move start pointer forward
    dec di                    ; Move end pointer backward
    jmp reverse_loop          ; Continue swapping

reversal_done:
    ; Add string terminator for output
    lea bx, Input_buffer + 2  ; Point to start of string
    add bx, cx                ; Move to end of string
    mov byte ptr [bx], '$'    ; Add string terminator
    
    ; Print newline after input
    mov ah, 09h
    lea dx, newline
    int 21h
    
    ; Print output message
    mov ah, 09h
    lea dx, Output_msg
    int 21h
    
    ; Print reversed string
    mov ah, 09h
    lea dx, Input_buffer + 2  ; Print the modified input buffer
    int 21h
    jmp exit_program

print_empty:
    ; Handle empty string case
    mov ah, 09h
    lea dx, Output_msg
    int 21h
    
    mov ah, 09h
    lea dx, newline
    int 21h

exit_program:
    ; Exit to DOS
    mov ah, 4Ch
    int 21h

end start
    