import "package:bookfinder_app/exceptions/service_provider_error_handling.dart";
import "package:bookfinder_app/interfaces/logging/logging_service.dart";
import "package:bookfinder_app/services/logging/talker_imp/talker_logging_service.dart";
import "package:dio/dio.dart";
import "package:flutter/widgets.dart";
import "package:talker_dio_logger/talker_dio_logger.dart";
import "package:talker_flutter/talker_flutter.dart";

enum LoggingServiceImplementation {
  talker,
  notInitialized,
}

/// Service provider for the logging service. It provides the logging service
/// instance and the Dio interceptor for the current implementation.
///
/// This service should be initialized before initialization of any other
/// service that depends on logging.
class LoggingServiceProvider {
  static LoggingService? _instance;

  /// Currently used implementation type of the logging service provider.
  static LoggingServiceImplementation get implementationType {
    if (_instance is TalkerLoggingService) {
      return LoggingServiceImplementation.talker;
    }

    assert(
      _instance == null,
      "Looks like there is an unknown implementation type that is not added to "
      "the LoggingServiceImplementation enum. Make sure to cover all the cases.",
    );

    return LoggingServiceImplementation.notInitialized;
  }

  /// Initializes the logging service provider with the Talker implementation.
  static void initTalker() {
    if (_instance != null) {
      _instance!.warning(
        "Logging service provider is already initialized with the Talker "
        "implementation",
      );

      return;
    }

    final talker = TalkerFlutter.init();
    _instance = TalkerLoggingService(talker);

    _instance!.info("Logging service initialized with Talker implementation");
  }

  /// Instance of the logging service provider.
  ///
  /// Throws [ServiceProviderNotInitializedError] if the provider is not
  /// initialized.
  static LoggingService get i {
    if (_instance == null) {
      throw ServiceProviderNotInitializedError(
        providerName: "Logging Service Provider",
      );
    }

    return _instance!;
  }

  /// Dio interceptor for the current logging service implementation.
  ///
  /// Returns `null` if the interceptor is not available for the current
  /// implementation.
  static Interceptor? get dioInterceptor {
    if (i is TalkerLoggingService) {
      return TalkerDioLogger(
        talker: (i as TalkerLoggingService).talker,
        settings: TalkerDioLoggerSettings(
          responseFilter: (response) =>
              !response.requestOptions.path.contains("recommendation"),
        ),
      );
    }

    _instance?.warning(
      "Dio interceptor is not available for the current logging service "
      "implementation (${implementationType.name})",
    );

    return null;
  }

  static Widget? getDebugLogsScreen() {
    if (i is TalkerLoggingService) {
      return TalkerScreen(
        talker: (i as TalkerLoggingService).talker,
      );
    }

    _instance?.warning(
      "Debug logs screen is not available for the current logging service "
      "implementation (${implementationType.name})",
    );

    return null;
  }
}
