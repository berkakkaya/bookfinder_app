extension StringExtension on String {
  Iterable<String> get leadingLetters {
    return split(" ").map((e) => e.isEmpty ? "" : e[0]);
  }
}
