AStack SEGMENT STACK 
         DW       12 DUP(?)
AStack	ENDS

DATA  SEGMENT				;SEG DATA
    a	    DW	1
    b	    DW	1
    i	    DW	0
    k       DW  0
    i1      DW  ?
    i2      DW  ?
    res     DW  ?
DATA	ENDS								;ENDS DATA

CODE      SEGMENT   						;SEG CODE
ASSUME  DS:DATA, CS:CODE, SS:AStack
 	
Main    PROC  FAR
    	push ds
	sub ax, ax
	push ax
	mov ax, DATA
	mov ds, ax
	mov ax, a
	cmp ax, b
jle f3
	mov ax, i ; f3_2
	shl ax, 1 ; i*4
	shl ax, 1 ; i*4
	neg ax
	add ax, 7
	mov i1, ax
	jmp f7_1
f3:
	mov ax, i ; f3_1
	shl ax, 1 ; i*4
	shl ax, 1 ;
	mov cx, i ;
	shl cx, 1 ; i*2
	add ax, cx; i*6
	neg ax
	add ax, 8 ;
	mov i1, ax;
	jmp f7_2
f7_1:
	mov ax, i ;
	shl ax, 1 ; i*4
	shl ax, 1 ;
	sub ax, 5 ;
	neg ax
	mov i2, ax
	jmp f5
f7_2:
	mov ax, i ;
	shl ax, 1 ; i*2
	add ax, i ; i*3
	neg ax    ; -i*3
	add ax, 10;
	mov i2, ax
	jmp f5
f5:
	mov ax, k
  	cmp k, 0
jne f5_2	  ; if k<>0
	mov ax, i1
	cmp ax, 6
jle i1_6 
  	mov res, 6   
	jmp f_end
i1_6:
	mov ax, i1
	mov res, ax
	jmp f_end
f5_2:
	mov ax, i1
	cmp i1, 0
jl i1_neg ; i1<0
f_5_2_2:
	mov ax, i2
	cmp i2, 0
jl i2_neg ; i2<0
	jmp f_res
i1_neg:
	neg i1
	jmp f_5_2_2
i2_neg:
	neg i2	
f_res:
	mov ax, i1
	add res, ax
	mov ax, i2
	add res, ax
f_end: 
	mov ah, 4ch
	int 21h

Main      ENDP
CODE      ENDS
END Main				;ENDS CODE
