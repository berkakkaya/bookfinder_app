import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/snackbars.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/services/logging/logging_service_provider.dart";
import "package:bookfinder_app/utils/auth_utils.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (kDebugMode)
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _showDeveloperDialog,
                    icon: Icon(Icons.developer_mode_rounded),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Center(
              child: FilledButton.icon(
                icon: Icon(Icons.logout_rounded),
                label: Text("Çıkış Yap"),
                style: context.theme.filledButtonTheme.style?.copyWith(
                  backgroundColor: WidgetStatePropertyAll(colorRed),
                ),
                onPressed: logoutPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logoutPressed() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Çıkış Yap"),
          content: const Text("Çıkış yapmak istediğinize emin misiniz?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Hayır"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Evet"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      // Log out the user
      await logout();
    }
  }

  Future<void> _showDeveloperDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Geliştirici Seçenekleri"),
          content: Text("Kullanmak istediğiniz geliştirici seçeneğini seçin."),
          actions: [
            TextButton(
              onPressed: () {
                final screen = LoggingServiceProvider.getDebugLogsScreen();

                if (screen != null) {
                  context.navigateTo(screen);
                } else {
                  context.showSnackbar(
                    "Kullanılan log servis implementasyonu bu "
                    "özelliği desteklemiyor.",
                    type: SnackbarType.error,
                  );
                }
              },
              child: const Text("Logları görüntüle"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Kapat"),
            ),
          ],
        );
      },
    );
  }
}
