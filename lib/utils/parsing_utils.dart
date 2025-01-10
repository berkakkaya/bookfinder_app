String parseLeadingLetters(
  String input, {
  int? count,
}) {
  final leadingLetters = input.split(" ").map((e) => e.isEmpty ? "" : e[0]);

  if (count != null) {
    return leadingLetters.take(count).join();
  }

  return leadingLetters.join();
}
