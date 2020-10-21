AStack SEGMENT STACK
	DW 32 DUP(?)   			
AStack ENDS
				
DATA SEGMENT				
	A 	DW 4
	B 	DW 2
	I 	DW 1
	K 	DW 3
	I1 	DW ?
	I2 	DW ?
	RES DW ?
DATA ENDS

CODE      SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
	mov  ax, DATA
   	mov  ds, ax
f:
	mov si, A
	mov bx, B
	mov ax, I
	shl ax, 1
	cmp si, bx
	jg f1_1
	jmp f1
	
f1:
	mov bx, I
	shl bx, 1
	shl bx, 1
	shl bx, 1
	sub ax, bx
	add ax, 4
	mov I1, ax
	jmp f_2
	
f1_1:
	mov bx, I
	add ax, bx
	add ax, 6
	mov I1, ax
	jmp f_2
	
f_2:
	mov si, A
	mov bx, B
	mov ax, I
	shl ax, 1
	cmp si, bx
	jg f2
	jmp f2_2
	
f2:
	shl ax, 1
	neg ax
	add ax, 20
	mov I2, ax
	jmp f_3
	
f2_2:
	mov bx, I
	shl bx, 1
	shl bx, 1
	shl bx, 1
	sub ax, bx
	add ax, 6
	mov I1, ax
	jmp f_3
	
f_3:
	mov ax, I1
	mov bx, I2
	mov si, 0
	cmp si, K
	jg f3
	jmp f3_2 
	

f3:
	mov cx, 0
	cmp cx, ax
	jg NEG_AX
	cmp cx, bx
	jg NEG_BX
	add ax, bx
	mov RES, ax
	jmp f_end
	
f3_2: 
	cmp ax, 6
	jg SET_RES_I
	mov si, 6
	cmp si, ax
	jg SET_RES_6
	
NEG_AX:
	neg ax
	jmp f3
	
NEG_BX:
	neg bx
	jmp f3
	
SET_RES_6:
	mov res, 6
	jmp f_end
	
SET_RES_I:
	mov ax, I1
	mov res, ax
		
f_end:
	mov  ah, 4ch		;завершаем программу
	int  21h  


 
Main      ENDP
CODE      ENDS
END Main				;ENDS CODE
	

	
	
	
		