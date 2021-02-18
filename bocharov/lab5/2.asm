stack segment stack
	dw 6 dup(?)
stack ends
data segment
	keep_seg dw 0
	keep_offset dw 0
data ends

code segment
	assume ds:data, cs:code, ss:stack
	
	interrupt proc far
 push ax
 push cx
     

  in   al,  61h      
  push ax            
  or   al,  00000011b 
  out  61h, al       
  mov  al,  90        
  out  42h, al   	              
	            
  mov  cx,  1000     

Zvuk:             	  
  push CX	             
  mov  CX,  150
  Cicle:
     loop Cicle
  pop  cx
  loop Zvuk

  pop  ax             

  and  al,  11111100b 
  out  61h, AL
pop cx
pop ax
mov al, 20h
out 20h, al
		
iret
	interrupt endp
	
	
	main proc far
		push ds
		sub ax, ax
		push ax
		
		mov ax, data
		mov ds, ax
		
		
		mov ax, 351ch
		int 21h
		
		mov keep_offset, bx
		mov keep_seg, es
	;---------------------------------
		cli
		push ds
		mov dx, offset interrupt
		mov ax, seg interrupt
		mov ds, ax
		
		mov ax, 251ch
		int 21h
		
		pop ds
		sti
	;---------------------------------





looper:
		
		mov ah, 1h
		int 21h
		cmp al, '1'
		je next
		jmp looper
		
		next:


		cli
		push ds
		
		mov dx, keep_offset
		mov ax, keep_seg
		mov ds, ax
		
		mov ah, 25h
		mov al, 1ch
		int 21h
		
		pop ds
		sti
	
	;---------------------------------
	
		ret
	main endp
code ends
end main
