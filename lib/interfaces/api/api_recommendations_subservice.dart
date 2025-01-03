import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/services/api/dio_imp/api_recommendations_subservice.dart";

abstract class ApiRecommendationsSubservice {
  Future<ApiResponse<RecommendationData>> getRecommendations({
    required String authHeader,
  });
}
