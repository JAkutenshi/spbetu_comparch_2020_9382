#include <math.h>
#include <iostream>
#include <iomanip>
using namespace std;

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
    cout << "Вычисляем asin(x)\nВведите x: ";
    cin >> x;
    while (x > 1 || x < -1) {
        cout << "Аргумент должен быть от -1 до 1, повторите ввод: ";
        cin >> x;
    }
    cout << "asin(x) библиотека: " << setprecision(15) << asin(x) << endl;
    cout << "asin(x) кастомный: " << setprecision(15) << Asin(&x) << endl;
    return 0;
}