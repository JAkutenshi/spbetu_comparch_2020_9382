; Стек программы
AStack SEGMENT STACK
 DW 12 DUP(?)
AStack ENDS
; Данные программы
DATA SEGMENT
; Директивы описания данных
a dw ?
b dw ?
i dw ?
k dw ?
i1 dw ?
i2 dw ?
i3 dw ?

DATA ENDS

CODE SEGMENT
 ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
 push DS
 sub AX,AX
 push AX
 mov AX,DATA
 mov DS,AX
 sub ax,ax
 mov ax,a
 mov bx,b
 mov cx,i
 cmp ax,bx; 
ja above
;a<=b
	add i1,cx
	shl cx,1
	add i1,cx
	mov cx,i1
	add i1,4
	neg cx
	add i2,2
	add i2,cx	
	jmp f3
above:
;a>b 
	add i1,15
	shl cx,1
	add i2,-2
	add i2, cx
	neg cx
	add i1,cx
	jmp f3
	
f3:
	;модуль i1
	mov ax,i1
	cwd
	xor ax, dx
	sub ax, dx
	mov i1,ax
	cmp k,00
	JNe noE
	;k==0
	cmp i1,6 ;min(i1,6)
	ja above2
	mov ax,i1
	mov i3,ax
	jmp ret1
above2:
	mov i3,6
	jmp ret1
	
noE:
;k!=0
;модуль i2
	mov ax,i2
	cwd
	xor ax, dx
	sub ax, dx
	mov i2,ax
	
	mov i3,ax
	mov ax, i1
	add i3,ax 
ret1:
 ret 2
Main ENDP
CODE ENDS
 END Main