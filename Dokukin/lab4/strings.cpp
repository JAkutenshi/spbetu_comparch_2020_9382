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
	// Symbol codes: '�' = -128, '�' = -127, ..., '�' = -97, '�' = -96, '�' = -95, ..., '�' = -81,'�' = -32, ..., '�' = -17, '�' = -16, '�' = -15
	
	asm("mov  %0, %%rsi\n\t"     // SI = source_str
        "mov  %1, %%rdi\n\t"     // DI = dest_str
        "mov $80, %%ecx\n\t"     // ECX = Nmax

        "get_symbol:"
        "lodsb (%%rsi)\n\t"        // ��������� ������ � AL
        "cmpb $0x30, %%al\n\t"     // ���������� ������ � ����� ����� 0 
        "jl is_character\n\t"      // ���� ������, �� �� �����, ���� ������ � �������� �� �����
        "cmpb $0x37, %%al\n\t"     // ���������� ������ � ����� ����� 7
        "jg is_character\n\t"      // ���� ������, �� �� ������������ �����, ���� � �������� �� �����

        "is_number:"
        "sub $0x30, %%al\n\t"    // �������� 48, ����� �������� �����
        "xor $0x7, %%al\n\t"     // ����������� ��������� 3 ����
        "add $0x30, %%al\n\t"    // ���������� 48, ����� �������� ��� ����� �����
        "jmp final\n\t"          // ��������� � ������ � �������� ������

        "is_character:"
        "cmpb $0xc0, %%al\n\t "   		  // C��������� � �������� 'A'
        "jl final\n\t"            		  // T��� ������, ��������� � ������ � �������� ������
        "cmpb $0xdf, %%al\n\t"    		  // C��������� � �������� '�'
        "jg final\n\t"   				  // T��� ������, �� �������� � ������ � �������� ������
        "add $0x20, %%al\n\t"     		  // �������� �������� �����

        "final:"
        "stosb (%%rdi)\n\t"      // ���������� ������ � �������� ������
        "loop get_symbol\n\t"    // ������������ � ������ ���� ecx!=0
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
