#include <iostream>
#include <fstream>
#include <random>

using namespace std;

extern "C" void mod1(int* numbers, int numbers_size, int* result, int xmin);
extern "C" void mod2(int* array, int array_size, int xmin, int* intervals, int intervals_size, int* result);


int main()
{
	setlocale(0, "Russian");
	srand(time(NULL));
	ofstream result("result.txt");

	int numbers_size;
	int* numbers;
	int xmin, xmax;
	int intervals_size;
	int* intervals;
	int* intervals2;
	int* mod1_result;
	int* mod2_result;

	cout << "Enter count of numbers:\n";
	cin >> numbers_size;
	if (numbers_size > 16 * 1024)
	{
		cout << "Count of numbers must be <= 16*1024\n";
		return 0;
	}
	cout << "Enter xmin and xmax:\n";
	cin >> xmin >> xmax;
	cout << "Enter count of borders:\n";
	cin >> intervals_size;
	if (intervals_size > 24)
	{
		cout << "Count of intervals must be <= 24\n";
		return 0;
	}

	numbers = new int[numbers_size];
	intervals = new int[intervals_size];
	intervals2 = new int[intervals_size];

	int len_asm_mod1_res = abs(xmax - xmin) + 1;
	mod1_result = new int[len_asm_mod1_res];
	for (int i = 0; i < len_asm_mod1_res; i++)
	{
		mod1_result[i] = 0;
	}

	mod2_result = new int[intervals_size + 1];
	for (int i = 0; i < intervals_size + 1; i++)
	{
		mod2_result[i] = 0;
	}

	cout << "Enter all borders:\n";
	for (int i = 0; i < intervals_size; i++)
	{
		cin >> intervals[i];
		intervals2[i] = intervals[i];
	}

	for (int i = 0; i < numbers_size; i++)
	{
		numbers[i] = xmin + rand() % (xmax - xmin + 1);
	}

	cout << "Randomized values\n";
	result << "Randomized values\n";
	for (int i = 0; i < numbers_size; i++)
	{
		cout << numbers[i] << ' ';	
		result << numbers[i] << ' ';
	}
	cout << '\n';
	cout << '\n';
	result << '\n';
	result << '\n';

	cout << "The number of repetitions of each individual number:\n";
	result << "The number of repetitions of each individual number:\n";

	mod1(numbers, numbers_size, mod1_result, xmin);


	for (int i = 0; i < len_asm_mod1_res; i++)
	{
		cout << xmin + i << ": " << mod1_result[i] << "\n";
		result << xmin + i << ": " << mod1_result[i] << "\n";
	}
	cout << '\n';
	result << '\n';

	mod2(mod1_result, numbers_size, xmin, intervals, intervals_size, mod2_result);


	cout << "Result:\n";
	result << "Result:\n";
	cout << "Nom\tBorder\tCount of numbers" << endl;
	result << "Nom\tBorder\tCount of numbers" << endl;

	for (int i = 0; i < intervals_size + 1; i++)
	{
		if (i != intervals_size)
		{
			cout << i + 1 << "\t" << intervals2[i] << '\t' << mod2_result[i+1] << endl;
			result << i + 1 << "\t" << intervals2[i] << '\t' << mod2_result[i+1] << endl;
		}
	}

	delete[] numbers;
	delete[] intervals;
	delete[] intervals2;
	delete[] mod1_result;
	delete[] mod2_result;

	return 0;
}
