enum BookTrackingStatus {
  willRead,
  reading,
  completed,
  dropped,
}

class BookTrackingData {
  final String bookId;
  final BookTrackingStatus status;

  const BookTrackingData({
    required this.bookId,
    required this.status,
  });
}

class BookTrackingDataWithBookData extends BookTrackingData {
  final String bookTitle;
  final List<String> bookAuthors;
  final String bookThumbnailUrl;

  const BookTrackingDataWithBookData({
    required super.bookId,
    required super.status,
    required this.bookTitle,
    required this.bookAuthors,
    required this.bookThumbnailUrl,
  });
}
