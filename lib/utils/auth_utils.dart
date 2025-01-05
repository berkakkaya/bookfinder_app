/// Utils for managing authentication with more ease.
///
/// Functions inside this library can be used to manage
/// authentication in a more efficient way. This includes
/// functions to sign in, sign out, doing API request
/// with authentication check, etc.
///
/// This library does API request and manages preference
/// service recors if needed.
library;

import "package:bookfinder_app/consts/navigator_key.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/token_pair.dart";
import "package:bookfinder_app/screens/authentication/welcome_screen.dart";
import "package:bookfinder_app/services/api/api_service_provider.dart";
import "package:bookfinder_app/services/preferences/preference_service_provider.dart";
import "package:flutter/material.dart";

/// Logs in the user with given [email] and [password].
///
/// This method wraps the API request and preference service record
/// management for logging in a user. It will automatically save
/// the token pair to the preference service if the login is successful.
Future<ApiResponse<void>> login({
  required String email,
  required String password,
}) async {
  final response = await ApiServiceProvider.i.auth.login(email, password);

  if (response.status == ResponseStatus.ok) {
    assert(response.data != null, "Token pair must not be null");

    await PreferenceServiceProvider.i.setTokens(response.data!);
  }

  return response;
}

/// Registers a new user with given [nameSurname], [email] and [password].
///
/// This method wraps the API request and preference service record
/// management for registering a new user. It will automatically
/// save the token pair to the preference service if the registration
/// is successful.
Future<ApiResponse<void>> register({
  required String nameSurname,
  required String email,
  required String password,
}) async {
  final response = await ApiServiceProvider.i.auth.register(
    nameSurname: nameSurname,
    email: email,
    password: password,
  );

  if (response.status == ResponseStatus.created) {
    assert(response.data != null, "Token pair must not be null");

    await PreferenceServiceProvider.i.setTokens(response.data!);
  }

  return response;
}

/// Logs out the user and clears the tokens from the
/// preference service.
///
/// This method, by default, will automatically route the user
/// to the welcome screen. You can disable this behavior by
/// setting [autoRoute] to `false`.
Future<void> logout({
  bool autoRoute = true,
}) async {
  // Clear the tokens from the preference service and log out
  await PreferenceServiceProvider.i.setTokens(null);
  await ApiServiceProvider.i.auth.logout();

  // Route the user to the welcome screen if `autoRoute` is true
  if (autoRoute) {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const WelcomeScreen(),
      ),
      (_) => false,
    );
  }
}

/// Executes an API request with given [action] and
/// automatically handles authentication.
///
/// If the access token is expired, this method will automatically
/// refresh the access token and retry the request. If the refresh
/// token is also expired, the user will be logged out.
///
/// This method, by default, will automatically route the user
/// to the welcome screen if the user is unauthorized. You can
/// disable this behavior by setting [autoRouteIfUnauthorized]
/// to `false`.
///
/// You should use this method for all API requests that require
/// authentication.
Future<ApiResponse<T>> withAuth<T>(
  Future<ApiResponse<T>> Function(String authHeader) action, {
  autoRouteIfUnauthorized = true,
}) async {
  final TokenPair? initialTokens = ApiServiceProvider.i.auth.tokenPairState;

  if (initialTokens == null) {
    // No token pair found, logout the user
    await logout(autoRoute: autoRouteIfUnauthorized);

    return ApiResponse(status: ResponseStatus.unauthorized);
  }

  // Try to do the action with the initial token pair
  ApiResponse<T> response = await action(
    "Bearer ${initialTokens.accessToken}",
  );

  if (response.status != ResponseStatus.unauthorized) {
    // If no authorization error happened, return the response as is
    return response;
  }

  // Try to refresh the access token
  final tokenRefreshResponse =
      await ApiServiceProvider.i.auth.refreshAccessToken();

  if (tokenRefreshResponse.status != ResponseStatus.created) {
    // Token could not be refreshed, logout the user
    await logout(autoRoute: autoRouteIfUnauthorized);

    return ApiResponse(status: ResponseStatus.unauthorized);
  }

  // Try to do the action again
  response = await action(
      "Bearer ${ApiServiceProvider.i.auth.tokenPairState!.accessToken}");

  if (response.status == ResponseStatus.unauthorized) {
    // Logout the user if the action still unauthorized
    await logout(autoRoute: autoRouteIfUnauthorized);

    return response;
  }

  // Save the new token pair if the action is successful
  await PreferenceServiceProvider.i.setTokens(
    ApiServiceProvider.i.auth.tokenPairState!,
  );
  return response;
}
