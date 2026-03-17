SECTION .data
    buffer db 6 dup('0')   
    newline db 10          

SECTION .bss

SECTION .text
    global _start

_start:

  
    mov ax, 57920          
    mov ecx, 6             
    mov edi, buffer
    add edi, 5             

    
convert_loop:
    xor dx, dx             
    mov bx, 10
    div bx                

    add dl, '0'            
    mov [edi], dl          

    dec edi
    loop convert_loop

    
    mov eax, 4             
    mov ebx, 1             
    mov ecx, buffer
    mov edx, 6             
    int 0x80

   
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

   
    mov eax, 1             
    xor ebx, ebx
    int 0x80
