import "package:bookfinder_app/consts/colors.dart";
import "package:flutter/material.dart";

enum SnackbarType {
  info,
  success,
  warning,
  error,
}

extension SnackbarsExt on BuildContext {
  void showSnackbar(
    String message, {
    SnackbarType type = SnackbarType.info,
    bool hideCurrentBeforeShowing = true,
    bool showCloseIcon = true,
  }) {
    if (hideCurrentBeforeShowing) {
      ScaffoldMessenger.of(this).hideCurrentSnackBar();
    }

    final Icon icon = switch (type) {
      SnackbarType.info => const Icon(Icons.info_rounded),
      SnackbarType.success => const Icon(Icons.check_circle_rounded),
      SnackbarType.warning => const Icon(Icons.warning_rounded),
      SnackbarType.error => const Icon(Icons.error_rounded),
    };

    final Color color = switch (type) {
      SnackbarType.info => colorBlue,
      SnackbarType.success => colorGreen,
      SnackbarType.warning => colorOrange,
      SnackbarType.error => colorRed,
    };

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconTheme(
              data: const IconThemeData(
                color: colorBackground,
              ),
              child: icon,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        showCloseIcon: showCloseIcon,
      ),
    );
  }
}
