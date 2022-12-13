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


// Must be run on Windows

int main(void)
{
    LARGE_INTEGER StartingTime, EndingTime, ElapsedMicroseconds;
    LARGE_INTEGER Frequency;

    // Set N For Each Test here
    int N = 50000000;
    bool runHost = true;

    std::string hostResult;
    if (runHost) {
        // Run on the Host Serially
        thrust::host_vector<int> h_vec(N);
        thrust::generate(h_vec.begin(), h_vec.end(), rand);

        QueryPerformanceFrequency(&Frequency);
        QueryPerformanceCounter(&StartingTime);

        thrust::sort(h_vec.begin(), h_vec.end());

        QueryPerformanceCounter(&EndingTime);
        ElapsedMicroseconds.QuadPart = EndingTime.QuadPart - StartingTime.QuadPart;
        ElapsedMicroseconds.QuadPart *= 1000000;
        ElapsedMicroseconds.QuadPart /= Frequency.QuadPart;

        hostResult = "The elapsed time was " + std::to_string(ElapsedMicroseconds.QuadPart) + " Microseconds.\n";
    }
    else {
        hostResult = "Host version not run.\n";
    }
    // GPU VERSION

    thrust::host_vector<int> h_vec2(N);

    LARGE_INTEGER StartingTime2, EndingTime2, ElapsedMicroseconds2;
    LARGE_INTEGER Frequency2;
    QueryPerformanceFrequency(&Frequency2);
    QueryPerformanceCounter(&StartingTime2);

    // transfer data to the device
    thrust::device_vector<int> d_vec = h_vec2;
    thrust::generate(h_vec2.begin(), h_vec2.end(), rand);

    // use thrust to sort the device array.
    thrust::sort(d_vec.begin(), d_vec.end());
  
    // transfer data back to host
    thrust::copy(d_vec.begin(), d_vec.end(), h_vec2.begin());

    QueryPerformanceCounter(&EndingTime2);
    ElapsedMicroseconds2.QuadPart = EndingTime2.QuadPart - StartingTime2.QuadPart;
    ElapsedMicroseconds2.QuadPart *= 1000000;
    ElapsedMicroseconds2.QuadPart /= Frequency2.QuadPart;

    std::string deviceResult = "The elapsed time for GPU Sort was " + std::to_string(ElapsedMicroseconds2.QuadPart) + " Microseconds.\n";

    std::cout << hostResult << deviceResult;

    return 0;
}
