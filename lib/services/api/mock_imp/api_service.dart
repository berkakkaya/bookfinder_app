import "package:bookfinder_app/interfaces/api/api_service.dart";
import "package:bookfinder_app/services/api/mock_imp/api_auth_subservice.dart";
import "package:bookfinder_app/services/api/mock_imp/api_bookdatas_subservice.dart";
import "package:bookfinder_app/services/api/mock_imp/api_recommendations_subservice.dart";
import "package:bookfinder_app/services/api/mock_imp/mock_api_db.dart";

class MockApiService implements ApiService {
  final MockApiDb db;

  final MockApiAuthSubservice _authSubservice;
  final MockApiBookdatasSubservice _bookdatasSubservice;
  final MockApiRecommendationsSubservice _recommendationsSubservice;

  MockApiService(this.db)
      : _authSubservice = MockApiAuthSubservice(db),
        _bookdatasSubservice = MockApiBookdatasSubservice(db),
        _recommendationsSubservice = MockApiRecommendationsSubservice(db);

  @override
  MockApiAuthSubservice get auth => _authSubservice;

  @override
  MockApiBookdatasSubservice get bookDatas => _bookdatasSubservice;

  @override
  MockApiRecommendationsSubservice get recommendations =>
      _recommendationsSubservice;

  @override
  Future<bool> checkApiHealth() {
    return Future.value(true);
  }
}
