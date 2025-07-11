import 'dart:math';

/// An extension on [List] providing many utility methods for grouping,
/// merging, transforming, and analyzing list data.
extension ListExtensions<T> on List<T> {
  /// Groups the elements of the list by a key.
  ///
  /// Iterates over each element, uses [keySelector] to generate a key, and
  /// adds the element to a list associated with that key.
  ///
  /// Example:
  /// ```dart
  /// final fruits = ['apple', 'apricot', 'banana'];
  /// final grouped = fruits.groupBy((fruit) => fruit[0]);
  /// // grouped: { 'a': ['apple', 'apricot'], 'b': ['banana'] }
  /// ```
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final Map<K, List<T>> groupedMap = {};
    for (final item in this) {
      final key = keySelector(item);
      groupedMap.putIfAbsent(key, () => []).add(item);
    }
    return groupedMap;
  }

  /// Groups the list items by a key and merges items with the same key.
  ///
  /// For each element, [keySelector] is used to get its key. If an item with
  /// the same key already exists, the [mergeFunction] is applied to combine the
  /// two items; otherwise, the item is added as is.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3, 4];
  /// // Group by even/odd and sum the numbers in each group.
  /// final merged = numbers.mergeBy(
  ///   (n) => n % 2 == 0 ? 'even' : 'odd',
  ///   (acc, cur) => acc + cur,
  /// );
  /// // merged: [sum of odds, sum of evens]
  /// ```
  List<T> mergeBy<K>(
    K Function(T) keySelector,
    T Function(T accumulated, T current) mergeFunction,
  ) {
    final Map<K, T> mergedMap = {};

    for (var item in this) {
      final key = keySelector(item);
      if (mergedMap.containsKey(key)) {
        mergedMap[key] = mergeFunction(mergedMap[key] as T, item);
      } else {
        mergedMap[key] = item;
      }
    }

    return mergedMap.values.toList();
  }

  /// Converts the list into a map, where keys are generated by [keySelector].
  ///
  /// Each element is added to the resulting map using the key returned by
  /// [keySelector]. If duplicate keys occur, later elements overwrite earlier ones.
  ///
  /// Example:
  /// ```dart
  /// final users = [
  ///   {'id': 1, 'name': 'Alice'},
  ///   {'id': 2, 'name': 'Bob'},
  /// ];
  /// final userMap = users.toMap((user) => user['id']);
  /// // userMap: {1: {'id': 1, 'name': 'Alice'}, 2: {'id': 2, 'name': 'Bob'}}
  /// ```
  Map<K, T> toMap<K>(K Function(T) keySelector) {
    final Map<K, T> mapped = {};
    for (var item in this) {
      mapped[keySelector(item)] = item;
    }
    return mapped;
  }

  /// Extracts a list of non-null values by applying [selector] to each element.
  ///
  /// Only values for which [selector] does not return `null` are included.
  ///
  /// Example:
  /// ```dart
  /// final items = ['apple', null, 'banana'];
  /// final nonNullItems = items.select((item) => item);
  /// // nonNullItems: ['apple', 'banana']
  /// ```
  List<K> select<K>(K? Function(T item) selector) {
    return [
      for (var item in this)
        if (selector(item) != null) selector(item) as K
    ];
  }

  /// Returns a list containing only the distinct elements.
  ///
  /// Uses the default equality and hashCode implementations.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 2, 3];
  /// final distinctNumbers = numbers.distinct();
  /// // distinctNumbers: [1, 2, 3]
  /// ```
  List<T> distinct() => toSet().toList();

  /// Returns a list containing only the distinct elements, determined by [keySelector].
  ///
  /// Elements are considered duplicates if they produce the same key.
  ///
  /// Example:
  /// ```dart
  /// final people = [{'name': 'Alice'}, {'name': 'Bob'}, {'name': 'Alice'}];
  /// final unique = people.distinctBy((p) => p['name']);
  /// // unique contains the first occurrence for each name.
  /// ```
  List<T> distinctBy<K>(K Function(T) keySelector) {
    final Set<K> seen = {};
    return [
      for (var item in this)
        if (seen.add(keySelector(item))) item
    ];
  }

  /// Partitions the list into two lists based on [predicate].
  ///
  /// Returns a tuple where the first list contains elements that satisfy
  /// [predicate] and the second contains those that do not.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3, 4];
  /// final (evens, odds) = numbers.partition((n) => n % 2 == 0);
  /// // evens: [2, 4], odds: [1, 3]
  /// ```
  (List<T>, List<T>) partition(bool Function(T item) predicate) {
    final pass = <T>[];
    final fail = <T>[];
    for (var item in this) {
      (predicate(item) ? pass : fail).add(item);
    }
    return (pass, fail);
  }

  /// Sorts the list in place based on a key provided by [keySelector] in ascending order.
  ///
  /// The key type must implement [Comparable].
  ///
  /// Example:
  /// ```dart
  /// final people = [
  ///   {'name': 'Alice', 'age': 30},
  ///   {'name': 'Bob', 'age': 25},
  ///   {'name': 'Charlie', 'age': 35},
  /// ];
  /// people.sortBy((person) => person['age']);
  /// // people is now sorted by age in ascending order.
  /// ```
  void sortBy<K extends Comparable>(K Function(T) keySelector) =>
      sort((a, b) => keySelector(a).compareTo(keySelector(b)));

  /// Sorts the list in place based on a key provided by [keySelector] in descending order.
  ///
  /// The key type must implement [Comparable].
  ///
  /// Example:
  /// ```dart
  /// final people = [
  ///   {'name': 'Alice', 'age': 30},
  ///   {'name': 'Bob', 'age': 25},
  ///   {'name': 'Charlie', 'age': 35},
  /// ];
  /// people.sortByDescending((person) => person['age']);
  /// // people is now sorted by age in descending order.
  /// ```
  void sortByDescending<K extends Comparable>(K Function(T) keySelector) {
    sort((a, b) => keySelector(b).compareTo(keySelector(a)));
  }

  /// Computes the sum of values obtained by applying [selector] to each element.
  ///
  /// The numeric type [K] (typically [int] or [double]) is used for the sum.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3];
  /// final sum = numbers.sumBy((n) => n);
  /// // sum: 6
  /// ```
  K sumBy<K extends num>(K Function(T item) selector) {
    return fold<K>(
        0 as K, (previous, current) => (previous + selector(current)) as K);
  }

  /// Returns the element with the minimum value as determined by [keySelector].
  ///
  /// Returns `null` if the list is empty.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [10, 5, 8];
  /// final minNumber = numbers.minBy((n) => n);
  /// // minNumber: 5
  /// ```
  T? minBy<K extends Comparable<K>>(K Function(T item) keySelector) {
    return isEmpty
        ? null
        : reduce(
            (a, b) => keySelector(a).compareTo(keySelector(b)) < 0 ? a : b);
  }

  /// Returns the element with the maximum value as determined by [keySelector].
  ///
  /// Returns `null` if the list is empty.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [10, 5, 8];
  /// final maxNumber = numbers.maxBy((n) => n);
  /// // maxNumber: 10
  /// ```
  T? maxBy<K extends Comparable<K>>(K Function(T item) keySelector) {
    return isEmpty
        ? null
        : reduce(
            (a, b) => keySelector(a).compareTo(keySelector(b)) > 0 ? a : b);
  }

  /// Splits the list into sublists (chunks) of the given [size].
  ///
  /// This is an alias for [chunked]. If the list length is not a multiple of [size],
  /// the final chunk may be smaller.
  ///
  /// Example:
  /// ```dart
  /// final letters = ['a', 'b', 'c', 'd', 'e'];
  /// final chunks = letters.chunkBy(2);
  /// // chunks: [['a', 'b'], ['c', 'd'], ['e']]
  /// ```
  List<List<T>> chunkBy(int size) {
    final List<List<T>> chunks = [];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }

  /// Transforms each element into a [MapEntry] using [transform] and builds a map.
  ///
  /// Each [MapEntry]'s key and value are added to the resulting map.
  ///
  /// Example:
  /// ```dart
  /// final fruits = ['apple', 'banana', 'cherry'];
  /// final fruitLengths = fruits.associate(
  ///   (fruit) => MapEntry(fruit, fruit.length),
  /// );
  /// // fruitLengths: {'apple': 5, 'banana': 6, 'cherry': 6}
  /// ```
  Map<K, V> associate<K, V>(MapEntry<K, V> Function(T) transform) {
    final Map<K, V> map = {};
    for (var item in this) {
      final entry = transform(item);
      map[entry.key] = entry.value;
    }
    return map;
  }

  /// Creates a map where the keys are generated by [keySelector] and the values are the corresponding elements.
  ///
  /// If multiple elements produce the same key, the last one encountered will be used.
  ///
  /// Example:
  /// ```dart
  /// final users = [
  ///   {'id': 1, 'name': 'Alice'},
  ///   {'id': 2, 'name': 'Bob'},
  /// ];
  /// final userMap = users.associateBy((user) => user['id']);
  /// // userMap: {1: {'id': 1, 'name': 'Alice'}, 2: {'id': 2, 'name': 'Bob'}}
  /// ```
  Map<K, T> associateBy<K>(K Function(T) keySelector) {
    final Map<K, T> map = {};
    for (var item in this) {
      map[keySelector(item)] = item;
    }
    return map;
  }

  /// Creates a map where each element is used as a key and the corresponding value is computed by [valueSelector].
  ///
  /// Example:
  /// ```dart
  /// final fruits = ['apple', 'banana', 'cherry'];
  /// final fruitColors = fruits.associateWith((fruit) =>
  ///   fruit == 'apple'
  ///       ? 'red'
  ///       : fruit == 'banana'
  ///           ? 'yellow'
  ///           : 'red');
  /// // fruitColors: {'apple': 'red', 'banana': 'yellow', 'cherry': 'red'}
  /// ```
  Map<T, V> associateWith<V>(V Function(T) valueSelector) {
    final Map<T, V> map = {};
    for (var item in this) {
      map[item] = valueSelector(item);
    }
    return map;
  }

  /// Flattens a list of lists by one level.
  ///
  /// If an element is a [List] of type [T], its contents are added; otherwise, the element is added directly.
  ///
  /// Example:
  /// ```dart
  /// final nestedList = [1, [2, 3], 4];
  /// final flattened = nestedList.flatten();
  /// // flattened: [1, 2, 3, 4]
  /// ```
  List<T> flatten() {
    final List<T> flattened = [];
    for (var item in this) {
      if (item is List<T>) {
        flattened.addAll(item);
      } else {
        flattened.add(item);
      }
    }
    return flattened;
  }

  /// Combines elements from this list and [other] into a new list.
  ///
  /// The [transform] function takes one element from each list (matched by index)
  /// and returns a combined result. The resulting list is as long as the shorter list.
  ///
  /// Example:
  /// ```dart
  /// final numbers1 = [1, 2, 3];
  /// final numbers2 = [4, 5, 6];
  /// final sums = numbers1.zip(numbers2, (a, b) => a + b);
  /// // sums: [5, 7, 9]
  /// ```
  List<R> zip<R>(List<T> other, R Function(T, T) transform) {
    final List<R> zipped = [];
    final int minLength = length < other.length ? length : other.length;
    for (var i = 0; i < minLength; i++) {
      zipped.add(transform(this[i], other[i]));
    }
    return zipped;
  }

  /// Takes elements from the list while [predicate] is true and also includes
  /// the first element that does not satisfy [predicate].
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3, 4, 5];
  /// final result = numbers.takeWhileInclusive((n) => n < 3);
  /// // result: [1, 2, 3]  // 3 is included even though 3 < 3 is false.
  /// ```
  List<T> takeWhileInclusive(bool Function(T) predicate) {
    final List<T> result = [];
    for (var item in this) {
      result.add(item);
      if (!predicate(item)) {
        break;
      }
    }
    return result;
  }

  /// Drops elements from the list while [predicate] is true, but includes
  /// the first element for which [predicate] returns false.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3, 4, 5];
  /// final result = numbers.dropWhileInclusive((n) => n < 3);
  /// // result: [3, 4, 5]  // 3 is the first element that fails the predicate and is included.
  /// ```
  List<T> dropWhileInclusive(bool Function(T) predicate) {
    final List<T> result = [];
    bool dropping = true;
    for (var item in this) {
      if (dropping && !predicate(item)) {
        dropping = false;
      }
      if (!dropping) {
        result.add(item);
      }
    }
    return result;
  }

  /// Creates a list of sliding windows (sublists) of the given [size].
  ///
  /// The window moves by [step] elements. If [partialWindows] is `true`, windows
  /// at the end that are smaller than [size] are included; otherwise, they are omitted.
  ///
  /// Examples:
  /// ```dart
  /// final numbers = [1, 2, 3, 4, 5];
  ///
  /// // Example with partialWindows set to true:
  /// // The windows are: [1, 2, 3] starting at index 0,
  /// //                  [3, 4, 5] starting at index 2,
  /// //                  [5]      starting at index 4 (partial window)
  /// final windowsTrue = numbers.windowed(3, step: 2, partialWindows: true);
  /// print(windowsTrue); // Output: [[1, 2, 3], [3, 4, 5], [5]]
  ///
  /// // Example with partialWindows set to false:
  /// // Only complete windows are returned:
  /// // [1, 2, 3] starting at index 0 and [3, 4, 5] starting at index 2.
  /// final windowsFalse = numbers.windowed(3, step: 2, partialWindows: false);
  /// print(windowsFalse); // Output: [[1, 2, 3], [3, 4, 5]]
  /// ```
  List<List<T>> windowed(int size,
      {int step = 1, bool partialWindows = false}) {
    final List<List<T>> windows = [];
    for (var i = 0; i < length; i += step) {
      if (i + size > length && !partialWindows) break;
      windows.add(sublist(i, i + size > length ? length : i + size));
    }
    return windows;
  }

  /// Returns a list containing only the elements that are present in both this list and [other].
  ///
  /// Uses the default equality for type [T].
  ///
  /// Example:
  /// ```dart
  /// final list1 = [1, 2, 3];
  /// final list2 = [2, 3, 4];
  /// final common = list1.intersect(list2);
  /// // common: [2, 3]
  /// ```
  List<T> intersect(List<T> other) {
    final Set<T> otherSet = other.toSet();
    return [
      for (var item in this)
        if (otherSet.contains(item)) item
    ];
  }

  /// Returns a list of elements that exist in this list but not in [other],
  /// based on a unique key extracted using [keySelector].
  ///
  /// This method does not rely on object equality (`==`). Instead, it removes
  /// items from this list that have a matching key in [other].
  ///
  /// ### Example Usage:
  /// ```dart
  /// final list1 = [Item(id: 1), Item(id: 2), Item(id: 3)];
  /// final list2 = [Item(id: 2)];
  ///
  /// final difference = list1.subtract(list2, (item) => item.id);
  /// // Result: [Item(id: 1), Item(id: 3)]
  /// ```
  ///
  /// - [other]: The list of items to exclude from this list.
  /// - [keySelector]: A function that extracts a unique key from each item for comparison.
  List<T> subtract<K>(List<T> other, K Function(T) keySelector) {
    final otherKeys = other.map(keySelector).toSet();
    return where((item) => !otherKeys.contains(keySelector(item))).toList();
  }

  /// Iterates over each element along with its index and performs [action].
  ///
  /// Example:
  /// ```dart
  /// final items = ['a', 'b', 'c'];
  /// items.forEachIndexed((i, item) => print('$i: $item'));
  /// ```
  void forEachIndexed(void Function(int index, T item) action) {
    for (var i = 0; i < length; i++) {
      action(i, this[i]);
    }
  }

  /// Returns a new list with the results of applying [transform] to each element along with its index.
  ///
  /// Example:
  /// ```dart
  /// final letters = ['a', 'b', 'c'];
  /// final indexed = letters.mapIndexed((i, letter) => '$i: $letter');
  /// // indexed: ['0: a', '1: b', '2: c']
  /// ```
  List<R> mapIndexed<R>(R Function(int index, T item) transform) {
    return [for (var i = 0; i < length; i++) transform(i, this[i])];
  }

  /// Filters the list using a predicate that also receives the element's index.
  ///
  /// Returns a list of elements for which the predicate returns `true`.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [10, 15, 20, 25];
  /// final filtered = numbers.filterIndexed((i, n) => i % 2 == 0);
  /// // filtered: [10, 20]
  /// ```
  List<T> filterIndexed(bool Function(int index, T item) predicate) {
    return [
      for (var i = 0; i < length; i++)
        if (predicate(i, this[i])) this[i]
    ];
  }

  /// Checks if all elements satisfy the [predicate], which also receives the index.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [2, 4, 6];
  /// final allEven = numbers.allIndexed((i, n) => n % 2 == 0);
  /// // allEven: true
  /// ```
  bool allIndexed(bool Function(int index, T item) predicate) {
    for (var i = 0; i < length; i++) {
      if (!predicate(i, this[i])) {
        return false;
      }
    }
    return true;
  }

  /// Checks if at least one element satisfies the [predicate], which also receives the index.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 3, 4];
  /// final anyEven = numbers.anyIndexed((i, n) => n % 2 == 0);
  /// // anyEven: true
  /// ```
  bool anyIndexed(bool Function(int index, T item) predicate) {
    for (var i = 0; i < length; i++) {
      if (predicate(i, this[i])) {
        return true;
      }
    }
    return false;
  }

  /// Counts the number of elements that satisfy [predicate].
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3, 4];
  /// final evenCount = numbers.count((n) => n % 2 == 0);
  /// // evenCount: 2
  /// ```
  int count(bool Function(T) predicate) {
    int count = 0;
    for (var item in this) {
      if (predicate(item)) {
        count++;
      }
    }
    return count;
  }

  /// Counts the elements in groups defined by [keySelector].
  ///
  /// Returns a map where each key is associated with the number of elements
  /// that produced that key.
  ///
  /// Example:
  /// ```dart
  /// final words = ['apple', 'banana', 'apricot'];
  /// final counts = words.countBy((word) => word[0]);
  /// // counts: {'a': 2, 'b': 1}
  /// ```
  Map<K, int> countBy<K>(K Function(T item) keySelector) {
    final countMap = <K, int>{};
    for (var item in this) {
      final key = keySelector(item);
      countMap[key] = (countMap[key] ?? 0) + 1;
    }
    return countMap;
  }

  /// Counts the number of elements that satisfy [predicate] which also receives the index.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3, 4];
  /// final countAtOddIndices = numbers.countIndexed((i, n) => i.isOdd);
  /// // countAtOddIndices: 2
  /// ```
  int countIndexed(bool Function(int index, T item) predicate) {
    int count = 0;
    for (var i = 0; i < length; i++) {
      if (predicate(i, this[i])) {
        count++;
      }
    }
    return count;
  }

  /// Folds the list into a single value by iteratively combining elements,
  /// while also providing the element's index to the [combine] function.
  ///
  /// [initial] is the starting value, and for each element, [combine] is called
  /// with the current index, the accumulated value, and the element.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3];
  /// final result = numbers.foldIndexed(0, (i, acc, n) => acc + n * i);
  /// // result: 0*1 + 1*2 + 2*3 = 8
  /// ```
  R foldIndexed<R>(
      R initial, R Function(int index, R accumulated, T item) combine) {
    var result = initial;
    for (var i = 0; i < length; i++) {
      result = combine(i, result, this[i]);
    }
    return result;
  }

  /// Reduces the list to a single value by iteratively combining elements,
  /// while also providing the element's index to the [combine] function.
  ///
  /// Throws a [StateError] if the list is empty.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3, 4];
  /// final result = numbers.reduceIndexed((i, acc, n) => acc + n);
  /// // result: 10
  /// ```
  T reduceIndexed(T Function(int index, T accumulated, T item) combine) {
    if (isEmpty) {
      throw StateError("Cannot reduce an empty list.");
    }
    var result = this[0];
    for (var i = 1; i < length; i++) {
      result = combine(i, result, this[i]);
    }
    return result;
  }

  /// Performs a "scan" operation on the list, returning a list of intermediate
  /// accumulated values.
  ///
  /// [initial] is the starting value. For each element, [combine] is applied
  /// to the accumulated value and the element, and the new accumulated value
  /// is added to the result.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3];
  /// final scanResult = numbers.scan(0, (acc, n) => acc + n);
  /// // scanResult: [1, 3, 6]
  /// ```
  List<R> scan<R>(R initial, R Function(R accumulated, T item) combine) {
    final List<R> result = [];
    var accumulated = initial;
    for (var item in this) {
      accumulated = combine(accumulated, item);
      result.add(accumulated);
    }
    return result;
  }

  /// Performs a "scan" operation on the list with an indexed combine function,
  /// returning a list of intermediate accumulated values.
  ///
  /// [initial] is the starting value. For each element, [combine] is applied
  /// with the current index, the accumulated value, and the element.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3];
  /// final scanResult = numbers.scanIndexed(0, (i, acc, n) => acc + n * i);
  /// // scanResult: [0, 2, 8]
  /// ```
  List<R> scanIndexed<R>(
      R initial, R Function(int index, R accumulated, T item) combine) {
    final List<R> result = [];
    var accumulated = initial;
    for (var i = 0; i < length; i++) {
      accumulated = combine(i, accumulated, this[i]);
      result.add(accumulated);
    }
    return result;
  }

  /// Returns a new list with the elements in random order.
  ///
  /// The original list is not modified.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3, 4, 5];
  /// final randomOrder = numbers.shuffled();
  /// // randomOrder: order may vary, e.g. [3, 1, 5, 2, 4]
  /// ```
  List<T> shuffled() {
    final List<T> copy = List.from(this);
    copy.shuffle();
    return copy;
  }

  /// Returns a random sample of [count] elements from the list.
  ///
  /// The sample is drawn without replacement. If [count] is less than or equal to 0,
  /// an empty list is returned.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3, 4, 5];
  /// final sample = numbers.sample(2);
  /// // sample: contains 2 random elements from numbers, e.g. [3, 5]
  /// ```
  List<T> sample(int count) {
    if (count <= 0) return [];
    final List<T> copy = shuffled();
    return copy.take(count).toList();
  }

  /// Returns a random sample of [count] elements from the list, with replacement.
  ///
  /// Elements may appear multiple times in the sample. If [count] is less than or equal to 0,
  /// an empty list is returned.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3];
  /// final sample = numbers.sampleWithReplacement(5);
  /// // sample: may contain duplicates, e.g. [2, 1, 3, 3, 2]
  /// ```
  List<T> sampleWithReplacement(int count) {
    if (count <= 0) return [];
    final List<T> result = [];
    final Random random = Random();
    for (var i = 0; i < count; i++) {
      result.add(this[random.nextInt(length)]);
    }
    return result;
  }

  /// Returns a random element from the list.
  ///
  /// Throws a [StateError] if the list is empty.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3, 4];
  /// final randomElement = numbers.random();
  /// // randomElement: one random element from numbers.
  /// ```
  T random() {
    if (isEmpty) {
      throw StateError("Cannot get a random element from an empty list.");
    }
    final Random random = Random();
    return this[random.nextInt(length)];
  }

  /// Returns a random element from the list or `null` if the list is empty.
  ///
  /// Example:
  /// ```dart
  /// final emptyList = [];
  /// final element = emptyList.randomOrNull();
  /// // element: null
  /// ```
  T? randomOrNull() {
    if (isEmpty) return null;
    final Random random = Random();
    return this[random.nextInt(length)];
  }

  /// Finds different (updated) items between two lists based on a key selector and a comparison function.
  ///
  /// - [other]: The other list to compare with.
  /// - [keySelector]: A function to extract the key used to identify items.
  /// - [compare]: A function to compare two items and determine if they are different.
  ///
  /// Returns a list of items from the current list that are present in [other] but have changed.
  List<T> diffBy<K>(
      List<T> other, K Function(T) keySelector, bool Function(T, T) compare) {
    // Convert the 'other' list into a map for quick lookup.
    final otherMap = other.toMap(keySelector);

    // Find common items based on the key selector and filter those that are different.
    return intersectBy(other, keySelector).where((currentItem) {
      final previousItem = otherMap[keySelector(currentItem)];
      return previousItem != null && compare(currentItem, previousItem);
    }).toList();
  }

  /// Finds the intersection of two lists based on a key selector.
  ///
  /// - [other]: The other list to compare with.
  /// - [keySelector]: A function to extract the key used to identify items.
  ///
  /// Returns a list of items that are present in both lists based on the key.
  List<T> intersectBy<K>(List<T> other, K Function(T) keySelector) {
    final Set<K> otherKeys = other.map(keySelector).toSet();
    return [
      for (var item in this)
        if (otherKeys.contains(keySelector(item))) item
    ];
  }

  /// Computes the quantity difference (`new - old`) for items present in both lists.
  ///
  /// - [other]: The old list to compare with.
  /// - [keySelector]: A function to extract the key used to identify items.
  /// - [quantitySelector]: A function to extract the quantity from an item.
  /// - [updateQuantity]: A function to update the quantity field.
  ///
  /// Returns a list of updated items where the quantity is replaced with the difference,
  /// excluding newly added or deleted items.
  List<T> quantityDiff<K>(
    List<T> other,
    K Function(T) keySelector,
    int Function(T) quantitySelector,
    T Function(T item, int newQuantity) updateQuantity,
  ) {
    return diffBy(
      other,
      keySelector,
      (currentItem, previousItem) =>
          quantitySelector(currentItem) != quantitySelector(previousItem),
    ).map((currentItem) {
      final oldQuantity = quantitySelector(
        other.firstWhere(
          (previousItem) =>
              keySelector(previousItem) == keySelector(currentItem),
        ),
      );

      final newQuantity = quantitySelector(currentItem);
      final difference = newQuantity - oldQuantity;

      return updateQuantity(currentItem, difference);
    }).toList();
  }
}

extension FlattenExtension<E> on List<List<E>> {
  List<E> flatten() {
    final List<E> flattened = [];
    for (var sublist in this) {
      flattened.addAll(sublist);
    }
    return flattened;
  }
}
