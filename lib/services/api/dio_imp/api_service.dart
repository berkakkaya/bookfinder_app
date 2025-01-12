import "package:bookfinder_app/exceptions/api_error_handling.dart";
import "package:bookfinder_app/interfaces/api/api_service.dart";
import "package:bookfinder_app/models/token_pair.dart";
import "package:bookfinder_app/services/api/dio_imp/api_bookdatas_subservice.dart";
import "package:bookfinder_app/services/api/dio_imp/api_booktracking_subservice.dart";
import "package:bookfinder_app/services/api/dio_imp/api_feed_subservice.dart";
import "package:bookfinder_app/services/api/dio_imp/api_library_subservice.dart";
import "package:bookfinder_app/services/api/dio_imp/api_recommendations_subservice.dart";
import "package:bookfinder_app/services/api/dio_imp/api_auth_subservice.dart";
import "package:bookfinder_app/services/api/dio_imp/api_users_subservice.dart";
import "package:bookfinder_app/services/logging/logging_service_provider.dart";
import "package:dio/dio.dart";

class DioApiService extends ApiService {
  final Dio _dio;

  final DioApiBookdatasSubservice _bookDatasSubservice;
  final DioApiRecommendationsSubservice _recommendationsSubservice;
  final DioApiAuthSubservice _authSubservice;
  final DioApiUsersSubservice _usersSubservice;
  final DioApiBooktrackingSubservice _booktrackingSubservice;
  final DioApiLibrarySubservice _librarySubservice;
  final DioApiFeedSubservice _feedSubservice;

  @override
  DioApiBookdatasSubservice get bookDatas => _bookDatasSubservice;

  @override
  DioApiRecommendationsSubservice get recommendations =>
      _recommendationsSubservice;

  @override
  DioApiAuthSubservice get auth => _authSubservice;

  @override
  DioApiUsersSubservice get users => _usersSubservice;

  @override
  DioApiBooktrackingSubservice get bookTracking => _booktrackingSubservice;

  @override
  DioApiLibrarySubservice get library => _librarySubservice;

  @override
  DioApiFeedSubservice get feed => _feedSubservice;

  DioApiService._({
    required Dio dio,
    required TokenPair? tokens,
  })  : _dio = dio,
        _bookDatasSubservice = DioApiBookdatasSubservice(dio),
        _recommendationsSubservice = DioApiRecommendationsSubservice(dio),
        _authSubservice = DioApiAuthSubservice(dio, tokens: tokens),
        _usersSubservice = DioApiUsersSubservice(dio),
        _booktrackingSubservice = DioApiBooktrackingSubservice(dio),
        _librarySubservice = DioApiLibrarySubservice(dio),
        _feedSubservice = DioApiFeedSubservice(dio);

  static Future<DioApiService> createInstance({
    required Uri baseUri,
    required TokenPair? tokens,
    List<Interceptor>? interceptors,
  }) async {
    // Create a temporary Dio instance to test the base URI
    final tempDio = Dio(BaseOptions(
      baseUrl: baseUri.toString(),
      validateStatus: (status) => status != null && status < 400,
      sendTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      connectTimeout: Duration(seconds: 10),
    ));

    final isApiHealthy = await _checkHealthOfDio(tempDio);

    if (!isApiHealthy) {
      throw ApiUnreachableException("Cannot reach the API at $baseUri");
    }

    // Add the interceptors to the temporary Dio instance
    if (interceptors != null) {
      tempDio.interceptors.addAll(interceptors);
    }

    return DioApiService._(dio: tempDio, tokens: tokens);
  }

  @override
  Future<bool> checkApiHealth() async {
    return _checkHealthOfDio(_dio);
  }

  static Future<bool> _checkHealthOfDio(Dio dio) async {
    try {
      final response = await dio.get("/");

      if (response.statusCode == 200) {
        LoggingServiceProvider.i
            .info("API check has been completed successfully.");

        return true;
      }

      LoggingServiceProvider.i.warning(
        "API healthcheck failed. API returned status code ${response.statusCode}",
      );

      return false;
    } on DioException catch (e) {
      LoggingServiceProvider.i.warning(
        "API healthcheck failed.",
        exception: e,
        stackTrace: e.stackTrace,
      );

      return false;
    }
  }
}
