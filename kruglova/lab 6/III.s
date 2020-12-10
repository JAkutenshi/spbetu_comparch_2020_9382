.intel_syntax noprefix
.global INTERVAL_SORTING
.text

INTERVAL_SORTING:  # rdi : LGrInt,   rsi : result ,   rdx : array,    rcx : NInt

	WokWork:
		mov rax, [rdx]   		    # в rax лежит текущий элемент
		push rdx    	 		      # сохраняем указатель на текущий элемент
		mov rdx, 0    	 		    # обнуляем указатель

    Index_case:
    	mov rbx, rdx			    # в rbx лежит текущий индекс из LGrInt
    	shl rbx, 3				    # этот индекс умножаем на 8, т.е. каждый элемент по 8 байт
    	cmp rax, [rdi + rbx]	# сравниваем текущий элемент массива с текущей границей
        jge search_case			# если элемент массива больше границы
        jmp write_case

    search_case:
    	inc rdx					      # для перехода к следующему индексу массива границ
        jmp Index_case

    write_case:
    	add rbx, rsi			    # rbx указывает на индекс LGrInt
    	mov rax, [rbx]			  # rax хранит индекс LGrInt который надо ++
    	inc rax					      # увеличиваем индекс на один
    	mov [rbx], rax;			  # возвращаем обратно
    	pop rdx					      # восстанавливаем указатель на array
    	add rdx, 8				    # перемещаем указатель на следующий элемент массива чисел
    	loop WokWork			    # в цикле проходим по всем элементам массива

    ret
