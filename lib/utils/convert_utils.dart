import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/bookdata_models.dart";

ResponseStatus? parseResponseStatus(int? statusCode) {
  return switch (statusCode) {
    200 => ResponseStatus.ok,
    201 => ResponseStatus.created,
    204 => ResponseStatus.noContentOk,
    400 => ResponseStatus.badRequest,
    401 => ResponseStatus.unauthorized,
    403 => ResponseStatus.forbidden,
    404 => ResponseStatus.notFound,
    409 => ResponseStatus.conflict,
    500 => ResponseStatus.serverError,
    != null => ResponseStatus.unknownError,
    _ => null,
  };
}

String convertIndustryIdentifierToString(IdentifierType type) {
  return switch (type) {
    IdentifierType.isbn10 => "ISBN-10",
    IdentifierType.isbn13 => "ISBN-13",
    IdentifierType.issn => "ISSN",
    IdentifierType.other => "Other",
  };
}

/// Generates a seed for given [input] string. This seed can be used for random
/// operations and it will always return the same value for the same input.
int generateSeedFromString(String input) {
  return input.codeUnits.fold(0, (prev, element) => prev + element);
}
