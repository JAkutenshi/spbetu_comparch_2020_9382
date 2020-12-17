#include <math.h>
#include <iostream>
#include <iomanip>

using namespace std;
/* var6
function
Name Acos - compute acos
Usage double Acos (double *xP);
Prototype in math.h
Description Computes acos of the number pointed to by xP.
 Arguments to acos must be in the range -1 to 1, acos returns a value in the range 0 to pi.
Use the trig identities acos (x) = atan (sqrt (1-x^2) / x) */


double acosAsm(double* xP) {
    double x = *xP;
    double y = -1;
    _asm {
        fld x;// кладем в стек x
        fld x;
        fmul;// переменожаем два первых значения в стеке -- (x^2)
        fld1;// кладем единицу в стек
        fxch st(1);// меняем местами элементы стека st(0) и st(1)
        fsub;// вычитаем из 1ого 0ый элемент стека и кладем в 0 элемент -- (1 - x^2)
        fsqrt;// вычисляем корень 0ого элемента стека -- sqrt(1-x^2)
        fld x;
        fdiv;// делим 1ый элемент стека на 0ой и кладем в стек -- sqrt(1-x^2)/x
        fld1;
        fpatan;// вычисляем арктангенс от числа, образованного делением 1 элемента на 0 элемент стека -- atan(sqrt(1-x^2)/x)
        fstp y;// кладем элемент 0 в переменную y
        // определяем дальнейшие действия в случае отрицательного или положительного значения
        fldz;// кладем в стек число 0
        fld x;
        fcom;// сравниваем два элемента из стека
        fstsw ax;// берем результат из сопроцессора
        sahf;// загружаем ax в регистр флагов
        jae finish;// в случае, если x >= 0
        fld y;
        fldpi;// кладем в стек константу пи
        fadd;// складываем два элемента из стека и кладем в 0 элемент
        fstp y;
    finish:
    }
    return y;
}


int main()
{
    double x;
    cout << "Enter x:\n";
    cin >> x;
    while ((x < -1) || (x > 1)) {
        cout << "Data must be at range of -1 to 1.\n\n";
        cout << "Enter x again:\n";
        cin >> x;
    }
    cout << "acos(x) of math.h: " << setprecision(15) << acos(x) << '\n'; // Иначе консольный вывод сьедает всю точность
    cout << "acos(x) of assembler: " << setprecision(15) << acosAsm(&x) << '\n';
    return 0;
}
