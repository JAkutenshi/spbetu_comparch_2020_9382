.MODEL flat, C 
.CODE 
func2 PROC C one_step_intervals_dist : ptr dword, left_borders : ptr dword, dist : ptr dword, x_min : dword, x_max : dword 
mov eax, x_min; Инициализация переменных 
mov ebx, 0; 
mov ecx, 0; 
mov edi, dist; 
mov edx, left_borders; 
mov esi, one_step_intervals_dist; 
start_func2: 
; Начало обработки 
cmp eax, dword ptr [edx]; Проверяет, нужно ли перейти на другой интервал. 
jge stuff; 
mov ebx, dword ptr [esi+ecx*4]; 
add dword ptr [edi], ebx; Увеличиваем счетчик интервала. 
; Увеличиваем переменные цикла 
inc ecx; 
inc eax; 
cmp eax, x_max; 
jle start_func2; 
jmp to_end; 
stuff: 
add edi, 4; Меняет интервал 
add edx, 4; 
jmp start_func2; возвращается 
to_end: 
ret 
func2 ENDP 
end 