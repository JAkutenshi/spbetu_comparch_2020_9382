#include <fstream>
#include <iostream>
#include <windows.h>

int main(){
	SetConsoleCP(1251);
    SetConsoleOutputCP(1251);
	
	const int Nmax = 80;
	
	std::cout<<"Program for inverting octal numbers\n"
			   "and converting russian letters into lower case.\n"
			   "Made by ETU student Dokukin V.M., 9382.\n";
			   
	char* source_str = new char[Nmax+1]; // source_str[80] = '\0'
	char* dest_str = new char[Nmax+1];   // dest_str[80] = '\0'
	
	std::cin.getline(source_str, Nmax);
	source_str[Nmax] = '\0';
	dest_str[Nmax] = '\0';
	// Symbol codes: 'А' = -128, 'Б' = -127, ..., 'Я' = -97, 'а' = -96, 'б' = -95, ..., 'п' = -81,'р' = -32, ..., 'я' = -17, 'Ё' = -16, 'ё' = -15
	
	asm("mov  %0, %%rsi\n\t"     // SI = source_str
        "mov  %1, %%rdi\n\t"     // DI = dest_str
        "mov $80, %%ecx\n\t"     // ECX = Nmax

        "get_symbol:"
        "lodsb (%%rsi)\n\t"        // Загружаем символ в AL
        "cmpb $0x30, %%al\n\t"     // Сравниваем символ с кодом цифры 0 
        "jl is_character\n\t"      // Если меньше, то не цифра, идем дальше к проверке на буквы
        "cmpb $0x37, %%al\n\t"     // Сравниваем символ с кодом цифры 7
        "jg is_character\n\t"      // Если больше, то не восьмеричная цифра, идем к проверке на буквы

        "is_number:"
        "sub $0x30, %%al\n\t"    // Вычитаем 48, чтобы получить цифру
        "xor $0x7, %%al\n\t"     // Инвертируем последние 3 бита
        "add $0x30, %%al\n\t"    // Прибавляем 48, чтобы получить код новой цифры
        "jmp final\n\t"          // Переходим к выводу в выходную строку

        "is_character:"
        "cmpb $0xc0, %%al\n\t "   		  // Cравниваем с символом 'A'
        "jl final\n\t"            		  // Tсли меньше, переходим к выводу в выходную строку
        "cmpb $0xdf, %%al\n\t"    		  // Cравниваем с символом 'Я'
        "jg final\n\t"   				  // Tсли больше, то преходим к выводу в выходную строку
        "add $0x20, %%al\n\t"     		  // Получаем строчную букву

        "final:"
        "stosb (%%rdi)\n\t"      // Записываем символ в выходную строку
        "loop get_symbol\n\t"    // Возвращаемся в начало пока ecx!=0
        ::"m"(source_str),"m"(dest_str)
    );
    
	std::cout<<"\n----------------------------------\n";
	std::cout<<"Source string: " << source_str << '\n';
	std::cout<<"Destination string: " << dest_str << '\n';
	
	std::ofstream f("output.txt");
	if (f.is_open()){
		f << dest_str;
		f.close();
	}
	
	return 0;
}
