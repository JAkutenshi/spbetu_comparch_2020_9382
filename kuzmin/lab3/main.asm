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
	   cmp ax, bx
	   jg firstf1f2
	
	secondf1f2:
		mov cx, i
		shl cx, 1
		add cx, i
		sub cx, 10
		neg cx
		mov f2, cx
		sub cx, 5
		shl cx,1
		neg cx
		mov f1, cx
		jmp firstf3
		
	firstf1f2:
		mov cx, i
		shl cx, 1
		shl cx, 1
		add cx, 3 
		neg cx
		mov f1, cx
		mov cx, i
		shl cx, 1
		shl cx, 1
		sub cx, 5 
		neg cx
		mov f2, cx
		
	firstf3:
		mov cx, k
		cmp cx, 0
		jl secondf3
		mov cx, f1
		sub cx, f2
		cmp cx, 0
		jle getreswithneg
		cmp cx, 2
		jle get1
		mov f3, 2
		jmp exit
		get1:
		mov f3, cx
		jmp exit
	getreswithneg:
		neg cx
		cmp cx, 2
		jle get1
		mov f3, cx
		jmp exit
		
	secondf3:
		mov cx, 6
		neg cx
		mov dx, f2
		neg dx
		cmp dx, cx
		jge getres2
		mov f3, cx
		jmp exit
		getres2:
		mov f3, dx
		jmp exit
	exit:
		mov ah, 4ch
		int 21h

MAIN ENDP 

CODE ENDS 

END MAIN