#include <ctime> 
#include <iostream> 
#include <windows.h> 
#include <fstream> 
#include <algorithm> 

using namespace std;
ofstream output("output.txt", ios_base::app);

extern "C"
{
	void func1(int *, int*, int, int);
	void func2(int*, int*, int*, int, int);
}

int main()
{
	setlocale(LC_ALL, "Russian");
	srand(time(NULL));
	int random_amount = 0, random_numbers[16384], x_min = 0, x_max = 0, borders_amount = 0, left_borders[30];
	cout << "Введите минимальное число: " << endl;
	cin >> x_min;
	x_max = x_min - 1;
	while (x_max <= x_min) {
		cout << "Введите максимальное число: " << endl;
		cin >> x_max;
		if (x_max <= x_min)
			cout << "Максимальное значение не можеть быть меньше минимального!" << endl;
	}
	cout << "Вы задали интервал: [" << x_min << ", " << x_max << "]" << endl;
	cout << "Введите кол-во чисел, которое требуется сгенерировать(<= 16384):" << endl;
	while (random_amount > 16384 || random_amount < 1) {
		cin >> random_amount;
		if (random_amount < 1 || random_amount > 16384)
			cout << "Введеное количество чисел должно лежать в интервале от 1 до 16384! Повторите попытку:" << endl;
	}
	for (int i = 0; i < random_amount; i++)
		random_numbers[i] = rand() % (x_max - x_min + 1) + x_min;
	cout << "Введите кол-во интервалов, на которые разбивается диапазон изменения массива псевдослучайных целых чисел [1, 24]:" << endl;
	while (borders_amount > 24 || borders_amount < 1) {
		cin >> borders_amount;
		if (borders_amount < 1 || borders_amount > 24)
			cout << "Введеное количество интервалов должно лежать в интервале [1; 24]! Повторите попытку:" << endl;
	}
	if (borders_amount >(x_max - x_min + 1)) {
		cout << "Ошибка.Количество интервалов не может быть больше количества различных цифр" << endl;
		system("pause");
		exit(1);
	}
	for (int i = 0; i < borders_amount; i++)
		left_borders[i] = x_max + 1;
	if (borders_amount == 1)
		goto stop;
	cout << "Введите следующее количество границ интервалов - " << borders_amount - 1 << " ." << endl;

	for (int i = 0; i < borders_amount - 1; i++) {
		cout << "Введите " << i + 1 << "-ую границу: ";
		cin >> left_borders[i];
		if (left_borders[i] < x_min || left_borders[i] > x_max) {
			cout << "Граница должна быть > " << x_min + 1 << " и " << " < " << x_max - 1 << "!" << endl;
			i--;
		}
		if (left_borders[i] == x_min) {
			cout << "Крайнее левое значение отрезка уже является левой границей!Повторите попытку:" << endl;
			i--;
		}
		for (int j = 0; j < i; ++j) {
			if (left_borders[i] == left_borders[j]) {
				cout << "Граница не должна повторяться! Повторите попытку:" << endl;
				i--;
			}
		}
	}
	sort(left_borders, left_borders + borders_amount - 1);
	cout << "Отсортированые значения левых границ: "; output << "Отсортированные значения левых границ: ";
	for (int i = 0; i < borders_amount - 1; i++) {
		cout << left_borders[i]; output << left_borders[i];
		if (i < borders_amount - 2) {
			cout << ", "; output << ", ";
		}
	}
	cout << "." << endl; output << "." << endl;
stop:
	int *one_step_intervals_dist = new int[x_max - x_min + 1]{};
	func1(random_numbers, one_step_intervals_dist, random_amount, x_min);
	cout << "Сгенерированная выборка: " << endl; output << "Сгенерированная выборка: " << endl;
	for (int i = 0; i < random_amount; i++) {
		cout << random_numbers[i]; output << random_numbers[i];
		if (i < random_amount - 1) {
			cout << ", "; output << ", ";
		}
	}
	cout << "." << endl; output << "." << endl;
	cout << "Значения единичных распределений для чисел от минимума до максимума: " << endl; output << "Значения единичных распределений для чисел от минимума до максимума: " << endl;
	for (int i = 0; i <= x_max - x_min; i++) {
		cout << i + x_min << " -> " << one_step_intervals_dist[i]; output << i + x_min << " -> " << one_step_intervals_dist[i];
		if (i < x_max - x_min) {
			cout << ";" << endl; output << ";" << endl;
		}
	}
	cout << "." << endl; output << "." << endl;
	int *dist = new int[borders_amount] {};
	func2(one_step_intervals_dist, left_borders, dist, x_min, x_max);
	cout << "Значения распределений: "; output << "Значения распределений: ";
	for (int i = 0; i < borders_amount; i++) {
		cout << dist[i]; output << dist[i];
		if (i < borders_amount - 1) {
			cout << ", "; output << ", ";
		}
	}
	cout << "." << endl; output << "." << endl;
	cout << endl << "***Таблица результатов***" << endl << "№ Левая граница Количество чисел, попавших в интервал" << endl;
	cout << "1\t" << x_min << "\t\t\t" << dist[0] << endl;
	for (int i = 0; i < borders_amount - 1; i++) {
		cout << i + 2 << "\t" << left_borders[i] << "\t\t\t" << dist[i + 1] << endl;
	}
	delete[] dist; // очищаем память 
	delete[] one_step_intervals_dist;
	system("PAUSE");
	return 0;
}