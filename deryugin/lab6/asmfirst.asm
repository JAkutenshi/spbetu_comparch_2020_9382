.586
.model flat, C
.code
PUBLIC C asmfirst

asmfirst proc C array:dword, arrayLength:dword, oncefrequency:dword, xMin:dword
	mov edx, array
	mov ecx, arrayLength
	mov edi, oncefrequency

	loop_numbers:
		mov eax, [edx]
		add edx, 4
		sub eax, xMin
		mov ebx, [edi + eax*4]
		add ebx, 1
		mov [edi + eax*4], ebx
		loop loop_numbers

	ret
	asmfirst ENDP
	END