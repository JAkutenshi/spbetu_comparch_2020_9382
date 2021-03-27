#include <iostream>
#include <fstream>

#include <Windows.h>

int main() {
    system("chcp 65001");


    std::cout << "Вид преобразования 2:\n"
                 "Формирование выходной строки только из цифр и латинских букв входной строки" << std::endl;
    std::cout << "Hello, World!" << std::endl;

    //SetConsoleCP(866);
    //SetConsoleOutputCP(866);


    SetConsoleCP(1251);
    SetConsoleOutputCP(1251);

    const int size = 80;

    char s1[size + 1] = {0}; // input string
    char s2[size + 1] = {0};   // output string

    std::cin.getline(s1, size);

    //std::cout<<"size::"<<sizeof (s1)<<std::endl;

    asm("mov  %0, %%esi\n\t"     // SI = source_str
        "mov  %1, %%edi\n\t"     // DI = dest_str
        "mov $80, %%ecx\n\t"     // ECX = Nmax

        "get_symbol:\n\t"
        "lodsb (%%esi)\n\t"       
        "cmpb $'0', %%al\n\t"     
        "jl is_character\n\t"      
        "cmpb $'9', %%al\n\t"     
        "jg is_character\n\t"     


        "stosb (%%edi)\n\t"         
        "jmp final\n"

        "is_character:\n"

        "is_H:\n\t"
        "cmpb $'A', %%al\n\t "         
        "jl is_L\n\t"                      
        "cmpb $'Z', %%al\n\t"              
        "jg is_L\n\t"
        "stosb (%%edi)\n\t"
        "jmp final\n"
        "is_L:\n\t"
        "cmpb $'a', %%al\n\t "        
        "jl final\n\t"                      
        "cmpb $'z', %%al\n\t"              
        "jg final\n\t"
        "stosb (%%edi)\n\t"


        "final:\n\t"
        "loop get_symbol\n\t"
    ::"r"(s1), "r"(s2)
    );

    std::cout << "vot_tak_vot ->> " << s2 << std::endl;
    return 0;
}
