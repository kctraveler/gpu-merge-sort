#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <string.h>
#include <thrust/generate.h>
#include <thrust/sort.h>
#include <thrust/copy.h>
#include <algorithm>
#include <cstdlib>
#include <stdio.h>
#include <stdlib.h>
#include <Windows.h>

/*
Unlike the other c++ example, this must be run on windows. I had issues with the NVCC compiler on the LUC cluster and decided to use my local workstation. In order to get a timer for profiling I had to use a Windows library.
*/

int main(void)
{
    LARGE_INTEGER StartingTime, EndingTime, ElapsedMicroseconds;
    LARGE_INTEGER Frequency;

    // Create host vector prior to starting timer
    thrust::host_vector<double> h_vec(16777216);
    thrust::generate(h_vec.begin(), h_vec.end(), rand);

    // Start timer for profiling
    QueryPerformanceFrequency(&Frequency);
    QueryPerformanceCounter(&StartingTime);

    // transfer data to the device
    thrust::device_vector<double> d_vec = h_vec;
    
    // use thrust to sort the device array.
    thrust::sort(d_vec.begin(), d_vec.end());
    // sort on the host
    //std::sort(h_vec.begin(), h_vec.end());

    // transfer data back to host
    thrust::copy(d_vec.begin(), d_vec.end(), h_vec.begin());

    // End timer and calculat Microseconds
    QueryPerformanceCounter(&EndingTime);
    ElapsedMicroseconds.QuadPart = EndingTime.QuadPart - StartingTime.QuadPart;
    ElapsedMicroseconds.QuadPart *= 1000000;
    ElapsedMicroseconds.QuadPart /= Frequency.QuadPart;
    std::cout << "The elapsed time was " <<  ElapsedMicroseconds.QuadPart;

    return 0;
}