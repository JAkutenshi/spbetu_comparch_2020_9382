.586p
.model flat, c

.data
	SUPER_counter dd 0

.code
	public c single ;распределение по интервалам единичной длины
	single proc c main_arr:dword, main_len:byte, single_counter_arr:dword, min:byte
		push edi
		push esi
		push eax
		push ebx
		push ecx
		push edx
		
		mov eax, dword ptr min 		; сохраняем адреса начала массивов чисел и счётчика,
		mov ecx, dword ptr main_len	; а также минимальное значение и длину массива чисел
		mov edi, main_arr
		mov esi, single_counter_arr
		
		counter:
			mov ebx,[edi]				; получаем текущее число
			sub ebx,eax					; получаем смещение относительно начала счётчика ( ЗНАЧЕНИЕ - XMIN )
			mov edx,[esi+4*ebx]			; берём значение для этого числа, находящееся в счётчике
			inc edx						; отмечаем, что встретилось [ещё] один раз
			mov [esi+4*ebx],edx			; записываем значение в массив-счётчик
			add edi,4					; идём к следующему элементу
			loop counter

		pop edx
		pop ecx
		pop ebx
		pop eax
		pop esi
		pop edi
		
		ret
	single endp
	
	public c custom ;распределение по различным интервалам
	custom proc c single_counter_arr:dword, single_counter_len:byte, left_borders_arr:dword, custom_counter_arr:dword ,custom_counter_len:byte, min:byte
		push edi
		push esi
		push eax
		push ebx
		push ecx
		push edx
		
		mov ecx,dword ptr single_counter_len		; счётчик для цикла
		
		mov edi,dword ptr single_counter_len		; указатель на последний элемент массива-счётчика вхождений чисел (интервалы единичной длины)
		dec edi
		shl edi,2
		add edi,single_counter_arr
		
		mov eax, dword ptr custom_counter_len 		; смещение относительно начала двух массивов : левых границ и счётчика попаданий в интервал
		dec eax
		shl eax,2
		
		push edi
		mov esi, left_borders_arr
		mov edi, custom_counter_arr
		add edi,eax
		add esi,eax						; запись в ESI указателя на последний элемент массива левых границ
		mov SUPER_counter,edi			; и запись в память указателя на последний элемент счётчика попаданий
		pop edi
		
		sub eax,eax
		mov eax, dword ptr min
		add eax, ecx					; запись в EAX максимально возможного (в данном диапазоне) элемента массива случайных чисел
		dec eax
		mov ebx,[esi]					; запись в EBX максимальной левой границы
		
		counter:
			cmp eax,ebx					; если число меньше левой границы, то ...(см. [*])
			
			jl lower
				push eax
				push esi					; если же больше или равно, то
				mov esi,SUPER_counter		; помещаем в ESI счётчик для границы
				mov edx,[esi]				; заносим его значение в EDX
				mov eax,[edi]				; помещаем количество вхождений в свой единичный интервал данного числа
				add edx,eax					; прибавляем это количество
				mov [esi],edx				; записываем обратно в счётчик для НЕединичных интервалов то, что мы получили
				pop esi
				pop eax
				jmp to_previous
			
			lower:					; [*]
			sub esi,4					;  ...Берём меньшую левую границу,
			sub SUPER_counter,4			; сдвигаем счётчик, который будет считать количество попаданий для неё,
			mov ebx,[esi]				; заносим новую границу в EBX
			jmp counter

				to_previous:
				dec eax						; здесь просто уменьшаем рассматриваемое число и указатель на счётчик для единичных интервалов
				sub edi,4
				loop counter

		pop edx
		pop ecx
		pop ebx
		pop eax
		pop esi
		pop edi
		
		ret
	custom endp
end