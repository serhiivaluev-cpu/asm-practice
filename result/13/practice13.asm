section .data
    msgN db "Enter n:",10
    lenMsgN equ $-msgN

    msgOrig db 10,"Original array:",10
    lenMsgOrig equ $-msgOrig

    msgRev db 10,"Reversed array:",10
    lenMsgRev equ $-msgRev

    msgYes db 10,"PALINDROME: YES",10
    lenMsgYes equ $-msgYes

    msgNo db 10,"PALINDROME: NO",10
    lenMsgNo equ $-msgNo

    space db " "
    nl db 10

section .bss
    buf resb 32
    outbuf resb 16

    n resd 1

    arr resd 200
    copyArr resd 200
    revArr resd 200

section .text
    global _start

; =====================================
; parse
; =====================================
read_int:
    push esi

    mov eax,3
    mov ebx,0
    mov ecx,buf
    mov edx,32
    int 0x80

    xor eax,eax
    mov esi,buf

.next:
    movzx ebx,byte [esi]

    cmp bl,10
    je .done

    cmp bl,13
    je .done

    cmp bl,0
    je .done

    sub ebx,'0'
    imul eax,eax,10
    add eax,ebx

    inc esi
    jmp .next

.done:
    pop esi
    ret

; =====================================
; I/O
; =====================================
print_str:
    mov eax,4
    mov ebx,1
    int 0x80
    ret

; =====================================
; I/O
; =====================================
print_int:
    mov edi,outbuf+15
    mov byte [edi],0

    cmp eax,0
    jne .convert

    dec edi
    mov byte [edi],'0'
    jmp .print

.convert:
    mov ebx,10

.loop:
    xor edx,edx
    div ebx

    add dl,'0'

    dec edi
    mov [edi],dl

    test eax,eax
    jnz .loop

.print:
    mov eax,4
    mov ebx,1
    mov ecx,edi
    mov edx,outbuf+15
    sub edx,edi
    int 0x80

    ret

_start:

; =====================================
; I/O
; =====================================
    mov ecx,msgN
    mov edx,lenMsgN
    call print_str

    call read_int
    mov [n],eax

; =====================================
; loops
; =====================================
    xor esi,esi

read_loop:
    cmp esi,[n]
    jge read_done

    call read_int
    mov [arr+esi*4],eax

    inc esi
    jmp read_loop

read_done:

; =====================================
; memory
; копіювання масиву
; =====================================
    xor esi,esi

copy_loop:
    cmp esi,[n]
    jge copy_done

    mov eax,[arr+esi*4]
    mov [copyArr+esi*4],eax

    inc esi
    jmp copy_loop

copy_done:

; =====================================
; memory
; реверс масиву
; =====================================
    xor esi,esi

rev_loop:
    cmp esi,[n]
    jge rev_done

    mov eax,[n]
    dec eax
    sub eax,esi

    mov ebx,[copyArr+eax*4]
    mov [revArr+esi*4],ebx

    inc esi
    jmp rev_loop

rev_done:

; =====================================
; I/O
; вивід оригіналу
; =====================================
    mov ecx,msgOrig
    mov edx,lenMsgOrig
    call print_str

    xor esi,esi

print_orig:
    cmp esi,[n]
    jge print_orig_done

    mov eax,[arr+esi*4]
    call print_int

    mov eax,4
    mov ebx,1
    mov ecx,space
    mov edx,1
    int 0x80

    inc esi
    jmp print_orig

print_orig_done:

; =====================================
; I/O
; вивід реверсу
; =====================================
    mov ecx,msgRev
    mov edx,lenMsgRev
    call print_str

    xor esi,esi

print_rev:
    cmp esi,[n]
    jge print_rev_done

    mov eax,[revArr+esi*4]
    call print_int

    mov eax,4
    mov ebx,1
    mov ecx,space
    mov edx,1
    int 0x80

    inc esi
    jmp print_rev

print_rev_done:

; =====================================
; logic
; перевірка паліндрому
; =====================================
    mov eax,1
    xor esi,esi

pal_loop:
    mov ebx,[n]
    shr ebx,1

    cmp esi,ebx
    jge pal_done

    mov ecx,[n]
    dec ecx
    sub ecx,esi

    mov edx,[arr+esi*4]
    cmp edx,[arr+ecx*4]
    jne not_pal

    inc esi
    jmp pal_loop

not_pal:
    mov eax,0

pal_done:

    cmp eax,1
    je yes_msg

    mov ecx,msgNo
    mov edx,lenMsgNo
    call print_str
    jmp exit_program

yes_msg:
    mov ecx,msgYes
    mov edx,lenMsgYes
    call print_str

exit_program:
    mov eax,1
    xor ebx,ebx
    int 0x80
