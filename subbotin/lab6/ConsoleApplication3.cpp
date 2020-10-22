

#include <iostream>
#include <fstream>
#include <ctime>
using namespace std;
int getRandomNumber(int min, int max)
{
    static const double fraction = 1.0 / (static_cast<double>(RAND_MAX) + 1.0);
    // Равномерно распределяем рандомное число в нашем диапазоне
    return static_cast<int>(rand() * fraction * (max - min + 1) + min);
}

extern "C"
{
    void MAS_INTERVAL(int array_size, int* arr, int* left_boarders, int* res_arr);
}

int main()
{
    srand(static_cast<unsigned int>(time(0)));
    system("chcp 1251 > nul");
    int array_size = 0;
    cout << "Введите длину массива: ";
    cin >> array_size;
    if (array_size > 16 * 1024) {
        cout << "Слишком много элементов!";
        return 0;
    }

    int x_min = 0;
    cout << "Введите нижний диапазон: ";
    cin >> x_min;

    int x_max = 0;
    cout << "Введите верхний диапазон: ";
    cin >> x_max;

    int intervals_number = 0;
    cout << "Введите количество диапазонов(<=24): ";
    cin >> intervals_number;
    if (intervals_number > 24) {
        cout << "Диапазон слишком много!";
        return 0;
    }

    int *left_boarders = new int[intervals_number];
    cout << "Введите " << intervals_number - 1 << " нижниx границ интервалов ";
    for (int i = 0; i < intervals_number - 1; i++) {
        cin >> left_boarders[i];
        if (left_boarders[i] > x_max || left_boarders[i] < x_min) {
            cout << "Введеное граница не входит в заданные промежутки!";
            return 0;
        }
    }
    left_boarders[intervals_number - 1] = x_max;

    int *arr = new int[array_size];
    for (int i = 0; i < array_size; i++) {
        arr[i] = getRandomNumber(x_min, x_max);
    }

    int *res_arr = new int[intervals_number];
    for (int i = 0; i < intervals_number; i++) {
        res_arr[i] = 0;
    }

    MAS_INTERVAL(array_size, arr, left_boarders, res_arr);

    ofstream myfile("out.txt", std::ios::out);
    for (int i = 0; i < array_size; i++) {
        cout << arr[i] << " ";
        myfile << arr[i] << " ";
    }
    myfile << endl;

    if (myfile) {
        myfile << "N_interval\tL_borders\tN_number\n";
        for (int i = 0; i < intervals_number; i++) {
            int res = i != 0 ? left_boarders[i - 1] : x_min;
            myfile << "    " << i+1 << "\t\t    " << res << "\t\t   " << res_arr[i] << endl;
        }
    }

}

