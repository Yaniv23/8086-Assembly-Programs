; =============================================
; Program: Get 10 numbers from user, sum evens
; Only valid 0–255 inputs are summed
; Even numbers are detected using a MASK (TEST)
; =============================================

.model small
.stack 100h

.data
    Prompt        db 'Enter a number (0-255):', 13, 10, '$'
    output_msg    db 'Sum of even numbers:', 13, 10, '$'
    newline       db 13, 10, '$'

    Input_buffer  db 4, 0, 4 dup(0)         ; DOS input buffer
    Num_array     db 10 dup(0)              ; store up to 10 numbers

.code
start:
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Initialize variables
    mov cx, 10             ; loop counter: 10 numbers
    xor bx, bx             ; array index
    xor si, si             ; sum of even numbers

input_loop:
    ; Prompt user
    mov ah, 09h
    lea dx, Prompt
    int 21h

    ; Read input string
    mov ah, 0Ah
    lea dx, Input_buffer
    int 21h

    ; Convert input string to number in AX
    call string_to_number

    ; Validate number range (0–254)
    cmp ax, 0
    jb not_count
    cmp ax, 255
    jge not_count

    ; Check even using bitmask
    jmp even_check

continue:
    ; Prepare for next input
    lea dx, newline
    mov ah, 09h
    int 21h

    loop input_loop        ; repeat until 10 entries
    jmp done

; ---------------------------------------------
; Convert ASCII string to number in AX
; ---------------------------------------------
string_to_number:
    push bx
    push cx
    push dx

    xor ax, ax                     ; result
    mov cl, Input_buffer[1]        ; input length
    cmp cl, 0
    je string_done                 ; empty = 0

    xor bx, bx                     ; index

string_loop:
    mov dl, Input_buffer[bx + 2]
    cmp dl, '0'
    jl string_error
    cmp dl, '9'
    jg string_error

    sub dl, '0'                    ; ASCII → digit

    push dx
    mov dx, 10
    mul dx                         ; AX *= 10
    pop dx
    add ax, dx                     ; AX += digit

    inc bx
    dec cl
    jnz string_loop
    jmp string_done

string_error:
    mov ax, 0                      ; invalid → 0

string_done:
    pop dx
    pop cx
    pop bx
    ret

; ---------------------------------------------
; Check if AX is even using TEST
; If even → store in array
; ---------------------------------------------
even_check:
    ;we can also use a regular mask, make a AND instr
    ;betwen the number and x"1"
    ;but here we use a simple check
    test al, 1
    jnz not_count                  ; odd → skip

add_to_array:
    mov Num_array[bx], al
    inc bx
    jmp continue

not_count:
    mov Num_array[bx], 0           ; mark as invalid
    inc bx
    jmp continue

; ---------------------------------------------
; Sum the even numbers from Num_array
; Result in BH
; ---------------------------------------------
sum_array:
    xor bx, bx
    xor ax, ax

sum_loop:
    mov al, Num_array[bx]
    add ah, al
    inc bx
    cmp bx, 10
    jl sum_loop

    mov bh, ah                     ; save sum
    xor ax, ax
    ret

; ---------------------------------------------
; Print the number in BH as decimal
; ---------------------------------------------
print_number:
    push ax
    mov al, bh
    mov cx, 0
    mov bx, 10
    xor ah, ah

convert_loop:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    test ax, ax
    jnz convert_loop

print_loop:
    pop dx
    mov ah, 02h
    int 21h
    loop print_loop

    pop ax
    ret

; ---------------------------------------------
; Display done message and print result
; ---------------------------------------------
done:
    call sum_array

    mov ah, 09h
    lea dx, output_msg
    int 21h

    call print_number

    ; Exit to DOS
exit_program:
    mov ah, 4Ch
    int 21h

end start
