#include <iostream>
#include <fstream>
#include <ctime>
#include <random>

extern "C" void INTERVAL_SORTING(int64_t* LGrInt, int64_t* borderult, int64_t* array, int64_t NInt);

int main() {
    int64_t NInt = 0;
    int64_t Xmin = 0;
    int64_t Xmax = 0;
    int64_t count = 0;
    int64_t border;

int64_t RandD(int64_t Xmin, int64_t Xmax)
{
    std::random_device rd;
    std::mt19937 mt(rd());
    std::uniform_int_distribution<int> dist(Xmin, Xmax);
    return dist(mt);
}

    std::cout << "Введите длину массива: ";
    std::cin >> NInt;
    // Проверка длины массива
    while (NInt > 16384) {
        std::cout << "Длинна больше допустимой, введите заново: ";
        std::cin >> NInt;
    }

    std::cout << "Введите нижний интервал: ";
    std::cin >> Xmin;

    std::cout << "Введите верхний интервал: ";
    std::cin >> Xmax;
    // Проверка верхнего интервала
    while (Xmax <= Xmin) {
        std::cout << "Введен не коректный верхний интервал, введите еще раз: " << '\n';
        std::cin >> Xmax;
    }

    std::cout << "Введите количество интервалов: ";
    std::cin >> count;
    // Проверка интервалов
    while (count > 24) {
        std::cout << "Введено не коректное число, введите еще раз: ";
        std::cin >> count;
    }

    int64_t *LGrInt = new int64_t[count];
    std::cout << "Введите " << count - 1 << " нижниx границ интервалов: ";
    // Считывание нижних границ
    for (int64_t i = 0; i < count - 1; i++) {
        std::cin >> LGrInt[i];
        while (LGrInt[i] > Xmax || LGrInt[i] < Xmin) {
            std::cout << "Введеная граница " << LGrInt[i] << " не входит в заданные промежутки! Введите еще раз: ";
            std::cin >> LGrInt[i];
        }
    }

    LGrInt[count - 1] = Xmax;

    int64_t *array = new int64_t[NInt];
    // Генерация псевдослучайных чисел
    for (int64_t i = 0; i < NInt; i++) {
        array[i] = RandD(Xmin,Xmax);
    }
    // Обнуляем массив ответ
    int64_t *borderult = new int64_t[count];
    for (int64_t i = 0; i < count; i++) {
        borderult[i] = 0;
    }
    // Вызов ассемблерного модуля
    INTERVAL_SORTING(LGrInt, borderult, array, NInt);
    // Запись в файл и вывод на экран
    std::ofstream out_file("borderult.txt");
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
            border = LGrInt[i - 1];
        }
        else {
            border = Xmin;
        }
            out_file << "       " << i+1 << "\t\t     " << border << "\t\t\t     " << borderult[i] << "\n";
            std::cout << "       " << i+1 << "\t     " << border << "\t\t     " << borderult[i] << "\n";
    }
    // Освобождение памяти
    delete borderult;
    delete array;
    delete LGrInt;

}
