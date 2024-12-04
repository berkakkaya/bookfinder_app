import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/services/api/api_service_auth.dart";
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
      body: Center(
        child: FilledButton.icon(
          icon: Icon(Icons.logout_rounded),
          label: Text("Çıkış Yap"),
          style: context.theme.filledButtonTheme.style?.copyWith(
            backgroundColor: WidgetStatePropertyAll(colorRed),
          ),
          onPressed: logoutPressed,
        ),
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
      ApiServiceAuth.logout();
    }
  }
}
