#include <iostream>
#include <fstream>

#define n 80
int main() {
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");
    std::cout << "Вариант 15.\nИсключение русских букв и цифр, введенных во входной строке, при формировании выходной строки.\nстудент 9382 г. - Пя Сон Хва\n";
    char str[n + 1];
    char answer[n + 1];
    std::cout << "Введите строку для обработки:\n";
    std::cin.getline(str, n+ 1);
    std::cout << "Строка до обработки:\n" << str << "\n";
    bool flag = false;
    for (int i = 0; i < strlen(str);i++)
        if (isalpha(str[i]))
            flag = true;
        if (flag) {
            _asm{
                    mov ecx, n;длина строки в ecx
                    mov al, 0
                    lea    si, str; кладем в ds:si адрес str
                    lea di, answer; кладем в di адрес answer
                    cld; обнуление флага направления

                    data_processing:
                    lodsb; копирует один байт из памяти по адресу ds:si в регистр al
                    cmp al, 'ё'
                    je for_exception; исключение кириллицы
                    cmp al, 'Ё'
                    je for_exception
                    cmp al, 'А'
                    jl check_digit_case
                    cmp al, 'я'
                    jg check_digit_case
                    loop data_processing
                    jmp finish_processing

                    for_exception:
                    loop data_processing

                    check_digit_case:; исключение цифр
                    cmp al, '0'
                    jl add_to_answer
                    cmp al, '9'
                    jg add_to_answer
                    loop data_processing

                    add_to_answer:
                    stosb; сохраняет регистр al в ячейке памяти по адресу es:di
                    loop data_processing

                    finish_processing:
                    mov al, 0
                    stosb
            }
        } else {
            answer[0] = '\0';
        }
   std::cout << "Вывод обработанной строки:\n" << answer;
    std::fstream fout("output.txt");
    fout << "Строка до обработки:\n" << str << "\nВывод обработанной строки:\n" << answer;
    return 0;
}