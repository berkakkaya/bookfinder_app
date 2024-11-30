import "package:flutter/material.dart";

extension NavigationExt on BuildContext {
  Future<T?> navigateTo<T>(Widget screen) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Future<T?> navigateToAndRemoveUntil<T>(Widget screen) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => screen),
      (_) => false,
    );
  }

  Future<T?> navigateToAndReplace<T, TO>(Widget screen) {
    return Navigator.of(this).pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void navigateBack<T extends Object?>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }
}
