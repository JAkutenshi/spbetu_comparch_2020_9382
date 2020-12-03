.intel_syntax noprefix
.global _MAS_INTERVAL
.text
_MAS_INTERVAL: # edi : left_borders, esi : res_arr , edx : arr, ecx : array_size
	mov rax,rcx
	mov rcx, 0 # счетчик для прохода по массиву чисел
	mov rbx, rdx # ebx указывает на начало массива чисел arr

	traverse_numbers:
		push rax
		mov rax,[rbx] #в eax лежит текущий элемент
		push rbx #сохраняем указатель на текущий элемент
		mov rbx,0 #обнуляем указатель

	traverse_borders: #здесь ebx - счетчик границ
		mov rdx,rbx # в edx лежит текующий индекс массива границ
		shl rdx,3 # этот индекс умножаем на 8, т.е. каждый элемент по 8 байт
		cmp rax,[rdi+rdx] # сравниваем текующий элемент с текующей левой границей (left_boarders + 4*i), i -номер элемента
		jle matched_interval # если число меньше либо равно левой границе, то идем в matched_interval

		inc rbx # инкрементируем указатель
		jmp traverse_borders # т.к. наше число больше левой

	matched_interval:
		add rdx,rsi # edx - сдвиг для left_boarders, после сложения edx указывает на элемент в res_arr который нужно инкрементировать

		mov rax,[rdx] #достаем количество подходящей левой границы
		inc rax #прибавляем к ней единицу
		mov [rdx],rax #вставляем ее обратно

		pop rbx #достаем текущий сдвиг для массива чисел

		add rbx,8 #перемещаем указатель на следующий элемент массива чисел
		inc rcx #инкрементируем количество разобранных элементов
		pop rax
		cmp rcx,rax #смотрим, рассмотрели ли мы все элементы
		jl traverse_numbers #если еще не все, то продолжаем
	ret
