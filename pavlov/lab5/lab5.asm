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
		
		mov al, 182					; настраиваем таймер
		out 43h, al
		
		mov ax, bx					; передаём делитель частоты
		out 42h, al
		mov al, ah
		out 42h, al

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
		in al, 61h					; включаем звук
		mov ah, al
		or al, 3
		mov bx, 12000				; начальный делитель частоты
		out 61h, al
		
		za:
		mov cx, 0ffffh				; ставим задержку на очень много тактов
		
		looper:
		loop looper
		
		sub bx, 100
		cmp bx, 1500				; уменьшаем делитель частоты на 100 (частота звука тем временем растёт)
		jg za
		
		xor bx, bx
		
		mov al, ah					; теперь надо выключить, общага спит
		out 61h, al
		
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
	