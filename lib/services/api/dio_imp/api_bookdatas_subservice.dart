import "package:bookfinder_app/interfaces/api/api_bookdatas_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/bookdata_models.dart";
import "package:bookfinder_app/utils/api_utils.dart";
import "package:dio/dio.dart";

class DioApiBookdatasSubservice implements ApiBookdatasSubservice {
  final Dio _dio;

  DioApiBookdatasSubservice(this._dio);

  @override
  Future<ApiResponse<List<BookSearchResult>>> searchBooks(
    String query, {
    required String authHeader,
  }) async {
    try {
      final response = await _dio.get(
        "/bookSearch",
        queryParameters: {"q": query},
        options: Options(headers: {"Authorization": authHeader}),
      );

      if (response.statusCode == 200) {
        final searchResults = BookSearchResult.fromJsonList(
          response.data["searchResults"],
        );
        return ApiResponse(data: searchResults, status: ResponseStatus.ok);
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      rethrow;
    }
  }

  @override
  Future<ApiResponse<BookData>> getBookData(
    String bookId, {
    required String authHeader,
  }) async {
    try {
      final response = await _dio.get(
        "/books/$bookId",
        options: Options(headers: {"Authorization": authHeader}),
      );

      if (response.statusCode == 200) {
        final data = BookData.fromJson(response.data);
        return ApiResponse(data: data, status: ResponseStatus.ok);
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      rethrow;
    }
  }
}
