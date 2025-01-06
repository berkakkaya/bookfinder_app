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
