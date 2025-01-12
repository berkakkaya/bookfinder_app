class BaseFeedEntry {
  final String issuerUserId;
  final String issuerNameSurname;
  final DateTime issuedAt;

  BaseFeedEntry({
    required this.issuerUserId,
    required this.issuerNameSurname,
    required this.issuedAt,
  });
}

class BookListPublishFeedEntry extends BaseFeedEntry {
  final String bookListId;
  final String bookListName;

  BookListPublishFeedEntry({
    required super.issuerUserId,
    required super.issuerNameSurname,
    required super.issuedAt,
    required this.bookListId,
    required this.bookListName,
  });
}
