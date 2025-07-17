; get 10 numbers from user and store them in an array
;write a function who adds the even numbers in the array
;to determine if a number is even, use MASK 
;print the result
;you have to check the input numbers for validity , if the number is not valid you dont have to add it to the array
;write me this code for an 8086 processor

.model small
.stack 100h

.data
    Prompt db 'Enter a number (0-255):',13,10,'$' 
    output_msg db 'Sum of even numbers:',13,10,'$'
    Input_buffer db 3, 0, 4 dup(0) ; buffer for input (max 3 digits + enter) 
    Num_array db 10 dup(0) ; array to store numbers
    Result db 0 ; variable to store the sum of even numbers

.code
start:
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Initialize variables
    mov cx, 10 ; loop counter for 10 numbers
    xor bx, bx ; index for Num_array
    xor si, si ; sum of even numbers
input_loop:
    ; Prompt user for input
    mov ah, 09h
    lea dx, Prompt
    int 21h

    ; Read string from user
    mov ah, 0Ah ; function to read string input
    lea dx, Input_buffer
    int 21h
    
    ; Convert string to number
    call string_to_number
    
    ; Check if the number is valid (0-255)
    cmp ax, 0
    jl continue ; if less than 0, invalid input    
    cmp ax, 255
    jg continue ; if greater than 255, invalid input

    ; Store in AL for even check
    mov al, al  ; AX already contains the number
    
    ;check if the number is even
    call even_check
    continue:
    loop input_loop ; continue loop until 10 numbers are entered
    
    ; Print the result
    mov ah, 09h
    lea dx, output_msg
    int 21h
    mov ax, si ; move sum of even numbers to AX
    call print_number ; call function to print the number in AX
    ; Exit to DOS 
    exit_program:
    mov ah, 4Ch 
    int 21h

; Function to convert string to number
string_to_number:
    push bx
    push cx
    push dx
    
    xor ax, ax ; result = 0
    mov cl, Input_buffer[1] ; get actual length of input
    cmp cl, 0
    je string_done ; if empty input, return 0
    
    xor bx, bx ; index = 0
string_loop:
    mov dl, Input_buffer[bx + 2] ; get character from buffer (skip first 2 bytes)
    cmp dl, '0'
    jl string_error ; invalid character
    cmp dl, '9'
    jg string_error ; invalid character
    
    sub dl, '0' ; convert ASCII to digit
    
    ; Multiply current result by 10 and add new digit
    push dx ; save new digit
    mov dx, 10
    mul dx ; ax = ax * 10
    pop dx ; restore digit
    add ax, dx ; add new digit to result
    
    inc bx
    dec cl
    jnz string_loop
    jmp string_done
    
string_error:
    mov ax, 0FFFFh ; return -1 for error
    
string_done:
    pop dx
    pop cx
    pop bx
    ret


    
    ;add valid number to array
even_check:
    ;we can also use a regular mask, make a AND instr 
    ;betwen the number and x"1"  
    ;but here we use a simple check
    TEST al, 1 ; Make mask to check if even
    jz add_to_array ; if even, add to array
    ret ; if odd, return without adding
add_to_array:
    mov Num_array[bx], al ; store the number in the array
    add si, ax ; si accumulates the sum of even numbers (use ax to avoid issues)
    inc bx ; increment index for next number
    ret ; return to input loop
print_number:
    ; Function to print the number in AX
    ; Convert number in AX to string and print it
    push ax
    mov cx, 0 ; digit counter
    mov bx, 10 ; divisor for decimal conversion
    convert_loop:
        xor dx, dx ; clear DX for division
        div bx ; divide AX by 10
        add dl, '0' ; convert remainder to ASCII
        push dx ; save digit on stack
        inc cx ; increment digit counter
        test ax, ax ; check if AX is zero
        jnz convert_loop ; continue until AX is zero
        ; Print digits in reverse order
    print_loop:
        pop dx ; get digit from stack
        mov ah, 02h ; function to print character
        int 21h ; print character
        loop print_loop ; repeat for all digits
    pop ax ; restore AX
    ret ; return from function

end start