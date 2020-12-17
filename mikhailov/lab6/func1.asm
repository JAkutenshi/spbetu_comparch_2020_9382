.386
.MODEL flat, C 
.CODE 
func1 PROC C random_numbers : ptr dword, one_step_intervals_dist : ptr dword, number_of_random_numbers : dword, x_min : dword 
; Данная функция строит единичное распределение. 
mov ecx, 0; инициалиируем счетчик 
mov esi, random_numbers; Устанавливаем указатель на входные данные 
mov edi, one_step_intervals_dist; Устанавливаем указатель на выходные данные 
start_func1: 
; Начало цикла работы программы 
mov eax, dword ptr [esi+ecx*4]; Считываем значение из входной строки 
sub eax, x_min; вычисляем адрес, на котором находятся его смещения в массиве 
inc dword ptr [edi+eax*4]; 
inc ecx; 
cmp ecx, number_of_random_numbers; 
jl start_func1; 
ret 
func1 ENDP 
end