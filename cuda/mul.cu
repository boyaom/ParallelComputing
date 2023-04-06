#include <iostream>
#include <cstring>
#include <cuda_runtime_api.h>
using namespace std;

long long squaresum(long long n) {return n*(n+1)*(2*n+1)/6;}

__global__ void cudamul_kernel(long long *A, long long *B, long long *C, int N) {
	int id = blockDim.x * blockIdx.x + threadIdx.x;
	if(id >= N * N) return;
	int i = id / N, j = id % N, k = 0;
	for(k = 0; k < N; k++) {
		C[id] += A[i * N + k] * B[k * N + j];
	}
}

int main(int argc, char **argv){
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
	cudaSetDevice(0);
	long long *cuda_A, *cuda_B, *cuda_C;
	int nBypes = N * N * sizeof(long long);
	cudaMalloc(&cuda_A, nBypes);
	cudaMalloc(&cuda_B, nBypes);
	cudaMalloc(&cuda_C, nBypes);
	
	cout << "begin" << endl;
	cudaMemcpy(cuda_A, A, nBypes, cudaMemcpyHostToDevice);
	cudaMemcpy(cuda_B, B, nBypes, cudaMemcpyHostToDevice);
	cudaMemcpy(cuda_C, C, nBypes, cudaMemcpyHostToDevice);
	
	int threadperblock = 256;
	int blockpergrid = (N * N + threadperblock - 1) / threadperblock;
	cudamul_kernel<<<blockpergrid, threadperblock>>>(cuda_A, cuda_B, cuda_C, N);
	
	cudaMemcpy(C, cuda_C, nBypes, cudaMemcpyDeviceToHost);
	// cudaDeviceSynchronize();
	cudaFree(cuda_A);
	cudaFree(cuda_B);
	cudaFree(cuda_C);
	
	cout << "end" << endl;
	cout << C[N * N - 1] << endl;
	cout << squaresum(N*N) - squaresum(N*N-N) << endl;
	return 0;
}
