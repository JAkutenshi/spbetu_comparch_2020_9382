#include <iostream>
#include <fstream>
#include <ctime>
#include <random>
using namespace std;
int64_t getRandomNumber(int64_t min, int64_t max)
{
    std::random_device rd;
    std::mt19937 mt(rd());
    std::uniform_int_distribution<int> dist(min, max);
    return dist(mt);
}

extern "C"
{
    void MAS_INTERVAL(int64_t* left_boarders, int64_t* res_arr, int64_t* arr, int64_t array_size);
}

int main()
{
    srand(static_cast<unsigned int>(time(0)));
    int64_t array_size = 0;
    cout << "Введите длину массива: ";
    cin >> array_size;
    if (array_size > 16 * 1024) {
        cout << "Слишком много элементов!";
        return 0;
    }

    int64_t x_min = 0;
    cout << "Введите нижний диапазон: ";
    cin >> x_min;

    int64_t x_max = 0;
    cout << "Введите верхний диапазон: ";
    cin >> x_max;

    int64_t intervals_number = 0;
    cout << "Введите количество диапазонов(<=24): ";
    cin >> intervals_number;
    if (intervals_number > 24) {
        cout << "Диапазон слишком много!";
        return 0;
    }

    int64_t *left_boarders = new int64_t[intervals_number];
    cout << "Введите " << intervals_number - 1 << " нижниx границ интервалов ";
    for (int64_t i = 0; i < intervals_number - 1; i++) {
        cin >> left_boarders[i];
        if (left_boarders[i] > x_max || left_boarders[i] < x_min) {
            cout << "Введеное граница не входит в заданные промежутки!";
            return 0;
        }
    }
    left_boarders[intervals_number - 1] = x_max;

    int64_t *arr = new int64_t[array_size];
    for (int64_t i = 0; i < array_size; i++) {
        arr[i] = getRandomNumber(x_min, x_max);
    }

    int64_t *res_arr = new int64_t[intervals_number];
    for (int64_t i = 0; i < intervals_number; i++) {
        res_arr[i] = 0;
    }

    MAS_INTERVAL(left_boarders, res_arr, arr, array_size);

    ofstream myfile("out.txt", std::ios::out);
    for (int64_t i = 0; i < array_size; i++) {
        cout << arr[i] << " ";
        myfile << arr[i] << " ";
    }
    myfile << endl;

    if (myfile) {
        myfile << "N_interval\tL_borders\tN_number\n";
        for (int64_t i = 0; i < intervals_number; i++) {
            int64_t res = i != 0 ? left_boarders[i - 1] : x_min;
            myfile << "    " << i+1 << "\t\t    " << res << "\t\t   " << res_arr[i] << endl;
        }
    }
    cout << "\nN_interval\tL_borders\tN_number\n";
    for (int64_t i = 0; i < intervals_number; i++) {
            int64_t res = i != 0 ? left_boarders[i - 1] : x_min;
            cout << "    " << i+1 << "\t\t    " << res << "\t\t   " << res_arr[i] << endl;
        }
}

