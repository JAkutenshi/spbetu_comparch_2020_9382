AStack SEGMENT STACK
    DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
a DW 1
b DW 1
i DW 1
k DW -1
i1 DW 0
i2 DW 0
res DW 0

DATA ENDS


CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR

mov ax, DATA
mov ds, ax


f1:
    mov ax, a
    cmp ax, b
    jle f1_1 ; a <= b
    jmp f1_0 ; a > b

f1_0:
    mov ax, i
    add ax, ax; i*2
    mov bx, 15; 15
    xchg bx, ax
    sub ax, bx

    mov i1, ax      
    jmp f2

f1_1:

    mov ax, i
    mov bx, ax
    shl ax, 1; i*3
    add ax, bx
    mov bx, 4; 4
    add ax, bx

    mov i1, ax
      
    jmp f2   

f2:
    mov ax, a
    cmp ax, b
    jle f2_1 ; a <= b
    jmp f2_0 ; a > b

f2_0:
    mov ax, i
    shl ax, 1; i*4
    shl ax, 1; i*4
    mov bx, 7; 7
    xchg ax, bx
    sub ax, bx

    mov i2, ax
      
    jmp f3
f2_1:
    mov ax, i
    mov bx, ax
    shl ax, 1; i*6
    add ax, bx
    shl ax, 1; i*6
    mov bx, 8; 8
    xchg ax, bx
    sub ax, bx

    mov i2, ax
      
    jmp f3
f3:
    mov ax, k;
    cmp k, 0
    jge f3_0 ; k >= 0
    jmp f3_1 ; k < 0
f3_1:

    mov ax, i2
    mov bx, 10; 10
    xchg ax, bx
    sub ax, bx

    cmp i1, ax;
    jae res1 ; >=
    
    mov res, ax

    jmp endLL
    res1:
    mov ax, i1
    mov res, ax
    jmp endLL    
f3_0:
    mov ax, i1;
    mov bx, i2;
    sub ax, bx

    cmp ax, 0
    jl f3_0_abs

    mov res, ax
    
    jmp endLL

f3_0_abs:

    neg ax
    
    mov res, ax
    jmp endLL

endLL:
    
    mov bx, res
    mov ah, 4ch
    int 21h
 
Main ENDP
CODE ENDS
    END Main