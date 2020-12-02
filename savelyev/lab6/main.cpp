#include <iostream>
#include <fstream>
#include <ctime>
#include <random>

extern "C" void INTERVAL_SORTING(int64_t* LGrInt, int64_t* result, int64_t* array, int64_t NInt);

int64_t getRandomNumber(int64_t min, int64_t max) {
    std::random_device rd;
    std::mt19937 mt(rd());
    std::uniform_int_distribution<int> dist(min, max);
    return dist(mt);
}

int main() {
    int64_t NInt = 0;
    int64_t Xmin = 0;
    int64_t Xmax = 0;
    int64_t count = 0;
    int64_t res;

    std::cout << "Введите длину массива: ";
    std::cin >> NInt;

    while (NInt > 16384) {
        std::cout << "Длинна больше допустимой, введите заново: ";
        std::cin >> NInt;
    }

    std::cout << "Введите нижний интервал: ";
    std::cin >> Xmin;

    std::cout << "Введите верхний интервал: ";
    std::cin >> Xmax;

    while (Xmax <= Xmin) {
        std::cout << "Введен не коректный верхний интервал, введите еще раз: " << '\n';
        std::cin >> Xmax;
    }

    std::cout << "Введите количество интервалов: ";
    std::cin >> count;

    while (count > 24) {
        std::cout << "Введено не коректное число, введите еще раз: ";
        std::cin >> count;
    }

    int64_t *LGrInt = new int64_t[count];
    std::cout << "Введите " << count - 1 << " нижниx границ интервалов: ";

    for (int64_t i = 0; i < count - 1; i++) {
        std::cin >> LGrInt[i];
        while (LGrInt[i] > Xmax || LGrInt[i] < Xmin) {
            std::cout << "Введеная граница " << LGrInt[i] << " не входит в заданные промежутки! Введите еще раз: ";
            std::cin >> LGrInt[i];
        }
    }

    LGrInt[count - 1] = Xmax;

    int64_t *array = new int64_t[NInt];

    for (int64_t i = 0; i < NInt; i++) {
        array[i] = getRandomNumber(Xmin, Xmax);
    }

    int64_t *result = new int64_t[count];
    for (int64_t i = 0; i < count; i++) {
        result[i] = 0;
    }

    INTERVAL_SORTING(LGrInt, result, array, NInt);

    std::ofstream out_file("result.txt");
    std::cout << "Набор случайных чисел: ";
    out_file << "Набор случайных чисел: ";
    for (int64_t i = 0; i < NInt; i++) {
        std::cout << array[i] << " ";
        out_file << array[i] << " ";
    }
    out_file << "\n";
    std::cout << "\n";
    std::cout << "\nНомер интервала\tЛевая граница\tКоличество чисел\n";
    out_file << "\nНомер интервала\tЛевая граница\tКоличество чисел\n";

    for (int64_t i = 0; i < count; i++) {
        if(i != 0) {
            res = LGrInt[i - 1];
        }
        else{
            res = Xmin;
        }
            out_file << "       " << i+1 << "\t\t     " << res << "\t\t\t     " << result[i] << "\n";
            std::cout << "       " << i+1 << "\t     " << res << "\t\t     " << result[i] << "\n";
    }

    delete result;
    delete array;
    delete LGrInt;

}
