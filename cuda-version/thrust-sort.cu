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

// Must be run on Windows.


int main(int argc, char* argv[])
{

    int N = 10000;
    bool runHost = false;

    for (int i = 1; i < argc;)
    {
#define check_index(i, str)                                    \
    if ((i) >= argc)                                           \
    {                                                          \
        fprintf(stderr, "Missing 2nd argument for %s\n", str); \
    }

        std::string key(argv[i++]);

        if (key == "-n" || key == "--npoints")
        {
            check_index(i, "-n");
            if (isdigit(*argv[i]))
                N = atoi(argv[i]);
            i++;
        }
        else if (key == "--host" || key == "-h")
        {
            runHost = true;
        }
        else
        {
            fprintf(stderr, "Unknown option %s\n", key.c_str());
        }
    }
    
    LARGE_INTEGER StartingTime, EndingTime, ElapsedMicroseconds;
    LARGE_INTEGER Frequency;
    
    std::string hostResult;
    if (runHost) {
        // Run on the Host Serially
        thrust::host_vector<double> h_vec(N);
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

    thrust::host_vector<double> h_vec2(N);
    thrust::generate(h_vec2.begin(), h_vec2.end(), rand);
    LARGE_INTEGER StartingTime2, EndingTime2, ElapsedMicroseconds2;
    LARGE_INTEGER Frequency2;
    QueryPerformanceFrequency(&Frequency2);
    QueryPerformanceCounter(&StartingTime2);

    // transfer data to the device
    thrust::device_vector<double> d_vec = h_vec2;
    
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
