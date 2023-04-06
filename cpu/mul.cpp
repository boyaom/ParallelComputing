#include <iostream>
#include <cstring>
using namespace std;

long long squaresum(long long n) {return n*(n+1)*(2*n+1)/6;}

void mul(long long *A, long long *B, long long *C, int N) {
	for(int i = 0; i < N; i++) {
		for(int k = 0; k < N; k++) {
			int tmp = A[i * N + k];
			for(int j = 0; j < N; j++) {
				C[i * N + j] += tmp * B[k * N + j];
			}
		}
	}
}

int main(int argc, char** argv) {
	long long *A, *B, *C;
	int N; 
	// N should lower than 2048,
	// otherwise squaresum result will be overflow.
	if(argc == 1) N = 2047;
	else N = atoi(argv[1]);
	// init
	A = new long long [N*N]();
	B = new long long [N*N]();
	C = new long long [N*N]();
	for(int i = 0; i < N; i++) {
		for(int j = 0; j < N; j++) {
			A[i * N + j] = i * N + j + 1;
			B[i * N + j] = j * N + i + 1;
		}
	}
	// multiply
	cout << "begin" << endl;
	mul(A, B, C, N);
	cout << "end" << endl;
	cout << C[N * N - 1] << endl;
	cout << squaresum(N*N) - squaresum(N*N-N) << endl;
	return 0;
}
