#include <iostream>
#include <stdio.h>

#define N 80
using namespace std;

int main()
{
	system("chcp 1251 > nul");
	char string1[N + 1];
	char string2[N + 1] = { 0 };
	cout <<
		"Лабораторная работа №4,Вариант №22\n"
		"Выполнил cтудент группы 9382 Михайлов Дмитрий\n"
		"\tЗадание:\n"
		"Преобразование всех заглавных латинских букв входной строки в строчные, а десятичные в инверсные\n"
		"Остальные символы входной строки передаются в выходную строку непосредственно.\n"
		"Введите строку, не превышающую 80 символов:" << endl;
	cin.getline(string1, N, '\n');
	_asm
	{
		push si
		push di
		push ax
		lea si, string1
		lea di, string2

		FOREACH :
		lodsb;

		test al, al
			je EXIT
			//jmp NEXT
			cmp al, 41h
			jb NOTBIGALPHA
			cmp al, 5Ah
			ja NEXT

			BIGALPHA :
		add al, 20h
			jmp NEXT

			NOTBIGALPHA :
		cmp al, 30h // < 0
			jb NEXT
			cmp al, 39h // > 39
			ja NEXT

			NUMBER : // invert = 39h - char + 30h
		neg al
			add al, 69h

			NEXT :
		stosb;
		jmp FOREACH

			EXIT : stosb
			pop ax
			pop di
			pop si
	}
	cout << "\nСтрока, полученная после преобразований функции, реализованной на языке ASM:" << endl << string2 << endl;
	return 0;
}
