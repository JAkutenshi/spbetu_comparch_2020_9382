.586p
.MODEL FLAT, C
.CODE
PUBLIC C asmsecond
asmsecond PROC C  frequencyLength: dword, xMin: dword, LGrInt: dword, countOfBorder: dword, frequency: dword, result: dword

mov esi, LGrInt; массив интервалов
mov ecx, countOfBorder; кол-во в массиве интервалов
mov edi, frequency; сами частоты

change_intervals:
	mov eax, [esi]
	sub eax, xMin
	mov [esi], eax
	add esi, 4
	loop change_intervals


mov esi, LGrInt
mov ecx, countOfBorder
mov eax, 0
mov ebx, [esi]
mov edx, 0;ndex of result

main:
	push ecx
	mov ecx, ebx
	push esi
	mov esi, result
	looping:
		cmp ecx, 0
		je next
		mov ebx, [edi]
		add [esi + eax * 4], ebx
		add edi, 4
		loop looping

next:
	pop esi
	mov ebx, [esi]
	add esi, 4
	sub ebx, [esi]
	neg ebx
	add eax, 1
	pop ecx
	loop main


ret
asmsecond ENDP
END