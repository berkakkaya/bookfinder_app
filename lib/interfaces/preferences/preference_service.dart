import "package:bookfinder_app/models/token_pair.dart";

abstract class PreferenceService {
  Future<TokenPair?> getTokens();
  Future<void> setTokens(TokenPair? tokens);

  Future<Uri?> getBaseUri();
  Future<void> setBaseUri(Uri? uri);
}
