AStack SEGMENT STACK
 DW 32 DUP(?)
AStack ENDS


DATA SEGMENT 

a db ?
b db ?
i db ?
k db ?
f1 dw ?
f2 dw ?
f3 dw ?

DATA ENDS

CODE SEGMENT 

MAIN PROC FAR

ASSUME SS:AStack, DS:Data, CS:Code

	   mov ax,data 
       mov ds,ax 
       mov  ax, a   
       mov  bx, b
 
   firstf1:
		cmp   ax, bx
		jle secondf1
		mov cx, i
		shl cx, 1
		shl cx, 1
		add cx, 3 
		neg cx
		mov f1, cx
		jmp firstf2
		
	secondf1:
		mov cx, i
		shl cx, 1
		shl cx, 1
		add cx, i
		add cx, i
		sub cx, 10
		mov f1, cx
		jmp firstf2
			
		
	firstf2:
		cmp   ax, bx
		jg secondf2
		mov cx, i
		mov cx, 2
		sal cx, 1
		sub cx, 5 
		mov f2, cx
		jmp firstf3
		
	secondf2:
	
		mov cx, i
		sal cx,1
		add cx, i
		add cx, 10 
		mov f2, cx
		jmp firstf3
		
	firstf3:
	
		mov cx, k
		cmp cx, 0
		jl secondf3
		mov cx, f1
		sub cx, f2
		cmp cx, 0
		cmp cx, 2
		jle getres1
		getres1:
		mov ax, cx
		jmp exit
		mov ax, 2
		jl abs_
		abs_:
		neg cx
		
	secondf3:
		mov cx, 6
		neg cx
		mov dx, f2
		neg dx
		cmp dx, cx
		jge getres2
		getres2:
		mov ax, cx
		jmp exit
		mov ax, cx
		jmp exit
		
	exit:
		mov ah, 4ch
		int 21h

MAIN ENDP 

CODE ENDS 

END MAIN