import "package:bookfinder_app/interfaces/api/api_recommendations_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/book_category_type.dart";
import "package:bookfinder_app/models/bookdata_models.dart";
import "package:bookfinder_app/utils/convert_utils.dart";
import "package:dio/dio.dart";

class DioApiRecommendationsSubservice implements ApiRecommendationsSubservice {
  final Dio _dio;

  DioApiRecommendationsSubservice(this._dio);

  @override
  Future<ApiResponse<List<BookRecommendation>>> getRecommendations({
    BookCategory? categoryFilter,
    required String authHeader,
  }) async {
    try {
      final response = await _dio.get(
        "/recommendations",
        queryParameters: {
          if (categoryFilter != null) "category": categoryFilter.name,
        },
        options: Options(headers: {"Authorization": authHeader}),
      );

      if (response.statusCode == 200) {
        final recommendations = BookRecommendation.fromJsonList(
          response.data["recommendations"],
        );
        return ApiResponse(data: recommendations, status: ResponseStatus.ok);
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      rethrow;
    }
  }
}
