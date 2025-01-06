import "package:bookfinder_app/interfaces/api/api_booktracking_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/book_tracking_models.dart";
import "package:dio/dio.dart";

class DioApiBooktrackingSubservice implements ApiBooktrackingSubservice {
  final Dio _dio;

  DioApiBooktrackingSubservice(this._dio);

  @override
  Future<ApiResponse<BookTrackingData>> getBookTrackingData(
    String bookId, {
    required String authHeader,
  }) {
    // TODO: implement getBookTrackingData
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<BookTrackingDataWithBookDatas>> getBookTrackingDatas({
    required String authHeader,
  }) {
    // TODO: implement getBookTrackingDatas
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<void>> removeBookTrackingData(
    String bookId, {
    required String authHeader,
  }) {
    // TODO: implement removeBookTrackingData
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<void>> updateBookTrackingData({
    required String bookId,
    required BookTrackingStatus status,
    required String authHeader,
  }) {
    // TODO: implement updateBookTrackingData
    throw UnimplementedError();
  }
}
