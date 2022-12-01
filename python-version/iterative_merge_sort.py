def merge(first, second):
  """Merges two sorted arrays into a single, also sorted array. The function 
  assumes that the two input arrays are sorted and does not attempt to verify so.

  Inputs: first, second: sorted arrays to be merged.
  Output: a sorted array with the values from the two input arrays.
  """
  merged = [0]*(len(first)+len(second))  # Output array initialized
  f = s = m = 0                         # Cursors for all arrays, labeled by array's first letter
  while f<len(first) and s<len(second):  # While both input arrays have elements to process
    if first[f] < second[s]:             # Smallest of leftmost elements is in first array 
      merged[m] = first[f]               # Copy leftmost element from first array to merged array
      f += 1                            # Advance leftmost position for first array
    else:                               # Smallest of leftmost elements is in second array
      merged[m] = second[s]             # Copy leftmost element from second array to merged array
      s += 1                            # Advance leftmost position for second array
    m += 1                              # Advance position for merged array
  while f < len(first):                  # When only first array has elements, copy them to merged
    merged[m] = first[f]                 # Copy element from first array to merged array
    f += 1                              # Advance index in first array
    m += 1                              # Advance index in merged array
  while s < len(second):                # When only second array has elements
    merged[m] = second[s]               # Copy element from second array to merged array
    s += 1                              # Advance index in second array
    m += 1                              # Advance index in merged array
  return merged                         # Return merged array

def iterative_merge_sort(array):
  """Iterative implementation of merge sort. 
  
  Function assumes that the size of the input array will always be a power of 2.
  """
  size_of_array = len(array)
  current_power = 0
  subarray_size = pow(2, current_power) # starting from the bottom and moving up
  index = 0
  while subarray_size != size_of_array: # while there are still ways to divide the array into subarrays
    while index < size_of_array: # while there are still subarrays to merge
        # Take two subarrays next to each other and merge them.
        w = merge(array[index:(index + subarray_size)], array[(index + subarray_size):(index + subarray_size + subarray_size)])
        array[index:(index + subarray_size + subarray_size)] = w # Then paste merged array where it belongs.
        index = index + subarray_size*2 # Then move on to next pair of subarrays.
    current_power = current_power + 1
    subarray_size = pow(2, current_power) # Move on to next power of 2.
    index = 0
  return array

# code demonstration below
array_8 = [8,2,7,4,9,1,3,0]
print(iterative_merge_sort(array_8)) # [0, 1, 2, 3, 4, 7, 8, 9]
array_1 = [8]
print(iterative_merge_sort(array_1)) # [8]
array_16_mirrored = [8,2,7,4,9,1,3,0,8,2,7,4,9,1,3,0]
print(iterative_merge_sort(array_16_mirrored)) # [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 7, 7, 8, 8, 9, 9]
array_4 = [8, 2, 7, 4]
print(iterative_merge_sort(array_4)) # [2, 4, 7, 8]
