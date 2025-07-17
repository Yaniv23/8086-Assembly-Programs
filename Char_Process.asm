
;Plan: 1-get 20 chars from user
;2-check each char
;3-if char is number add it to a sum and 
;4-if char is lower case convert to upper case and add to output
;5-if char is upper case convert to lower case  and add to output 
;6-if char is not letter or number count it
;7-print the output string
;8-print the sum of numbers
;9-print the count of other chars

; ---------------------------------------------
;========================================================
; Program: Character Processor on 8086
;
; Description:
;   1. Get 20 characters from user
;   2. For each character:
;       - Convert lowercase → uppercase
;       - Convert uppercase → lowercase
;       - If digit, sum it
;       - If not a letter/digit, count it
;   3. Print:
;       - Modified output string
;       - Sum of digits
;       - Count of "other" characters
;
; Example Input: "Hello123 Word!"
; Output:
;   hELLO wORD
;   numbers sum : 6
;   other chars amount: 1

;Plan:
;1-get 20 chars from user
;2-check each char
;3-if char is number add it to a sum and 
;4-if char is lower case convert to upper case and add to output
;5-if char is upper case convert to lower case  and add to output 
;6-if char is not letter or number count it
;7-print the output string
;8-print the sum of numbers
;9-print the count of other chars
;========================================================

.model small
.stack 100h

.data
    Prompt        db 'Enter up to 20 characters:', 13, 10, '$'
    sum_msg       db 'numbers sum:', 13, 10, '$'
    other_msg     db 'other chars amount:', 13, 10, '$'
    newline       db 13, 10, '$'

    Input_buffer  db 21, 0, 21 dup(0)          ; Input: max 20 chars + CR
    Output_buffer db 21 dup('$')               ; Output buffer
    Num_sum       db 0                         ; Sum of digits (stored in SI)
    Other_count   db 0                         ; Count of non-alphanumeric chars (stored in DI)

.code
start:
    ; Set up data segment
    mov ax, @data
    mov ds, ax

    ; Prompt user
    lea dx, Prompt
    call print_string

    ; Read up to 20 chars using DOS function 0Ah
    mov ah, 0Ah
    lea dx, Input_buffer
    int 21h

    ; Initialize registers
    xor bx, bx              ; Input index
    xor bp, bp              ; Output index
    xor si, si              ; Sum of digits
    xor di, di              ; Count of other characters

    ; Load input length
    mov cl, Input_buffer[1]
    cmp cl, 0
    je done_processing      ; Skip if no input

;--------------------------------------------------------
; Process each character from Input_buffer
;--------------------------------------------------------
string_loop:
    mov al, Input_buffer[bx + 2]

    cmp al, ' '
    je add_space_to_output

    cmp al, '0'
    jb other_case
    cmp al, '9'
    jbe add_to_sum

    cmp al, 'A'
    jb other_case
    cmp al, 'Z'
    jbe convert_to_lower

    cmp al, 'a'
    jb other_case
    cmp al, 'z'
    jbe convert_to_upper

    jmp other_case

continue_processing:
    inc bx
    dec cl
    jnz string_loop

    ; Terminate output string with $
    push bx
    mov bx, bp
    mov Output_buffer[bx], '$'
    pop bx

    ; Newline after input
    lea dx, newline
    call print_string

    ; Print results
    call print_output_string
    call print_sum
    call print_other_count

done_processing:
    mov ax, 4C00h
    int 21h

;--------------------------------------------------------
; Handle digits: convert and add to SI
;--------------------------------------------------------
add_to_sum:
    sub al, '0'
    xor ah, ah
    add si, ax
    jmp continue_processing

;--------------------------------------------------------
; Convert lowercase → uppercase
;--------------------------------------------------------
convert_to_upper:
    sub al, 32
    call store_output
    jmp continue_processing

;--------------------------------------------------------
; Convert uppercase → lowercase
;--------------------------------------------------------
convert_to_lower:
    add al, 32
    call store_output
    jmp continue_processing

;--------------------------------------------------------
; Handle space character
;--------------------------------------------------------
add_space_to_output:
    call store_output
    jmp continue_processing

;--------------------------------------------------------
; Handle other (non-alphanumeric) character
;--------------------------------------------------------
other_case:
    inc di
    jmp continue_processing

;--------------------------------------------------------
; Store AL into Output_buffer at [bp]
;--------------------------------------------------------
store_output:
    push bx
    mov bx, bp
    mov Output_buffer[bx], al
    inc bp
    pop bx
    ret

;========================================================
; Print string at [dx]
;========================================================
print_string proc
    mov ah, 09h
    int 21h
    ret
print_string endp

;========================================================
; Print a character in DL
;========================================================
print_char proc
    mov ah, 02h
    int 21h
    ret
print_char endp

;========================================================
; Print Output_buffer string
;========================================================
print_output_string:
    lea dx, Output_buffer
    call print_string
    lea dx, newline
    call print_string
    ret

;========================================================
; Print sum of digits stored in SI
;========================================================
print_sum:
    lea dx, sum_msg
    call print_string

    mov ax, si
    call print_number

    lea dx, newline
    call print_string
    ret

;========================================================
; Print count of other characters stored in DI
;========================================================
print_other_count:
    lea dx, other_msg
    call print_string

    mov ax, di
    call print_number

    lea dx, newline
    call print_string
    ret

;========================================================
; Print 16-bit unsigned integer in AX
;========================================================
print_number:
    push ax
    push bx
    push cx
    push dx
    push si

    mov bx, 10
    xor si, si

    cmp ax, 0
    jne convert_loop
    mov dl, '0'
    call print_char
    jmp print_done

convert_loop:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc si
    cmp ax, 0
    jne convert_loop

print_loop:
    pop dx
    call print_char
    dec si
    jnz print_loop

print_done:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

end start
