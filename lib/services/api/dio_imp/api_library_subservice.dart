import "package:bookfinder_app/interfaces/api/api_library_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/library_models.dart";
import "package:bookfinder_app/utils/convert_utils.dart";
import "package:dio/dio.dart";

class DioApiLibrarySubservice implements ApiLibrarySubservice {
  final Dio _dio;

  DioApiLibrarySubservice(this._dio);

  @override
  Future<ApiResponse<List<(BookListItem, bool)>>> fetchListContainStatusOfBook(
    String bookId, {
    required String authHeader,
  }) async {
    try {
      final response = await _dio.get(
        "/libraries/containData/$bookId",
        options: Options(
          headers: {
            "Authorization": authHeader,
          },
        ),
      );

      if (response.statusCode == 200) {
        final bookLists = (response.data["datas"] as List)
            .map((entry) => (
                  BookListItem.fromJson(entry),
                  entry["containsBook"] as bool,
                ))
            .toList();

        return ApiResponse(
          status: ResponseStatus.ok,
          data: bookLists,
        );
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      // Uncovered error occurred, rethrow it
      rethrow;
    }
  }

  @override
  Future<ApiResponse<void>> createBookList({
    required String title,
    required bool isPrivate,
    required String authHeader,
  }) async {
    try {
      final response = await _dio.post(
        "/libraries",
        data: {
          "title": title,
          "isPrivate": isPrivate,
        },
        options: Options(
          headers: {
            "Authorization": authHeader,
          },
        ),
      );

      if (response.statusCode == 201) {
        return ApiResponse(status: ResponseStatus.created);
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      // Uncovered error occurred, rethrow it
      rethrow;
    }
  }

  @override
  Future<ApiResponse<void>> deleteBookList(
    String bookListId, {
    required String authHeader,
  }) async {
    try {
      final response = await _dio.delete(
        "/libraries/$bookListId",
        options: Options(
          headers: {
            "Authorization": authHeader,
          },
        ),
      );

      if (response.statusCode == 200) {
        return ApiResponse(status: ResponseStatus.ok);
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      // Uncovered error occurred, rethrow it
      rethrow;
    }
  }

  @override
  Future<ApiResponse<BookListItemWithBooks>> getBookList(
    String bookListId, {
    required String authHeader,
  }) async {
    try {
      final response = await _dio.get(
        "/libraries/$bookListId",
        options: Options(
          headers: {
            "Authorization": authHeader,
          },
        ),
      );

      if (response.statusCode == 200) {
        final bookList = BookListItemWithBooks.fromJson(response.data);

        return ApiResponse(
          status: ResponseStatus.ok,
          data: bookList,
        );
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      // Uncovered error occurred, rethrow it
      rethrow;
    }
  }

  @override
  Future<ApiResponse<List<BookListItem>>> getBookLists({
    String? targetUserId,
    required String authHeader,
  }) async {
    try {
      final response = await _dio.get(
        "/libraries",
        queryParameters: {
          if (targetUserId != null) "userId": targetUserId,
        },
        options: Options(
          headers: {
            "Authorization": authHeader,
          },
        ),
      );

      if (response.statusCode == 200) {
        final bookLists = (response.data as List)
            .map((entry) => BookListItem.fromJson(entry))
            .toList();

        return ApiResponse(
          status: ResponseStatus.ok,
          data: bookLists,
        );
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      // Uncovered error occurred, rethrow it
      rethrow;
    }
  }

  @override
  Future<ApiResponse<void>> updateBookList(
    String bookListId, {
    required String title,
    required bool isPrivate,
    required String authHeader,
  }) async {
    try {
      final response = await _dio.patch(
        "/libraries/$bookListId",
        data: {
          "title": title,
          "isPrivate": isPrivate,
        },
        options: Options(
          headers: {
            "Authorization": authHeader,
          },
        ),
      );

      if (response.statusCode == 200) {
        return ApiResponse(status: ResponseStatus.ok);
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      // Uncovered error occurred, rethrow it
      rethrow;
    }
  }

  @override
  Future<ApiResponse<void>> addBookToList(
    String bookListId, {
    required String bookId,
    required String authHeader,
  }) async {
    try {
      final response = await _dio.post(
        "/libraries/$bookListId/books",
        data: {
          "bookId": bookId,
        },
        options: Options(
          headers: {
            "Authorization": authHeader,
          },
        ),
      );

      if (response.statusCode == 200) {
        return ApiResponse(status: ResponseStatus.ok);
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      // Uncovered error occurred, rethrow it
      rethrow;
    }
  }

  @override
  Future<ApiResponse<void>> removeBookFromList(
    String bookListId, {
    required String bookId,
    required String authHeader,
  }) async {
    try {
      final response = await _dio.delete(
        "/libraries/$bookListId/books",
        data: {
          "bookId": bookId,
        },
        options: Options(
          headers: {
            "Authorization": authHeader,
          },
        ),
      );

      if (response.statusCode == 200) {
        return ApiResponse(status: ResponseStatus.ok);
      }

      return ApiResponse(status: ResponseStatus.unknownError);
    } on DioException catch (e) {
      final responseType = parseResponseStatus(e.response?.statusCode);

      if (responseType != null) {
        return ApiResponse(status: responseType);
      }

      // Uncovered error occurred, rethrow it
      rethrow;
    }
  }
}
