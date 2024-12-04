enum ResponseStatus {
  ok,
  created,
  noContentOk,
  notFound,
  unauthorized,
  forbidden,
  conflict,
  serverError,
  unknownError,
}

class ApiResponse<T> {
  final ResponseStatus status;
  final T? data;

  ApiResponse({
    required this.status,
    this.data,
  });
}
