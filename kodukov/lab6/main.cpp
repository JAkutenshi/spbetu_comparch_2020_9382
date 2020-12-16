#include <ctime>
#include <fstream>
#include <iostream>
#include <random>

extern "C" {
void UNIT(int* Number, int NumRanDat, int* CountNumUnit1, int Xmin);
void ARBITARY(int* CountNumUnit1, int lenUnit1, int* LGrInt, int* CountNumN,
               int NInt, int Xmin);
}

void PrintArray(int *Arr, int num) { 
  for (int i = 0; i < num; i++) 
    std::cout << Arr[i] << " ";
  std::cout << "\n";
}

bool InsertBorder(int*& LGrInt, int cur_len, int num, int min, int max) {
  if (num < min || num > max) {
    std::cout << "Ошибка: число не в пределах интервала или уже задано\n";
    return false;
  }

  int i = 0, j = 0;
  while (i < cur_len) {
    if (LGrInt[i] < num)
      i++;
    else if (LGrInt[i] == num) {
      std::cout << "Ошибка: число уже присутствует в массиве\n";
      return false;
    } else {
      j = i;
      j = cur_len;
      while (i < j) {
        LGrInt[j] = LGrInt[j - 1];
        j--;
      }
      break;
    }
  }
  LGrInt[i] = num;

  return true;
}

void GetRandomNum(int*& Number, int len, int min, int max) {
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_int_distribution<> distr(min, max);

  for (--len; len >= 0; len--) Number[len] = distr(gen);
}

bool GetInformation(int& NumRanDat, int*& Number, int& Xmin, int& Xmax,
                    int& NInt, int*& LGrInt) {
  int len = 0, i = 0;

  setlocale(LC_ALL, "rus");

  //получение количества чисел
  std::cout << "1.Введите количество случайных чисел, 0 < N < 16384: ";
  std::cin >> NumRanDat;

  while (NumRanDat <= 0 || NumRanDat >= 16384) {
    std::cout << "Ошибка: число должно быть в приведенном диапазоне\n"
              << " Введите количество случайных чисел: ";
    std::cin >> NumRanDat;
  }

  //получение диапозона
  std::cout << "2.Введите диапазон случайных чисел: \n"
            << "От: ";
  std::cin >> Xmin;
  std::cout << "До: ";
  std::cin >> Xmax;

  while (Xmax <= Xmin) {
    std::cout << "Ошибка: правая граница диапозона должна быть больше левой\n"
              << "Введите правую границу: ";
    std::cin >> Xmax;
  }

  Number = new int[NumRanDat];
  if (!Number) {
    std::cout << "Ошибка: не удалось выделить память\n";
    return false;
  }

  GetRandomNum(Number, NumRanDat, Xmin, Xmax);

  //получение количества интервалов
  std::cout << "3.Введите количестно интервалов, но которые разобьется "
            << "диапозон 0 < N < 25: ";
  std::cin >> NInt;

  while (NInt <= 0 || NInt >= 25) {
    std::cout << "Ошибка: количество интервалов не в указанном диапазоне\n"
              << "Введите количество интервалов: ";
    std::cin >> NInt;
  }

  LGrInt = new int[NInt];

  if (!LGrInt) {
    std::cout << "Ошибка: не удалось выделить память\n";
    return 0;
  }

  //получение интервалов
  std::cout << "4.Выбор интервалов.\n";

  LGrInt[0] = Xmin;
  std::cout << "Граница 1: " << Xmin << "\n";
  for (i = 1; i < NInt; i++) {
    do {
      std::cout << "Граница " << i + 1 << ": ";
      std::cin >> len;
    } while (!InsertBorder(LGrInt, i, len, Xmin, Xmax));
  }

  return true;
}

void InitArray(int *Arr, int len) {
  for (--len; len >= 0; len--) Arr[len] = 0;
}

void PrintResult1(int *Number, int len) {
  int i = 0;
  std::ofstream fout("result1.txt");

  if (!fout.is_open()) {
    std::cout << "Error: can't open file " << '\n';
    return;
  }

  std::cout << "Распределение случайных чисел по инервалам единичной длины:\n";
  std::cout << "№\tЛев.гр.\t\tКол-во\n";
  fout << "Распределение случайных чисел по инервалам единичной длины:\n";
  fout << "№\tЛев.гр.\t\tКол-во\n";

  for (i = 0; i < len; i++) {
    std::cout << i << '\t' << i << "\t\t" << Number[i] << '\n';
    fout << i << '\t' << i << "\t\t" << Number[i] << '\n';
  }
  std::cout << "-----------------------------\n";

  fout.close();
}

void PrintResult2(int *LGrInt, int *CountNum, int len) {
  int i = 0;
  std::ofstream fout("result2.txt");

  if (!fout.is_open()) {
    std::cout << "Error: can't open file " << '\n';
    return;
  }

  std::cout << "Распределение случайных чисел по заданным интервалам:\n";
  std::cout << "№\tЛев.гр.\t\tКол-во\n";
  fout << "Распределение случайных чисел по инервалам еденичной длины:\n";
  fout << "№\tЛев.гр.\t\tКол-во\n";

  for (i = 0; i < len; i++) {
    std::cout << i << '\t' << LGrInt[i] << "\t\t" << CountNum[i] << '\n';
    fout << i << '\t' << LGrInt[i] << "\t\t" << CountNum[i] << '\n';
  }

  fout.close();
}

int main() {
  int 
    NumRanDat = 0,  //количество превдослучайных чисел
    *Number,  //массив чисел
    Xmin = 0,        //левая граница диапозона
    Xmax = 0,        //правая граница диапазона
    NInt = 0,  //количество границ (не в ключай граничный значения)
    *LGrInt,  //массив левых границ
    *CountNumUnit1,  //для интеревалов еденичной длины
    lenUnit1 = 0,
    *CountNumN;  //для интервалов проивольной длины

  if (!GetInformation(NumRanDat, Number, Xmin, Xmax, NInt, LGrInt))  //получить значения
    return 1;

  PrintArray(Number, NumRanDat);  //вывести случайные числа
  lenUnit1 = Xmax - Xmin + 1;     //выделение памяти
  CountNumUnit1 = new int[lenUnit1];

  if (!CountNumUnit1) {
    std::cout << "Ошибка: не удалось выделить память\n";
    return 1;
  }

  InitArray(CountNumUnit1, lenUnit1);
  CountNumN = new int[NInt];

  if (!CountNumN) {
    std::cout << "Ошибка: не удалось выделить память\n";
    return 1;
  }

  InitArray(CountNumN, NInt);
  UNIT(Number, NumRanDat, CountNumUnit1,
            Xmin);  // распределение по интервалам 1
  ARBITARY(CountNumUnit1, lenUnit1, LGrInt, CountNumN, NInt,
            Xmin);  //распределение по инервалам произвольной длины

  PrintResult1(CountNumUnit1, lenUnit1);  //вывод результата первой процедуры
  PrintResult2(LGrInt, CountNumN, NInt);  //вывод результата второй процедуры

  delete[] CountNumN;
  delete[] CountNumUnit1;
  delete[] Number;
  delete[] LGrInt;

  return 0;
}