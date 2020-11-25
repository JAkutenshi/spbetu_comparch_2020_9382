#include <iostream>
#include <stdio.h>

#define N 80
using namespace std;


int main() {
    system("chcp 1251 > nul");
	  char s1[N + 1];
	  char s2[2 * N + 1];
    cout << "Лабораторная работа номер 4\n"
			"Заменить введенные во входной строке русские буквы на десятичные числа,\n"
			"соответствующие их номеру по алфавиту, остальные символы входной строки\n" 
			"передать в выходную строку непосредственно\n"
			"Выполнил Савельев И.С группа 9382\n";

    cin.getline(s1, N);
    
    __asm {
        mov ecx, N      
		lea si, s1
		lea di, s2
		cld

		WorkWork :

        lodsb

		cmp al, 'Ё'		; Если Ё
		je Yo

		cmp al, 'ё'		; Если ё
		je Yo;

		cmp al, 'А'		; Если < А не буква
		jl WriteSymbol;

		cmp al, 'я'		; Если > я не буква
		jg WriteSymbol;

		; в[A, я]

		cmp al, 'а'		; Если в[a, я]
		jge Inaia

		; попали сюда значит в[A, Я]
		cmp al, 'Е'
		jle YoMinus; перед Ё

		inc al; после Ё

		YoMinus :		
		sub al, 'А'
		inc al
		jmp FirstNumber

		Inaia :
		cmp al, 'е'		; перед ё
		jle YoSmall

		inc al			; после ё

		YoSmall : ; в[а, е]
		sub al, 'а'
		inc al

		jmp FirstNumber

		Yo :
		mov al, 7

		FirstNumber :
		cmp al, 29
		jg tri

		cmp al, 19
		jg dwa

		cmp al, 9
		jg odin

		mov ah, al
		mov al, '0'
		stosb
		mov al, ah
		jmp SecondNumber

		tri :
		mov ah, al
		mov al, '3'
		stosb
		mov al, ah
		sub al, 30
		jmp SecondNumber

		dwa :
		mov ah, al
		mov al, '2'
		stosb
		mov al, ah
		sub al, 20
		jmp SecondNumber

		odin :
		mov ah, al
		mov al, '1'
		stosb
		mov al, ah
		sub al, 10

	
		SecondNumber :
		add al, 48

		WriteSymbol :
		stosb

        loop WorkWork

		mov al, 0
		stosb

    }

	cout << s2;   
    return 0;
}
