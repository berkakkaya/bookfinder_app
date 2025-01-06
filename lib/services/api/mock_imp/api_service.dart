import "package:bookfinder_app/interfaces/api/api_service.dart";
import "package:bookfinder_app/services/api/mock_imp/api_auth_subservice.dart";
import "package:bookfinder_app/services/api/mock_imp/api_bookdatas_subservice.dart";
import "package:bookfinder_app/services/api/mock_imp/api_booktracking_subservice.dart";
import "package:bookfinder_app/services/api/mock_imp/api_recommendations_subservice.dart";
import "package:bookfinder_app/services/api/mock_imp/api_users_subservice.dart";
import "package:bookfinder_app/services/api/mock_imp/mock_api_db.dart";

class MockApiService implements ApiService {
  final MockApiDb db;

  final MockApiAuthSubservice _authSubservice;
  final MockApiUsersSubservice _usersSubservice;
  final MockApiBookdatasSubservice _bookdatasSubservice;
  final MockApiRecommendationsSubservice _recommendationsSubservice;
  final MockApiBooktrackingSubservice _booktrackingSubservice;

  MockApiService(this.db)
      : _authSubservice = MockApiAuthSubservice(db),
        _usersSubservice = MockApiUsersSubservice(db),
        _bookdatasSubservice = MockApiBookdatasSubservice(db),
        _recommendationsSubservice = MockApiRecommendationsSubservice(db),
        _booktrackingSubservice = MockApiBooktrackingSubservice(db);

  @override
  MockApiAuthSubservice get auth => _authSubservice;

  @override
  MockApiUsersSubservice get users => _usersSubservice;

  @override
  MockApiBookdatasSubservice get bookDatas => _bookdatasSubservice;

  @override
  MockApiRecommendationsSubservice get recommendations =>
      _recommendationsSubservice;

  @override
  MockApiBooktrackingSubservice get bookTracking => _booktrackingSubservice;

  @override
  Future<bool> checkApiHealth() {
    return Future.value(true);
  }
}
