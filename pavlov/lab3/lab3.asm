stack segment stack
	dw 4 dup(?)
stack ends

data segment
	i1 dw 0
	i2 dw 0
	buff    db 4,?,4 Dup(?)
	
data ends

code segment

	assume cs:code ds:data ss:stack
	
	input proc near
	
		mov cx, 0
		mov ah,0ah
		sub di,di
		mov dx,offset buff		; Считывание строки и запись её в буфер, перевод на новую строку
		int 21h
		mov dl,0ah
		mov ah,02
		int 21h
		
		mov si,offset buff+2
		cmp byte ptr [si], '-'	;Запоминаем знак для флага
		jnz pre
		mov di,1
		inc si
		
		pre:
		sub ax,ax				; Готовим регистры для записи: ax = 0 , bx = 10 - основание СС
		mov bx,10
		
		transform:
		mov cl,[si]				; Проверка на последний символ
		cmp cl,0dh
		jz sign
		

		cmp cl,'0'				; Проверка на соответствие цифре
		jb err
		cmp cl,'9'
		ja err
	 
		sub cl,'0'				; Перевод из кода символа в цифру, домножение на 10, прибавление в конец
		mul bx
		add ax,cx
		inc si
		jmp transform
	 
		err:
		mov dx, offset error	; Ошибка (если не цифра), выход
		mov ah,09
		int 21h
		int 20h
	 
		sign:
		cmp di,1				; Установка знака
		jnz fin
		neg ax
		
		fin:
		ret
	 
	error db "incorrect number$"
	input endp
	
	
	
	result proc near		
		cmp bx, 0
		jl less
		sub cx, dx				; Если k >= 0, находим разность
		cmp cx, 0				; Если разность < 0, меняем знак, находя модуль
		jge skip
		neg cx
		
		skip:
		mov ax, cx				; Запись в ax
		jmp exit
		
		less:
		sub dx, 10				; Если k < 0, вычитаем из i2 10
		neg dx					; Меняем знак
		cmp cx, dx
		jg greater
		mov ax, dx				; Находим наибольшее, записываем его в ax
		jmp exit
		
		greater:
		mov ax, cx
		
		exit:
		ret
	result endp

	main proc far
		push ds
		sub ax,ax				; Подготовка сегментов
		push ax
	
		mov ax, seg data
		mov ds, ax				; Привязка к сегменту данных
		sub ax, ax
		
		call input
		mov ds:i1, ax			;ввод a
		call input
		mov ds:i2, ax			;ввод b
		call input
		mov bx, ax				;ввод i
		
		mov cx, ds:i1			; Заносим в регистры
		mov dx, ds:i2
		
		cmp cx, dx
		jg greater1
		
		shl bx, 1
		shl bx, 1
		add bx, ax
		add bx, ax				; F1 если а <= b
		sub bx, 8
		neg bx
		mov ds:i1, bx
		jmp next1
		
		greater1:
		shl bx, 1
		shl bx, 1				; F1 если a > b
		sub bx, 7
		neg bx
		mov ds:i1, bx
		
		next1:
		mov bx, ax
		
		cmp cx, dx
		jg greater2
		
		shl bx, 1
		add bx, ax
		add bx, 6				; F2 если a <= b
		mov ds:i2, bx
		jmp next2
		
		greater2:
		shl bx, 1
		shl bx, 1
		add bx, ax				; F2 если a > b
		add bx, ax
		sub bx, 4
		neg bx
		mov ds:i2, bx
		
		next2:
		
		call input
		mov bx, ax		;k
		mov cx, ds:i1			; Заносим в регистры значения, вычисленные функциями
		mov dx, ds:i2
		
		call result				; Вызов процедуры нахождения значения F3 (RES)
		
		ret
	main endp
code ends
end main