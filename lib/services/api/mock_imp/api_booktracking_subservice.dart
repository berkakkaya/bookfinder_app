import "package:bookfinder_app/extensions/lists.dart";
import "package:bookfinder_app/interfaces/api/api_booktracking_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/book_tracking_models.dart";
import "package:bookfinder_app/models/mock_datamodels.dart";
import "package:bookfinder_app/services/api/mock_imp/mock_api_db.dart";

class MockApiBooktrackingSubservice implements ApiBooktrackingSubservice {
  final MockApiDb _db;

  MockApiBooktrackingSubservice(this._db);

  @override
  Future<ApiResponse<BookTrackingData>> getBookTrackingData(
    String bookId, {
    required String authHeader,
  }) {
    final userId = authHeader.split(" ").last;

    final bookTrackingData = _db.mockBookTrackingDatas.firstWhereOrNull(
      (e) => e.userId == userId && e.bookId == bookId,
    );

    if (bookTrackingData == null) {
      return Future.value(ApiResponse(
        status: ResponseStatus.notFound,
      ));
    }

    return Future.value(ApiResponse(
      status: ResponseStatus.ok,
      data: bookTrackingData,
    ));
  }

  @override
  Future<ApiResponse<BookTrackingDataWithBookDatas>> getBookTrackingDatas({
    required String authHeader,
  }) {
    final userId = authHeader.split(" ").last;

    final BookTrackingDataWithBookDatas bookTrackingDatas =
        _db.mockBookTrackingDatas.where((e) => e.userId == userId).map((e) {
      final bookData = _db.mockBookDatas.firstWhere(
        (b) => b.bookId == e.bookId,
      );

      return BookTrackingDataWithBookData(
        bookId: e.bookId,
        status: e.status,
        bookTitle: bookData.title,
        bookAuthors: bookData.authors,
        bookThumbnailUrl: bookData.thumbnailUrl,
      );
    }).toList();

    return Future.value(ApiResponse(
      status: ResponseStatus.ok,
      data: bookTrackingDatas,
    ));
  }

  @override
  Future<ApiResponse<void>> removeBookTrackingData(
    String bookId, {
    required String authHeader,
  }) {
    final userId = authHeader.split(" ").last;

    final bookTrackingData = _db.mockBookTrackingDatas.firstWhereOrNull(
      (e) => e.userId == userId && e.bookId == bookId,
    );

    if (bookTrackingData == null) {
      return Future.value(ApiResponse(
        status: ResponseStatus.notFound,
      ));
    }

    _db.mockBookTrackingDatas.remove(bookTrackingData);

    return Future.value(ApiResponse(
      status: ResponseStatus.ok,
    ));
  }

  @override
  Future<ApiResponse<void>> updateBookTrackingData({
    required String bookId,
    required BookTrackingStatus status,
    required String authHeader,
  }) {
    final userId = authHeader.split(" ").last;

    final bookTrackingData = _db.mockBookTrackingDatas.firstWhereOrNull(
      (e) => e.userId == userId && e.bookId == bookId,
    );

    if (bookTrackingData == null) {
      final newData = MockBookTrackingData(
        userId: userId,
        bookId: bookId,
        status: status,
      );

      _db.mockBookTrackingDatas.add(newData);
    } else {
      bookTrackingData.status = status;
    }

    return Future.value(ApiResponse(
      status: ResponseStatus.ok,
    ));
  }
}
