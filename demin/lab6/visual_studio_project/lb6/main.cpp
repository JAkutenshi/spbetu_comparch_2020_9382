#include <iostream>
#include <random>
#include <fstream>

using namespace std;

extern "C" {
	void ASM_FUN(int* LGrIn, int* array, int* res, int NInt,int NumRanDat);
}


int main()
{
	int NumRanDat = 0;//Длина массива числе
	int Xmin = 0;//левая граница
	int Xmax = 0;//правая границв
	int NInt = 0;//количество интервалов 
	int* LGrInt = nullptr;// массив левых границ интервалов
	int* arr = nullptr;// массив целых чисел
	int* res = nullptr;// результирующий массив

	cout << "Enter the length of the array\n";
	cin >> NumRanDat;
	while (1) {
		if (NumRanDat > 0 && NumRanDat <= 16 * 1024) {
			break;
		}
		cout << "Wrong: try again\n";
		cout << "Enter the length of the array\n";
		cin >> NumRanDat;
	}
	arr = new int[NumRanDat];
	cout << "Enter the bottom border\n";
	cin >> Xmin;
	cout << "Enter the upper  border\n";
	cin >> Xmax;

	cout << "Enter number of intervals\n";
	cin >> NInt;

	while (1) {
		if (NInt > 0 && NInt <= 24) {
			break;
		}
		cout << "Wrong: try again\n";
		cout << "Enter number of intervals\n";
		cin >> NInt;
	}
	LGrInt = new int[NInt+1];
	res = new int[NInt];
	cout << "Enter " << NInt  << "lintervals\n";
	for (int i = 0; i < NInt ; i++)
	{
		cin >> LGrInt[i];
		while (1) {
			if (LGrInt[i] >= Xmin && LGrInt[i] <= Xmax) {
				break;
			}
			cout << "Wrong: try again\n";
			cin >> LGrInt[i];
		}
	}
	LGrInt[NInt] = Xmax +1;
	

	//дискретная равномерное распределение
	std::random_device                  rand_dev;
	std::mt19937                        generator(rand_dev());
	std::uniform_int_distribution<int>  distr(Xmin, Xmax);
	for (int i = 0; i < NumRanDat; i++)
	{
		arr[i] = distr(generator);
	}
	for (int i = 0; i < NInt; i++)
	{
		res[i] = 0;
	}
	

	//вызов ассемблерной функции
	ASM_FUN(LGrInt, arr, res, NInt, NumRanDat);

	std::ofstream file;
	file.open("out.txt");

	for (int i = 0; i < NumRanDat; i++)
	{
		cout << arr[i] << " ";
	}

	cout << "\n";

	for (int i = 0; i < NInt; i++)
	{
		if (i == NInt-1) {
			cout << "№" << i << " [" << LGrInt[i] << " ," << Xmax << "]: " << res[i] << "\n";
			continue;
		}else if (LGrInt[i]!= LGrInt[i + 1]) {
			cout << "№" << i << " [" << LGrInt[i] << " ," << LGrInt[i + 1] - 1 << "]: " << res[i] << "\n";
		}
		else {
			cout << "№" << i << " [" << LGrInt[i] << " ," << LGrInt[i + 1] << "]: " << res[i] << "\n";
		}
	}
	for (int i = 0; i < NInt; i++)
	{
		file << i << "  " << LGrInt[i] << "  " << res[i]<<"\n";
	}

	return 0;
}

