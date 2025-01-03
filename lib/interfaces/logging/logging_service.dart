abstract class LoggingService {
  void debug(
    String message, {
    Object? exception,
    StackTrace? stackTrace,
  });

  void info(
    String message, {
    Object? exception,
    StackTrace? stackTrace,
  });

  void warning(
    String message, {
    Object? exception,
    StackTrace? stackTrace,
  });

  void error(
    String message, {
    Object? exception,
    StackTrace? stackTrace,
  });

  void fatal(
    String message, {
    Object? exception,
    StackTrace? stackTrace,
  });
}
