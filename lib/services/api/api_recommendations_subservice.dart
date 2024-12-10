import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/services/api/base_api_service.dart";
import "package:dio/dio.dart";

typedef RecommendationData = List<Map<String, dynamic>>;

class ApiRecommendationsSubservice {
  static Future<ApiResponse<RecommendationData>> getRecommendations({
    required String authHeader,
  }) async {
    final dio = BaseApiService.dio;

    try {
      final response = await dio.get(
        "/recommendations",
        options: Options(headers: {"Authorization": authHeader}),
      );

      if (response.statusCode == 200) {
        final data = RecommendationData.from(response.data);
        return ApiResponse(data: data, status: ResponseStatus.ok);
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
