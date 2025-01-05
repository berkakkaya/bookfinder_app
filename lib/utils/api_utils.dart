import "package:bookfinder_app/models/api_response.dart";

ResponseStatus? parseResponseStatus(int? statusCode) {
  return switch (statusCode) {
    200 => ResponseStatus.ok,
    201 => ResponseStatus.created,
    204 => ResponseStatus.noContentOk,
    401 => ResponseStatus.unauthorized,
    403 => ResponseStatus.forbidden,
    404 => ResponseStatus.notFound,
    409 => ResponseStatus.conflict,
    500 => ResponseStatus.serverError,
    != null => ResponseStatus.unknownError,
    _ => null,
  };
}
