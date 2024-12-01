import "package:animations/animations.dart";
import "package:flutter/material.dart";

enum TransitionAnimationType {
  plain,
  sharedAxisX,
  fadeThrough,
}

PageRouteBuilder<T> _buildSharedAxisXRouteBuilder<T>(Widget screen) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.horizontal,
        child: child,
      );
    },
  );
}

PageRouteBuilder<T> _buildFadeThroughRouteBuilder<T>(Widget screen) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    },
  );
}

extension NavigationExt on BuildContext {
  Future<T?> navigateTo<T>(
    Widget screen, {
    TransitionAnimationType animation = TransitionAnimationType.plain,
  }) {
    final Route<T> route = switch (animation) {
      TransitionAnimationType.sharedAxisX =>
        _buildSharedAxisXRouteBuilder(screen),
      TransitionAnimationType.fadeThrough =>
        _buildFadeThroughRouteBuilder(screen),
      TransitionAnimationType.plain =>
        MaterialPageRoute(builder: (_) => screen),
    };

    return Navigator.of(this).push<T>(route);
  }

  Future<T?> navigateToAndRemoveUntil<T>(
    Widget screen, {
    TransitionAnimationType animation = TransitionAnimationType.plain,
  }) {
    final Route<T> route = switch (animation) {
      TransitionAnimationType.sharedAxisX =>
        _buildSharedAxisXRouteBuilder<T>(screen),
      TransitionAnimationType.fadeThrough =>
        _buildFadeThroughRouteBuilder<T>(screen),
      TransitionAnimationType.plain =>
        MaterialPageRoute(builder: (_) => screen),
    };

    return Navigator.of(this).pushAndRemoveUntil<T>(route, (_) => false);
  }

  Future<T?> navigateToAndReplace<T, TO>(
    Widget screen, {
    TransitionAnimationType animation = TransitionAnimationType.plain,
  }) {
    final Route<T> route = switch (animation) {
      TransitionAnimationType.sharedAxisX =>
        _buildSharedAxisXRouteBuilder<T>(screen),
      TransitionAnimationType.fadeThrough =>
        _buildFadeThroughRouteBuilder<T>(screen),
      TransitionAnimationType.plain =>
        MaterialPageRoute(builder: (_) => screen),
    };

    return Navigator.of(this).pushReplacement<T, TO>(route);
  }

  void navigateBack<T extends Object?>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }
}
