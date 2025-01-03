import "package:bookfinder_app/interfaces/logging/logging_service.dart";
import "package:bookfinder_app/services/logging/talker_imp/talker_logging_service.dart";
import "package:dio/dio.dart";
import "package:talker_dio_logger/talker_dio_logger.dart";
import "package:talker_flutter/talker_flutter.dart";

class LoggingServiceProvider {
  static LoggingService? _instance;

  static void initTalker() {
    final talker = TalkerFlutter.init();
    _instance = TalkerLoggingService(talker);
  }

  static LoggingService get instance {
    assert(_instance != null, "Logging service provider is not initialized");

    return _instance!;
  }

  static Interceptor? get dioInterceptor {
    if (instance is TalkerLoggingService) {
      return TalkerDioLogger(
        talker: (instance as TalkerLoggingService).talker,
      );
    }

    return null;
  }
}
