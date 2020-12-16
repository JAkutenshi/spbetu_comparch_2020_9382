#include <math.h>
#include <iostream>

double valexp(double val, int exp) {
    double a = val;
    double x = exp;

    _asm {
        fld a;   
        fld x;   
        fscale;  // умножаем a на 2 в степени x
        fstp a;  // Сохраняем вещественное значение в a с извлечением из стека
    }

    return a;
}

int main()
{
	setlocale(LC_ALL, "rus");
	double a = 0.0;
    	int x = 0;
	std::cout << "Введите число: ";
	std::cin >> a;
   	std::cout << "Введите степень: ";
    	std::cin >> x;
	std::cout << "Ответ: " << valexp(a, x) << "\n";
}
