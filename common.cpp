#include "common.h"
#include "stdio.h"

bool compare_arrays(int* a, int* b, int size)
{
    for (int i = 0; i < size; i++) {
        if (a[i] != b[i]) return false;
    }

    printf("Arrays are same \n");
    return true;
}
