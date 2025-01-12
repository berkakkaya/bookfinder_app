class BaseFeedEntry {
  final String issuerUserId;
  final String issuerNameSurname;
  final DateTime issuedAt;

  BaseFeedEntry({
    required this.issuerUserId,
    required this.issuerNameSurname,
    required this.issuedAt,
  });

  static BaseFeedEntry fromJson(Map<String, dynamic> json) {
    final type = json["type"] as String;

    switch (type) {
      case "book_list_publish":
        return BookListPublishFeedEntry(
          issuerUserId: json["issuerUserId"],
          issuerNameSurname: json["issuerNameSurname"],
          issuedAt: DateTime.parse(json["issuedAt"]),
          bookListId: json["bookListId"],
          bookListName: json["bookListName"],
        );
      default:
        throw ArgumentError("Unknown feed entry type: $type");
    }
  }
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
