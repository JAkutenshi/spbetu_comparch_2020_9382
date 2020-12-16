#include <iostream>
#include <stdio.h>

#define NMax 80
using namespace std;


int main() {
    system("chcp 1251 > nul");
    char str[NMax], strOut[NMax];
    cin.getline(str, NMax);
    cout << " Инвертирование введенных во входной строке цифр в десятичной системе счисления (СС)\n"
        "и преобразование строчных русских букв в заглавные, остальные символы входной строки\n"
        "передаются в выходную строку непосредственно.\n"
        "Выполнил Дерюгин Дмитрий. гр. 9382\n";
    __asm {
        sub eax, eax; set eax in 0
        mov ecx, NMax; set ecx max length
        lea edi, strOut; move str in edi
        lea esi, str; move strOut in esi
        forloop:
            lodsb; copy in al from si
            cmp al, 0
            jne start
            jmp exitforloop

            start :
            cmp al, '0'; compare al with '0'
                jae digitorletter
                jmp exitforloop

                digitorletter :
            cmp al, '9'; compare al with '9'
                jbe digit; if al <= 9
                cmp al, 'А'; compare al with 'A'
                jae letter
                jmp exitforloop

                letter :
                    cmp al, 'Я'
                    jbe uppercaseletter
                    cmp al, 'я'
                    jbe lowercaseletter
                    jmp exitforloop

                        lowercaseletter :
                        sub al, 32
                        jmp exitforloop

                    uppercaseletter :
                        jmp exitforloop

            digit :
                mov ah, 57
                sub ah, al
                mov al, 48
                add al, ah
                jmp exitforloop
            exitforloop:
                stosb; save al t di
        loop forloop

    };

    cout << "Строка до преобразования:" << str << "\n";
    cout << "Строка после преобразования:" << strOut;
    return 0;
}
