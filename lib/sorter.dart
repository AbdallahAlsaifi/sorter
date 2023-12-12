import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'geo_coordinate.dart';
import 'sorter_platform_interface.dart';

typedef Compare<T> = int Function(T a, T b);

class Sorter {
  Future<String?> getPlatformVersion() {
    return SorterPlatform.instance.getPlatformVersion();
  }

  static List<T> bubbleSort<T>(List<T> list,
      {Compare<T>? compare, bool reverse = false}) {
    compare ??= (T a, T b) => (a as Comparable).compareTo(b);

    int n = list.length;
    bool swapped;

    do {
      swapped = false;
      for (int i = 0; i < n - 1; i++) {
        int comparisonResult = compare(list[i], list[i + 1]);
        if ((!reverse && comparisonResult > 0) ||
            (reverse && comparisonResult < 0)) {
          // Swap elements
          T temp = list[i];
          list[i] = list[i + 1];
          list[i + 1] = temp;
          swapped = true;
        }
      }
      n--;
    } while (swapped);

    return list;
  }

  static List<T> selectionSort<T>(List<T> list,
      {Compare<T>? compare, bool reverse = false}) {
    compare ??= (T a, T b) => (a as Comparable).compareTo(b);

    int n = list.length;

    for (int i = 0; i < n - 1; i++) {
      int minIndex = i;
      for (int j = i + 1; j < n; j++) {
        if ((!reverse && compare(list[j], list[minIndex]) < 0) ||
            (reverse && compare(list[j], list[minIndex]) > 0)) {
          minIndex = j;
        }
      }
      if (minIndex != i) {
        // Swap elements
        T temp = list[i];
        list[i] = list[minIndex];
        list[minIndex] = temp;
      }
    }

    return list;
  }

  static List<T> insertionSort<T>(List<T> list,
      {Compare<T>? compare, bool reverse = false}) {
    compare ??= (T a, T b) => (a as Comparable).compareTo(b);

    int n = list.length;

    for (int i = 1; i < n; i++) {
      T key = list[i];
      int j = i - 1;

      while (j >= 0 &&
          ((!reverse && compare(list[j], key) > 0) ||
              (reverse && compare(list[j], key) < 0))) {
        list[j + 1] = list[j];
        j = j - 1;
      }
      list[j + 1] = key;
    }

    return list;
  }

  static List<T> mergeSort<T>(List<T> list,
      {Compare<T>? compare, bool reverse = false}) {
    compare ??= (T a, T b) => (a as Comparable).compareTo(b);

    if (list.length <= 1) {
      return list;
    }

    List<T> merge(List<T> left, List<T> right) {
      List<T> result = [];
      int leftIndex = 0, rightIndex = 0;

      while (leftIndex < left.length && rightIndex < right.length) {
        int comparisonResult = compare!(left[leftIndex], right[rightIndex]);
        if ((!reverse && comparisonResult <= 0) ||
            (reverse && comparisonResult >= 0)) {
          result.add(left[leftIndex]);
          leftIndex++;
        } else {
          result.add(right[rightIndex]);
          rightIndex++;
        }
      }

      result.addAll(left.sublist(leftIndex));
      result.addAll(right.sublist(rightIndex));

      return result;
    }

    int mid = list.length ~/ 2;
    List<T> left =
        mergeSort(list.sublist(0, mid), compare: compare, reverse: reverse);
    List<T> right =
        mergeSort(list.sublist(mid), compare: compare, reverse: reverse);

    return merge(left, right);
  }

  static List<T> quickSort<T>(List<T> list,
      {Compare<T>? compare, bool reverse = false}) {
    compare ??= (T a, T b) => (a as Comparable).compareTo(b);

    int _partition(List<T> arr, int left, int right) {
      T pivot = arr[right];
      int i = left - 1;

      for (int j = left; j < right; j++) {
        if ((!reverse && compare!(arr[j], pivot) <= 0) ||
            (reverse && compare!(arr[j], pivot) >= 0)) {
          i++;
          T temp = arr[i];
          arr[i] = arr[j];
          arr[j] = temp;
        }
      }

      T temp = arr[i + 1];
      arr[i + 1] = arr[right];
      arr[right] = temp;

      return i + 1;
    }

    void _quickSort(List<T> arr, int left, int right) {
      if (left < right) {
        int partitionIndex = _partition(arr, left, right);

        _quickSort(arr, left, partitionIndex - 1);
        _quickSort(arr, partitionIndex + 1, right);
      }
    }

    List<T> sortedList = List.from(list);
    _quickSort(sortedList, 0, sortedList.length - 1);
    return sortedList;
  }

  static void heapSort<T>(List<T> list,
      {Compare<T>? compare, bool reverse = false}) {
    compare ??= (T a, T b) => (a as Comparable).compareTo(b);

    void heapify(List<T> arr, int n, int i) {
      int largest = i;
      int left = 2 * i + 1;
      int right = 2 * i + 2;

      if (left < n &&
          ((!reverse && compare!(arr[left], arr[largest]) > 0) ||
              (reverse && compare!(arr[left], arr[largest]) < 0))) {
        largest = left;
      }

      if (right < n &&
          ((!reverse && compare!(arr[right], arr[largest]) > 0) ||
              (reverse && compare!(arr[right], arr[largest]) < 0))) {
        largest = right;
      }

      if (largest != i) {
        T temp = arr[i];
        arr[i] = arr[largest];
        arr[largest] = temp;

        heapify(arr, n, largest);
      }
    }

    void buildMaxHeap(List<T> arr, int n) {
      for (int i = (n ~/ 2) - 1; i >= 0; i--) {
        heapify(arr, n, i);
      }
    }

    int n = list.length;

    buildMaxHeap(list, n);

    for (int i = n - 1; i > 0; i--) {
      T temp = list[0];
      list[0] = list[i];
      list[i] = temp;

      heapify(list, i, 0);
    }
  }

  static List<int> radixSort(List<int> list, {bool reverse = false}) {
    int getMax(List<int> arr) {
      int max = arr[0];
      for (int i = 1; i < arr.length; i++) {
        if (arr[i] > max) {
          max = arr[i];
        }
      }
      return max;
    }

    void countSort(List<int> arr, int exp) {
      List<int> output = List.filled(arr.length, 0);
      List<int> count = List.filled(10, 0);

      for (int i = 0; i < arr.length; i++) {
        count[(arr[i] ~/ exp) % 10]++;
      }

      for (int i = 1; i < 10; i++) {
        count[i] += count[i - 1];
      }

      for (int i = arr.length - 1; i >= 0; i--) {
        output[count[(arr[i] ~/ exp) % 10] - 1] = arr[i];
        count[(arr[i] ~/ exp) % 10]--;
      }

      for (int i = 0; i < arr.length; i++) {
        arr[i] = output[i];
      }
    }

    int max = getMax(list);

    for (int exp = 1; max ~/ exp > 0; exp *= 10) {
      countSort(list, exp);
    }

    if (reverse) {
      list = list.reversed.toList();
    }

    return list;
  }

  static List<double> bucketSort(List<double> list, {bool reverse = false}) {
    int getIndex(double value, int length) {
      return ((value * length) ~/ 1).toInt();
    }

    void insertionSort(List<double> bucket) {
      for (int i = 1; i < bucket.length; i++) {
        double temp = bucket[i];
        int j = i - 1;
        while (j >= 0 &&
            ((!reverse && bucket[j] > temp) || (reverse && bucket[j] < temp))) {
          bucket[j + 1] = bucket[j];
          j--;
        }
        bucket[j + 1] = temp;
      }
    }

    if (list.isEmpty) return list;

    int n = list.length;
    int numBuckets = n ~/ 2; // Dividing by 2 for demonstration purposes

    List<List<double>> buckets = List.generate(numBuckets, (_) => <double>[]);

    for (int i = 0; i < n; i++) {
      int index = getIndex(list[i], numBuckets);
      buckets[index].add(list[i]);
    }

    for (int i = 0; i < numBuckets; i++) {
      insertionSort(buckets[i]);
    }

    List<double> sortedList = [];
    for (int i = 0; i < numBuckets; i++) {
      sortedList.addAll(buckets[i]);
    }

    return sortedList;
  }

  static List<DocumentSnapshot> sortFirebaseDocumentsByField(
    List<DocumentSnapshot> documents,
    String fieldName, {
    bool reverse = false,
  }) {
    List<DocumentSnapshot> sortedDocuments = List.from(documents);

    sortedDocuments.sort((a, b) {
      dynamic valueA = a[fieldName];
      dynamic valueB = b[fieldName];

      if (valueA is num && valueB is num) {
        return reverse ? valueB.compareTo(valueA) : valueA.compareTo(valueB);
      } else if (valueA is String && valueB is String) {
        return reverse ? valueB.compareTo(valueA) : valueA.compareTo(valueB);
      } else if (valueA is Timestamp && valueB is Timestamp) {
        return reverse ? valueB.compareTo(valueA) : valueA.compareTo(valueB);
      } else if (valueA is List && valueB is List) {
        List<dynamic> listA = List.from(valueA);
        List<dynamic> listB = List.from(valueB);
        listA.sort();
        listB.sort();
        return reverse
            ? listB.toString().compareTo(listA.toString())
            : listA.toString().compareTo(listB.toString());
      } else if (valueA is Map && valueB is Map) {
        Map<dynamic, dynamic> mapA = Map.from(valueA);
        Map<dynamic, dynamic> mapB = Map.from(valueB);
        var keysA = mapA.keys.toList()..sort();
        var keysB = mapB.keys.toList()..sort();
        return reverse
            ? keysB.toString().compareTo(keysA.toString())
            : keysA.toString().compareTo(keysB.toString());
      }
      return 0;
    });

    return sortedDocuments;
  }

  static List<String> sortMobileNumbersAsString(List<String> numbers,
      {bool reverse = false}) {
    List<String> sortedNumbers = List.from(numbers);

    sortedNumbers.sort((a, b) {
      String cleanA =
          a.replaceAll(RegExp(r'^(\+|00)'), ''); // Remove leading '+' or '00'
      String cleanB =
          b.replaceAll(RegExp(r'^(\+|00)'), ''); // Remove leading '+' or '00'

      return cleanA.compareTo(cleanB);
    });

    if (reverse) {
      sortedNumbers = sortedNumbers.reversed.toList();
    }

    return sortedNumbers;
  }

  static List<int> sortMobileNumbersAsInt(List<int> numbers,
      {bool reverse = false}) {
    List<String> numberStrings = numbers.map((num) => num.toString()).toList();

    numberStrings.sort((a, b) {
      String cleanA = a.replaceAll(RegExp(r'^(\+|00)'), '');
      String cleanB = b.replaceAll(RegExp(r'^(\+|00)'), '');

      return cleanA.compareTo(cleanB);
    });

    if (reverse) {
      numberStrings = numberStrings.reversed.toList();
    }

    List<int> sortedNumbers =
        numberStrings.map((str) => int.parse(str)).toList();

    return sortedNumbers;
  }

  static List<String> sortEmails(List<String> emails,
      {bool includeDomain = false}) {
    emails.sort((a, b) {
      String usernameA = a.split('@')[0];
      String domainA = a.split('@')[1];

      String usernameB = b.split('@')[0];
      String domainB = b.split('@')[1];

      if (includeDomain) {
        if (domainA != domainB) {
          return domainA.compareTo(domainB);
        }
      }

      return usernameA.compareTo(usernameB);
    });

    return emails;
  }

  static List<Color> sortColors(List<Color> colors, {bool reverse = false}) {
    colors.sort((a, b) {
      int intA = a.value;
      int intB = b.value;

      return intA.compareTo(intB);
    });

    if (reverse) {
      colors = colors.reversed.toList();
    }

    return colors;
  }

  static List<DateTime> sortDateTimes(List<DateTime> dateTimes,
      {bool reverse = false}) {
    dateTimes.sort((a, b) => a.compareTo(b));

    if (reverse) {
      dateTimes = dateTimes.reversed.toList();
    }

    return dateTimes;
  }

  static List<GeoCoordinate> sortGeographicData(
      List<GeoCoordinate> coordinates) {
    coordinates.sort((a, b) {
      // Sort by latitude
      int latitudeComparison = a.latitude.compareTo(b.latitude);
      if (latitudeComparison != 0) {
        return latitudeComparison;
      }

      // If latitude is the same, sort by longitude
      return a.longitude.compareTo(b.longitude);
    });

    return coordinates;
  }

  static Map<K, V> sortMap<K, V>(Map<K, V> map, {bool reverse = false}) {
    var sortedKeys = map.keys.toList()..sort();
    if (reverse) {
      sortedKeys = sortedKeys.reversed.toList();
    }

    var sortedMap = LinkedHashMap<K, V>();
    for (var key in sortedKeys) {
      sortedMap[key] = map[key]!;
    }

    return sortedMap;
  }

  static Set<T> sortSet<T extends Comparable>(Set<T> set,
      {bool reverse = false}) {
    List<T> sortedList = set.toList()..sort();
    if (reverse) {
      sortedList = sortedList.reversed.toList();
    }
    return sortedList.toSet();
  }

  static List<T> sortObjects<T>(List<T> objects,
      {bool Function(T a, T b)? compare}) {
    objects.sort((a, b) {
      if (compare != null) {
        return compare(a, b) ? 1 : -1;
      }
      // Sort by default comparison for objects that support comparison
      return a.toString().compareTo(b.toString());
    });

    return objects;
  }

  static List<File> sortFilesByName(Directory directory,
      {bool reverse = false}) {
    List<File> files = directory.listSync().whereType<File>().toList();
    files.sort((a, b) => a.path.compareTo(b.path));

    if (reverse) {
      files = files.reversed.toList();
    }

    return files;
  }

  static Uint8List sortUint8List(Uint8List list, {bool reverse = false}) {
    List<int> sortedList = list.toList()..sort();
    if (reverse) {
      sortedList = sortedList.reversed.toList();
    }
    return Uint8List.fromList(sortedList);
  }
}
