#include <iostream>
#include <fstream>
#define N 81

int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");
	std::ofstream output;
	std::cout << "\t\tВ данной программе из введённой строки удаляются\n\t\t\t   латинские буквы и цифры\n\t\t    Выполнил студент гр. 9382 Павлов Роман\n\n" <<
					"Введите строку: ";

	char s1[N];
	char s2[N];
	std::cin.getline(s1, N);

	_asm {
		mov ecx, N;
		mov al, 0
		lea si, s1
		lea di, s2
		cld
		
		step :
			lodsb

			cmp al, '\0'
			je ex

			digit1 :
				cmp al, '0'
				jl write
				jmp digit2

			digit2 :
				cmp al, '9'
				jg latin1
				jmp skip

			latin1 :
				cmp al, 'a'
				jl latinU1
				jmp latin2

			latin2 :
				cmp al, 'z'
				jg write
				jmp skip

			latinU1 :
				cmp al, 'A'
				jl write
				jmp latinU2

			latinU2 :
				cmp al, 'Z'
				jg write
				jmp skip

			write :
				stosb

			skip :
				loop step

			ex :
				stosb
				sub al, al
				xor si, si
				xor di, di
	}

	std::cout << "Выходная строка:  " << s2 << "\n";
	output.open("output.txt");
	output << "Исходная строка:  " << s1 << "\nВыходная строка:  " << s2 << "\n";
	output.close();
	return 0;
}