.586p
.MODEL FLAT, C
.CODE
PUBLIC C mod2
mod2 PROC C array: dword, array_size: dword, xmin: dword, intervals: dword, intervals_size: dword, result: dword

push esi
push edi
push ebp

mov edi, array  
mov esi, intervals  
mov ecx, intervals_size 

index_for_intervals:
	mov eax, [esi]
	sub eax, xmin
	mov [esi], eax
	add esi, 4
	loop index_for_intervals

mov esi, intervals
mov ecx, intervals_size
mov ebx, 0
mov eax, [esi]

for_loop:
	push ecx  
	mov ecx, eax 
	push esi  
	mov esi, result 

    for_array:
		cmp ecx, 0 
		je end_for
        mov eax, [edi]
        add [esi + 4*ebx], eax
        add edi, 4
        loop for_array

end_for:
    pop esi
    inc ebx
	mov eax, [esi]
	add esi, 4
	sub eax, [esi]
	neg eax 
	pop ecx
	loop for_loop

mov esi, result
mov ecx, intervals_size
mov eax, 0

final_interval: 
	add eax, [esi]
	add esi, 4
	loop final_interval

mov esi, result
sub eax, array_size
neg eax

add [esi + 4*ebx], eax

pop ebp
pop edi
pop esi

ret
mod2 ENDP
END
