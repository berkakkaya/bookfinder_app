import "package:bookfinder_app/exceptions/api_error_handling.dart";
import "package:bookfinder_app/interfaces/api/api_auth_subservice.dart";
import "package:bookfinder_app/interfaces/api/api_bookdatas_subservice.dart";
import "package:bookfinder_app/interfaces/api/api_recommendations_subservice.dart";
import "package:bookfinder_app/interfaces/api/api_service.dart";
import "package:bookfinder_app/models/token_pair.dart";
import "package:bookfinder_app/services/api/dio_imp/api_bookdatas_subservice.dart";
import "package:bookfinder_app/services/api/dio_imp/api_recommendations_subservice.dart";
import "package:bookfinder_app/services/api/dio_imp/api_auth_subservice.dart";
import "package:bookfinder_app/services/logging/logging_service_provider.dart";
import "package:dio/dio.dart";

class DioApiService extends ApiService {
  final Dio _dio;

  final DioApiBookdatasSubservice _bookDatasSubservice;
  final DioApiRecommendationsSubservice _recommendationsSubservice;
  final DioApiAuthSubservice _authSubservice;

  @override
  ApiBookdatasSubservice get bookDatas => _bookDatasSubservice;
  @override
  ApiRecommendationsSubservice get recommendations =>
      _recommendationsSubservice;
  @override
  ApiAuthSubservice get auth => _authSubservice;

  DioApiService._({
    required Dio dio,
    required TokenPair? tokens,
  })  : _dio = dio,
        _bookDatasSubservice = DioApiBookdatasSubservice(dio),
        _recommendationsSubservice = DioApiRecommendationsSubservice(dio),
        _authSubservice = DioApiAuthSubservice(dio, tokens: tokens);

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
        LoggingServiceProvider.instance
            .info("API check has been completed successfully.");

        return true;
      }

      LoggingServiceProvider.instance.warning(
        "API healthcheck failed. API returned status code ${response.statusCode}",
      );

      return false;
    } on DioException catch (e) {
      LoggingServiceProvider.instance.warning(
        "API healthcheck failed.",
        exception: e,
        stackTrace: e.stackTrace,
      );

      return false;
    }
  }
}
