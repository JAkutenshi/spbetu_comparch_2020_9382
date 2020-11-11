#include <iostream>
#include <stdio.h>

using namespace std;
#define Nmax 80


int main() {
    system("chcp 1251 > nul");
    char strLine[Nmax];
    cin.getline(strLine, Nmax);
    cout << "Лабораторная работа№4. Выполнил Демин Виктор 9382\n"
        "Преобразование всех строчных латинских букв входной строки в заглавные, \n"
        "а десятичных цифр в инверсные, остальные символы входной строки передаются в выходную\n"
        "строку непосредственно.\n";
    char strOut[Nmax];

    _asm {
        mov ecx, Nmax
        sub eax, eax
        lea edi, strOut
        lea esi, strLine
        cld
        start : ;весь цикл
            lodsb
                    cmp al,0
                    jne ife
                    jmp exitLoopIter
                    ife:
                ; основной цикл
                    cmp al, '0'; проверка будет это цифра или буква
                    jae  digitOrletter
                        jmp exitLoopIter
                        digitOrletter:
                        cmp al, '9'; проверка если цифра
                        jbe digit
                            cmp al, 'A'
                            jae maybyLetter
                            jmp exitLoopIter
                        maybyLetter:
                        cmp al, 'Z'
                        jbe BigLetter
                            cmp al,'z'
                                jbe maybySmallLatter
                                jmp exitLoopIter
                                     maybySmallLatter:
                                cmp al, 'a'
                                    jae SmallLatter

                                    jmp exitLoopIter
                            SmallLatter : ;получение заглавной
                            sub al,32

                        jmp exitLoopIter
                        BigLetter : ;получение строчной
                        add al, 32
                        jmp exitLoopIter
                            digit:
                                mov ah, 57    
                                sub ah,al
                                mov al,48
                                add al, ah
                                jmp exitLoopIter
                exitLoopIter:
            stosb   
            loop    start
    };
    
    cout <<"Строка до преобразования:"<< strLine << "\n";
    cout<< "Строка после преобразования:" << strOut;

    return 0;
}

