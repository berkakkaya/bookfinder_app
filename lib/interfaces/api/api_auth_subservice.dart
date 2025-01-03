import "package:bookfinder_app/models/api_response.dart";

abstract class ApiAuthSubservice {
  Future<ApiResponse<void>> login(String email, String password);
  Future<ApiResponse<void>> register({
    required String nameSurname,
    required String email,
    required String password,
  });
  Future<ApiResponse<void>> refreshAccessToken();
  Future<void> logout();
}
