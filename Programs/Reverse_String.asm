;========================================================
; Program: Reverse String on 8086
;
; Description:
;   - Get string input (max 20 characters)
;   - Use two-pointer "palindrome logic" to reverse the string
;   - Swap characters from both ends moving toward center
;   - Print the reversed string
;========================================================

.model small
.stack 100h

.data
    Prompt        db 'Enter a string (max 20 chars):', 13, 10, '$'
    Output_msg    db 'Reversed string:', 13, 10, '$'
    newline       db 13, 10, '$'
    Input_buffer  db 21, 0, 21 dup(0)           ; Input buffer for DOS (max 20 chars)

.code
start:
    ; Initialize data segment
    mov     ax, @data
    mov     ds, ax

    ; Prompt user for input
    mov     ah, 09h
    lea     dx, Prompt
    int     21h

    ; Read input 
    mov     ah, 0Ah
    lea     dx, Input_buffer
    int     21h

    ; Load input length and check if empty
    mov     cl, Input_buffer[1]     ; CL = input length
    xor     ch, ch                  ; Clear CH → CX = length
    cmp     cx, 0
    je      print_empty             ; If empty string, skip reversal

    ; Set pointers for reversal
    lea     si, Input_buffer + 2    ; SI = start of input
    mov     bx, si                  ; BX = start pointer
    lea     di, Input_buffer + 2
    add     di, cx                  ; DI → one past last char ('$')
    dec     di                      ; DI = end pointer

reverse_loop:
    cmp     bx, di
    jae     reversal_done           ; If BX ≥ DI → done

    ; Swap characters at BX and DI
    mov     al, [bx]                ; Load character from start
    mov     ah, [di]                ; Load character from end
    mov     [bx], ah                ; Store end char at start position
    mov     [di], al                ; Store start char at end position

    inc     bx
    dec     di
    jmp     reverse_loop

reversal_done:
    ; Add string terminator at end
    lea     bx, Input_buffer + 2
    add     bx, cx
	mov dl, '$'         ; Put '$' character in DL
	mov [bx], dl        ; Store it at the end of the string

    ; Print newline
    mov     ah, 09h
    lea     dx, newline
    int     21h

    ; Print output label
    mov     ah, 09h
    lea     dx, Output_msg
    int     21h

    ; Print reversed string
    mov     ah, 09h
    lea     dx, Input_buffer + 2  ; Start of reversed string
    int     21h
    jmp     exit_program

print_empty:
    ; Handle empty string input
    mov     ah, 09h
    lea     dx, Output_msg
    int     21h

    mov     ah, 09h
    lea     dx, newline
    int     21h

exit_program:
    ; Exit to DOS
    mov     ah, 4Ch
    int     21h

end start
