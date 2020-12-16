#define _CRT_SECURE_NO_WARNINGS
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <ctime>
#include <random>

extern "C"
{
    void _form_array(int NumRanDat, int* arr, int* LGrInt, int* res_arr);
}

int main()
{
    int NumRanDat = 0;
    std::cout << "Enter length of array:\n";
    std::cin >> NumRanDat;
    if (NumRanDat > 16 * 1024) {
        std::cout << "Array is too long! It must not exceed 16*1024\n";
        return 0;
    }
    int Xmin = 0, Xmax = 0, NInt = 0;
    std::cout << "Enter low range:\n";
    std::cin >> Xmin;
    std::cout << "Enter high range:\n";
    std::cin >> Xmax;
    std::cout << "Enter number of ranges(<= 24): ";
    std::cin >> NInt;
    if (NInt > 24) {
        std::cout << "There are too many ranges! It must be less than or equal to 24\n";
        return 0;
    }
    int* LGrInt = new int[NInt]();
    std::cout << "Enter " << NInt - 1 << " lower bounds of intervals:\n";
    LGrInt[0] = Xmin;
    for (int i = 1; i < NInt; i++) {
        std::cin >> LGrInt[i];
        while (LGrInt[i] < LGrInt[i - 1]) {
            std::cout << "Entered bound " << LGrInt[i] << " are lower than previous! Enter again\n";
            std::cin >> LGrInt[i];
        }
        while (LGrInt[i] < Xmin || LGrInt[i] > Xmax) {
            std::cout << "Entered bound " << LGrInt[i] << " are not included in the specified intervals! Enter again\n";
            std::cin >> LGrInt[i];
        }
    }
    LGrInt[NInt - 1] = Xmax;
    int* arr = new int[NumRanDat]();
    for (int i = 0; i < NumRanDat; i++) {
        arr[i] = Xmin + rand() % (Xmax - Xmin + 1);
    }
    int* res_arr = new int[NInt];
    for (int i = 0; i < NInt; i++)
        res_arr[i] = 0;
    _form_array(NumRanDat, arr, LGrInt, res_arr);
    std::ofstream file("res.txt");
    std::cout << "Generated pseudo-random numbers:\n";
    file << "Generated pseudo-random numbers:\n";
    for (int i = 0; i < NumRanDat; i++) {
        std::cout << arr[i] << " ";
        file << arr[i] << " ";
    }
    std::cout << "\n";
    file << "\n";
    std::cout << "\nn_of_interval\tl_brs\tcnt_of_p-rm_n\n";
    file << "\nn_of_interval\tleft_brs\tcnt_of_p-rm_n\n";
    for (int i = 0; i < NInt; i++) {
        int res = i != 0 ? LGrInt[i] : Xmin;
        file << "     " << i + 1 << "\t\t    " << res << "\t\t   " << res_arr[i] << "\n";
        std::cout << "     " << i + 1 << "\t\t    " << res << "\t\t   " << res_arr[i] << "\n";
    }
}
