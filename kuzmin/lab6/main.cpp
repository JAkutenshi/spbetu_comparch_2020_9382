

#include <iostream>

int main()
{
	
	int n;
	int xmin;
	int xmax;
	int arr_length;

	setlocale(LC_ALL, "Russian");

	std::cout << "Введите размер массива: ";
	std::cin >> n;
	while (n <= 0) {
		std::cout << "Повторите ввод:";
		std::cin >> n;
	}
	int* randomnumbers = new int[n];

	std::cout << "Введите диапазон распределения: ";
	std::cin >> xmin >> xmax;
	while (xmin > xmax) {
		std::cout << "Повторите ввод:";
		std::cin >> xmin >> xmax;
	}
	const int range = abs(xmax - xmin) + 1;
	int* unitintervalfrequency = new int[range];


	std::cout << "Введите количество интервалов: ";
	std::cin >> arr_length;
	while (arr_length <= 0) {
		std::cout << "\nПовторите ввод: ";
		std::cin >> arr_length;
	}
	int* lgrint = new int[arr_length];
	int* frequency = new int[arr_length];


	std::cout << "Левые границы интервалов: ";
	for (int i = 0; i < arr_length; i++){
		std::cin >> lgrint[i];
		frequency[i] = 0;
	}


	std::cout << "Разделение на интервалы: ";
	for (int i = 0; i < arr_length; i++) {
		std::cout << "[" << lgrint[i] << ",";
		if (i != arr_length - 1) std::cout << lgrint[i + 1] - 1 << "]";
		else std::cout << xmax << "]";
	}
	std::cout << "\nМассив случайных чисел: ";
	for (int i = 0; i < n; i++) {
		randomnumbers[i] = rand() % (abs(xmax - xmin) + 1) + xmin;
		std::cout << randomnumbers[i] << " ";
		
	}
	for (int i = 0; i < range; i++) unitintervalfrequency[i] = 0;
	std::cout << "\nРаспределение по единичным интервалам:\n";
	int h;
	_asm {
	
	mov ecx, n
	sub ecx, 1
	sub ebx, ebx
	mov edx, randomnumbers
	mov eax, unitintervalfrequency
	unit:
	mov esi, [edx + ebx*4]
	sub esi, xmin
	add [eax + esi*4], 1
	cmp ebx, ecx
	jge endloop
	inc ebx
	jmp unit
	endloop:
	
	}
	for (int i = 0; i < range; i++)
	std::cout << "[" << i + xmin << "]: " << unitintervalfrequency[i] << "\n";
	_asm {
		
		mov eax, unitintervalfrequency
		mov edx, frequency

		mov ecx, arr_length
		sub edi, edi
		cmp ecx, 1
		je lastint

		sub ecx, 2

		
		mov esi, lgrint
		mov esi, [esi + edi*4];
		sub esi, xmin

		mov ebx, lgrint
		add edi, 1
		mov ebx, [ebx + edi*4]
		sub ebx, xmin
		sub edi, 1
	
			
	
		countinterval:
		cmp esi, ebx
		je nextinterval
		
		mov eax, [eax + esi * 4]
		add [edx + edi*4], eax
		mov eax, unitintervalfrequency

		inc esi

		jmp countinterval

		nextinterval:
		cmp edi, ecx
		je lastint
		jg endprog
		inc edi
		mov esi, lgrint
		mov esi, [esi + edi*4]
		sub esi, xmin
		mov ebx, lgrint
		add edi, 1
		mov ebx, [ebx + edi*4]
		sub edi,  1
		sub ebx, xmin

		jmp countinterval

		lastint:
		cmp ecx, 1
		je noinc
		inc edi
		noinc:
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
		mov esi, [esi + edi*4]
		sub esi, xmin
		jmp countinterval

		endprog:
	}
	std::cout << "Распределение по заданным интервалам:\n";
	for (int i = 0; i < arr_length; i++)
		if (i != arr_length - 1)std::cout << "[" << lgrint[i] << "," <<lgrint[i + 1] - 1 << "]: " << frequency[i] << "\n";
		else std::cout << "[" << lgrint[i] << "," << xmax << "]: " << frequency[i] << "\n";
}

