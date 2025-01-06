import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/user_models.dart";

abstract class ApiUsersSubservice {
  Future<ApiResponse<User>> getUser(
    String? userId, {
    required String authHeader,
  });
}
