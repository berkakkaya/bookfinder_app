import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/services/api/dio_imp/api_bookdatas_subservice.dart";

abstract class ApiBookdatasSubservice {
  Future<ApiResponse<SearchResults>> searchBooks(
    String query, {
    required String authHeader,
  });

  Future<ApiResponse<BookData>> getBookData(
    String bookId, {
    required String authHeader,
  });
}
