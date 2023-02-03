#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>

__global__ void unique_idx_calc_threadIdx(int* input) {
	int tid = threadIdx.x;
	printf("threadIdx : %d, value : %d \n", tid, input[tid]);
}

__global__ void unique_gid_calculation(int* input) {
	int tid = threadIdx.x;
	int offset = blockIdx.x * blockDim.x;
	int gid = tid + offset;
	printf("blockIdx.x : %d, threadIdx.x : %d, gid : %d, value : %d \n",
		blockIdx.x, threadIdx.x, gid, input[gid]);
}

__global__ void unique_gid_calculation_2d(int* input) {
	int tid = threadIdx.x;
	int blockoffset = blockIdx.x * blockDim.x + blockIdx.y * blockDim.y;
	int rowoffset = blockIdx.y * blockDim.x * gridDim.x;
	int gid = tid + blockoffset + rowoffset;

	printf("blockIdx.x : %d, blockIdx.y : %d, threadIdx.x : %d, gid : %d, value : %d \n",
		blockIdx.x, blockIdx.y, threadIdx.x, gid, input[gid]);
}

__global__ void unique_gid_calculation_2d_2d(int* input) {
	int tid = threadIdx.x + blockDim.x * threadIdx.y;
	int blockoffset = blockIdx.x * blockDim.x * blockDim.y;
	int rowoffset = blockIdx.y * blockDim.x * blockDim.y * gridDim.x;
	int gid = tid + blockoffset + rowoffset;

	printf("blockIdx.x : %d, blockIdx.y : %d, threadIdx.x : %d, gid : %d, value : %d \n",
		blockIdx.x, blockIdx.y, threadIdx.x, gid, input[gid]);
}

int main() {
	int array_size = 16;
	int array_byte_size = sizeof(int) * array_size;
	int h_data[] = { 82, 281, 2, 1, 93, 5, 91, 57, 542, 134, 633, 76, 73, 134, 63, 313};

	for (int i = 0; i < array_size; i++) {
		printf("%d ", h_data[i]);
	}
	printf("\n \n");

	int* d_data;
	cudaMalloc((void**)&d_data, array_byte_size);
	cudaMemcpy(d_data, h_data, array_byte_size, cudaMemcpyHostToDevice);

	dim3 block(2, 2);
	dim3 grid(2, 2);

	//unique_idx_calc_threadIdx << <grid, block >> > (d_data);
	//unique_gid_calculation << <grid, block >> > (d_data);
	//unique_gid_calculation_2d << <grid, block >> > (d_data);
	unique_gid_calculation_2d_2d << <grid, block >> > (d_data);
	cudaDeviceSynchronize();

	cudaDeviceReset();
	
	return 0;
}