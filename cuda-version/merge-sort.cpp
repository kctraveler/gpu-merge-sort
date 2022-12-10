#include <iostream>
#include <math.h>
using namespace std;

void merge(double array[], int const left, int const mid, int const right)
{
    int const leftArrSize = mid - left + 1;
    int const rightArrSize = right - mid;

    // Create temporary arrays.
    double *leftArr = new double[leftArrSize],
           *rightArr = new double[rightArrSize];

    // Copy data to temporary arrays
    for (int i = 0; i < leftArrSize; i++)
        leftArr[i] = array[left + i];
    for (int j = 0; j < rightArrSize; j++)
        rightArr[j] = array[mid + 1 + j];

    int leftArrIndex = 0;
    int rightArrIndex = 0;
    int mergedArrIndex = left;

    // Make the merge
    while (leftArrIndex < leftArrSize && rightArrIndex < rightArrSize)
    {
        if (leftArr[leftArrIndex] <= rightArr[rightArrIndex])
        {
            array[mergedArrIndex] = leftArr[leftArrIndex];
            leftArrIndex++;
        }
        else
        {
            array[mergedArrIndex] = rightArr[rightArrIndex];
            rightArrIndex++;
        }
        mergedArrIndex++;
    }

    // Copy any remaining elements
    while (leftArrIndex < leftArrSize)
    {
        array[mergedArrIndex] = leftArr[leftArrIndex];
        leftArrIndex++;
        mergedArrIndex++;
    }
    while (rightArrIndex < rightArrSize)
    {
        array[mergedArrIndex] = rightArr[rightArrIndex];
        rightArrIndex++;
        mergedArrIndex++;
    }
    delete[] leftArr;
    delete[] rightArr;
}

// begin is left index and end is right index of the subarray
void mergeSort(double array[], int const begin, int const end)
{
    if (begin >= end)
        return; // recursive breakpoint
    int mid = begin + (end - begin) / 2;
    mergeSort(array, begin, mid);
    mergeSort(array, mid + 1, end);
    merge(array, begin, mid, end);
}

// Utility Functions
// Function that prints the array
void printArray(double A[], int size)
{
    for (int i = 0; i < size; i++)
        cout << A[i] << " ";
}
void generateArray(double array[], int size)
{
    srand(size * 1000); // seed
    for (int i = 0; i < size; i++)
        array[i] = (double)rand();
}

// Driver Code
int main(int argc, char *argv[])
{
    int size = 100;
    bool write_solution = false;

    // Check parameters
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
                size = atoi(argv[i]);
            i++;
        }
        else if (key == "--write" || key == "-w")
        {
            write_solution = true;
        }
        else
        {
            fprintf(stderr, "Unknown option %s\n", key.c_str());
        }
    }

    // TODO increase array size / prompt for array size
    double *arr = new double[size];
    generateArray(arr, size);
    if (write_solution)
    {
        cout << "Given array is size:\t";
        cout << size << "\nArray Contents:\n";
        printArray(arr, size);
    }
    mergeSort(arr, 0, size - 1);
    if (write_solution)
    {
        cout << "\nSorted array is size:\t";
        cout << size << "\nArray Contents:\n";
        printArray(arr, size);
        cout << "\n";
    }
    return 0;
}