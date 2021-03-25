AStack SEGMENT STACK
    DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
a DW 2
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


push ds
sub ax,ax
push ax
mov ax, data
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
    jmp f2_0

f1_1:

    mov ax, i
    mov bx, ax
    shl ax, 1; i*3
    add ax, bx
    add ax, 4

    mov i1, ax
      
    jmp f2_1   


f2_0:
    mov ax, i1
    shl ax, 1; 30 - 4i

    sub ax, 23 ; 7 - 4i

    mov i2, ax
      
    jmp f3


f2_1:
    mov ax, i1
    shl ax, 1; 6i+8
    neg ax
    add ax, 16

    mov i2, ax
      
    jmp f3


f3:
    cmp k, 0
    jge f3_0 ; k >= 0
    jmp f3_1 ; k < 0
f3_1:

    mov ax, i2
	
    sub ax, 10

    neg ax

    cmp i1, ax;
    jge res1 ; >=

    jmp endLL

    res1:
    mov ax, i1

    jmp endLL    
f3_0:
    mov ax, i1;
    sub ax, i2

    cmp ax, 0
    jl f3_0_abs
    
    jmp endLL

f3_0_abs:

    neg ax
    
    jmp endLL

endLL:

    mov res, ax
    mov bx, res    
    mov ah, 4ch
    int 21h
 
Main ENDP
CODE ENDS
    END Main