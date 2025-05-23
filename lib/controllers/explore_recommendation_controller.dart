import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/book_category_type.dart";
import "package:bookfinder_app/models/bookdata_models.dart";
import "package:bookfinder_app/services/api/api_service_provider.dart";
import "package:bookfinder_app/services/logging/logging_service_provider.dart";
import "package:bookfinder_app/utils/auth_utils.dart";

class ExploreRecommendationController {
  ExploreRecommendationController() {
    _recommendationFetchFuture = _fetchNewRecommendations();
  }

  BookCategory? _selectedCategory;

  final List<BookRecommendation> _recommendations = [];

  bool _fetchOngoing = false;
  late Future<bool> _recommendationFetchFuture;

  BookCategory? get selectedCategory => _selectedCategory;

  Future<bool> _fetchNewRecommendations() async {
    if (_fetchOngoing) {
      return _recommendationFetchFuture;
    }

    _fetchOngoing = true;

    try {
      final result = await withAuth(
        (authHeader) => ApiServiceProvider.i.recommendations.getRecommendations(
          categoryFilter: _selectedCategory,
          authHeader: authHeader,
        ),
      );

      if (result.status != ResponseStatus.ok) {
        LoggingServiceProvider.i.error(
          "Failed to fetch recommendations: ${result.status}",
        );

        return false;
      }

      assert(
        result.data != null,
        "Recommendation response must not be null after successful fetch",
      );

      _recommendations.addAll(result.data!);
      return true;
    } finally {
      _fetchOngoing = false;
    }
  }

  Future<bool> forceFetchNewRecommendations([BookCategory? newFilter]) async {
    _selectedCategory = newFilter;
    _recommendations.clear();

    _recommendationFetchFuture = _fetchNewRecommendations();
    return _recommendationFetchFuture;
  }

  Future<BookRecommendation?> getNextRecommendation() async {
    if (_recommendations.isEmpty) {
      if (!_fetchOngoing) {
        _recommendationFetchFuture = _fetchNewRecommendations();
      }

      final isFetchSuccessful = await _recommendationFetchFuture;

      if (!isFetchSuccessful) {
        return null;
      }
    }

    if (_recommendations.isEmpty) {
      LoggingServiceProvider.i.error(
        "Recommendation fetch returned no recommendations",
      );

      return null;
    }

    final recommendation = _recommendations.removeAt(0);

    if (_recommendations.length < 5 && !_fetchOngoing) {
      _recommendationFetchFuture = _fetchNewRecommendations();
    }

    return recommendation;
  }
}
