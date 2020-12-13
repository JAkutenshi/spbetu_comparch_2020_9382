.586p
.MODEL FLAT, C
.CODE
PUBLIC C mod1
mod1 PROC C numbers: dword, numbers_size: dword, result: dword, xmin: dword

push esi
push edi

mov edi, numbers
mov ecx, numbers_size
mov esi, result 

for_numbers:
	mov eax, [edi] 
	sub eax, xmin  
	mov ebx, [esi + 4*eax] 
	inc ebx 
	mov [esi + 4*eax], ebx 
	add edi, 4 
	loop for_numbers

pop edi
pop esi

ret
mod1 ENDP
END 
