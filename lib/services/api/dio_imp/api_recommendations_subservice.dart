import "package:bookfinder_app/interfaces/api/api_recommendations_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/bookdata_models.dart";
import "package:dio/dio.dart";

class DioApiRecommendationsSubservice implements ApiRecommendationsSubservice {
  final Dio _dio;

  DioApiRecommendationsSubservice(this._dio);

  @override
  Future<ApiResponse<List<BookRecommendation>>> getRecommendations({
    required String authHeader,
  }) async {
    try {
      final response = await _dio.get(
        "/recommendations",
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
      if (e.response?.statusCode == 401) {
        return ApiResponse(status: ResponseStatus.unauthorized);
      }

      rethrow;
    }
  }
}
