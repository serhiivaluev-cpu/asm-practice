section .data
    prompt db "Enter height (5..25): ", 0
    prompt_len equ $ - prompt

    newline db 10

section .bss
    input resb 4
    linebuf resb 64

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
    mov edx, 4
    int 0x80

    mov esi, input
    xor eax, eax

parse_loop:
    mov bl, [esi]
    cmp bl, 10
    je parse_done
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
    inc esi
    jmp parse_loop

parse_done:
    mov ebp, eax

    cmp ebp, 5
    jl exit
    cmp ebp, 25
    jg exit

    mov edi, 1

outer_loop:
    cmp edi, ebp
    jg exit

    mov eax, ebp
    sub eax, edi
    mov esi, eax

    mov eax, edi
    shl eax, 1
    sub eax, 1
    mov edx, eax

    mov ecx, linebuf

space_loop:
    cmp esi, 0
    je star_loop
    mov byte [ecx], ' '
    inc ecx
    dec esi
    jmp space_loop

star_loop:
    cmp edx, 0
    je add_newline
    mov byte [ecx], '*'
    inc ecx
    dec edx
    jmp star_loop

add_newline:
    mov byte [ecx], 10
    inc ecx

    mov eax, ecx
    sub eax, linebuf

    push eax
    push linebuf
    call print_line
    add esp, 8

    inc edi
    jmp outer_loop

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_line:
    push ebp
    mov ebp, esp

    mov ecx, [ebp+8]
    mov edx, [ebp+12]

    mov eax, 4
    mov ebx, 1
    int 0x80

    pop ebp
    ret
