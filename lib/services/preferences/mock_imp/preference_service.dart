import "package:bookfinder_app/interfaces/preferences/preference_service.dart";
import "package:bookfinder_app/models/token_pair.dart";

class MockPreferenceService extends PreferenceService {
  TokenPair? _tokens;
  String? _baseUri;

  @override
  Future<TokenPair?> getTokens() {
    return Future.value(_tokens);
  }

  @override
  Future<void> setTokens(TokenPair? tokens) {
    _tokens = tokens;
    return Future.value();
  }

  @override
  Future<String?> getBaseUri() {
    return Future.value(_baseUri);
  }

  @override
  Future<void> setBaseUri(String? uri) {
    _baseUri = uri;
    return Future.value();
  }
}
