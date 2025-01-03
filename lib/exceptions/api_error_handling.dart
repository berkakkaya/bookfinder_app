class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() {
    return message;
  }
}

/// Exception thrown when the API is unreachable.
///
/// This exception is thrown when the API is not reachable. This can be
/// due to a network error, or the API being down.
///
/// NOTE: Throwers of this exception should provide a message explaining why
/// the API is unreachable. Also a logger should be used to log the error
/// before throwing this exception.
class ApiUnreachableException extends ApiException {
  ApiUnreachableException(super.message);
}
