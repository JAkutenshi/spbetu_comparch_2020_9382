#include <iostream>
#include <fstream>
#include <ctime>
#include <random>

int64_t getRandomNum(int64_t min, int64_t max) {
    return min + rand() % (max - min);
}

void fillArray(int64_t size, int64_t *arr, int64_t min, int64_t max) {
    for (int64_t i = 0; i < size; i++)
        arr[i] = getRandomNum(min, max);
}

void initArray(int64_t size, int64_t *arr) {
    for (int64_t i = 0; i < size; i++)
        arr[i] = 0;
}

void readArray(int64_t size, int64_t *arr) {
    for (int i = 1; i < size; i++)
        std::cin >> arr[i];
}

void printArray(int64_t size, int64_t *arr) {
    for (int64_t i = 0; i < size; i++)
        std::cout << arr[i] << " ";

    std::cout << std::endl;
}

void printBordersAndCounts(int64_t size, int64_t *arr, int64_t *res) {
    for (int64_t i = 0; i < size; i++) {
        std::cout << "Промежуток : [" << arr[i] << "," << arr[i + 1] << ") --> Попаданий : " << res[i];
        std::cout << std::endl;
    }

}void printToFile(int64_t size, int64_t *arr, int64_t *res) {


    std::ofstream res_file("res.txt");

    for (int64_t i = 0; i < size; i++) {
        res_file << "Промежуток : [" << arr[i] << "," << arr[i + 1] << ") --> Попаданий : " << res[i];
        res_file << std::endl;
    }

}

extern "C" void count_int(int64_t *array, int64_t array_size, int64_t *borders, int64_t borders_size, int64_t *res);

int main() {
    int64_t arr_size = 0;
    int64_t borders_size = 0;
    int64_t Left_lim = 0;
    int64_t Rihgt_lim = 0;

    std::cout << "Введите размер массива" << std::endl;
    std::cin >> arr_size;

    std::cout << "Введите нижний предел" << std::endl;
    std::cin >> Left_lim;

    std::cout << "Введите верхний предел" << std::endl;
    std::cin >> Rihgt_lim;


    int64_t array[arr_size];
    fillArray(arr_size, array, Left_lim, Rihgt_lim);

    std::cout << "Сгенерированный массив : ";
    printArray(arr_size, array);


    std::cout << "Введите кол-во разделителей" << std::endl;
    std::cin >> borders_size;

    borders_size++;

    int64_t borders[borders_size + 1];
    initArray(borders_size, borders);

    std::cout << "Введите массив разделителей" << std::endl;
    readArray(borders_size, borders);
    borders[0] = Left_lim;
    borders[borders_size] = Rihgt_lim;

    int64_t res[borders_size];
    initArray(borders_size, res);

    //std::cout << "size=" << sizeof(int64_t) << std::endl;
    count_int(array, arr_size, borders, borders_size, res);


    std::cout << "Результат : " << std::endl;
    printBordersAndCounts(borders_size, borders, res);
    printToFile(borders_size, borders, res);

}