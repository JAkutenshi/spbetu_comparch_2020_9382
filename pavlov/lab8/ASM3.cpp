#include <iostream>
#include <math.h>

using namespace std;

double Asin(double x) {
	__asm {
		fld x
		fld1
		fld x
		fld x
		fmulp st(1), st(0)
		fsubp st(1), st(0)
		fsqrt
		fpatan
		fstp x
	}
	return x;
}

int main()
{
	setlocale(LC_ALL, "Rus");
	double x = 0.0;
	cout << "Введите вещественное число от -1 до 1 : ";
	cin >> x;
	while (!(x <= 1 && x >= -1)) {
		cout << "Повторяю: от -1 до 1! : ";
		cin >> x;
	}
	cout << "Неповторимый оригинал (ассемблер feat. математический сопроцессор): " << Asin(x) << "\n";
	cout << "Жалкая пародия (математическая библиотека Си): " << asin(x) << "\n";
}