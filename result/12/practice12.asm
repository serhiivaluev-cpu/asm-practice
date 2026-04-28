section .data
    msg1 db "Enter text: ", 0
    len1 equ $ - msg1

    msg2 db "Enter pattern: ", 0
    len2 equ $ - msg2

    nl db 10

section .bss
    text resb 256
    pattern resb 64
    first resd 1

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, text
    mov edx, 200
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, pattern
    mov edx, 50
    int 0x80

    mov esi, text
clean_text:
    mov al, [esi]
    cmp al, 10
    je zero_text
    cmp al, 0
    je done_clean_text
    inc esi
    jmp clean_text
zero_text:
    mov byte [esi], 0
done_clean_text:

    mov esi, pattern
clean_pat:
    mov al, [esi]
    cmp al, 10
    je zero_pat
    cmp al, 0
    je done_clean_pat
    inc esi
    jmp clean_pat
zero_pat:
    mov byte [esi], 0
done_clean_pat:

    mov esi, text
    call strlen
    mov ebx, eax

    mov esi, pattern
    call strlen
    mov ecx, eax

    cmp ecx, 0
    je empty_pattern

    xor edi, edi
    mov dword [first], -1
    xor eax, eax

outer:
    mov edx, ebx
    sub edx, ecx
    cmp edi, edx
    jg done

    push edi
    mov esi, text
    add esi, edi
    mov edi, pattern

inner:
    mov bl, [esi]
    mov dl, [edi]
    cmp dl, 0
    je match

    cmp bl, dl
    jne nomatch

    inc esi
    inc edi
    jmp inner

match:
    pop edi
    cmp dword [first], -1
    jne skip_first
    mov [first], edi
skip_first:
    inc eax
    add edi, ecx
    jmp outer

nomatch:
    pop edi
    inc edi
    jmp outer

done:
    mov ebx, eax
    mov eax, [first]
    call print_int
    call print_nl
    mov eax, ebx
    call print_int
    jmp exit

empty_pattern:
    mov eax, -1
    call print_int
    call print_nl
    mov eax, 0
    call print_int

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

strlen:
    xor eax, eax
.len:
    cmp byte [esi+eax], 0
    je .done
    inc eax
    jmp .len
.done:
    ret

print_int:
    mov ecx, text+220
    mov ebx, 10

    cmp eax, 0
    jge .pos
    neg eax
    mov byte [ecx], '-'
    inc ecx

.pos:
    mov edi, ecx

.conv:
    xor edx, edx
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz .conv

    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, text+220
    sub edx, edi
    int 0x80
    ret

print_nl:
    mov eax, 4
    mov ebx, 1
    mov ecx, nl
    mov edx, 1
    int 0x80
    ret
