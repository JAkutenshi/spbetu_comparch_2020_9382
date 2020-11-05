#include <iostream>
#include <stdio.h>

#define N 80
using namespace std;

int main()
{
    system("chcp 1251 > nul");
    char _str[N + 1];
    cout << "ЛР4. Сорокумов Сергей 9382. \n 19. Заменить введенные во входной строке латинские буквы на числа, соответствующие их номеру по алфавиту, представленному в десятичной СС, остальные символы входной строки передать в выходную строку непосредственно.\n";
    char str_out[N * 2 + 1];
    int i = 0;
    cin.getline(_str, N);
    _asm {
        sub eax, eax;
        mov al, 0;		in al code of str ending symbol
            mov ecx, N;	    ecx = N
            lea edi, _str;	edi now points at start of _str
            repne scas; 	ecx now contains N - str.length
            sub ecx, N; 	ecx = -str.length
            neg ecx;		ecx = str.length
            mov edx, ecx;    edx = ecx
            sub edi, edi; 	edi == 0
            sub esi, esi;    esi == 0

            traverse:
         mov edi, edx;	edi = edx
             sub edi, ecx;	edi - points at last element in str, when we subtracting ecx we pointing to currentIdx, as ecx decreasing every iteration

            mov al, _str[edi];	al contains currentElement

            cmp al, 'a'
            jge small
            cmp al, 'A'
            jge big
            jmp writeSymbol


        small:
            cmp al , 'z'
            jle  number_small
            jmp writeSymbol
        
        big:
            cmp al, 'Z'
            jle number_big
            jmp writeSymbol

        number_big:
            sub al, 'A'
                inc al
                cmp al, 10
                jl startAlf
                cmp al, 20
                jl midleAlf
                jmp endAlf

        number_small:
            sub al, 'a'
              inc al
            cmp al, 10
            jl startAlf
            cmp al, 20
            jl midleAlf
            jmp endAlf
            

        startAlf:
            mov str_out[esi], '0'
            inc esi
                add al, 48
            jmp writeSymbol

        midleAlf:
            mov str_out[esi], '1'
                inc esi
                sub al, 10
                add al, 48
                jmp writeSymbol

        endAlf :
            mov str_out[esi], '2'
                inc esi
                sub al, 20
                add al, 48
                jmp writeSymbol

           writeSymbol :
            
            mov str_out[esi], al
            inc esi
            loop traverse;

             mov str_out[esi], 0
    }
    cout << str_out << endl;
    system("pause");
    std::cout << "To continue the program, press any key ...";
    std::cin.get();
    return 0;
}