#include <iostream>
#include <time.h>
#include <fstream>
using namespace std;

extern "C" void asmfirst(int* array, int arrayLength, int* oncefrequency, int xMin);
extern "C" void asmsecond(int frequencyLength, int xMin, int* LGrInt, int countOfBorder, int* frequency, int* result);

int main() {
	
	srand(time(nullptr));
	int  xMin, xMax, array_length, countOfBorders;

	cout << "enter array length\n";
	cin >> array_length;
	if (array_length <= 0 || array_length > 16 * 1024) {
		cout << "array length must be positive and less then 16 * 1024. Set by default 10\n";
		array_length = 10;
	}

	cout << "Enter minimum and maximum numbers\n";
	cin >> xMin >> xMax;
	if (xMin > xMax) {
		cout << "Minimum number more then maximum. They will be swap\n";
		int tmp = xMin;
		xMin = xMax;
		xMax = tmp;
	}

	cout << "Enter count of borders\n";
	cin >> countOfBorders;
	if (countOfBorders <= 0 || countOfBorders > 24) {
		cout << "Count of borders must be in range (0;24). Set by defauld 5\n";
		countOfBorders = 5;
	}

	int* array = new int[array_length];
	int* LGrInt = new int[countOfBorders + 1];
	int* result = new int[countOfBorders + 1];

	cout << "Enter " << countOfBorders<< " intervals\n";
	for (int i = 0; i < countOfBorders; i++) {
			cin >> LGrInt[i];
			if (i != 0) {
				if (LGrInt[i] < LGrInt[i - 1]) {
					cout << "Incorrect value\n";
					return 0;	
				}
			}
			result[i] = 0;
	
	}
	result[countOfBorders] = 0;
	LGrInt[countOfBorders] = xMax + 1;

	int* oncefrequency = new int[xMax - xMin + 1];
	for (int i = 0; i < xMax - xMin + 1; i++) oncefrequency[i] = 0;

	for (int i = 0; i < array_length; i++) {
		array[i] = xMin + rand() % (xMax - xMin + 1);
	}

	cout << "random numbers:\n";
	for (int i = 0; i < array_length; i++) cout << array[i] << " ";
	cout << endl;

	asmfirst(array, array_length, oncefrequency, xMin);
	
	for (int i = 0; i < xMax - xMin + 1; i++) {
		if (oncefrequency[i] == 0) continue;
		cout << xMin + i<< " ";
		cout << oncefrequency[i] << endl;
	}

	asmsecond(xMax - xMin + 1, xMin, LGrInt, countOfBorders + 1,  oncefrequency, result);

	

	ofstream fout;
	fout.open("file.txt");
	for (int i = 0; i < countOfBorders + 1; i++) {
		if (i == 0) fout << "¹" << i + 1 << " [" << xMin << "; " << xMin + LGrInt[i] << ") " << result[i] << endl;
		else if (i == countOfBorders)  fout << "¹" << i + 1 << " [" << xMin + LGrInt[i - 1] << "; " << xMin + LGrInt[i] - 1 << "] " << result[i] << endl;
		else  fout << "¹" << i + 1 << " [" << xMin + LGrInt[i - 1] << "; " << xMin + LGrInt[i] << ") " << result[i] << endl;
	}
	fout.close();

	return 0;
}