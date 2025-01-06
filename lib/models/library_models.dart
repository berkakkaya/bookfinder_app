class BookListItem {
  final String bookListId;
  final String authorId;
  String _title;
  int bookCount;
  bool _isPrivate;

  BookListItem({
    required this.bookListId,
    required this.authorId,
    required String title,
    required this.bookCount,
    required bool isPrivate,
  })  : _title = title,
        _isPrivate = isPrivate {
    if (title == "_likedBooks" && !isPrivate) {
      throw StateError("Liked books library must be private.");
    }
  }

  String get title => _title == "_likedBooks" ? "Beğenilen Kitaplar" : _title;
  String get internalTitle => _title;

  set title(String title) {
    _title = title;
  }

  bool get isPrivate => _isPrivate;

  set isPrivate(bool isPrivate) {
    if (_title == "_likedBooks" && !isPrivate) {
      throw StateError("Can't change visibility of liked books library.");
    }

    _isPrivate = isPrivate;
  }
}

class BookListBookItem {
  final String bookId;
  final String title;
  final List<String> authors;
  final String thumbnailUrl;

  BookListBookItem({
    required this.bookId,
    required this.title,
    required this.authors,
    required this.thumbnailUrl,
  });
}

class BookListItemWithBooks extends BookListItem {
  final List<BookListBookItem> books;

  BookListItemWithBooks({
    required super.bookListId,
    required super.authorId,
    required super.title,
    required super.bookCount,
    required super.isPrivate,
    required this.books,
  });
}
