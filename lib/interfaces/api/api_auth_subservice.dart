import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/token_pair.dart";

abstract class ApiAuthSubservice {
  TokenPair? get tokenPairState;

  Future<ApiResponse<TokenPair>> login(String email, String password);
  Future<ApiResponse<TokenPair>> register({
    required String nameSurname,
    required String email,
    required String password,
  });
  Future<ApiResponse<void>> refreshAccessToken();
  Future<void> logout();
}
