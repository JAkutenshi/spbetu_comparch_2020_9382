.686
.MODEL FLAT, C
.STACK
.DATA
.CODE
_form_array PROC C NumRanDat:dword, arr:dword, LGrInt:dword, res_arr:dword

mov ecx,0 ;счетчик для прохода по массиву
mov ebx,[arr] ;входной массив
mov esi,[LGrInt] ;массив с левыми границами
mov edi,[res_arr] ;массив-ответ

fst_case:
	nop
	mov eax,[ebx] ;берем элемент входного массива
	push ebx ; сохраняем указатель на текущий элемент
	mov ebx,0 ; обнуляем указатель

snd_case:
	mov edx,ebx ; edx содержит текущий индекс массива границ
	shl edx,2 ; индекс умножаем на 4, так как каждый элемент по 4 байт
	cmp eax,[esi+edx] ; сравниваем текующий элемент с текущей левой границей
jg searching_case
jmp exepting_case

searching_case:
	inc ebx; инкрементируем, пока не найдем нужный интервал
jmp snd_case

exepting_case:
	add edx,edi ;в массиве-ответе инкерементируем счетчик 
	mov eax,[edx]
	inc eax
	mov [edx],eax;
	pop ebx ;забираем текущий элемент и ссылаемся на новый
	add ebx,4
	inc ecx ;инкрементируем индекс массива
	cmp ecx, NumRanDat
jl fst_case

ret
_form_array ENDP

END