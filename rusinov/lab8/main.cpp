#include <math.h>
#include <iostream>
#include <iomanip>
using namespace std;

/* Name Asin - compute asin
Usage double Asin(double* xP);
Prototype in math.h
Description Computes asin of the number pointed to by xP.
Arguments to asin must be in the range - 1 to 1, asin returns a value in the range - pi / 2 to pi / 2.
Use the trig identities : asin(x) = atan(x / sqrt(1 - x ^ 2)); */

double Asin(double* xP)
{
    double x = *xP;
    double y = -1;
    _asm {
            fld x;
            fld x;
            fmul;
            fld1;
            fsub st(0), st(1);
            fsqrt;
            fld x;
            fxch st(1);
            fpatan;
            fstp y;
    }
    return y;
}


int main()
{
    system("chcp 1251 > nul");
    double x;
    cout << "Введите x: ";
    cin >> x;
    while (x > 1 || x < -1) {
        cout << "Аргумент должен быть от -1 до 1, повторите ввод: ";
        cin >> x;
    }
    cout << "asin(x) из библиотеки math.h: " << setprecision(15) << asin(x) << endl;
    cout << "asin(x) ассемблерный: " << setprecision(15) << Asin(&x) << endl;
    return 0;
}
