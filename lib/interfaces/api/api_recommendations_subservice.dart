import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/bookdata_models.dart";

abstract class ApiRecommendationsSubservice {
  Future<ApiResponse<List<BookRecommendation>>> getRecommendations({
    required String authHeader,
  });
}
