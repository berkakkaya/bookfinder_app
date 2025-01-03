import "package:bookfinder_app/interfaces/api/api_auth_subservice.dart";
import "package:bookfinder_app/interfaces/api/api_bookdatas_subservice.dart";
import "package:bookfinder_app/interfaces/api/api_recommendations_subservice.dart";

abstract class ApiService {
  ApiAuthSubservice get auth;
  ApiBookdatasSubservice get bookDatas;
  ApiRecommendationsSubservice get recommendations;
}
