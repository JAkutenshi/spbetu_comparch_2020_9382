stack segment stack
	dw 64 dup(0)
stack ends

data segment
	choice db '0 - ����筮� �᫮, 1 - �����筮� �᫮', 13, 10, '$'
	product dw 4 dup(0)
	origin db 33, ?, 33 dup(0)
	result db 33 dup(0)
	error db "incorrect number$"
data ends

additional segment
	assume ds:data, cs:additional
	strToInt proc far
		push ax
		mov ax, data
		mov ds, ax
		pop ax

		xor cx, cx
		mov ah,0ah
		mov dx,offset origin		; Считывание строки и запись её в буфер, перевод на новую строку
		int 21h
		mov dl,0ah
		mov ah,02
		int 21h
		
		mov si,offset origin+2

		xor ax,ax				; Готовим регистры для записи: ax = 0, dx = 0, bx = 2 - основание СС
		xor dx, dx
		mov bx,2
		
		mov cl, origin[1]
		
		transformdx:
		cmp cx, 17				; Расчёт двух старших байтов
		jl sec_word
		
		push cx
		
		mov cl, [si]
		cmp cl,'0'				; Проверка на соответствие цифре
		jb err
		cmp cl,'1'
		ja err
	 
		sub cl,'0'				; Перевод из кода символа в цифру, домножение на 10, прибавление в конец
		mul bx
		add ax,cx
		inc si
		
		pop cx
		
		loop transformdx
		
		sec_word:				; Расчёт двух младших байтов
		push ax
		xor ax, ax
		
		transformax:
		mov cl,[si]				; Проверка на последний символ
		cmp cl,0dh
		jz fin
		
		cmp cl,'0'				; Проверка на соответствие цифре
		jb err
		cmp cl,'1'
		ja err
	 
		sub cl,'0'				; Перевод из кода символа в цифру, домножение на 2, прибавление в конец
		mul bx
		add ax,cx
		inc si
		jmp transformax
	 
		err:
		mov dx, offset error	; Ошибка (если не цифра), выход
		mov ah,09
		int 21h
		int 20h
		
		fin:
		pop dx
		pop cx
		pop bx
			
		push ax					; Помещение числа в стек
		push dx
		
		push bx
		push cx
		ret

	strToInt endp
additional ends

code segment
	assume ds:data, cs:code, ss:stack
	
	strToInt10 proc near
	
		push ax
		mov ax, data
		mov ds, ax
		pop ax

		xor cx, cx
		mov ah,0ah
		mov dx,offset origin		; Считывание строки и запись её в буфер, перевод на новую строку
		int 21h
		mov dl,0ah
		mov ah,02
		int 21h
		
		mov si,offset origin+2
		xor dx, dx
		xor ax, ax				; Готовим регистры для записи: ax = 0 , bx = 10 - основание СС
		mov bx,10
		
		transform:
		mov cl,[si]				; Проверка на последний символ
		cmp cl,0dh
		jz fin10
		

		cmp cl,'0'				; Проверка на соответствие цифре
		jb err10
		cmp cl,'9'
		ja err10
	 
		sub cl,'0'				; Перевод из кода символа в цифру, домножение на 10, прибавление в конец
		
		cmp dx, 0
		jg omg
		
		mul bx
		add ax,cx
		inc si
		
		jmp transform
		
		omg:
		push dx
		mul bx
		mov product[2], dx
		mov product[4], ax
		pop ax
		mul bx
		add product, dx
		adc product[2], ax
		mov dx, product[2]
		mov ax, product[4]
		adc ax, cx
		inc si
		jmp transform
	 
		err10:
		mov dx, offset error	; Ошибка (если не цифра), выход
		mov ah,09
		int 21h
		int 20h
		
		fin10:
		ret
	
	strToInt10 endp
	
	intToStr proc near
		push ax
		push bx
		push cx
		push dx
		push di
		
		lea di, result			; Переход в конец строки, запись символа конца строки
		add di, 33
		mov cl, '$'
		mov [di], cl
		dec di
		
		mov cx, 16
		
		shiftax:
			shr ax, 1
			jc setax
			mov ch, 48
			jmp recax
			
			setax:
				mov ch, 49		; Сдвиг вправо, заполнение первых 16 знаков
			
			recax:
			mov [di], ch
			dec di
			and cx, 00FFh
			loop shiftax
			
		mov cx, 16
		
		shiftdx:
			shr dx, 1
			jc setdx
			mov ch, 48
			jmp recdx
			
			setdx:
				mov ch, 49		; Сдвиг вправо, заполнение последних 16 знаков
			
			recdx:
			mov [di], ch
			dec di
			and cx, 00FFh
			loop shiftdx
		
		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		ret
	intToStr endp
	
	main proc far
		xor ax, ax
		push ds
		push ax
		
		mov ax, data
		mov ds, ax
		
		mov dx, offset choice
		mov ah, 9
		int 21h
		
		entering:
		
		mov ah, 1
		int 21h
		
		push ax
		
		mov ah, 2
		mov dl, 10
		int 21h
		mov dl, 13
		int 21h
		
		pop ax
		
		cmp al, 30h
		jne decimal
		
		call strToInt			; Ввод числа
		;assume cs: code		
		pop dx					; Получение числа из стека
		pop ax
		jmp toStr
		
		decimal:
		cmp al, 31h
		jne entering
		
		call strToInt10		; Ввод числа	
		
		toStr:
		call intToStr			; Запись числа в виде строки
		
		mov dx, offset result
		mov ah, 9				; Вывод результата на экран
		int 21h
		
		ret
	main endp
code ends
end main