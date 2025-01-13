import "package:bookfinder_app/interfaces/api/api_users_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/user_models.dart";
import "package:bookfinder_app/utils/convert_utils.dart";
import "package:dio/dio.dart";

class DioApiUsersSubservice implements ApiUsersSubservice {
  final Dio _dio;

  DioApiUsersSubservice(this._dio);

  @override
  Future<ApiResponse<User>> getUser(
    String? userId, {
    required String authHeader,
  }) async {
    final String queryUserId = userId ?? "me";

    try {
      final response = await _dio.get(
        "/users/$queryUserId",
        options: Options(headers: {"Authorization": authHeader}),
      );

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        return ApiResponse(data: user, status: ResponseStatus.ok);
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      rethrow;
    }
  }

  @override
  Future<ApiResponse<void>> followUser(
    String userId, {
    required String authHeader,
  }) async {
    try {
      final response = await _dio.post(
        "/followingUsers",
        data: {"userId": userId},
        options: Options(headers: {"Authorization": authHeader}),
      );

      if (response.statusCode == 200) {
        return ApiResponse(status: ResponseStatus.ok);
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      rethrow;
    }
  }

  @override
  Future<ApiResponse<void>> unfollowUser(
    String userId, {
    required String authHeader,
  }) async {
    try {
      final response = await _dio.delete(
        "/followingUsers",
        data: {"userId": userId},
        options: Options(headers: {"Authorization": authHeader}),
      );

      if (response.statusCode == 200) {
        return ApiResponse(status: ResponseStatus.ok);
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkFollowStatus(
    String userId, {
    required String authHeader,
  }) async {
    try {
      final response = await _dio.get(
        "/followStatus/$userId",
        options: Options(headers: {"Authorization": authHeader}),
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          status: ResponseStatus.ok,
          data: response.data["isFollowing"],
        );
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      rethrow;
    }
  }
}
