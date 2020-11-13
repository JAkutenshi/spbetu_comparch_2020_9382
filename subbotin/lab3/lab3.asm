STACKSG SEGMENT  PARA STACK 'Stack'
        DW       32 DUP(?)
STACKSG	ENDS

DATASG  SEGMENT  PARA 'Data'				;SEG DATA
VARA	DW	1h
VARB	DW	1h
VARI	DW	1h
VARK	DW	1h
VARI1	DW	1h
VARI2	DW	1h
VARRES	DW	1h
DATASG	ENDS								;ENDS DATA

CODE      SEGMENT   						;SEG CODE
ASSUME  DS:DataSG, CS:Code
	
Main      PROC  FAR
   	mov  ax, DATASG
   	mov  ds, ax
   
f1: 
   mov ax,VARA          ;переменная a в ax
   mov si,VARB          ;переменная b в si
   mov bx,VARI			;переменная i в bx
   shl bx,1				;умножаем переменную i в bx на 2
   
   cmp	ax,si			;сравниваем переменные a и b соответственно
   
   jg	f1_1			;если a>b переходим к метке f1_1

f1_2:					;если a<=b ,то считаем 3*(i+2)
	mov ax,VARI			;ax = i
	add ax,bx			;ax = ax + bx = i + 2*i = 3i
	add ax,6			;ax +=6, ax = 3i+6
	mov VARI1,ax
	jmp f2
	
	
f1_1:   				; если a>b, то считаем -(6*i-4) = -6*i + 4
	shl bx, 1			;bx *= 2 , bx = 4*i
	shl bx, 1           ;bx *= 2,  bx = 8*i
	mov ax,VARI         ;ax = i
	shl ax,1            ;ax = 2*i
	sub ax,bx           ;ax = ax - bx = 2*i - 8*i = -6*i
	add ax,4            ;ax = -6*i + 4
	mov VARI1,ax
		
f2: 
   mov ax,VARA          ;переменная a в ax
   cmp	ax,VARB			;сравниваем переменные a и b соответственно
   jg	f2_1			;если a>b переходим к метке f2_1

f2_2:					; если a<=b, то считаем 5 - 3*(i+1) = 2 - 3*i
	mov ax,VARI			;ax = i
	shl ax, 1			;ax *= 2 = 2*i
	shl ax, 1           ;ax *= 2 = 4*i
	mov bx,VARI         ;bx = i
	sub bx,ax           ;bx = bx - ax = i - 4*i = -3*i
	add bx,2            ;bx+=2
	mov VARI2,bx
	jmp f3

f2_1:   				; если a>b, то считаем 2*(i+1)-4 = 2*i - 2
	mov bx,VARI			;bx = i
	shl bx,1			;bx *= 2
	sub bx,2			;bx = bx - 2 = 2*i - 2
	mov VARI2,bx
	
f3: 
   mov 	ax,VARI2		;кладем в ax i2			
   cmp	ax,0			; сравниваем i2 с 0
   jl	f3_I2_NEG		;если i2 < 0

f3_K_POS:
	mov bx,VARK         ;кладем в bx k
	cmp bx, 0           ;сравниваем k с 0
	jl  f3_K_NEG
	sub ax,3			;ax = ax-3 = |i2|-3
	cmp 4,ax            ;сравниваем 4 с |i2|-3
	jl  f3_ax           ;если 4 < |i2|-3
	mov VARRES,4
	jmp f3_end


f3_ax:
	mov VARRES,ax
	jmp f3_end

f3_K_NEG:
	mov bx, VARI1       ;кладем в bx i1
	cmp bx, 0           ;сравниваем i1 c 0
	jl f3_I1_NEG        ;если i1<0

f3_K_NEG_COUNT:
	sub bx,ax
	mov VARRES,bx
	jmp f3_end

f3_I1_NEG:
	neg bx
	jmp f3_K_NEG_COUNT

f3_I2_NEG:
	neg ax
	jmp f3_K_POS

f3_end:	
	mov  ah, 4ch		;завершаем программу
	int  21h  


 
Main      ENDP
CODE      ENDS
END Main				;ENDS CODE
