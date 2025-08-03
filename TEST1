;write an assembly 8086 code who deal with zero division error
;if we try to divete by zero the user will get the nessage " You can't divide by zero!!!"
;save the original function from the interrupt table(its the min addres in the memory)
;write a code who get input from user and try to divide by a constant number

.model small
.stack 100h
.data
    divide_by_zero_msg db 13,10, 'You can''t divide by zero!!!', 13, 10, '$'

.code
start:
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Save original interrupt vector for division by zero
    mov ah, 35h  ; Get interrupt vector
    mov al, 0
    int 21h
    ;change the vector to our custom handler
    mov ah, 25h  ; Set interrupt vector
    mov al, 0     ; Interrupt number for division by zero
    mov dx, offset new_divide_by_zero ; address of new interrupt  
    push seg new_divide_by_zero
    int 21h ; set the new interrupt 
    
    ;try to divide by zero
    mov ax, 10    ; Initialize dividend
    mov cl, 0     ; Set divisor to zero
    div cl        ; This will trigger interrupt 0
    ;
    mov ah, 25h  ; Restore original interrupt vector
    mov al, 0
    mov dx, bx
    push es 
    pop ds
    int 21h
exit:
    ; Exit program
    mov ax, 4C00h
    int 21h

 ;description
new_divide_by_zero proc
    push ax
    push dx
    push ds
    
    mov ax, @data    ; Set up data segment
    mov ds, ax
    
    lea dx, divide_by_zero_msg
    mov ah, 09h
    int 21h
    
    pop ds
    pop dx
    pop ax
    iret             ; Return from interrupt
new_divide_by_zero endp
end start