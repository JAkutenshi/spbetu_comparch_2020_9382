#include <math.h>
#include <iostream>

double ldexp(double value, int exp) {
    double x = value;
    double y = exp;

    _asm {
        fld y;   
        fld x;   
        fscale;  // умножаем х на 2 в степени у
        fstp x;  // Сохраняем вещественное значение в х с извлечением из стека
    }

    return x;
}

int main()
{
	setlocale(LC_ALL, "Rus");
	double x = 0.0;
    int y = 0;
	std::cout << "Введите  число : ";
	std::cin >> x;
    std::cout << "Введите  степень : ";
    std::cin >> y;
	std::cout << "Ответ : " << ldexp(x, y) << "\n";
}
