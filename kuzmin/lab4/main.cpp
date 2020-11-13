#include <iostream>

int main() {


	char* str = new char[80];
	char a;
	char index1;
	int index2;
	setlocale(LC_ALL, "Russian");
	std::cout << "Строка: ";
	fgets(str, 80, stdin);
	std::cout << "Латинская буква: ";
	a = std::getc(stdin);
	_asm {
		mov al, a 
		mov index1, al
		sub index1, 'a'
		mov edi, str
		mov ecx, 80
		cld
		repne scasb
		je found

		mov index2, -1
		jmp end

		found:
			sub edi, [str]
			mov index2, edi

	    end:
	}

	std::cout << "Номер символа в алфавите: " << (int)index1;
	std::cout << "\nПервое вхождение в строке: " << index2;
	return 0;
}