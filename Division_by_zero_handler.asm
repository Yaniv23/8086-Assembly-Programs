;--------------------------------------------------
; Division by zero handler for 8086
; Installs a custom handler for INT 0 (divide by zero)
; Prompts user for a number, divides 2 by input, and prints error if input is zero
;--------------------------------------------------

.model small
.stack 100h

.data
print_error db "you can't divide by zero!!!",13,10,'$' ; Error message for division by zero
msg_num     db "Enter a number:$"                        ; Prompt for user input
old_int0_off dw ?                                       ; To save original INT 0 offset
old_int0_seg dw ?                                       ; To save original INT 0 segment

;----------------------
; Code Segment
;----------------------
.code
start:
    mov ax, @data                ; Set up data segment
    mov ds, ax

    ; Get original INT 0 (divide by zero) handler
    mov ah, 35h                  ; DOS: Get interrupt vector
    mov al, 0                    ; Interrupt 0 (divide by zero)
    int 21h
    mov [old_int0_off], bx       ; Save original offset
    mov [old_int0_seg], es       ; Save original segment

    ; Install custom INT 0 handler (error_msg)
    push ds                      ; Save DS
    mov ah, 25h                  ; DOS: Set interrupt vector
    mov al, 0                    ; Interrupt 0
    lea dx, error_msg            ; Offset of new handler
    push cs
    pop ds                       ; Set DS = CS for handler address
    int 21h                      ; Install handler
    pop ds                       ; Restore DS

    ; Prompt user for a number
    lea dx, msg_num
    call print_string

    ; Read a single digit from user
    mov ah, 01h                  ; DOS: Read character
    int 21h
    sub al, '0'                  ; Convert ASCII to number
    mov bl, al                   ; Store in BL

    ; Try to divide 2 by user input (triggers handler if input is 0)
    mov al, 2
    div bl

    ; Restore original INT 0 handler before exit
    mov ah, 25h                  ; DOS: Set interrupt vector
    mov al, 0                    ; Interrupt 0
    mov dx, [old_int0_off]       ; Restore offset
    mov ds, [old_int0_seg]       ; Restore segment
    int 21h

    mov ax, 4C00h                ; Exit program
    int 21h

;----------------------
; print_string procedure
;----------------------
print_string proc
    mov ah, 09h
    int 21h
    ret
print_string endp

;----------------------
; Custom division by zero handler
;----------------------
error_msg proc
    lea dx, print_error          ; Load error message
    call print_string
    iret                         ; Return from interrupt
error_msg endp

END start
