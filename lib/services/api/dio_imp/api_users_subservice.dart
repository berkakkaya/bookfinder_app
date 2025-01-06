import "package:bookfinder_app/interfaces/api/api_users_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/user_models.dart";
import "package:dio/dio.dart";

class DioApiUsersSubservice implements ApiUsersSubservice {
  final Dio _dio;

  DioApiUsersSubservice(this._dio);

  @override
  Future<ApiResponse<User>> getUser(String? userId,
      {required String authHeader}) {
    // TODO: implement getUser
    throw UnimplementedError();
  }
}
