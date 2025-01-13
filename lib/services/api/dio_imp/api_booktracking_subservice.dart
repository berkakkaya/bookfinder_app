import "package:bookfinder_app/interfaces/api/api_booktracking_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/book_tracking_models.dart";
import "package:bookfinder_app/utils/convert_utils.dart";
import "package:dio/dio.dart";

class DioApiBooktrackingSubservice implements ApiBooktrackingSubservice {
  final Dio _dio;

  DioApiBooktrackingSubservice(this._dio);

  @override
  Future<ApiResponse<BookTrackingData>> getBookTrackingData(
    String bookId, {
    required String authHeader,
  }) async {
    try {
      final response = await _dio.get(
        "/bookTrackDatas",
        queryParameters: {
          "bookId": bookId,
        },
        options: Options(
          headers: {
            "Authorization": authHeader,
          },
        ),
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          status: ResponseStatus.ok,
          data: BookTrackingData.fromJson(response.data["data"]),
        );
      }

      return ApiResponse(status: ResponseStatus.notFound);
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
  Future<ApiResponse<BookTrackingDataWithBookDatas>> getBookTrackingDatas({
    required String authHeader,
  }) async {
    try {
      final response = await _dio.get(
        "/bookTrackDatas",
        options: Options(
          headers: {
            "Authorization": authHeader,
          },
        ),
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          status: ResponseStatus.ok,
          data: (response.data["datas"] as List<dynamic>)
              .map((json) => BookTrackingDataWithBookData.fromJson(json))
              .toList(),
        );
      }

      return ApiResponse(status: ResponseStatus.notFound);
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
  Future<ApiResponse<void>> removeBookTrackingData(
    String bookId, {
    required String authHeader,
  }) {
    return _updateBookTrackingData(
      bookId: bookId,
      status: null,
      authHeader: authHeader,
    );
  }

  @override
  Future<ApiResponse<void>> updateBookTrackingData({
    required String bookId,
    required BookTrackingStatus status,
    required String authHeader,
  }) {
    return _updateBookTrackingData(
      bookId: bookId,
      status: status,
      authHeader: authHeader,
    );
  }

  Future<ApiResponse<void>> _updateBookTrackingData({
    required String bookId,
    required BookTrackingStatus? status,
    required String authHeader,
  }) async {
    final Map<String, dynamic> data = status == null
        ? {"bookId": bookId}
        : {
            "bookId": bookId,
            "status": status.name,
          };

    try {
      final response = await _dio.patch(
        "/bookTrackDatas",
        data: data,
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
