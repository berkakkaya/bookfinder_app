import "package:bookfinder_app/extensions/lists.dart";
import "package:bookfinder_app/interfaces/api/api_bookdatas_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/bookdata_models.dart";
import "package:bookfinder_app/services/api/mock_imp/mock_api_db.dart";

class MockApiBookdatasSubservice extends ApiBookdatasSubservice {
  final MockApiDb _db;

  MockApiBookdatasSubservice(this._db);

  @override
  Future<ApiResponse<BookData>> getBookData(
    String bookId, {
    required String authHeader,
  }) {
    final bookData = _db.mockBookDatas.firstWhereOrNull(
      (b) => b.bookId == bookId,
    );

    return Future.value(ApiResponse(
      status: bookData != null ? ResponseStatus.ok : ResponseStatus.notFound,
      data: bookData,
    ));
  }

  @override
  Future<ApiResponse<List<BookSearchResult>>> searchBooks(
    String query, {
    required String authHeader,
  }) {
    final results = _db.mockBookDatas
        .where((b) => b.title.toLowerCase().contains(query.toLowerCase()))
        .map((b) => BookSearchResult(
              bookId: b.bookId,
              title: b.title,
              thumbnailUrl: b.thumbnailUrl,
            ))
        .toList();

    return Future.value(ApiResponse(
      status: results.isNotEmpty ? ResponseStatus.ok : ResponseStatus.notFound,
      data: results.isNotEmpty ? results : null,
    ));
  }
}
