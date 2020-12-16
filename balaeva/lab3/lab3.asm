AStack SEGMENT STACK
	DW 12 DUP(?)   			
AStack ENDS
				
DATA SEGMENT				
	A 	DW 0
	B 	DW 0
	I 	DW 0
	K 	DW -1
	I1 	DW ?
	I2 	DW ?
	RES DW ?
DATA ENDS

CODE      SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:AStack
				
Main PROC FAR
	push  DS
	sub   AX,AX
	push  AX
	mov   AX,DATA
	mov   DS,AX
	mov   BX,I
	sal   BX,1h 
	sal   BX,1  ;4i is needed in both parts
	mov   AX,A
	cmp   AX,B
	jle cond_b

	add BX,3 	;4i + 3
	neg BX
	mov I1,BX
	add BX,23
	mov I2,BX
	jmp f3

cond_b:
	add BX,I
	add BX,I
	sub BX,10  ;6i - 10
	mov I1,BX
	neg BX
	sub BX, 4; BX-4
	mov I2,BX

f3:
skip_abs_1:
	mov AX,K
	cmp AX,0
	jge f3_b
	mov AX,I1
	sub AX, BX
	cmp AX, 0
	jge f3_end
	neg AX
	jmp f3_end
	
f3_b:
	cmp BX, 0
	jge skip_abs_2
	neg bx
skip_abs_2:
	cmp BX,7
	jge max_b
	mov AX, 7
	jmp f3_end
max_b:
	mov AX,BX
f3_end:
	mov RES,AX
    ret
Main ENDP
	CODE      ENDS
	END Main
