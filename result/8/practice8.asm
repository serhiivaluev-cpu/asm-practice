section .data
    space db ' '
    nl db 10

section .bss
    buffer resb 1024
    array resd 100
    idx resd 100

section .text
    global _start

_start:
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 1024
    int 0x80

    mov esi, buffer
    call read_int
    mov ecx, eax

    xor edi, edi

read_loop:
    cmp edi, ecx
    jge read_target
    call read_int
    mov [array + edi*4], eax
    inc edi
    jmp read_loop

read_target:
    call read_int
    mov ebx, eax

    xor edi, edi
    xor edx, edx
    mov eax, -1

search_loop:
    cmp edi, ecx
    jge print_result

   mov eax, [array + edi*4]
cmp eax, ebx
    jne next

    cmp eax, -1
    jne store
    mov eax, edi

store:
    mov [idx + edx*4], edi
    inc edx

next:
    inc edi
    jmp search_loop

print_result:
    push eax
    call print_int
    add esp, 4

    mov eax, 4
    mov ebx, 1
    mov ecx, nl
    mov edx, 1
    int 0x80

    push edx
    call print_int
    add esp, 4

    mov eax, 4
    mov ebx, 1
    mov ecx, nl
    mov edx, 1
    int 0x80

    xor edi, edi

print_loop:
    cmp edi, edx
    jge exit

    mov eax, [idx + edi*4]
    push eax
    call print_int
    add esp, 4

    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 0x80

    inc edi
    jmp print_loop

exit:
    mov eax, 4
    mov ebx, 1
    mov ecx, nl
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80


read_int:
    xor eax, eax

skip_ws:
    mov bl, [esi]
    cmp bl, ' '
    je incp
    cmp bl, 10
    je incp
    cmp bl, 0
    je done
    jmp conv

incp:
    inc esi
    jmp skip_ws

conv:
    xor eax, eax

loop_r:
    mov bl, [esi]
    cmp bl, '0'
    jl done
    cmp bl, '9'
    jg done

    imul eax, eax, 10
    sub bl, '0'
    movzx ebx, bl
    add eax, ebx

    inc esi
    jmp loop_r

done:
    ret


print_int:
    mov eax, [esp+4]

    mov ecx, buffer
    add ecx, 1023
    mov byte [ecx], 0

    mov ebx, 10
    xor edi, edi

    cmp eax, 0
    jge start

    neg eax
    mov edi, 1

start:
    cmp eax, 0
    jne loop

    dec ecx
    mov byte [ecx], '0'
    jmp print

loop:
    xor edx, edx
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    cmp eax, 0
    jne loop

print:
    cmp edi, 0
    je out
    dec ecx
    mov byte [ecx], '-'

out:
    mov eax, 4
    mov ebx, 1
    mov edx, buffer
    add edx, 1023
    sub edx, ecx
    int 0x80

    ret
