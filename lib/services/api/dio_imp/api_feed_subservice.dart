import "package:bookfinder_app/interfaces/api/api_feed_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/feed_models.dart";
import "package:bookfinder_app/utils/convert_utils.dart";
import "package:dio/dio.dart";

class DioApiFeedSubservice extends ApiFeedSubservice {
  final Dio _dio;

  DioApiFeedSubservice(this._dio);

  @override
  Future<ApiResponse<List<BaseFeedEntry>>> getFeedEntries({
    bool fetchUpdatesFromOthers = false,
    required String authHeader,
  }) async {
    try {
      final response = await _dio.get(
        "/feed",
        queryParameters: {
          "getUpdatesFromOthers": fetchUpdatesFromOthers == true ? "1" : "0",
        },
        options: Options(
          headers: {
            "Authorization": authHeader,
          },
        ),
      );

      if (response.statusCode == 200) {
        final feedEntries = (response.data["feed"] as List)
            .map((entry) => BaseFeedEntry.fromJson(entry))
            .toList();

        return ApiResponse(
          status: ResponseStatus.ok,
          data: feedEntries,
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
}
