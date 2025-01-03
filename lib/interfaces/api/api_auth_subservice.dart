import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/token_pair.dart";

abstract class ApiAuthSubservice {
  /// Returns the current token pair state.
  TokenPair? get tokenPairState;

  /// Logs in the user with given [email] and [password].
  ///
  /// Returns the token pair if the login is successful.
  ///
  /// Possible response types are:
  /// - [ResponseStatus.ok]: Login successful.
  /// - [ResponseStatus.unauthorized]: Invalid credentials.
  /// - [ResponseStatus.serverError]: Server error occurred.
  /// - [ResponseStatus.unknownError]: Unknown error occurred.
  Future<ApiResponse<TokenPair>> login(String email, String password);

  /// Registers a new user with given [nameSurname], [email] and [password].
  ///
  /// Returns the token pair if the registration is successful.
  ///
  /// Possible response types are:
  /// - [ResponseStatus.created]: Registration successful.
  /// - [ResponseStatus.conflict]: Email is already in use.
  /// - [ResponseStatus.serverError]: Server error occurred.
  /// - [ResponseStatus.unknownError]: Unknown error occurred.
  Future<ApiResponse<TokenPair>> register({
    required String nameSurname,
    required String email,
    required String password,
  });

  /// Refreshes the access token with the refresh token.
  ///
  /// Returns the new token pair if the refresh is successful.
  ///
  /// Possible response types are:
  /// - [ResponseStatus.created]: Refresh successful.
  /// - [ResponseStatus.unauthorized]: Invalid refresh token.
  /// - [ResponseStatus.serverError]: Server error occurred.
  /// - [ResponseStatus.unknownError]: Unknown error occurred.
  Future<ApiResponse<TokenPair>> refreshAccessToken();

  /// Logs out the user.
  Future<void> logout();
}
