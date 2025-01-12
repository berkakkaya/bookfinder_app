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
    userId ??= authHeader.split(" ").last;

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

  @override
  Future<ApiResponse<void>> followUser(
    String userId, {
    required String authHeader,
  }) {
    final requesterUserId = authHeader.split(" ").last;
    final requesterUser = _db.mockUsers.firstWhere(
      (u) => u.userId == requesterUserId,
    );

    final targetUser = _db.mockUsers.firstWhereOrNull(
      (u) => u.userId == userId,
    );

    if (targetUser == null) {
      return Future.value(ApiResponse(
        status: ResponseStatus.notFound,
      ));
    }

    requesterUser.followedUsers.add(userId);
    return Future.value(ApiResponse(
      status: ResponseStatus.ok,
    ));
  }

  @override
  Future<ApiResponse<void>> unfollowUser(
    String userId, {
    required String authHeader,
  }) {
    final requesterUserId = authHeader.split(" ").last;
    final requesterUser = _db.mockUsers.firstWhere(
      (u) => u.userId == requesterUserId,
    );

    final targetUser = _db.mockUsers.firstWhereOrNull(
      (u) => u.userId == userId,
    );

    if (targetUser == null) {
      return Future.value(ApiResponse(
        status: ResponseStatus.notFound,
      ));
    }

    requesterUser.followedUsers.remove(userId);
    return Future.value(ApiResponse(
      status: ResponseStatus.ok,
    ));
  }

  @override
  Future<ApiResponse<bool>> checkFollowStatus(
    String userId, {
    required String authHeader,
  }) {
    final requesterUserId = authHeader.split(" ").last;
    final requesterUser = _db.mockUsers.firstWhere(
      (u) => u.userId == requesterUserId,
    );

    final isFollowing = requesterUser.followedUsers.contains(userId);
    return Future.value(ApiResponse(
      status: ResponseStatus.ok,
      data: isFollowing,
    ));
  }
}
