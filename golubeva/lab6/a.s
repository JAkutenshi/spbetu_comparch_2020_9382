.intel_syntax noprefix
.global DISTRIBUTION_INTERVAL
.text
DISTRIBUTION_INTERVAL:  # edi : left_borders, esi : res_arr , edx : arr, ecx : size
	mov rax,rcx			# ecx указывает на длину массива
	mov rcx, 0   	 	# счетчик для прохода по массиву чисел
	mov rbx, rdx    	# ebx указывает на начало массива чисел arr
	
	passing_numbers:
		push rax
		mov rax,[rbx]   # в eax лежит текущий элемент
		push rbx    	# сохраняем указатель на текущий элемент
		mov rbx,0    	# обнуляем указатель

	passing_borders:    # ebx - счетчик границ
		mov rdx,rbx    	# в edx лежит текущий индекс массива границ
		shl rdx,3    	# этот индекс умножаем на 8, т.е. каждый элемент по 8 байт
		cmp rax,[rdi+rdx]    	# сравниваем текующий элемент с текущей левой границей (left_boarders + 4*i), i -номер элемента
		jle matched_interval    # если число меньше либо равно левой границе, то идем в matched_interval

		inc rbx    				
		jmp passing_borders     # т.к. наше число больше левой границы

	matched_interval:
		add rdx,rsi    			# edx - сдвиг для left_boarders, после сложения edx 
								#указывает на элемент в res_arr который нужно инкрементировать

		mov rax,[rdx]    		# достаем количество подходящей левой границы
		inc rax    				# прибавляем к ней единицу
		mov [rdx],rax    		# вставляем ее обратно

		pop rbx    				# достаем текущий сдвиг для массива чисел

		add rbx,8    			# перемещаем указатель на следующий элемент массива чисел
		inc rcx    				# увеличиваем количетво обработанных элементов
		pop rax					
		cmp rcx,rax    			#смотрим, рассмотрели ли мы все элементы
		jl passing_numbers      #если еще не все, то продолжаем
	ret

