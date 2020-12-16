.586
.model flat, C
.code
countintervals1 proc C numbers:dword, unitintervalfrequency:dword, n:dword, xmin:dword, xmax:dword
		mov ecx, n
		sub ecx, 1
		sub ebx, ebx
		mov edx, numbers
		mov eax, unitintervalfrequency
		unit:
		mov esi, [edx + ebx * 4]
			sub esi, xmin
			mov edi, [eax + esi * 4]
			add edi, 1
			mov [eax + esi * 4], edi
			mov edi, 0
			cmp ebx, ecx
			jge endloop
			inc ebx
			jmp unit
			endloop :
ret
countintervals1 endp
end