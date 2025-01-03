import "package:bookfinder_app/interfaces/api/api_bookdatas_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:dio/dio.dart";

typedef SearchResults = List<Map<String, dynamic>>;
typedef BookData = Map<String, dynamic>;

class DioApiBookdatasSubservice implements ApiBookdatasSubservice {
  final Dio _dio;

  DioApiBookdatasSubservice(this._dio);

  @override
  Future<ApiResponse<SearchResults>> searchBooks(
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
        final data = SearchResults.from(response.data);
        return ApiResponse(data: data, status: ResponseStatus.ok);
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return ApiResponse(status: ResponseStatus.notFound);
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
        final data = BookData.from(response.data);
        return ApiResponse(data: data, status: ResponseStatus.ok);
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return ApiResponse(status: ResponseStatus.notFound);
      }

      rethrow;
    }
  }
}
