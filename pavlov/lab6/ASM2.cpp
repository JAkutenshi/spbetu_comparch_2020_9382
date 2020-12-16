#include <iostream>
#include <random>
#include <new>
#include <fstream>

//Объявление ассемблерных процедур
extern "C" {
	void single(int* main_arr, int main_len, int* single_counter_arr, int min);
	void custom(int* single_counter_arr, int single_counter_len, int* left_borders_arr, int* custom_counter_arr, int custom_counter_len, int min);
}

//Заполнение массива случайными числами
void GetRandomNum(int*& Number, int len, int min, int max){
	std::random_device rd;
	std::mt19937 gen(rd());
	std::uniform_int_distribution<> distr(min, max);

	for (--len;len >= 0;len--) {
		Number[len] = distr(gen);
	}
}

//Вставка значения (границы) в массив
bool InsertBorder(int*& LGrInt, int cur_len, int num, int min, int max) {
	if (num < min || num > max) {
		std::cout << "Ошибка: число не в пределах интервала или уже задано\n";
		return false;
	}
	int i = 0;
	int j = 0;
	while (i < cur_len) {
		if (LGrInt[i] < num) {
			i++;
		}
		else if (LGrInt[i] == num) {
			std::cout << "Ошибка: число уже присутствует в массиве\n";
			return false;
		}
		else {
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

//Получение от пользователя информации о числах и интервалах
bool GetInformation(int& NumRanDat, int*& Number, int& Xmin, int& Xmax, int& NInt, int*& LGrInt){
	int len = 0;
	int i = 0;
	setlocale(LC_ALL, "rus");

	std::cout << "Введите количество случайных чисел (от 1 до 16384): ";
	std::cin >> NumRanDat;
	std::cout << NumRanDat << std::endl;

	while (!(NumRanDat > 0 && NumRanDat < 16385)){
		std::cout << "Число не входит в диапазон\n" << "Повторите ввод: ";
		std::cin >> NumRanDat;
	}

	std::cout << "Введите диапазон случайных чисел: \n" << "От: ";
	std::cin >> Xmin;
	std::cout << "До :";
	std::cin >> Xmax;

	while (Xmax <= Xmin){
		std::cout << "Правая граница диапазона должна быть больше левой\n" << "Повторите ввод: ";
		std::cin >> Xmax;
	}

	Number = new int[NumRanDat];

	if (!Number) {
		std::cout << "Не удалось выделить память для массива чисел\n";
		return false;
	}

	GetRandomNum(Number, NumRanDat, Xmin, Xmax);

	std::cout << "Введите количестно интервалов для разделения диапазона (от 1 до 24): ";
	std::cin >> NInt;

	while (NInt <= 0 || NInt > 24){
		std::cin.clear();
		std::cin.sync();
		std::cout << "Количество интервалов не входит в указанный диапазон\n" << "Повторите ввод: ";
		std::cin >> NInt;
	}
	LGrInt = new int[NInt];

	if (!LGrInt) {
		std::cout << "Не удалось выделить память для массива левых границ\n";
		return 0;
	}

	std::cout << "Выбор интервалов.\n" << "\t1.Распределить интервалы равномерно по диапазону\n" << "\t2.Установить интервалы самостоятельно\n";

	while (i == 0){
		std::cin >> i;

		switch (i){
		case 1:
			len = Xmax - Xmin;
			for (i = 0;i < NInt;i++) {
				LGrInt[i] = Xmin + len / NInt * i;
			}

			break;
		case 2:
			LGrInt[0] = Xmin;
			std::cout << "Граница 1: " << Xmin << "\n\n";
			for (i = 1;i < NInt;i++) {
				do {
					std::cout << "Граница " << i + 1 << ": ";
					std::cin >> len;
				} while (!InsertBorder(LGrInt, i, len, Xmin, Xmax));
			}

			break;
		default:
			std::cout << "Недопустимый номер операции, повторите ввод: ";
			i = 0;

			break;
		}
	}
	return true;
}

//Инициализация нулями
void InitArray(int*& Arr, int len){
	for (--len;len >= 0;len--) {
		Arr[len] = 0;
	}
}

//Вывод результата для единичных интервалов
void PrintResult1(int* Number, int len, int min){
	int i = 0;
	std::ofstream fout;
	fout.open("result1.txt");

	if (!fout.is_open()) {
		std::cout << "Не удалось открыть файл.\n";
		return;
	}

	std::cout << "Распределение случайных чисел по интервалам единичной длины:\n";
	std::cout << "№\tЛевая гр.\tКол-во\t\n";
	fout << "Распределение случайных чисел по интервалам единичной длины:\n";
	fout << "№\tЛевая гр.\tКол-во\t\n";

	for (i = 0;i < len;i++)
	{
		std::cout << i << '\t' << min + i << "\t\t" << Number[i] << '\n';
		fout << i << '\t' << min + i << "\t\t" << Number[i] << '\n';
	}

	std::cout << "-----------------------------\n";
	fout.close();
}

//Вывод результатов для различных интервалов
void PrintResult2(int* LGrInt, int* CountNum, int len){
	int i = 0;
	std::ofstream fout;
	fout.open("result2.txt");

	if (!fout.is_open()) {
		std::cout << "Не удалось открыть файл.\n";
		return;
	}

	std::cout << "Распределение случайных чисел по заданным интервалам:\n";
	std::cout << "№\tЛевая гр.\tКол-во\t\n";
	fout << "Распределение случайных чисел по интервалам единичной длины:\n";
	fout << "№\tЛевая гр.\tКол-во\t\n";

	for (i = 0;i < len;i++) {
		std::cout << i << '\t' << LGrInt[i] << "\t\t" << CountNum[i] << '\n';
		fout << i << '\t' << LGrInt[i] << "\t\t" << CountNum[i] << '\n';
	}

	fout.close();
}

//Вывод массива на экран
void PrintArray(int* array, int length) {
	for (int i = 0; i < length; i++) {
		std::cout << i << ") " << array[i] << "\n";
	}
}

int main(void) {
	int NumRanDat = 0;
	int* Number = nullptr;
	int Xmin = 0;
	int Xmax = 0;
	int NInt = 0;
	int* LGrInt = nullptr;
	int* CountNumUnit1 = nullptr;
	int lenUnit1 = 0;
	int* CountNumN = nullptr;

	//Ввод информации о массиве

	if (!GetInformation(NumRanDat, Number, Xmin, Xmax, NInt, LGrInt)) {
		return 1;
	}
	PrintArray(Number, NumRanDat);

	//Создание необходимых массивов

	lenUnit1 = Xmax - Xmin + 1;
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

	//Распределение и подсчёт

	single(Number, NumRanDat, CountNumUnit1, Xmin);
	custom(CountNumUnit1, lenUnit1, LGrInt, CountNumN, NInt, Xmin);

	//Вывод на экран и в файл

	PrintResult1(CountNumUnit1, lenUnit1, Xmin);
	PrintResult2(LGrInt, CountNumN, NInt);

	delete[] CountNumN;
	delete[] CountNumUnit1;
	delete[] Number;
	delete[] LGrInt;

	return 0;
}