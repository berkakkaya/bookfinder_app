import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/services/api/base_api_service.dart";
import "package:dio/dio.dart";

typedef SearchResults = List<Map<String, dynamic>>;
typedef BookData = Map<String, dynamic>;

class ApiBookdatasSubservice {
  static Future<ApiResponse<SearchResults>> searchBooks(
    String query, {
    required String authHeader,
  }) async {
    final dio = BaseApiService.dio;

    try {
      final response = await dio.get(
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

  static Future<ApiResponse<BookData>> getBookData(
    String bookId, {
    required String authHeader,
  }) async {
    final dio = BaseApiService.dio;

    try {
      final response = await dio.get(
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
