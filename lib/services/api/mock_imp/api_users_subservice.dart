import "package:bookfinder_app/extensions/lists.dart";
import "package:bookfinder_app/interfaces/api/api_users_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/user_models.dart";
import "package:bookfinder_app/services/api/mock_imp/mock_api_db.dart";

class MockApiUsersSubservice implements ApiUsersSubservice {
  final MockApiDb _db;

  MockApiUsersSubservice(this._db);

  @override
  Future<ApiResponse<User>> getUser(
    String? userId, {
    required String authHeader,
  }) {
    // Auth header is in the format: "Bearer access <token>"
    // In mock implementation, the <token> is the userId
    userId ??= authHeader.split(" ")[2];

    final foundUser = _db.mockUsers.firstWhereOrNull(
      (u) => u.userId == userId,
    );

    if (foundUser == null) {
      return Future.value(ApiResponse(
        status: ResponseStatus.notFound,
      ));
    }

    return Future.value(ApiResponse(
      status: ResponseStatus.ok,
      data: foundUser,
    ));
  }
}
