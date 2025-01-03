import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/token_pair.dart";

abstract class ApiAuthSubservice {
  /// Returns the current token pair state.
  TokenPair? get tokenPairState;

  /// Sets the token pair state to [tokenPair].
  ///
  /// This method is used to set the token pair state when the app is
  /// initialized with the token pair. In other situations, it is not
  /// recommended to use this method to update the token pair state.
  /// Use [login], [register], [refreshAccessToken] or [logout] methods
  /// to update the token pair state.
  void setTokenPair(TokenPair tokenPair);

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
