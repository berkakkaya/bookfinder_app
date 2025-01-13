enum BookTrackingStatus {
  willRead,
  reading,
  completed,
  dropped,
}

BookTrackingStatus convertStrToBookTrackingStatus(String status) {
  switch (status) {
    case "willRead":
      return BookTrackingStatus.willRead;
    case "reading":
      return BookTrackingStatus.reading;
    case "completed":
      return BookTrackingStatus.completed;
    case "dropped":
      return BookTrackingStatus.dropped;
    default:
      throw ArgumentError("Invalid status: $status");
  }
}

class BookTrackingData {
  final String bookId;
  BookTrackingStatus status;

  BookTrackingData({
    required this.bookId,
    required this.status,
  });

  static BookTrackingData fromJson(Map<String, dynamic> json) {
    return BookTrackingData(
      bookId: json["bookId"],
      status: convertStrToBookTrackingStatus(json["status"]),
    );
  }
}

class BookTrackingDataWithBookData extends BookTrackingData {
  final String bookTitle;
  final List<String> bookAuthors;
  final String bookThumbnailUrl;

  BookTrackingDataWithBookData({
    required super.bookId,
    required super.status,
    required this.bookTitle,
    required this.bookAuthors,
    required this.bookThumbnailUrl,
  });

  static BookTrackingDataWithBookData fromJson(Map<String, dynamic> json) {
    return BookTrackingDataWithBookData(
      bookId: json["bookId"],
      status: convertStrToBookTrackingStatus(json["status"]),
      bookTitle: json["bookTitle"],
      bookAuthors: List<String>.from(json["bookAuthors"]),
      bookThumbnailUrl: json["bookThumbnailUrl"],
    );
  }
}
