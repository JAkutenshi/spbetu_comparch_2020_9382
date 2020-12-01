#define _CRT_SECURE_NO_WARNINGS

#include <math.h>
#include <stdio.h>

/* function
 Name ldexp - calculates value * 2^exp
 Usage double ldexp(double value, int exp);
 Prototype in math.h
 Description ldexp calculates value * 2^exp */

double Ldexp(double value, int exp) {
  double x = value;
  double p = exp;

  _asm {
    fld p;  // p -> st(0)
    fld x;  // x -> st(0), p -> st(1)
    fscale;  // st(0) * 2^st(1) = x * 2^p
    fstp x;  // pop st(0) -> x
  }

  return x;
}

int main()
{
  double x;
  int p;

  printf("Enter x: ");
  scanf("%lf", &x);
  printf("Enter pow: ");
  scanf("%d", &p);

  printf("math.h ldexp(x): %lf\n", ldexp(x, p));
  printf("asm Ldexp(x): %lf\n", Ldexp(x, p));

  return 0;
}