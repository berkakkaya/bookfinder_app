enum ResponseStatus {
  ok,
  created,
  noContentOk,
  badRequest,
  notFound,
  unauthorized,
  forbidden,
  conflict,
  serverError,
  unknownError,
}

/// Represents a response from the API. Response status is represented
/// by [ResponseStatus] and the data is represented by [data]. By changing
/// the type of [data], this class can be used to represent different types
/// of API responses.
///
/// Please note that the [data] field can be null. This is because some
/// API responses may not have any data to return. Consult the API
/// documentation to determine if the API response will have data.
class ApiResponse<T> {
  /// Status of the API response
  final ResponseStatus status;

  /// Data returned by the API
  final T? data;

  const ApiResponse({
    required this.status,
    this.data,
  });
}
