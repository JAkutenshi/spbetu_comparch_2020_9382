#include <iostream>
#include <fstream>

#define n 80
int main() {
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");
    std::cout << "Работу выполнил: студент группы 9382 Иерусалимов Никита" << std::endl;
    std::cout << "15.Исключение русских букв и цифр, введенных во входной строке, при формировании выходной строки." << std::endl;
    char str[n + 1];
    char answer[n + 1];
    std::cout << "Введите строку для обработки:\n";
    std::cin.getline(str, n + 1);
    std::cout << "Строка до обработки:\n" << str << "\n";
    _asm {
        mov al, 0;		в al заносим нуль - символ
        mov ecx, n;	 в ecx сохраняем максимальную длину строки ecx = N
        lea edi, str;	edi указывает на начало строки string1
        repne scas; 	ecx = N - длина введенной строки
        sub ecx, n; 	ecx = -длина строки
        neg ecx;		ecx = длина строки
        mov edx, ecx;    edx = ecx
        sub edi, edi; 	edi == 0
        sub esi, esi;    esi == 0      

        sentens :
                 mov edi, edx;	edi = edx
                 sub edi, ecx;	edi будет указывать на текущий элемент строки, т.к.сначала edi указывает на последний элемент, а ecx уменьшается на 1 с каждой итерацией
                 mov al, str[edi];	в al лежит текущий элемент строки
                 cmp al,'A'
                 jl rus
                 cmp al, 'Z'
                 jle smallSentense
                 jmp print
        smallSentense :
                    cmp al, 'a'
                    jl skip
                    cmp al, 'z'
                    jle skip
                    jmp print

       rus :
                cmp al, 'Ё'
                    je skip
                    cmp al, 'ё'
                    je skip
                    cmp al, 'А'
                    jl print
                    cmp al, 'я'
                    jg digit
                    jmp skip
       digit :
                     cmp al,'0'
                     jl print
                    cmp al, '9'
                    jg print
                    jmp skip
            print :
            mov answer[esi], al
            inc esi

            skip :
                loop sentens

         mov answer[esi],0
    }
    std::cout << "Вывод обработанной строки:\n" << answer;
    std::fstream fout("output.txt");
    fout << "Строка до обработки:\n" << str << "\nВывод обработанной строки:\n" << answer;
    return 0;
}