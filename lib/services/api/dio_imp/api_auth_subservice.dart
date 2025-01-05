import "package:bookfinder_app/interfaces/api/api_auth_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/token_pair.dart";
import "package:bookfinder_app/utils/api_utils.dart";
import "package:dio/dio.dart";

class DioApiAuthSubservice extends ApiAuthSubservice {
  final Dio _dio;

  /// The token pair used for authentication.
  TokenPair? _tokens;

  DioApiAuthSubservice(
    this._dio, {
    required TokenPair? tokens,
  }) {
    _tokens = tokens;
  }

  @override
  TokenPair? get tokenPairState => _tokens;

  @override
  void setTokenPair(TokenPair tokenPair) {
    _tokens = tokenPair;
  }

  @override
  Future<ApiResponse<TokenPair>> login(String email, String password) async {
    try {
      final response = await _dio.post("/login", data: {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        _tokens = TokenPair(
          accessToken: response.data["accessToken"],
          refreshToken: response.data["refreshToken"],
        );

        return ApiResponse(
          status: ResponseStatus.ok,
          data: _tokens,
        );
      } else {
        return ApiResponse(status: ResponseStatus.unknownError);
      }
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      // Uncovered error occurred, rethrow it
      rethrow;
    }
  }

  @override
  Future<ApiResponse<TokenPair>> register({
    required String nameSurname,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post("/register", data: {
        "nameSurname": nameSurname,
        "email": email,
        "password": password,
      });

      if (response.statusCode == 201) {
        _tokens = TokenPair(
          accessToken: response.data["accessToken"],
          refreshToken: response.data["refreshToken"],
        );

        return ApiResponse(
          status: ResponseStatus.created,
          data: _tokens,
        );
      } else {
        return ApiResponse(status: ResponseStatus.unknownError);
      }
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      // Uncovered error occurred, rethrow it
      rethrow;
    }
  }

  @override
  Future<ApiResponse<TokenPair>> refreshAccessToken() async {
    if (_tokens == null) {
      return ApiResponse(status: ResponseStatus.unauthorized);
    }

    try {
      final response = await _dio.post("/token",
          options: Options(
            headers: {
              "Authorization": "Bearer ${_tokens!.refreshToken}",
            },
          ));

      if (response.statusCode == 201) {
        _tokens = TokenPair(
          accessToken: response.data["accessToken"],
          refreshToken: _tokens!.refreshToken,
        );

        return ApiResponse(
          status: ResponseStatus.created,
          data: _tokens,
        );
      } else {
        return ApiResponse(status: ResponseStatus.unknownError);
      }
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      // Uncovered error occurred, rethrow it
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    _tokens = null;
  }
}
