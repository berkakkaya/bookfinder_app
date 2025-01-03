import "package:bookfinder_app/interfaces/preferences/preference_service.dart";
import "package:bookfinder_app/models/token_pair.dart";
import "package:shared_preferences/shared_preferences.dart";

class ActualPreferenceService implements PreferenceService {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  @override
  Future<TokenPair?> getTokens() async {
    final accessToken = await _prefs.getString("access_token");
    final refreshToken = await _prefs.getString("refresh_token");

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    return TokenPair(accessToken: accessToken, refreshToken: refreshToken);
  }

  @override
  Future<void> setTokens(TokenPair? tokens) async {
    if (tokens == null) {
      await _prefs.remove("access_token");
      await _prefs.remove("refresh_token");

      return;
    }

    await _prefs.setString("access_token", tokens.accessToken);
    await _prefs.setString("refresh_token", tokens.refreshToken);
  }
}
