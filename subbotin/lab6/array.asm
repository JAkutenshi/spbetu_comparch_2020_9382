.686
.MODEL FLAT, C
.STACK
.DATA
.CODE
MAS_INTERVAL PROC C array_size:dword, arr:dword, left_boarders:dword, res_arr:dword
mov ecx, 0; счетчик для прохода по массиву чисел
mov ebx, arr ; ebx указывает на начало массива чисел
mov edi,left_boarders; edi указывает на начало массива левых граней
traverse_numbers:
	mov eax,[ebx]; в eax лежит текущий элемент
	push ebx; сохраняем указатель на текущий элемент
	mov ebx,0; обнуляем указатель

traverse_borders: ;здесь ebx - счетчик границ
	mov edx,ebx; в edx лежит текующий индекс массива границ
	shl edx,2; этот индекс умножаем на 4, т.е. каждый элемент по 4 байта
	cmp eax,[edi+edx]; сравниваем текующий элемент с текующей левой границей (left_boarders + 4*i), i -номер элемента
	jle matched_interval; если число меньше либо равно левой границе, то идем в matched_interval
	
	inc ebx; инкрементируем указатель
	jmp traverse_borders; т.к. наше число больше левой 

matched_interval:
	add edx,res_arr; edx - сдвиг для left_boarders, после сложения edx указывает на элемент в res_arr который нужно инкрементировать

	mov eax,[edx];достаем количество подходящей левой границы
	inc eax;прибавляем к ней единицу
	mov [edx],eax;вставляем ее обратно

	pop ebx;достаем текущий сдвиг для массива чисел

	add ebx,4; перемещаем указатель на следующий элемент массива чисел
	inc ecx; инкрементируем количество разобранных элементов
	cmp ecx,array_size; смотрим, рассмотрели ли мы все элементы
	jl traverse_numbers; если еще не все, то продолжаем
ret
MAS_INTERVAL ENDP
END
