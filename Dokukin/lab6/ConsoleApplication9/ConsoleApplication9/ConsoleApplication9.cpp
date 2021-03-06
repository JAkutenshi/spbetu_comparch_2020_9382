#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <ctime>
#include <random>

extern "C" // C functions usage
{
	void _form_array(int NumRanDat, int numRanges, int* arr, int* LGrInt, int* res_arr);
}

int main()
{
	srand(time(0));

	int NumRanDat = 0;
	std::cout << "Enter random nubmers array length:\n";
	std::cin >> NumRanDat;
	if (NumRanDat > 16 * 1024) {
		NumRanDat = 16 * 1024;
	}
	int Xmin = 0, Xmax = 0, NInt = 0;
	std::cout << "Enter lower bound:\n";
	std::cin >> Xmin;
	std::cout << "Enter higher bound:\n";
	std::cin >> Xmax;
	std::cout << "Enter number of ranges(<= 24): ";
	std::cin >> NInt;
	if (NInt > 24) {
		NInt = 24;
	}
	int* LGrInt = new int[NInt];
	std::cout << "Enter " << NInt << " lower bounds of intervals:\n";
	for (int i = 0; i < NInt; i++)
	{
		std::cin >> LGrInt[i];
		if (i != 0) while (LGrInt[i] < LGrInt[i - 1])
		{
			std::cout << "Entered bound " << LGrInt[i] << " is lower than previous, try again.\n";
			std::cin >> LGrInt[i];
		}
		while (LGrInt[i] < Xmin || LGrInt[i] > Xmax)
		{
			std::cout << "Entered bound " << LGrInt[i] << " is not included in the specified intervals, try again.\n";
			std::cin >> LGrInt[i];
		}
	}

	// End of input

	int* arr = new int[NumRanDat]();

	for (int i = 0; i < NumRanDat; i++)
	{
		int r = rand();
		arr[i] = Xmin + r % (Xmax - Xmin + 1);
	}

	int* res_arr = new int[NInt];
	for (int i = 0; i < NInt; i++)
		res_arr[i] = 0;
	_form_array(NumRanDat, NInt, arr, LGrInt, res_arr); // Assembler

	// Output
	std::ofstream file("res.txt");
	std::cout << "Generated pseudo-random numbers:\n";
	file << "Generated pseudo-random numbers:\n";
	for (int i = 0; i < NumRanDat; i++)
	{
		std::cout << arr[i] << " ";
		file << arr[i] << " ";
	}
	std::cout << "\n";
	file << "\n";
	std::cout << "\n# of intervals\tlower bound\tcount\n";
	file << "\n# of intervals\tlower bound\tcount\n";
	for (int i = 0; i < NInt; i++) {
		int res = LGrInt[i];
		file << "     " << i + 1 << "\t\t    " << res << "\t\t   " << res_arr[i] << "\n";
		std::cout << "     " << i + 1 << "\t\t    " << res << "\t\t   " << res_arr[i] << "\n";
	}
	return 0;
}