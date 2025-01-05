/// Represents the type of identifier for a book
enum IdentifierType {
  /// ISBN-10 identifier
  isbn10,

  /// ISBN-13 identifier
  isbn13,

  /// ISSN identifier
  issn,

  /// Other type of identifier
  other,
}

/// Represents a book identifier
class BookIdentifier {
  /// The type of identifier
  final IdentifierType type;

  /// The identifier value
  final String identifier;

  const BookIdentifier({required this.type, required this.identifier});

  /// Converts a JSON object to a [BookIdentifier] object
  factory BookIdentifier.fromJson(Map<String, dynamic> json) {
    final IdentifierType type = switch (json["type"]) {
      "ISBN_10" => IdentifierType.isbn10,
      "ISBN_13" => IdentifierType.isbn13,
      "ISSN" => IdentifierType.issn,
      _ => IdentifierType.other,
    };

    return BookIdentifier(
      type: type,
      identifier: json["identifier"],
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookIdentifier &&
        other.type == type &&
        other.identifier == identifier;
  }

  @override
  int get hashCode => (type.name + identifier).hashCode;
}

/// Represents the data of a book
class BookData {
  /// Unique identifier of this book
  final String bookId;

  /// The title of this book
  final String title;

  /// Authors of this book
  final List<String> authors;

  /// Description of this book
  final String? description;

  /// URL of the thumbnail image of this book
  final String thumbnailUrl;

  /// Industry standard identifiers of this book
  final List<BookIdentifier> identifiers;

  const BookData({
    required this.bookId,
    required this.title,
    required this.authors,
    this.description,
    required this.thumbnailUrl,
    this.identifiers = const [],
  });

  /// Converts a JSON object to a [BookData] object
  factory BookData.fromJson(Map<String, dynamic> json) {
    final List<BookIdentifier> identifiers = [];

    for (final Map<String, dynamic> identifier in json["identifiers"]) {
      identifiers.add(BookIdentifier.fromJson(identifier));
    }

    return BookData(
      bookId: json["bookId"],
      title: json["title"],
      authors: json["authors"],
      description: json["description"],
      thumbnailUrl: json["thumbnailUrl"],
      identifiers: identifiers,
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookData && other.bookId == bookId;
  }

  @override
  int get hashCode => bookId.hashCode;
}

/// Represents a book recommendation
class BookRecommendation {
  /// Unique identifier of this book
  final String bookId;

  /// The title of this book
  final String title;

  /// Authors of this book
  final List<String> authors;

  /// Description of this book
  final String? description;

  /// URL of the thumbnail image of this book
  final String thumbnailUrl;

  const BookRecommendation({
    required this.bookId,
    required this.title,
    required this.authors,
    this.description,
    required this.thumbnailUrl,
  });

  /// Converts a JSON object to a [BookRecommendation] object
  factory BookRecommendation.fromJson(Map<String, dynamic> json) {
    return BookRecommendation(
      bookId: json["bookId"],
      title: json["title"],
      authors: json["authors"],
      description: json["description"],
      thumbnailUrl: json["thumbnailUrl"],
    );
  }

  /// Converts a list of JSON objects to a list of [BookRecommendation] objects
  static List<BookRecommendation> fromJsonList(
    List<Map<String, dynamic>> list,
  ) {
    return list.map((e) => BookRecommendation.fromJson(e)).toList();
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookRecommendation && other.bookId == bookId;
  }

  @override
  int get hashCode => bookId.hashCode;
}

class BookSearchResult {
  /// Unique identifier of this book
  final String bookId;

  /// The title of this book
  final String title;

  /// URL of the thumbnail image of this book
  final String thumbnailUrl;

  const BookSearchResult({
    required this.bookId,
    required this.title,
    required this.thumbnailUrl,
  });

  /// Converts a JSON object to a [BookSearchResult] object
  factory BookSearchResult.fromJson(Map<String, dynamic> json) {
    return BookSearchResult(
      bookId: json["bookId"],
      title: json["title"],
      thumbnailUrl: json["thumbnailUrl"],
    );
  }

  /// Converts a list of JSON objects to a list of [BookSearchResult] objects
  static List<BookSearchResult> fromJsonList(List<Map<String, dynamic>> list) {
    return list.map((e) => BookSearchResult.fromJson(e)).toList();
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookSearchResult && other.bookId == bookId;
  }

  @override
  int get hashCode => bookId.hashCode;
}
