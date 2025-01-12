import "package:bookfinder_app/interfaces/api/api_feed_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/feed_models.dart";
import "package:dio/dio.dart";

class DioApiFeedSubservice extends ApiFeedSubservice {
  final Dio _dio;

  DioApiFeedSubservice(this._dio);

  @override
  Future<ApiResponse<List<BaseFeedEntry>>> getFeedEntries({
    bool fetchUpdatesFromOthers = false,
    required String authHeader,
  }) {
    // TODO: implement getFeedEntries
    throw UnimplementedError();
  }
}
