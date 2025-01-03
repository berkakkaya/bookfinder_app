import "package:bookfinder_app/exceptions/api_error_handling.dart";
import "package:bookfinder_app/interfaces/api/api_auth_subservice.dart";
import "package:bookfinder_app/interfaces/api/api_bookdatas_subservice.dart";
import "package:bookfinder_app/interfaces/api/api_recommendations_subservice.dart";
import "package:bookfinder_app/interfaces/api/api_service.dart";
import "package:bookfinder_app/models/token_pair.dart";
import "package:bookfinder_app/services/api/dio_imp/api_bookdatas_subservice.dart";
import "package:bookfinder_app/services/api/dio_imp/api_recommendations_subservice.dart";
import "package:bookfinder_app/services/api/dio_imp/api_auth_subservice.dart";
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

    return DioApiService._(dio: tempDio, tokens: tokens);
  }

  @override
  Future<bool> checkApiHealth() async {
    return _checkHealthOfDio(_dio);
  }

  static Future<bool> _checkHealthOfDio(Dio dio) async {
    try {
      final response = await dio.get("/health");

      return response.statusCode == 200;
    } on DioException {
      return false;
    }
  }
}
