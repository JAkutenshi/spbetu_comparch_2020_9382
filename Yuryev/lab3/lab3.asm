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
	shl bx, 1	; bx = 8I
	sub ax, bx	; ax = 2I - 8I = -6I
	add ax, 4
	mov I1, ax
	jmp f_2
	
f1_1:
	mov bx, I
	add ax, bx	; ax = 2I + I = 3I
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
	add ax, 5
	mov I2, ax
	jmp f_3
	
f2_2:
	add ax, I
	neg ax
	add ax, 10
	mov I2, ax
	
f_3:
	mov ax, I1
	mov bx, I2
	mov si, 0
	cmp si, K
	jg f3
	jmp f3_2 
	

f3:
	neg bx;
	add bx, 10
	cmp ax, bx
	jg maxI1
	jmp maxI2
	
	
f3_2: 
	sub ax, bx
	cmp ax, 0
	jge maxI1
	neg ax
	
	
	
maxI1:
	mov RES, ax
	jmp f_end
	
maxI2:
	mov RES, bx
	jmp f_end

		
f_end:
	mov  ah, 4ch
	int  21h  


 
Main      ENDP
CODE      ENDS
END Main
	

	
	
	
		
