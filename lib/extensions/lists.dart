import "dart:math";

extension ListExt<T> on List<T> {
  /// Returns the first element that satisfies the given predicate [test].
  ///
  /// If no element satisfies the predicate, the result will be `null`.
  T? firstWhereOrNull(bool Function(T) test) {
    for (T element in this) {
      if (test(element)) {
        return element;
      }
    }

    return null;
  }

  /// Picks random elements from the list at [count] amount.
  ///
  /// If [count] is greater than or equal to the length of the list,
  /// the list will be shuffled and returned.
  Iterable<T> pickRandom(
    int count, {
    int? seed,
  }) sync* {
    final random = Random(seed);
    final List<T> copy = List<T>.from(this);

    if (count >= length) {
      copy.shuffle(random);

      yield* copy;
      return;
    }

    for (int i = 0; i < count; i++) {
      final int index = random.nextInt(copy.length);
      yield copy.removeAt(index);
    }
  }
}
