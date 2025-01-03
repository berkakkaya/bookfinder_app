import "package:bookfinder_app/exceptions/api_error_handling.dart";
import "package:bookfinder_app/interfaces/api/api_service.dart";
import "package:bookfinder_app/models/token_pair.dart";
import "package:bookfinder_app/services/api/dio_imp/api_service.dart";

class ApiServiceProvider {
  static ApiService? _apiServiceInstance;

  /// Initializes the API service provider with `dio` implementation.
  ///
  /// Throws [ApiUnreachableException] if the API is unreachable.
  static Future<void> initDio({
    required Uri baseUri,
    required TokenPair? tokens,
  }) async {
    try {
      _apiServiceInstance = await DioApiService.createInstance(
        baseUri: baseUri,
        tokens: tokens,
      );
    } on ApiUnreachableException {
      // Rethrow the exception to the caller, as it is a critical error
      // and should not be handled here.
      rethrow;
    }
  }

  /// Returns the API service instance.
  ///
  /// NOTE: Make sure to call [initDio] before calling this method.
  static ApiService get i {
    assert(
      _apiServiceInstance != null,
      "API service must be initialized before use",
    );

    return _apiServiceInstance!;
  }
}
