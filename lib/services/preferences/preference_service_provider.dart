import "package:bookfinder_app/interfaces/preferences/preference_service.dart";
import "package:bookfinder_app/services/preferences/mock_imp/preference_service.dart";
import "package:bookfinder_app/services/preferences/shared_prefs_imp/preference_service.dart";

class PreferenceServiceProvider {
  static PreferenceService? _instance;

  /// Initializes the preference service provider with a mock implementation.
  static void initMock() {
    _instance = MockPreferenceService();
  }

  /// Initializes the preference service provider with the `shared_preferences`
  /// implementation.
  static void initActual() {
    _instance = ActualPreferenceService();
  }

  /// Returns the preference service instance.
  ///
  /// NOTE: Make sure to call either `initMock` or `initActual` before calling
  /// this method.
  static PreferenceService get i {
    assert(
      _instance != null,
      "Preference service provider must be initialized before use",
    );

    return _instance!;
  }
}
