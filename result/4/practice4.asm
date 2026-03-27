section .data
    newline db 10

section .bss
    buffer resb 32        
    result resb 32        

section .text
    global _start

_start:


    mov eax, 3            
    mov ebx, 0            
    mov ecx, buffer
    mov edx, 32
    int 0x80


    mov esi, buffer       
    xor eax, eax          
    xor ebx, ebx

parse_loop:
    mov bl, [esi]         
    cmp bl, 10            
    je parse_done

    cmp bl, '0'
    jl parse_done
    cmp bl, '9'
    jg parse_done

    sub bl, '0'           
    mov ecx, eax
    mov eax, 10
    mul ecx               
    add eax, ebx          


    inc esi
    jmp parse_loop

parse_done:


    mov ecx, result + 31  
    mov byte [ecx], 0

convert_loop:
    dec ecx
    xor edx, edx
    mov ebx, 10
    div ebx               

    add dl, '0'
    mov [ecx], dl

    cmp eax, 0
    jne convert_loop


    mov eax, 4            
    mov ebx, 1            
    mov edx, result + 31
    sub edx, ecx          
    mov ecx, ecx
    int 0x80

    
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80


    mov eax, 1
    xor ebx, ebx
    int 0x80
