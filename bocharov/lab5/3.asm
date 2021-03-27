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
  push ax; 
  push dx; save reg
  push bx; save reg
     

    mov      bx,270    ; Hz
    mov      ax,34DDh
    mov      dx,12h    ;(dx,ax)=1193181 , 12h -> 18Hz
    cmp      dx,bx     ; 
    jnb      Done      ;
    div      bx        ;ax=(dx,ax)/bx (word)
    mov      bx,ax     ;
    in       al,61h    ;
    or       al,3      ; 0 -> ch2, 1 -> out 
    out      61h,al    
    mov      al,00000110b   ; 3-1-> imp, 0->format
                        
    mov      dx,43h    ; timer
    out      dx,al     ;
    dec      dx    ;     channel 2 42h
    mov      al,bl     ; 
    out      dx,al     ; 
    mov      al,bh     ; 
    out      dx,al     ; 
Done:
  
pop bx
pop dx
pop ax	
	
iret
interrupt endp
	
	
	main proc far
		push ds
		sub ax, ax
		push ax
		
		mov ax, data
		mov ds, ax
		
		
		mov ax, 351ch ; 35 - get vec(bx = offset, es = seg), 1ch - ?vec
		int 21h ;
		
		mov keep_offset, bx ; save vec
		mov keep_seg, es
	;---------------------------------
		cli
		push ds
		mov dx, offset interrupt ;
		mov ax, seg interrupt    ;
		mov ds, ax
		
		mov ax, 251ch ; 25 - set(offset = dx, seg = ds), 1ch - ?vec
		int 21h
		
		pop ds
		sti
	;---------------------------------





looper:
		
            	mov ah, 1h ; 1h - get char
		int 21h
		cmp al, '1'
		je next
		jmp looper
next:

    push    ax  ; 
    in  al,61h  ; 
    and al,not 3; turn off 0,1 bit 
    out 61h,al  ; 
    pop ax  ; 
		
		


		cli
		push ds
		
		mov dx, keep_offset
		mov ax, keep_seg
		mov ds, ax
		
		mov ah, 25h ; 25h - set(25 - set(offset = dx, seg = ds))
		mov al, 1ch; 1ch - ?vec
		int 21h ; 
		
		pop ds
		sti
	
	;---------------------------------
	
		ret
	main endp
code ends
end main