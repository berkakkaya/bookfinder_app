import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/services/api/base_api_service.dart";

typedef RecommendationData = List<Map<String, dynamic>>;

class ApiRecommendationsSubservice {
  static Future<ApiResponse<RecommendationData>> getRecommendations() async {
    final dio = BaseApiService.dio;

    final response = await dio.get("/recommendations");

    if (response.statusCode == 200) {
      final data = RecommendationData.from(response.data);
      return ApiResponse(data: data, status: ResponseStatus.ok);
    }

    return ApiResponse(status: ResponseStatus.unknownError);
  }
}
