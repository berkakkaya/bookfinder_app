import "package:bookfinder_app/interfaces/logging/logging_service.dart";
import "package:talker/talker.dart";

class TalkerLoggingService implements LoggingService {
  final Talker talker;

  TalkerLoggingService(this.talker);

  @override
  void debug(
    String message, {
    Object? exception,
    StackTrace? stackTrace,
  }) {
    talker.debug(message, exception, stackTrace);
  }

  @override
  void error(
    String message, {
    Object? exception,
    StackTrace? stackTrace,
  }) {
    talker.error(message, exception, stackTrace);
  }

  @override
  void fatal(
    String message, {
    Object? exception,
    StackTrace? stackTrace,
  }) {
    talker.critical(message, exception, stackTrace);
  }

  @override
  void info(
    String message, {
    Object? exception,
    StackTrace? stackTrace,
  }) {
    talker.info(message, exception, stackTrace);
  }

  @override
  void warning(
    String message, {
    Object? exception,
    StackTrace? stackTrace,
  }) {
    talker.warning(message, exception, stackTrace);
  }
}
