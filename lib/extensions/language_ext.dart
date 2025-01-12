import "package:flutter/widgets.dart";

extension ContextLanguageExt on BuildContext {
  String get locale => Localizations.localeOf(this).languageCode;
}
