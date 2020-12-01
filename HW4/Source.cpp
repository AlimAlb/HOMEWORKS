//Албогачиев Алим Ахмедович
//БПИ196
//Вариант 1

#include <iostream>
#include <thread>
#include <chrono>
#include<vector>
#include<string>
#include<omp.h>

int VectorMul(std::vector<std::vector<int>> matrix1, std::vector<std::vector<int>> matrix2, int i, int j);

int ReadNumber(std::string message, int left, int right);

void ThreadsFunction(int curr, int last, std::vector<std::vector<int>> matr2, std::vector<std::vector<int>> matr1, std::vector<int>* result, int num);

std::vector<std::vector<int>> GenerateMatrix(int n);

void ShowMatrix(std::vector<std::vector<int>> matr);

int main() {


	int num = ReadNumber("Write number of columns(rows) of matrix:", 2, 100);
	int numOfThreads = ReadNumber("Write number of threads:", 1, num * num);

	std::vector<std::vector<int>> matr1 = GenerateMatrix(num);
	std::vector<std::vector<int>> matr2 = GenerateMatrix(num);
	std::vector<int> result;
	result.resize(num * num);

	int step = num * num / numOfThreads;
	int last = 0;
	omp_set_num_threads(numOfThreads);
	int curr = step;
	#pragma omp parallel shared(last, step, num, matr1, matr2, result)
	{
	#pragma omp for 
		for (int last = 0; last < num * num; last += step) {
			ThreadsFunction(curr, last, matr2, matr1, &result, num);
			curr += step;
		}
	}
	std::this_thread::sleep_for(std::chrono::milliseconds(100));
	std::cout << "Matrix 1:\n";
	ShowMatrix(matr1);
	std::cout << "Matrix 2:\n";
	ShowMatrix(matr2);
	std::cout << "RESULT:\n";
	for (int i = 0; i < num * num; i++) {
		if (i % num == 0 && i != 0) {
			std::cout << "\n";
		}
		std::cout << " " << result[i];
	}
	return 0;
}
void ShowMatrix(std::vector<std::vector<int>> matr)
{
	for (int i = 0; i < matr.size(); i++)
	{
		for (int j = 0; j < matr.size(); j++)
		{
			std::cout << " " << matr[i][j];
		}
		std::cout << "\n";
	}
}



int VectorMul(std::vector<std::vector<int>> matrix1, std::vector<std::vector<int>> matrix2, int i, int j) {
	int elem = 0;
	for (int k = 0; k < matrix1.size(); k++) {
		elem += matrix1[i][k] * matrix2[k][j];
	}
	return elem;
}

std::vector<std::vector<int>> GenerateMatrix(int n) {
	std::vector<std::vector<int>> matrix;
	for (int i = 0; i < n; i++) {
		std::vector<int> vec;
		for (int j = 0; j < n; j++) {
			vec.push_back(rand() % 11);
		}
		matrix.push_back(vec);
	}
	return matrix;
}

int ReadNumber(std::string message, int left, int right) {
	int number;
	std::cout << message << "\n";
	std::cin >> number;
	while (number < left || number > right) {
		std::cout << "Wrong number! Try again:\n";
		std::cin >> number;
	}
	return number;
}


void ThreadsFunction(int curr, int last, std::vector<std::vector<int>> matr2, std::vector<std::vector<int>> matr1, std::vector<int>* result, int num) {
	for (int j = last; j < num * num && j < curr; j++) {
		(*result)[j] = VectorMul(matr1, matr2, j / num, j % num);
	}
}