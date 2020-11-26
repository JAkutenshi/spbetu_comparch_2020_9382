stack segment stack
	dw 6 dup(?)						; вполне достаточно
stack ends

data segment
	keep_seg dw 0					; здесь сохраним дефолтный вектор
	keep_offset dw 0
data ends

code segment
	assume ds:data, cs:code, ss:stack
	
	interrupt proc far
		jmp a
		save_ax dw 1 (0)
		save_ss dw 1 (0)
		save_sp dw 1 (0)
		iStack dw 6 dup(0)			; выделяем память для нового стека
		
		a:
		mov save_ss, ss
		mov save_sp, sp
		mov save_ax, ax
		mov ax, seg iStack			; сохраняем стек программы в памяти
		mov ss, ax
		mov sp, offset a
		mov ax, save_ax
		
		push ax						; AX будем менять, сохраняем на стеке
		push bx
		
		in al, 61h					; включаем звук
		mov ah, al
		mov bx, 13000
		
		or al, 3
		out 61h, al
		
		za:
		
		sub bx, 1
		mov al, 182					; настраиваем таймер
		out 43h, al

		
		mov ax, bx					; передаём делитель частоты
		out 42h, al
		mov al, ah
		out 42h, al
		
		cmp bx, 6000
		jne za
		xor bx, bx
		
		mov al, ah					; теперь надо выключить, общага спит
		out 61h, al
		
		pop bx
		pop ax						; восстанавливаем AX
		
		mov save_ax, ax
		mov ax, save_ss
		mov ss, ax					; восстанавливаем стек программы
		mov sp, save_sp
		mov ax, save_ax
		
		mov al, 20h					; возвращаем возможность управления другим прерываниям (с более низким приоритетом)
		out 20h, al
		
		iret
	interrupt endp
	
	
	main proc far
		push ds
		sub ax, ax					; инициализируем сегмент данных
		push ax
		
		mov ax, data
		mov ds, ax
		
		
		mov ax, 351ch				; получаем вектор прерывания, сохраняем в памяти
		int 21h
		
		mov keep_offset, bx
		mov keep_seg, es
	;---------------------------------
		cli
		push ds
		mov dx, offset interrupt	; устанавливаем новый обработчик прерывания
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
		
		mov dx, keep_offset			; восстанавливаем исходный вектор прерывания
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
	