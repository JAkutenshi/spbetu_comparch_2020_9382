.686
.MODEL FLAT, C
.STACK
.DATA
.CODE
_form_array PROC C NumRanDat:dword, numRanges:dword, arr:dword, LGrInt:dword, res_arr:dword ; Получаем данные из программы высокого уровня

mov ecx, 0 ; счетчик для прохода по массиву
mov ebx, [arr] ; массив случайных чисел
mov esi, [LGrInt] ; массив с левыми границами
mov edi, [res_arr] ; массив-результат

@begin:
	mov eax, [ebx] ; берем элемент входного массива
	push ebx  ; сохраняем указатель на текущий элемент
	push ecx
	mov ebx, 0 ; обнуляем указатель
	mov ecx, 1 ; счетчик для прохода по границам

@move:
	mov edx, ebx ; edx содержит текущий индекс массива границ

	shl edx, 2 ; индекс умножаем на 4, т.к. каждый элемент состоит из 4 байт
	cmp eax, [esi+edx] ; сравниваем текущий элемент с текущей левой границей
	jl @end
	add edx, 4
	cmp ecx, numRanges
	je @is_in ; если дошли до последней границы - элемент точно содержится в ней
	cmp eax, [esi+edx] ; сравниваем со следующей левой границей
	jl @is_in ; если меньше - попал в отрезок
	jmp @continue ; иначе - идем дальше по массиву

@is_in:
	sub edx, 4
	add edx, edi; в массиве-ответе инкрементируем счетчик
	push eax
	mov eax, [edx]
	inc eax
	mov [edx], eax
	pop eax
	jmp @end

@continue: ; продолжаем обход массива границ
	inc ebx
	inc ecx
	jmp @move

@end:
	pop ecx
	pop ebx  ; забираем текущий элемент и ссылаемся на новый
	add ebx, 4
	inc ecx ; инкрементируем счетчик
	cmp ecx, NumRanDat
    jl @begin

ret

_form_array ENDP
END