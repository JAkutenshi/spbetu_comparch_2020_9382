#include <math.h>
#include <iostream>
#include <iomanip>
using namespace std;

/* function
Name 	Acos - compute acos
Usage 	double Acos(double *xP);
Prototype in math.h
Description Computes acos of the number pointed to by xP.
Arguments to acos must be in the range - 1 to 1, acos returns a value in the range 0 to pi.
Use the trig identities acos(x) = atan(sqrt(1 - x ^ 2) / x) */
double Acos(double* xP)
{
	double x = *xP;
	double y = -1;
	_asm {
		fld x;		// вставляем в стек x, stack: 0)x
		fld x;		// вставляем в стек x, stack: 0)x , 1)x
		fmul;		// переменожает два первых значения в стеке, stack: 0)x^2
		fld1;		// вставляем единицу в стек, stack: 0)1 , 1)x^2
		fxch st(1);	// меняем местами элементы стека 0 и 1, stack: 0)x^2, 1)1
		fsub;		// вычитаем из 1, 0 элемент стека и вставляем в 0 элемент, stack: 0) 1-x^2
		fsqrt;		// вычисляем корень у 0 элемента стека и вставляем в 0 элемент, stack: 0) sqrt(1-x^2)
		fld x;		// вставляем в стек x, stack: 0)x , 1)sqrt(1-x^2)
		fdiv;		// делим 1 элемент стека на нулевой и вставляем в стек, stack: 0) sqrt(1-x^2)/x
		fld1;		// вставляем 1 в стек, stack: 0)1 , 1)sqrt(1-x^2)/x
		fpatan;		// считаем арктангенс от числа, образованного
					// делением 1 элемента на 0 элемент стека, stack: 0) arctan(sqrt(1-x^2)/x)
		fstp y;		// достаем из стека элемент 0 в переменную y.

		//надо рассмотреть случай с отрицательным значением

		fldz;		//вставляем в стек число 0, stack: 0) 0
		fld x;		//вставляем в стек переменную x, stack: 0)x, 1)0
		fcom;		//сравниваем два элемента из стека
		fstsw ax;	//забираем результат из сопроцессора  
		sahf		//загружаем ax в регистр флагов
			jae to_end;	//если x >= 0
		fld y;		//записываем в стек переменную y, stack 0)y
		fldpi;		//записываем в стек константу пи, stack: 0)pi, 1)y
		fadd;		//складываем два элемента из стека и кладем в 0 элемент, stack: 0) pi+y
		fstp y;		//кладем элемент из стека в y
	to_end:
	}
	return y;
}


int main()
{
	system("chcp 1251 > nul");
	double x;
	cout << "Введите x: ";
	cin >> x;
	while (x < -1 || x>1) {
		cout << "Аргумент должен быть в пределах от -1 до 1!" << endl;
		cout << "Введите x: ";
		cin >> x;
	}
	cout << "acos(x) из библиотеки math.h: " << setprecision(15) << acos(x) << endl;
	cout << "Acos(x) ассемблерный: " << setprecision(15) << Acos(&x) << endl;
	return 0;
}
