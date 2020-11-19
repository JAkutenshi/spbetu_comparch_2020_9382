#include <iostream>
#include <fstream>
#include <ctime>


int64_t getRandomNumber(int64_t min, int64_t max)
{
    return min + rand() % (max - min);
}

extern "C" void MODULE_INTERVAL(int64_t* left_boarders, int64_t* res_array, int64_t* array, int64_t size);

int main()
{
    int64_t size = 0;
    std::cout << "Введите длину массива: ";
    std::cin >> size;
    while (size <= 0 || size > 16 * 1024) {
        if (size > 16 * 1024) std::cout << "Слишком много элементов! Введите длину, которая меньше или равно 16*1024\n";
        else std::cout << "Кол-во элементов должно быть > 0! Введите заново: ";
        std::cin>>size;
    }

    int64_t Xmin = 0;
    std::cout << "Введите нижний диапазон: ";
    std::cin >> Xmin;

    int64_t Xmax = 0;
    std::cout << "Введите верхний диапазон: ";
    std::cin >> Xmax;

    int64_t countIntervals = 0;
    std::cout << "Введите количество диапазонов(<=24): ";
    std::cin >> countIntervals;
    while (countIntervals > 24) {
        std::cout << "Диапазонов слишком много! Введите количество интервалов, которое меньше или равно 24\n";
        std::cin >> countIntervals;
    }

    auto *leftBorders = new int64_t[countIntervals];
    std::cout << "Введите " << countIntervals - 1 << " нижниx границ интервалов: ";
    for (int64_t i = 0; i < countIntervals - 1; i++) {
        std::cin >> leftBorders[i];
        while (leftBorders[i] > Xmax || leftBorders[i] < Xmin) {
            std::cout << "Введеная граница " << leftBorders[i] << " не входит в заданные промежутки! Введите снова: ";
            std::cin >> leftBorders[i];
        }
        while (i != 0 && leftBorders[i-1] >= leftBorders[i]) {
            std::cout << "Введеная граница " << leftBorders[i] << " <= предыдущей границе! Введите снова: ";
            std::cin >> leftBorders[i];
        }
    }
    leftBorders[countIntervals - 1] = Xmax;

    auto *numberArray = new int64_t[size];
    for (int64_t i = 0; i < size; i++) {
        numberArray[i] = getRandomNumber(Xmin, Xmax);
    }

    auto *resultArray = new int64_t[countIntervals];
    for (int64_t i = 0; i < countIntervals; i++) {
        resultArray[i] = 0;
    }

    MODULE_INTERVAL(leftBorders, resultArray, numberArray, size);

    std::ofstream file("result.txt");
    std::cout<<"Сгенерированные псевдослучайные числа: ";
    file << "Сгенерированные псевдослучайные числа: ";
    for (int64_t i = 0; i < size; i++) {
        std::cout << numberArray[i] << " ";
        file << numberArray[i] << " ";
    }
    file << "\n";
    std::cout<<"\n";
    std::cout << "\nNumer_interval\tLeft_borders\tCount_number\n";
    file << "\nNumer_interval\tLeft_borders\tN_number\n";
    for (int64_t i = 0; i < countIntervals; i++) {
        int64_t res = i != 0 ? leftBorders[i - 1] : Xmin;
        file << "    " << i + 1 << "\t\t    " << res << "\t\t   " << resultArray[i] << "\n";
        std::cout << "    " << i+1 << "\t\t    " << res << "\t\t   " << resultArray[i] << "\n";
    }
}