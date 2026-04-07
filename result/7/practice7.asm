section .data
    msg_in  db "Enter n (5..50): "
    len_in  equ $ - msg_in

    msg_arr db "Array: "
    len_arr equ $ - msg_arr

    msg_min db 10, "Min: "
    len_min equ $ - msg_min

    msg_max db 10, "Max: "
    len_max equ $ - msg_max

    space   db " "
    nl      db 10

section .bss
    arr     resd 50
    buffer  resb 16
    n       resd 1

section .text
    global _start

_start:

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_in
    mov edx, len_in
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 16
    int 0x80

    xor eax, eax
    mov esi, buffer

parse:
    mov bl, [esi]
    cmp bl, 10
    je parsed
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
    inc esi
    jmp parse

parsed:
    mov [n], eax

    cmp eax, 5
    jl exit
    cmp eax, 50
    jg exit

    xor esi, esi
    mov ecx, [n]

fill:
    cmp esi, ecx
    jge filled

    mov eax, esi
    imul eax, esi
    mov ebx, esi
    imul ebx, 3
    sub eax, ebx
    add eax, 7

    mov [arr + esi*4], eax

    inc esi
    jmp fill

filled:

    xor esi, esi
    mov ecx, [n]

    mov eax, [arr]
    mov ebx, [arr]
    mov edi, 0
    mov ebp, 0

find:
    cmp esi, ecx
    jge found

    mov edx, [arr + esi*4]

    cmp edx, eax
    jge check_max
    mov eax, edx
    mov edi, esi

check_max:
    cmp edx, ebx
    jle next
    mov ebx, edx
    mov ebp, esi

next:
    inc esi
    jmp find

found:

    mov [buffer], eax      
    mov [buffer+4], ebx    
    mov [buffer+8], edi    
    mov [buffer+12], ebp   

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_arr
    mov edx, len_arr
    int 0x80

    xor esi, esi
    mov ecx, [n]

print_arr:
    cmp esi, ecx
    jge done_arr

    push ecx
    mov eax, [arr + esi*4]
    call print_num
    pop ecx

    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 0x80

    inc esi
    jmp print_arr

done_arr:

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_min
    mov edx, len_min
    int 0x80

    mov eax, [buffer]
    call print_num

    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 0x80

    mov eax, [buffer+8]
    call print_num

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_max
    mov edx, len_max
    int 0x80

    mov eax, [buffer+4]
    call print_num

    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 0x80

    mov eax, [buffer+12]
    call print_num

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_num:
    push eax
    push ebx
    push ecx
    push edx

    mov ecx, buffer
    add ecx, 15

    mov ebx, 10

.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz .convert

    mov edx, buffer
    add edx, 16
    sub edx, ecx

    mov eax, 4
    mov ebx, 1
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
