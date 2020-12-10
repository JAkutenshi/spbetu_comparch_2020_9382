#include <iostream>
#include <stdio.h>

#define N 80
using namespace std;

int main()
{
    system("chcp 1251 > nul");
    char _str[N + 1];
    cout << "ЛР4. Юрьев Сергей 9382. \n 25. Инвертирование введенных во входной строке цифр в десятичной СС и преобразование заглавных русских букв в строчные, остальные символы входной строки передаются в выходную строку непосредственно.\n";
    char str_out[N * 2 + 1];
    int i = 0;
    cin.getline(_str, N);
    _asm {
        sub eax, eax;
        mov al, 0;	
            mov ecx, N;	 
            lea edi, _str;
            repne scas; 
            sub ecx, N; 
            neg ecx;
            mov edx, ecx;
            sub edi, edi;
            sub esi, esi;

            traverse:
        mov edi, edx;	
            sub edi, ecx;

            mov al, _str[edi];

            cmp al, '0'; 
        jge numbChecker; if al >= '0'
            jmp rus; else

            numbChecker :
            cmp al, '9';
            jle numb; if al <= '9'
                jmp rus; else

            numb :
            mov bl, 9; bl = 9
            cmp al, '0';
            je invertNumb if al == '0'
                mov bl, 7; bl = 7
            cmp al, '1'; 
            je invertNumb if al == '1'
                mov bl, 5;
            cmp al, '2'; if al == '2'
            je invertNumb
                mov bl, 3;
            cmp al, '3'; if al == '3'
            je invertNumb
                mov bl, 1;
            cmp al, '4';
            je invertNumb
                mov bl, 1;
            neg bl
                cmp al, '5';
            je invertNumb
                mov bl, 3;
            neg bl
                cmp al, '6';
            je invertNumb
                mov bl, 5;
            neg bl
                cmp al, '7';
            je invertNumb
                mov bl, 7;
            neg bl
                cmp al, '8';
            je invertNumb
                mov bl, 9;
            neg bl
                cmp al, '9';
            je invertNumb
            jmp writeSymbol

            invertNumb :
            add al, bl;


            rus :
            cmp al, 'А';
            jge rusAlf; if al >= 'A'
            jmp writeSymbol

            rusAlf :
            cmp al, 'Я'; 
            jle inverse; if al <= 'Я'
            jmp writeSymbol

            inverse :
            add al, 32;
            
            writeSymbol :
            mov str_out[esi], al;
            inc esi;
            loop traverse;

        mov str_out[esi], 0
    }
    cout << str_out;
    return 0;
}
