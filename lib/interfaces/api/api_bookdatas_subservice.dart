import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/bookdata_models.dart";

abstract class ApiBookdatasSubservice {
  Future<ApiResponse<List<BookSearchResult>>> searchBooks(
    String query, {
    required String authHeader,
  });

  Future<ApiResponse<BookData>> getBookData(
    String bookId, {
    required String authHeader,
  });
}
