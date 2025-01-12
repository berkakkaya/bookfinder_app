import "package:bookfinder_app/interfaces/api/api_feed_subservice.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/feed_models.dart";
import "package:bookfinder_app/models/mock_datamodels.dart";
import "package:bookfinder_app/services/api/mock_imp/mock_api_db.dart";

class MockApiFeedSubservice extends ApiFeedSubservice {
  final MockApiDb _db;

  MockApiFeedSubservice(this._db);

  @override
  Future<ApiResponse<List<BaseFeedEntry>>> getFeedEntries({
    bool fetchUpdatesFromOthers = false,
    required String authHeader,
  }) {
    final String userId = authHeader.split(" ").last;
    final MockUser user = _db.mockUsers.firstWhere((u) => u.userId == userId);

    final feedEntries = _db.mockFeedEntries.where((feed) {
      if (fetchUpdatesFromOthers) return true;

      return user.followedUsers.contains(feed.issuerUserId);
    }).toList();

    return Future.value(ApiResponse(
      status: ResponseStatus.ok,
      data: feedEntries,
    ));
  }
}
