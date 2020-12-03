.586
.model flat, C
.code
countintervals2 proc C frequency:dword, lgrint:dword, arr_length:dword, unitintervalfrequency:dword, xmin:dword, xmax:dword
		mov eax, unitintervalfrequency
		mov edx, frequency

		mov ecx, arr_length
		sub edi, edi
		cmp ecx, 1
		je lastint

		sub ecx, 2

		mov esi, lgrint
		mov esi, [esi + edi * 4];
		sub esi, xmin

			mov ebx, lgrint
			add edi, 1
			mov ebx, [ebx + edi * 4]
			sub ebx, xmin
			sub edi, 1

			countinterval:
		cmp esi, ebx
			je nextinterval

			mov eax, [eax + esi * 4]
			add[edx + edi * 4], eax
			mov eax, unitintervalfrequency

			inc esi

			jmp countinterval

			nextinterval :
		cmp edi, ecx
			je lastint
			jg endprog
			inc edi
			mov esi, lgrint
			mov esi, [esi + edi * 4]
			sub esi, xmin
			mov ebx, lgrint
			add edi, 1
			mov ebx, [ebx + edi * 4]
			sub edi, 1
			sub ebx, xmin

			jmp countinterval

			lastint :
		cmp ecx, 1
			je noinc
			inc edi
			noinc :
		mov ecx, 0
			mov esi, xmax
			sub esi, xmin
			add esi, 1
			cmp ebx, esi
			je endprog
			mov ebx, xmax
			sub ebx, xmin
			add ebx, 1
			mov esi, lgrint
			mov esi, [esi + edi * 4]
			sub esi, xmin
			jmp countinterval

			endprog :
ret
countintervals2 endp
end