import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/book_tracking_models.dart";

typedef BookTrackingDataWithBookDatas = List<BookTrackingDataWithBookData>;

abstract class ApiBooktrackingSubservice {
  Future<ApiResponse<BookTrackingDataWithBookDatas>> getBookTrackingDatas({
    required String authHeader,
  });

  Future<ApiResponse<BookTrackingData>> getBookTrackingData(
    String bookId, {
    required String authHeader,
  });

  Future<ApiResponse<void>> updateBookTrackingData({
    required String bookId,
    required BookTrackingStatus status,
    required String authHeader,
  });

  Future<ApiResponse<void>> removeBookTrackingData(
    String bookId, {
    required String authHeader,
  });
}
