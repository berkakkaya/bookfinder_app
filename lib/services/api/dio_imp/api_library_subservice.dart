import "package:bookfinder_app/interfaces/api/api_library_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/library_models.dart";
import "package:dio/dio.dart";

class DioApiLibrarySubservice implements ApiLibrarySubservice {
  final Dio _dio;

  DioApiLibrarySubservice(this._dio);

  @override
  Future<ApiResponse<List<(BookListItem, bool)>>> fetchListContainStatusOfBook(
    String bookId, {
    required String authHeader,
  }) {
    // TODO: implement fetchListContainStatusOfBook
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<void>> createBookList({
    required String title,
    required bool isPrivate,
    required String authHeader,
  }) {
    // TODO: implement createBookList
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<void>> deleteBookList(
    String bookListId, {
    required String authHeader,
  }) {
    // TODO: implement deleteBookList
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<BookListItemWithBooks>> getBookList(
    String bookListId, {
    required String authHeader,
  }) {
    // TODO: implement getBookList
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<List<BookListItem>>> getBookLists({
    String? targetUserId,
    required String authHeader,
  }) {
    // TODO: implement getBookLists
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<void>> updateBookList(
    String bookListId, {
    required String title,
    required bool isPrivate,
    required String authHeader,
  }) {
    // TODO: implement updateBookList
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<void>> addBookToList(
    String bookListId, {
    required String bookId,
    required String authHeader,
  }) {
    // TODO: implement addBookToList
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<void>> removeBookFromList(
    String bookListId, {
    required String bookId,
    required String authHeader,
  }) {
    // TODO: implement removeBookFromList
    throw UnimplementedError();
  }
}
