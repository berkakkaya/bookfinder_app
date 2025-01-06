import "package:bookfinder_app/interfaces/api/api_auth_subservice.dart";
import "package:bookfinder_app/interfaces/api/api_bookdatas_subservice.dart";
import "package:bookfinder_app/interfaces/api/api_booktracking_subservice.dart";
import "package:bookfinder_app/interfaces/api/api_library_subservice.dart";
import "package:bookfinder_app/interfaces/api/api_recommendations_subservice.dart";
import "package:bookfinder_app/interfaces/api/api_users_subservice.dart";

abstract class ApiService {
  ApiAuthSubservice get auth;
  ApiUsersSubservice get users;
  ApiBookdatasSubservice get bookDatas;
  ApiRecommendationsSubservice get recommendations;
  ApiBooktrackingSubservice get bookTracking;
  ApiLibrarySubservice get library;

  Future<bool> checkApiHealth();
}
