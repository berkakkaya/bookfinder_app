import "package:bookfinder_app/consts/navigator_key.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/screens/authentication/welcome_screen.dart";
import "package:bookfinder_app/services/api/base_api_service.dart";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

/// API service with auth state handling.
///
/// This class extends [BaseApiService] and adds methods for
/// handling the user's authentication state.
class ApiServiceAuth extends BaseApiService {
  /// The current access token
  static String? _accessToken;

  /// The current refresh token
  static String? _refreshToken;

  static String? get authHeader {
    if (_accessToken == null) {
      return null;
    }

    return "Bearer $_accessToken";
  }

  static Future<bool> init(Uri? baseUri) async {
    final preferences = SharedPreferencesAsync();

    // Load the access and refresh tokens from the shared preferences
    _accessToken = await preferences.getString("accessToken");
    _refreshToken = await preferences.getString("refreshToken");

    return BaseApiService.init(baseUri);
  }

  static Future<ApiResponse<void>> login(String email, String password) async {
    final dio = BaseApiService.dio;
    final preferences = SharedPreferencesAsync();

    try {
      final response = await dio.post("/login", data: {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        _accessToken = response.data["accessToken"];
        _refreshToken = response.data["refreshToken"];

        await preferences.setString("accessToken", _accessToken!);
        await preferences.setString("refreshToken", _refreshToken!);

        return ApiResponse(status: ResponseStatus.ok);
      } else {
        return ApiResponse(status: ResponseStatus.unknownError);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse(status: ResponseStatus.unauthorized);
      }

      // Uncovered error occurred, rethrow it
      rethrow;
    }
  }

  static Future<ApiResponse<void>> register({
    required String nameSurname,
    required String email,
    required String password,
  }) async {
    final dio = BaseApiService.dio;
    final preferences = SharedPreferencesAsync();

    try {
      final response = await dio.post("/register", data: {
        "nameSurname": nameSurname,
        "email": email,
        "password": password,
      });

      if (response.statusCode == 201) {
        _accessToken = response.data["accessToken"];
        _refreshToken = response.data["refreshToken"];

        await preferences.setString("accessToken", _accessToken!);
        await preferences.setString("refreshToken", _refreshToken!);

        return ApiResponse(status: ResponseStatus.created);
      } else {
        return ApiResponse(status: ResponseStatus.unknownError);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return ApiResponse(status: ResponseStatus.conflict);
      }

      // Uncovered error occurred, rethrow it
      rethrow;
    }
  }

  static Future<ApiResponse<void>> refreshAccessToken() async {
    final dio = BaseApiService.dio;
    final preferences = SharedPreferencesAsync();

    if (_refreshToken == null) {
      return ApiResponse(status: ResponseStatus.unauthorized);
    }

    try {
      final response = await dio.post("/token",
          options: Options(
            headers: {
              "Authorization": authHeader!,
            },
          ));

      if (response.statusCode == 201) {
        _accessToken = response.data["accessToken"];
        await preferences.setString("accessToken", _accessToken!);

        return ApiResponse(status: ResponseStatus.created);
      } else {
        return ApiResponse(status: ResponseStatus.unknownError);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return ApiResponse(status: ResponseStatus.unauthorized);
      }

      // Uncovered error occurred, rethrow it
      rethrow;
    }
  }

  static Future<void> logout() async {
    final preferences = SharedPreferencesAsync();

    _accessToken = null;
    _refreshToken = null;

    await preferences.remove("accessToken");
    await preferences.remove("refreshToken");

    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (_) => false,
    );
  }

  /// Performs a API request and auto refreshes the access token if needed.
  ///
  /// If the access token is expired, this method will automatically
  /// refresh the access token and retry the request. If the refresh
  /// token is also expired, the user will be logged out.
  ///
  /// You should use this method for all API requests that require
  /// authentication.
  static Future<ApiResponse<T>> reqWithAuthCheck<T>(
    Future<ApiResponse<T>> Function(String authHeader) request,
  ) async {
    if (authHeader == null) {
      await logout();
      return ApiResponse(status: ResponseStatus.unauthorized);
    }

    final response = await request(authHeader!);

    if (response.status == ResponseStatus.unauthorized) {
      final refreshResponse = await refreshAccessToken();

      if (refreshResponse.status == ResponseStatus.created) {
        return await request(authHeader!);
      }

      await logout();
      return ApiResponse(status: ResponseStatus.unauthorized);
    }

    return response;
  }
}
