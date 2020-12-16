#include <iostream>
#include <stdio.h>

#define N 80
using namespace std;

int main()
{
	system("chcp 1251 > nul");
	char string1[N+1];
	char string2[N+1] = { 0 };
	cout <<
		"Лабораторная работа №4,Вариант №3\n"
		"Выполнила cтудентка группы 9382 Круглова Виктория\n"
		"\tЗадание:\n"
		"Формирование выходной строки только из русских\n"
		"и латинских букв входной строки.\n"
		"Введите строку, не превышающую 80 символов:" << endl;
	cin.getline(string1, N, '\n');
	_asm {
			sub eax, eax; обнуляем eax
			mov al, 0;		в al заносим нуль - символ
			mov ecx, N;	 в ecx сохраняем максимальную длину строки ecx = N
			lea edi, string1;	edi указывает на начало строки string1
			repne scas; 	ecx = N - длина введенной строки
			sub ecx, N; 	ecx = -длина строки
			neg ecx;		ecx = длина строки
			mov edx, ecx;    edx = ecx
			sub edi, edi; 	edi == 0
			sub esi, esi;    esi == 0

			FOREACH:
				mov edi, edx;	edi = edx
				sub edi, ecx;	edi будет указывать на текущий элемент строки, т.к.сначала edi указывает на последний элемент, а ecx уменьшается на 1 с каждой итерацией
				mov al, string1[edi];	в al лежит текущий элемент строки

				cmp al, 'Ё'; проверяем отдельно Ё
				je PRINT_LETTER; если это Ё, то выводим в строку
				cmp al, 'ё'; проверяем отдельно ё
				je PRINT_LETTER; если это ё, то выводим в строку

				cmp al, 'А';	если символ < A, тогда это не русская буква
				jl MAYBE_LATIN; проверим латинская ли это буква
				cmp al, 'я';	если символ > я, тогда это не русская буква
				jg MAYBE_LATIN; проверим латинская ли это буква

				jmp PRINT_LETTER; выводим русскую букву

			MAYBE_LATIN:
				cmp al, 'A'; если символ < A, тогда это не латинская буква
				jl SKIP_LETTER; пропускаем символ

				cmp al, 'Z'; если символ <= Z, тогда это латинская буква
				jle PRINT_LETTER; выводим латинскую букву

				cmp al, 'a'; если символ < a, тогда это не латинская буква
				jl SKIP_LETTER;пропускаем символ

				cmp al, 'z'; если символ <= z, тогда это латинская буква
				jle PRINT_LETTER; выводим латинскую букву


			PRINT_LETTER :
				mov string2[esi], al
				inc esi

			SKIP_LETTER:
				loop FOREACH;

		mov string2[esi], 0
	}
	cout << "\nСтрока, полученная после преобразований функции, реализованной на языке ASM:" << endl << string2 << endl;
	return 0;
}
