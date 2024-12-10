import "package:dio/dio.dart";
import "package:shared_preferences/shared_preferences.dart";

class BaseApiService {
  static Dio? _dio;

  static Dio get dio {
    assert(_dio != null, "The base API service must be initialized before use");
    return _dio!;
  }

  /// Initializes the base API service with the given base URI.
  ///
  /// If [baseUri] is `null`, the base URI will be loaded
  /// from the shared preferences.
  ///
  /// Returns `true` if the base URI was successfully initialized,
  /// and `false` otherwise.
  static Future<bool> init([Uri? baseUri]) async {
    final preferences = SharedPreferencesAsync();

    // Load the base URI from the shared preferences if it's not provided
    if (baseUri == null) {
      final rawUrl = await preferences.getString("baseUri");
      if (rawUrl == null) {
        return false;
      }

      baseUri = Uri.parse(rawUrl);
    }

    // Create a temporary Dio instance to test the base URI
    final tempDio = Dio(BaseOptions(
      baseUrl: baseUri.toString(),
      validateStatus: (status) => status != null && status < 400,
      sendTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      connectTimeout: Duration(seconds: 10),
    ));

    // Do a test request to see if the base URI is valid
    try {
      await tempDio.get("/");
    } on DioException {
      return false;
    }

    // Our base URI is valid, so we can save it
    await preferences.setString("baseUri", baseUri.toString());
    _dio = tempDio;

    return true;
  }
}
