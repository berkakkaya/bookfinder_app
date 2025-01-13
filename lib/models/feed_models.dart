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
      case "bookListPublish'":
        return BookListPublishFeedEntry(
          issuerUserId: json["issuerUserId"],
          issuerNameSurname: json["issuerNameSurname"],
          issuedAt: DateTime.parse(json["issuedAt"]),
          bookListId: json["details"]["bookListId"],
          bookListName: json["details"]["bookListName"],
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
