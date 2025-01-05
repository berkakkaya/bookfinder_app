import "package:bookfinder_app/extensions/lists.dart";
import "package:bookfinder_app/interfaces/api/api_auth_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/mock_datamodels.dart";
import "package:bookfinder_app/models/token_pair.dart";
import "package:bookfinder_app/services/api/mock_imp/mock_api_db.dart";

class MockApiAuthSubservice implements ApiAuthSubservice {
  final MockApiDb _db;
  TokenPair? _tokenPair;

  MockApiAuthSubservice(MockApiDb db) : _db = db;

  @override
  void setTokenPair(TokenPair tokenPair) {
    _tokenPair = tokenPair;
  }

  @override
  TokenPair? get tokenPairState => _tokenPair;

  @override
  Future<ApiResponse<TokenPair>> login(String email, String password) {
    final MockUser? foundUser = _db.mockUsers.firstWhereOrNull(
      (u) => u.email == email,
    );

    if (foundUser == null) {
      return Future.value(ApiResponse(
        status: ResponseStatus.unauthorized,
      ));
    }

    if (foundUser.password != password) {
      return Future.value(ApiResponse(
        status: ResponseStatus.unauthorized,
      ));
    }

    _tokenPair = TokenPair(
      accessToken: "access ${foundUser.userId}",
      refreshToken: "refresh ${foundUser.userId}",
    );

    return Future.value(ApiResponse(
      status: ResponseStatus.ok,
      data: _tokenPair,
    ));
  }

  @override
  Future<ApiResponse<TokenPair>> register({
    required String nameSurname,
    required String email,
    required String password,
  }) {
    final MockUser? foundUser = _db.mockUsers.firstWhereOrNull(
      (u) => u.email == email,
    );

    if (foundUser != null) {
      return Future.value(ApiResponse(
        status: ResponseStatus.conflict,
      ));
    }

    final MockUser newUser = MockUser(
      userId: (_db.mockUsers.length + 1).toString(),
      nameSurname: nameSurname,
      email: email,
      password: password,
    );

    _db.mockUsers.add(newUser);

    _tokenPair = TokenPair(
      accessToken: "access ${newUser.userId}",
      refreshToken: "refresh ${newUser.userId}",
    );

    return Future.value(ApiResponse(
      status: ResponseStatus.created,
      data: _tokenPair,
    ));
  }

  @override
  Future<ApiResponse<TokenPair>> refreshAccessToken() {
    return Future.value(ApiResponse(
      status: ResponseStatus.created,
      data: _tokenPair,
    ));
  }

  @override
  Future<void> logout() {
    _tokenPair = null;

    return Future.value();
  }
}
