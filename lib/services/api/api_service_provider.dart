import "package:bookfinder_app/exceptions/api_error_handling.dart";
import "package:bookfinder_app/exceptions/service_provider_error_handling.dart";
import "package:bookfinder_app/interfaces/api/api_service.dart";
import "package:bookfinder_app/models/token_pair.dart";
import "package:bookfinder_app/services/api/dio_imp/api_service.dart";
import "package:bookfinder_app/services/api/mock_imp/api_service.dart";
import "package:bookfinder_app/services/api/mock_imp/mock_api_db.dart";
import "package:bookfinder_app/services/logging/logging_service_provider.dart";
import "package:dio/dio.dart";

enum ApiServiceImplementation {
  dio,
  mock,
  notInitialized,
}

class ApiServiceProvider {
  static ApiService? _apiServiceInstance;

  /// Returns the implementation type of the API service provider.
  static ApiServiceImplementation get implementationType {
    if (_apiServiceInstance is DioApiService) {
      return ApiServiceImplementation.dio;
    }

    if (_apiServiceInstance is MockApiService) {
      return ApiServiceImplementation.mock;
    }

    assert(
      _apiServiceInstance == null,
      "Looks like there is an unknown implementation type that is not added to "
      "the ApiServiceImplementation enum. Make sure to cover all the cases.",
    );

    return ApiServiceImplementation.notInitialized;
  }

  /// Initializes the API service provider with `dio` implementation.
  ///
  /// Throws [ApiUnreachableException] if the API is unreachable.
  static Future<void> initDio({
    required Uri baseUri,
    required TokenPair? tokens,
    List<Interceptor>? interceptors,
  }) async {
    if (_apiServiceInstance != null) {
      LoggingServiceProvider.instance.warning(
        "API service provider was already initialized, reinitializing with Dio "
        "implementation...",
      );
    }

    try {
      _apiServiceInstance = await DioApiService.createInstance(
        baseUri: baseUri,
        tokens: tokens,
        interceptors: interceptors,
      );

      LoggingServiceProvider.instance.info(
        "API service provider initialized with Dio implementation",
      );
    } on ApiUnreachableException catch (e, st) {
      LoggingServiceProvider.instance.error(
        "API service provider initialization with Dio implementation failed "
        "because the URI (${baseUri.toString()}) is unreachable",
        exception: e,
        stackTrace: st,
      );

      // Rethrow the exception to the caller, as it is a critical error
      // and should not be handled here.
      rethrow;
    }
  }

  static void initMock() {
    if (_apiServiceInstance != null) {
      LoggingServiceProvider.instance.warning(
        "API service provider was already initialized, reinitializing with "
        "mock implementation...",
      );
    }

    _apiServiceInstance = MockApiService(MockApiDb());

    LoggingServiceProvider.instance.info(
      "API service provider initialized with mock implementation",
    );
  }

  /// Returns the API service instance.
  ///
  /// NOTE: Make sure to call [initDio] before calling this method.
  static ApiService get i {
    if (_apiServiceInstance == null) {
      LoggingServiceProvider.instance.fatal(
        "API service provider must be initialized before getting the service "
        "instance!",
      );

      throw ServiceProviderNotInitializedError(
        providerName: "API Service Provider",
      );
    }

    return _apiServiceInstance!;
  }
}
