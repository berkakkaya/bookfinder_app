import "package:bookfinder_app/interfaces/preferences/preference_service.dart";
import "package:bookfinder_app/models/token_pair.dart";

class MockPreferenceService extends PreferenceService {
  TokenPair? _tokens;

  @override
  Future<TokenPair?> getTokens() {
    return Future.value(_tokens);
  }

  @override
  Future<void> setTokens(TokenPair? tokens) {
    _tokens = tokens;
    return Future.value();
  }
}
