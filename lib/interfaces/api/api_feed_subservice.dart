import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/feed_models.dart";

abstract class ApiFeedSubservice {
  /// Fetches feed entries from the server.
  ///
  /// If [fetchUpdatesFromOthers] is set to true, the server will
  /// return the feed entries from other users that the current user
  /// isn't following too.
  Future<ApiResponse<List<BaseFeedEntry>>> getFeedEntries({
    bool fetchUpdatesFromOthers = false,
    required String authHeader,
  });
}
