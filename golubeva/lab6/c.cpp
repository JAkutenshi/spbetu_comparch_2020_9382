#include <iostream>
#include <fstream>
#include <ctime>
#include <random>

int64_t getRandomNumber(int64_t min, int64_t max)
{
    return min+rand()%(max-min);
}

extern "C" void DISTRIBUTION_INTERVAL(int64_t* left_boarders, int64_t* res_array, int64_t* array, int64_t size);

int main()
{
    int64_t size = 0;
    std::cout << "Введите длину массива: ";
    std::cin >> size;
    while (size > 16 * 1024) {
        std::cout << "Слишком много элементов! Введите длину, которая меньше или равно 16*1024\n";
        std::cin>>size;
    }

    int64_t Xmin = 0;
    std::cout << "Введите нижний диапазон: ";
    std::cin >> Xmin;

    int64_t Xmax = 0;
    std::cout << "Введите верхний диапазон: ";
    std::cin >> Xmax;

    int64_t intervals_count = 0;
    std::cout << "Введите количество диапазонов(<=24): ";
    std::cin >> intervals_count;
    while (intervals_count > 24) {
        std::cout << "Диапазонов слишком много! Введите количество интервалов, которое меньше или равно 24\n";
        std::cin>>intervals_count;
    }

    int64_t *left_boarders = new int64_t[intervals_count];
    std::cout << "Введите " << intervals_count - 1 << " нижниx границ интервалов ";
    for (int64_t i = 0; i < intervals_count - 1; i++) {
        std::cin >> left_boarders[i];
        while (left_boarders[i] > Xmax || left_boarders[i] < Xmin) {
            std::cout << "Введеная граница "<<left_boarders[i]<<" не входит в заданные промежутки! Введите снова\n";
            std::cin>>left_boarders[i];
        }
    }
    left_boarders[intervals_count - 1] = Xmax;

    int64_t *array = new int64_t[size];
    for (int64_t i = 0; i < size; i++) {
        array[i] = getRandomNumber(Xmin, Xmax);
    }

    int64_t *res_array = new int64_t[intervals_count];
    for (int64_t i = 0; i < intervals_count; i++) {
        res_array[i] = 0;
    }

    DISTRIBUTION_INTERVAL(left_boarders, res_array, array, size);

    std::ofstream res_file("res.txt");
    std::cout<<"Сгенерированные псевдослучайные числа: ";
    res_file<<"Сгенерированные псевдослучайные числа: ";
    for (int64_t i = 0; i < size; i++) {
        std::cout << array[i] << " ";
        res_file << array[i] << " ";
    }
    res_file <<"\n";
    std::cout<<"\n";
    std::cout << "\nNumer_interval\tLeft_borders\tCount_number\n";
    res_file << "\nNumer_interval\tLeft_borders\tN_number\n";
    for (int64_t i = 0; i < intervals_count; i++) {
            int64_t res = i != 0 ? left_boarders[i - 1] : Xmin;
            res_file << "    " << i+1 << "\t\t    " << res << "\t\t   " << res_array[i] << "\n";
            std::cout << "    " << i+1 << "\t\t    " << res << "\t\t   " << res_array[i] << "\n";
        }
}