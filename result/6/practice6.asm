section .data
    
    msg_signed db "SIGNED: ", 0
    msg_unsigned db "UNSIGNED: ", 0
    msg_max_s db "MAX SIGNED: ", 0
    msg_max_u db "MAX UNSIGNED: ", 0

    lt db "a < b", 10, 0
    eq db "a = b", 10, 0
    gt db "a > b", 10, 0

    newline db 10, 0

section .bss
    a resd 1
    b resd 1
    buf resb 12      

section .text
    global _start


print:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret


itoa:
    mov ecx, buf + 11
    mov byte [ecx], 0
    mov ebx, 10
    mov edi, ecx

.convert:
    dec ecx
    xor edx, edx
    div ebx
    add dl, '0'
    mov [ecx], dl
    test eax, eax
    jnz .convert

    mov eax, ecx        
    mov edx, edi
    sub edx, ecx        
    ret


cmp_signed:
    mov eax, [a]
    mov ebx, [b]
    cmp eax, ebx

    jl .less
    jg .greater
    je .equal

.less:
    mov ecx, lt
    mov edx, 6
    call print
    ret

.greater:
    mov ecx, gt
    mov edx, 6
    call print
    ret

.equal:
    mov ecx, eq
    mov edx, 6
    call print
    ret


cmp_unsigned:
    mov eax, [a]
    mov ebx, [b]
    cmp eax, ebx

    jb .less
    ja .greater
    je .equal

.less:
    mov ecx, lt
    mov edx, 6
    call print
    ret

.greater:
    mov ecx, gt
    mov edx, 6
    call print
    ret

.equal:
    mov ecx, eq
    mov edx, 6
    call print
    ret


max_signed:
    mov eax, [a]
    mov ebx, [b]
    cmp eax, ebx

    jg .a_max
    mov eax, ebx
    ret

.a_max:
    ret


max_unsigned:
    mov eax, [a]
    mov ebx, [b]
    cmp eax, ebx

    ja .a_max
    mov eax, ebx
    ret

.a_max:
    ret


_start:

    
    mov dword [a], -5
    mov dword [b], 3

    
    mov ecx, msg_signed
    mov edx, 8
    call print
    call cmp_signed

    
    mov ecx, msg_unsigned
    mov edx, 10
    call print
    call cmp_unsigned

    
    mov ecx, msg_max_s
    mov edx, 12
    call print

    call max_signed
    call itoa
    mov ecx, eax
    call print

   
    mov ecx, newline
    mov edx, 1
    call print

    
    mov ecx, msg_max_u
    mov edx, 14
    call print

    call max_unsigned
    call itoa
    mov ecx, eax
    call print

    
    mov ecx, newline
    mov edx, 1
    call print

    
    mov eax, 1
    xor ebx, ebx
    int 0x80
