#include <stdio.h>

#include <iostream>

#define N 80
using namespace std;

int main() {
  system("chcp 1251 > nul");
  char _str[N + 1];
  cout << "ЛР4. Кодуков Александр 9382. \n 10. Преобразование введенных во входной "
          "шестнадцатиричных цифр в двоичную СС, остальные символы входной строки "
          "передаются в выходную строку непосредственно.\n";
  char str_out[N * 2 + 1];
  int i = 0;
  cin.getline(_str, N);
  _asm {
		sub eax, eax;
		mov al, 0;	  	in al code of str ending symbol
		mov ecx, N;	    ecx = N
		lea edi, _str;	edi now points at start of _str
		repne scas;   	ecx now contains N - str.length
		sub ecx, N;   	ecx = -str.length
		neg ecx;		    ecx = str.length
		mov edx, ecx;   edx = ecx
		sub edi, edi; 	edi == 0
		sub esi, esi;   esi == 0

	  traverse:
		  mov edi, edx;	edi = edx
			sub edi, ecx;	edi - points at last element in str, when we subtracting ecx we pointing to currentIdx, as ecx decreasing every iteration
			sub ax, ax
			mov al, _str[edi];	al contains currentElement

			cmp al, '0'; if symbol < 0 then its not hex number
			jl writeSymbol
			cmp al, 'F'; if symbol > F then its not hex number
			jg writeSymbol
			cmp al, '9'
			jle digit
			cmp al, 'A'
			jge letter
			jmp writeSymbol
		digit:
			sub al, '0'
			jmp tobin
		letter:
			sub al, 'A'
			add al, 10
			jmp tobin

		tobin:
			push ecx; save counter for global loop
			mov ecx, 4
			mov edi, esi; edi <- current pointer in str_out
		tobin_0:
			add edi, ecx
			sub edi, 1; edi += ecx - 1 to inverse write
      shr al, 1
      jc tobin_1
      mov bl,'0'
      jmp tobin_2
    tobin_1:
      mov bl,'1'
		tobin_2:
      mov str_out[edi], bl
			add edi, 1
			sub edi, ecx; restore edi
      inc esi
      loop tobin_0
		pop ecx; restore counter
		loop traverse

		writeSymbol :
      mov str_out[esi], al
      inc esi
      loop traverse
		mov str_out[esi], 0
  }
  cout << str_out;
  return 0;
}