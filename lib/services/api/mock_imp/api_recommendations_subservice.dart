import "package:bookfinder_app/extensions/lists.dart";
import "package:bookfinder_app/interfaces/api/api_recommendations_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/bookdata_models.dart";
import "package:bookfinder_app/services/api/mock_imp/mock_api_db.dart";

class MockApiRecommendationsSubservice extends ApiRecommendationsSubservice {
  final MockApiDb _db;

  MockApiRecommendationsSubservice(this._db);

  @override
  Future<ApiResponse<List<BookRecommendation>>> getRecommendations({
    required String authHeader,
  }) {
    return Future.value(ApiResponse(
      status: ResponseStatus.ok,
      data: _db.mockBookDatas
          .pickRandom(10)
          .map(
            (b) => BookRecommendation(
              bookId: b.bookId,
              title: b.title,
              authors: b.authors,
              thumbnailUrl: b.thumbnailUrl,
            ),
          )
          .toList(),
    ));
  }
}
