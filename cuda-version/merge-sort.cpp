#include <iostream>
using namespace std;

void merge(int array[], int const left, int const mid, int const right)
{
    int const leftArrSize = mid - left + 1;
    int const rightArrSize = right - mid;

    // Create temporary arrays.
    int *leftArr = new int[leftArrSize],
        *rightArr = new int[rightArrSize];

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
void mergeSort(int array[], int const begin, int const end)
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
void printArray(int A[], int size)
{
    for (int i = 0; i < size; i++)
        cout << A[i] << " ";
}

// Driver Code
int main()
{
    // TODO increase array size / prompt for array size
    int arr[] = {12, 11, 14, 2, 6, 104, 64, 6, 52, 27};
    int arr_size = sizeof(arr) / sizeof(arr[0]);

    cout << "Given array is size:\t";
    cout << arr_size << "\nArray Contents:\n";
    printArray(arr, arr_size);

    mergeSort(arr, 0, arr_size - 1);

    cout << "\nSorted array is size:\t";
    cout << arr_size << "\nArray Contents:\n";
    printArray(arr, arr_size);

    return 0;
}