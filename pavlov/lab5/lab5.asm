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
		jmp a
		save_ax dw 1 (0)
		save_ss dw 1 (0)
		save_sp dw 1 (0)
		iStack dw 6 dup(0)
		
		a:
		mov save_ss, ss
		mov save_sp, sp
		mov save_ax, ax
		mov ax, seg iStack?
		mov ss, ax
		mov sp, offset a
		mov ax, save_ax
		
		push ax
		push bx
		push dx
		
		in al, 61h
		mov ah, al
		mov dx, ax
		mov bx, 13000
		
		or al, 3
		out 61h, al
		
		za:
		
		sub bx, 1
		mov al, 182
		out 43h, al

		
		mov ax, bx
		out 42h, al
		mov al, ah
		out 42h, al
		
		cmp bx, 6000
		jne za
		xor bx, bx
		
		mov ax, dx
		out 61h, al
		
		pop dx
		pop bx
		pop ax
		
		mov save_ax, ax
		mov ax, save_ss
		mov ss, ax
		mov sp, save_sp
		mov ax, save_ax
		
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
		cmp al, 1bh
		je next
		jmp looper
		
		next:
	;---------------------------------
	
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