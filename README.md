# Sorter


This Dart library provides a collection of sorting algorithms for various data types. These algorithms facilitate sorting collections, from simple lists to more complex data structures.

## Usage

### Sorting Functions

The `Sorter` class offers various sorting algorithms, including:

- **Bubble Sort**
- **Selection Sort**
- **Insertion Sort**
- **Merge Sort**
- **Quick Sort**
- **Heap Sort**
- **Radix Sort**
- **Bucket Sort**
- **Sorting for Specific Data Types**

### How to Use

1. Import the necessary classes:

   ```dart
   import 'package:sorter/sorter.dart';
   ```

2. Call the desired sorting function with your data:

   ```dart
   List<int> unsortedList = [5, 2, 9, 1, 5];
   List<int> sortedList = Sorter.bubbleSort(unsortedList);
   ```

   Replace `bubbleSort` with the sorting algorithm of your choice.

### Sorting Various Data Types

The library supports sorting for:

- Integers
- Doubles
- Strings
- Dates
- Colors
- Geographic Coordinates
- Firebase Documents
- Files
- And more...

### Customization

Most sorting functions support additional parameters for customization, such as reversing the sorting order or specifying comparison functions.

## Contribution

Feel free to contribute by submitting bug fixes, enhancements, or additional sorting algorithms. Fork this repository, make changes, and create a pull request.
