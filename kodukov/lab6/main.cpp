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
    std::cout << "������: ����� �� � �������� ��������� ��� ��� ������\n";
    return false;
  }

  int i = 0, j = 0;
  while (i < cur_len) {
    if (LGrInt[i] < num)
      i++;
    else if (LGrInt[i] == num) {
      std::cout << "������: ����� ��� ������������ � �������\n";
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

  //��������� ���������� �����
  std::cout << "1.������� ���������� ��������� �����, 0 < N < 16384: ";
  std::cin >> NumRanDat;

  while (NumRanDat <= 0 || NumRanDat >= 16384) {
    std::cout << "������: ����� ������ ���� � ����������� ���������\n"
              << " ������� ���������� ��������� �����: ";
    std::cin >> NumRanDat;
  }

  //��������� ���������
  std::cout << "2.������� �������� ��������� �����: \n"
            << "��: ";
  std::cin >> Xmin;
  std::cout << "��: ";
  std::cin >> Xmax;

  while (Xmax <= Xmin) {
    std::cout << "������: ������ ������� ��������� ������ ���� ������ �����\n"
              << "������� ������ �������: ";
    std::cin >> Xmax;
  }

  Number = new int[NumRanDat];
  if (!Number) {
    std::cout << "������: �� ������� �������� ������\n";
    return false;
  }

  GetRandomNum(Number, NumRanDat, Xmin, Xmax);

  //��������� ���������� ����������
  std::cout << "3.������� ���������� ����������, �� ������� ���������� "
            << "�������� 0 < N < 25: ";
  std::cin >> NInt;

  while (NInt <= 0 || NInt >= 25) {
    std::cout << "������: ���������� ���������� �� � ��������� ���������\n"
              << "������� ���������� ����������: ";
    std::cin >> NInt;
  }

  LGrInt = new int[NInt];

  if (!LGrInt) {
    std::cout << "������: �� ������� �������� ������\n";
    return 0;
  }

  //��������� ����������
  std::cout << "4.����� ����������.\n";

  LGrInt[0] = Xmin;
  std::cout << "������� 1: " << Xmin << "\n";
  for (i = 1; i < NInt; i++) {
    do {
      std::cout << "������� " << i + 1 << ": ";
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

  std::cout << "������������� ��������� ����� �� ��������� ��������� �����:\n";
  std::cout << "�\t���.��.\t\t���-��\n";
  fout << "������������� ��������� ����� �� ��������� ��������� �����:\n";
  fout << "�\t���.��.\t\t���-��\n";

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

  std::cout << "������������� ��������� ����� �� �������� ����������:\n";
  std::cout << "�\t���.��.\t\t���-��\n";
  fout << "������������� ��������� ����� �� ��������� ��������� �����:\n";
  fout << "�\t���.��.\t\t���-��\n";

  for (i = 0; i < len; i++) {
    std::cout << i << '\t' << LGrInt[i] << "\t\t" << CountNum[i] << '\n';
    fout << i << '\t' << LGrInt[i] << "\t\t" << CountNum[i] << '\n';
  }

  fout.close();
}

int main() {
  int 
    NumRanDat = 0,  //���������� ��������������� �����
    *Number,  //������ �����
    Xmin = 0,        //����� ������� ���������
    Xmax = 0,        //������ ������� ���������
    NInt = 0,  //���������� ������ (�� � ������ ��������� ��������)
    *LGrInt,  //������ ����� ������
    *CountNumUnit1,  //��� ����������� ��������� �����
    lenUnit1 = 0,
    *CountNumN;  //��� ���������� ����������� �����

  if (!GetInformation(NumRanDat, Number, Xmin, Xmax, NInt, LGrInt))  //�������� ��������
    return 1;

  PrintArray(Number, NumRanDat);  //������� ��������� �����
  lenUnit1 = Xmax - Xmin + 1;     //��������� ������
  CountNumUnit1 = new int[lenUnit1];

  if (!CountNumUnit1) {
    std::cout << "������: �� ������� �������� ������\n";
    return 1;
  }

  InitArray(CountNumUnit1, lenUnit1);
  CountNumN = new int[NInt];

  if (!CountNumN) {
    std::cout << "������: �� ������� �������� ������\n";
    return 1;
  }

  InitArray(CountNumN, NInt);
  UNIT(Number, NumRanDat, CountNumUnit1,
            Xmin);  // ������������� �� ���������� 1
  ARBITARY(CountNumUnit1, lenUnit1, LGrInt, CountNumN, NInt,
            Xmin);  //������������� �� ��������� ������������ �����

  PrintResult1(CountNumUnit1, lenUnit1);  //����� ���������� ������ ���������
  PrintResult2(LGrInt, CountNumN, NInt);  //����� ���������� ������ ���������

  delete[] CountNumN;
  delete[] CountNumUnit1;
  delete[] Number;
  delete[] LGrInt;

  return 0;
}