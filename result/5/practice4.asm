section .data
    prompt db "Enter number: ", 0
    prompt_len equ $ - prompt

    newline db 10

section .bss

    input resb 16
    num resd 1
    sum resd 1
    len resd 1
    buffer resb 16

section .text
    global _start

_start:


    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 16
    int 0x80


    mov esi, input
    xor eax, eax

atoi_loop:
    mov bl, [esi]
    cmp bl, 10
    je atoi_done

    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx

    inc esi
    jmp atoi_loop

atoi_done:
    mov [num], eax


    mov eax, [num]
    mov dword [sum], 0
    mov dword [len], 0


calc_loop:
    cmp eax, 0
    je calc_done

    xor edx, edx
    mov ebx, 10
    div ebx

    add [sum], edx
    inc dword [len]

    jmp calc_loop

calc_done:


    mov eax, [sum]
    call itoa

    mov edx, eax
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80


    mov eax, [len]
    call itoa

    mov edx, eax
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80


    mov eax, 1
    xor ebx, ebx
    int 0x80



itoa:
    mov edi, buffer
    add edi, 15

    mov ecx, 0

itoa_loop:
    xor edx, edx
    mov ebx, 10
    div ebx

    add dl, '0'
    dec edi
    mov [edi], dl

    inc ecx

    cmp eax, 0
    jne itoa_loop

    mov esi, edi
    mov edi, buffer

copy_loop:
    cmp ecx, 0
    je copy_done

    mov al, [esi]
    mov [edi], al

    inc esi
    inc edi
    dec ecx
    jmp copy_loop

copy_done:
    mov eax, edi
    sub eax, buffer
    ret
