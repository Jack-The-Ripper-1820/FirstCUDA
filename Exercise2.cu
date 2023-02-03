#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>

__global__ void unique_gid_calculation_2d_2d_2d(int* input, int size) {
	int blockId = blockIdx.x + blockIdx.y * gridDim.x 
		+ gridDim.x * gridDim.y * blockIdx.z;
	int gid = blockId * (blockDim.x * blockDim.y * blockDim.z)
		+ (threadIdx.z * (blockDim.x * blockDim.y))
		+ (threadIdx.y * blockDim.x) + threadIdx.x;
	
	printf("blockIdx.x : %d, blockIdx.y : %d, threadIdx.x : %d, threadIdx.y : %d, threadIdx.z : %d, gid : %d, value : %d \n",
		blockIdx.x, blockIdx.y, threadIdx.x, threadIdx.y, threadIdx.z, gid, input[gid]);
}


//int main() {
//	int size = 512;
//	int byte_size = size * sizeof(int);
//
//	int* h_input;
//	h_input = (int*)malloc(byte_size);
//
//	time_t t;
//	srand((unsigned)time(&t));
//
//	for (int i = 0; i < size; i++) {
//		h_input[i] = (int)(rand() & 0xff);
//	}
//
//	int* d_input;
//	cudaMalloc((void**)&d_input, byte_size);
//
//	cudaMemcpy(d_input, h_input, byte_size, cudaMemcpyHostToDevice);
//
//	dim3 block(2,2,2);
//	dim3 grid(4,4,4);
//
//	unique_gid_calculation_2d_2d_2d << <grid, block >> > (d_input, size);
//	cudaDeviceSynchronize();
//
//	cudaFree(d_input);
//	free(h_input);
//
//	cudaDeviceReset();
//	return 0;
//}