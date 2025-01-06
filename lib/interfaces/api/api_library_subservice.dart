import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/library_models.dart";

abstract class ApiLibrarySubservice {
  Future<ApiResponse<List<BookListItem>>> getBookLists({
    required String authHeader,
  });

  Future<ApiResponse<BookListItemWithBooks>> getBookList(
    String bookListId, {
    required String authHeader,
  });

  Future<ApiResponse<void>> createBookList({
    required String title,
    required bool isPrivate,
    required String authHeader,
  });

  Future<ApiResponse<void>> updateBookList(
    String bookListId, {
    required String title,
    required bool isPrivate,
    required String authHeader,
  });

  Future<ApiResponse<void>> deleteBookList(
    String bookListId, {
    required String authHeader,
  });

  Future<ApiResponse<void>> checkWhichListsContainBook(
    String bookId, {
    required String authHeader,
  });
}
