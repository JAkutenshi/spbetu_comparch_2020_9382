#include <iostream>
#include <ctime> 
#include <windows.h> 
#include <fstream> 
#include <algorithm> 
#include <string>

using namespace std;
ofstream output("output.txt", ios_base::app);

extern "C"
{
	void func1(int* random_numbers, int* one_step_intervals_dist, int number_of_random_numbers, int x_min);
	void func2(int* one_step_intervals_dist, int* left_borders, int* dist, int x_min, int x_max);
}

void Log(const string& message)
{
	cout << message;
	output << message;
}

int PrintGet(const string& message)
{
	cout << message << ": ";
	int res;
	cin >> res;
	return res;
}

int PrintGetBorders(const string& message, int min, int max)
{
	cout << message << " [" << min << ", " << max << "]: ";
	int res;
	cin >> res;
	while (res < min || res > max)
	{
		cout << "Введеное число должно лежать в интервале от " << min << " до " << max << "! Повторите попытку:" << endl;
		cin >> res;
	}
	return res;
}

int main()
{
	setlocale(LC_ALL, "Russian");
	srand(time(NULL));

	// Ввод
	int min_num = PrintGet("Введите минимальное число");
	int max_num = PrintGetBorders("Введите максимальное число", min_num + 1, INT32_MAX - 1);
	cout << "Вы задали интервал: [" << min_num << ", " << max_num << "]" << endl;

	int random_count = PrintGetBorders("Введите кол-во чисел, которое требуется сгенерировать", 2, 16384);

	int* random_array = new int[random_count];
	for (int i = 0; i < random_count; i++) random_array[i] = rand() % (max_num - min_num + 1) + min_num;

	int borders_count = PrintGetBorders("Введите кол-во интервалов, на которые разбивается диапазон изменения массива псевдослучайных целых чисел", 2, 24);
	if (borders_count > (max_num - min_num + 1)) {
		cout << "Ошибка.Количество интервалов не может быть больше количества различных цифр" << endl;
		system("pause");
		exit(1);
	}

	int* left_borders = new int[borders_count];
	for (int i = 0; i < borders_count; i++) left_borders[i] = max_num + 1;

	for (int i = 0; i < borders_count - 1; i++) {
		left_borders[i] = PrintGetBorders("Введите " + to_string(i + 1) + (string)"-ую границу: ", min_num + 1, max_num - 1);
		for (int k = 0; k < i; k++) {
			if (left_borders[i] == left_borders[k]) {
				cout << "Граница не должна повторяться! Повторите попытку:" << endl;
				i--;
				break;
			}
		}
	}

	sort(left_borders, left_borders + borders_count - 1);

	// Вывод
	Log("Отсортированые значения левых границ: ");
	for (int i = 0; i < borders_count - 1; i++) {
		Log(to_string(left_borders[i]));
		if (i < borders_count - 2) {
			Log(", ");
		}
	}

	int* one_step_intervals_dist = new int[max_num - min_num + 1]{};
	func1(random_array, one_step_intervals_dist, random_count, min_num);
	Log(".\nСгенерированная выборка:\n");
	for (int i = 0; i < random_count; i++) {
		Log(to_string(random_array[i]));
		if (i < random_count - 1) {
			Log(",");
		}
	}

	Log(".\nЗначения единичных распределений для чисел от минимума до максимума:\n");
	for (int i = 0; i <= max_num - min_num; i++) {
		if (one_step_intervals_dist[i] == 0) continue;
		Log(to_string(i + min_num) + " -> " + to_string(one_step_intervals_dist[i]));
		if (i < max_num - min_num) {
			Log(";\n");
		}
	}

	Log("\nЗначения распределений:\n");
	int* dist = new int[borders_count] {};
	func2(one_step_intervals_dist, left_borders, dist, min_num, max_num);
	for (int i = 0; i < borders_count; i++) {
		Log(to_string(dist[i]));
		if (i < borders_count - 1) {
			Log(", ");
		}
	}

	Log(".\n\n***Таблица результатов***\n");
	Log("№ \t Левая граница \t Количество чисел, попавших в интервал\n");
	Log("1\t" + to_string(min_num) + "\t\t\t" + to_string(dist[0]) + "\n");
	for (int i = 0; i < borders_count - 1; i++) {
		Log(to_string(i + 2) + "\t" + to_string(left_borders[i]) + "\t\t\t" + to_string(dist[i + 1]) + "\n");
	}
	delete[] random_array;
	delete[] left_borders;
	delete[] dist;
	delete[] one_step_intervals_dist;
	output.close();
	system("PAUSE");
	return 0;
}