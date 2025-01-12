import "package:bookfinder_app/extensions/lists.dart";
import "package:bookfinder_app/interfaces/api/api_library_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/feed_models.dart";
import "package:bookfinder_app/models/library_models.dart";
import "package:bookfinder_app/services/api/mock_imp/mock_api_db.dart";
import "package:bookfinder_app/services/logging/logging_service_provider.dart";

class MockApiLibrarySubservice implements ApiLibrarySubservice {
  final MockApiDb _db;

  MockApiLibrarySubservice(this._db);

  @override
  Future<ApiResponse<List<(BookListItem, bool)>>> fetchListContainStatusOfBook(
    String bookId, {
    required String authHeader,
  }) {
    final userId = authHeader.split(" ").last;

    final containStatus = _db.mockBookListItems
        .where((list) => list.authorId == userId)
        .map((list) => (list, list.books.any((book) => book.bookId == bookId)))
        .toList();

    return Future.value(ApiResponse(
      status: ResponseStatus.ok,
      data: containStatus,
    ));
  }

  @override
  Future<ApiResponse<void>> createBookList({
    required String title,
    required bool isPrivate,
    required String authHeader,
  }) {
    if (title == "_likedBooks") {
      return Future.value(ApiResponse(
        status: ResponseStatus.badRequest,
      ));
    }

    final authorId = authHeader.split(" ").last;
    final int newBookListId = _db.mockBookListItems.isNotEmpty
        ? int.parse(_db.mockBookListItems.last.bookListId) + 1
        : 1;

    final newBookList = BookListItemWithBooks(
      bookListId: newBookListId.toString(),
      authorId: authorId,
      title: title,
      bookCount: 0,
      isPrivate: isPrivate,
      books: [],
    );

    _db.mockBookListItems.add(newBookList);

    // If newly created list is public, create feed record
    if (isPrivate == false) {
      final user = _db.mockUsers.firstWhere((user) => user.userId == authorId);

      _db.mockFeedEntries.add(BookListPublishFeedEntry(
        issuerUserId: authorId,
        issuerNameSurname: user.nameSurname,
        issuedAt: DateTime.now(),
        bookListId: newBookListId.toString(),
        bookListName: title,
      ));
    }

    return Future.value(ApiResponse(status: ResponseStatus.created));
  }

  @override
  Future<ApiResponse<void>> deleteBookList(
    String bookListId, {
    required String authHeader,
  }) {
    final authorId = authHeader.split(" ").last;

    final listIndex = _db.mockBookListItems.indexWhere(
      (list) => list.bookListId == bookListId && list.authorId == authorId,
    );

    if (listIndex == -1) {
      return Future.value(ApiResponse(
        status: ResponseStatus.notFound,
      ));
    }

    if (_db.mockBookListItems[listIndex].internalTitle == "_likedBooks") {
      LoggingServiceProvider.i.error(
        "Tried to delete the _likedBooks list, which is not allowed.",
      );

      return Future.value(ApiResponse(
        status: ResponseStatus.badRequest,
      ));
    }

    _db.mockBookListItems.removeAt(listIndex);

    return Future.value(ApiResponse(status: ResponseStatus.ok));
  }

  @override
  Future<ApiResponse<BookListItemWithBooks>> getBookList(
    String bookListId, {
    required String authHeader,
  }) {
    final authorId = authHeader.split(" ").last;

    final foundList = _db.mockBookListItems.firstWhereOrNull((list) {
      if (bookListId == "_likedBooks") {
        // Liked books list is a special list that is not created by the user.
        // Check if we are currently on the liked books list and authorId is
        // the same.
        return list.internalTitle == "_likedBooks" && list.authorId == authorId;
      }

      // Check if IDs match
      if (list.bookListId != bookListId) {
        return false;
      }

      // If the list is public, allow access
      if (list.isPrivate == false) {
        return true;
      }

      // If the list is private, only allow access if the authorId matches
      return list.authorId == authorId;
    });

    if (bookListId == "_likedBooks") {
      assert(foundList != null, "Liked books list should always exist.");
    }

    if (foundList == null) {
      return Future.value(ApiResponse(
        status: ResponseStatus.notFound,
      ));
    }

    return Future.value(ApiResponse(
      status: ResponseStatus.ok,
      data: foundList,
    ));
  }

  @override
  Future<ApiResponse<List<BookListItem>>> getBookLists({
    String? targetUserId,
    required String authHeader,
  }) {
    final authorId = authHeader.split(" ").last;

    final foundLists = _db.mockBookListItems.where((list) {
      if (targetUserId != null) {
        return list.authorId == targetUserId && list.isPrivate == false;
      }

      return list.authorId == authorId;
    }).toList();

    return Future.value(ApiResponse(
      status: ResponseStatus.ok,
      data: foundLists,
    ));
  }

  @override
  Future<ApiResponse<void>> updateBookList(
    String bookListId, {
    required String title,
    required bool isPrivate,
    required String authHeader,
  }) {
    if (title == "_likedBooks") {
      return Future.value(ApiResponse(
        status: ResponseStatus.badRequest,
      ));
    }

    final authorId = authHeader.split(" ").last;

    final listIndex = _db.mockBookListItems.indexWhere((list) {
      return list.bookListId == bookListId && list.authorId == authorId;
    });

    if (listIndex == -1) {
      return Future.value(ApiResponse(
        status: ResponseStatus.notFound,
      ));
    }

    final item = _db.mockBookListItems[listIndex];

    item.title = title;
    item.isPrivate = isPrivate;

    // If the list made public, create feed record
    if (isPrivate == false) {
      final user = _db.mockUsers.firstWhere((user) => user.userId == authorId);

      _db.mockFeedEntries.add(BookListPublishFeedEntry(
        issuerUserId: authorId,
        issuerNameSurname: user.nameSurname,
        issuedAt: DateTime.now(),
        bookListId: bookListId,
        bookListName: title,
      ));
    }

    return Future.value(ApiResponse(status: ResponseStatus.ok));
  }

  @override
  Future<ApiResponse<void>> addBookToList(
    String bookListId, {
    required String bookId,
    required String authHeader,
  }) {
    final authorId = authHeader.split(" ").last;

    final listIndex = _db.mockBookListItems.indexWhere((list) {
      if (bookListId == "_likedBooks") {
        return list.internalTitle == "_likedBooks" && list.authorId == authorId;
      }

      return list.bookListId == bookListId && list.authorId == authorId;
    });

    if (listIndex == -1) {
      return Future.value(ApiResponse(
        status: ResponseStatus.notFound,
      ));
    }

    final item = _db.mockBookListItems[listIndex];

    if (item.books.any((book) => book.bookId == bookId)) {
      return Future.value(ApiResponse(
        status: ResponseStatus.ok,
      ));
    }

    final book = _db.mockBookDatas.firstWhereOrNull(
      (book) => book.bookId == bookId,
    );

    if (book == null) {
      return Future.value(ApiResponse(
        status: ResponseStatus.notFound,
      ));
    }

    final newBook = BookListBookItem(
      bookId: bookId,
      title: book.title,
      authors: book.authors,
      thumbnailUrl: book.thumbnailUrl,
    );

    item.books.add(newBook);
    item.bookCount++;

    return Future.value(ApiResponse(status: ResponseStatus.ok));
  }

  @override
  Future<ApiResponse<void>> removeBookFromList(
    String bookListId, {
    required String bookId,
    required String authHeader,
  }) {
    final authorId = authHeader.split(" ").last;

    final listIndex = _db.mockBookListItems.indexWhere((list) {
      if (bookListId == "_likedBooks") {
        return list.internalTitle == "_likedBooks" && list.authorId == authorId;
      }

      return list.bookListId == bookListId && list.authorId == authorId;
    });

    if (listIndex == -1) {
      return Future.value(ApiResponse(
        status: ResponseStatus.notFound,
      ));
    }

    final item = _db.mockBookListItems[listIndex];

    final bookIndex = item.books.indexWhere((book) => book.bookId == bookId);

    if (bookIndex == -1) {
      return Future.value(ApiResponse(
        status: ResponseStatus.notFound,
      ));
    }

    item.books.removeAt(bookIndex);
    item.bookCount--;

    return Future.value(ApiResponse(status: ResponseStatus.ok));
  }
}
