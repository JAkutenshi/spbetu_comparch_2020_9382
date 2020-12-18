#include <iostream>
#include <fstream>

#define n 80
int main() {
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");
    std::cout << "Работу выполнила: студентка группы 9382 Балаева Милана" << std::endl;
    std::cout << "Вид преобразования: 5. Преобразование всех строчных латинских букв входной строки в" << std::endl;
    std::cout << "заглавные, а десятичных цифр в инверсные, остальные символы входной строки" << std::endl;
    std::cout << "передаются в выходную строку непосредственно." << std::endl;
    char str[n + 1];
    char answer[n + 1];
    std::cout << "Введите строку для обработки:\n";
    std::cin.getline(str, n + 1);
    std::cout << "Строка до обработки:\n" << str << "\n";
    _asm{
            mov ecx, n;длина строки в ecx
            mov al, 0
            lea    si, str; кладем в ds:si адрес str
            lea di, answer; кладем в es:di адрес answer
            cld; обнуление флага направления

            digit:
            lodsb; копирует один байт из памяти по адресу ds:si в регистр al
            cmp al, '0'
            jl character
            cmp al, '9'
            jg character
            sub al, '9'
            neg al
            add al, '0'
            jmp print

            character:
            cmp al, 'a'
            jl print
            cmp al, 'z'
            jg print
            sub al, 20h

            print:
            stosb; сохраняет регистр al в ячейке памяти по адресу es:di
            loop digit

            finish_processing:
            mov al, 0
            stosb
    }
    std::cout << "Вывод обработанной строки:\n" << answer;
    std::fstream fout("output.txt");
    fout << "Строка до обработки:\n" << str << "\nВывод обработанной строки:\n" << answer;
    return 0;
}