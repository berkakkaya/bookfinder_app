import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/snackbars.dart";
import "package:bookfinder_app/extensions/strings.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/user_models.dart";
import "package:bookfinder_app/services/api/api_service_provider.dart";
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
  Future<User?>? _userFuture;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _userFuture = _getCurrentUser();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        actions: [
          if (kDebugMode)
            IconButton(
              onPressed: _showDeveloperDialog,
              icon: Icon(Icons.developer_mode_rounded),
            ),
          IconButton(
            onPressed: () {
              setState(() {
                _userFuture = _getCurrentUser();
              });
            },
            icon: Icon(Icons.refresh_rounded),
          ),
          IconButton(
            onPressed: logoutPressed,
            icon: Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Kullanıcı bilgileri alınamadı. Lütfen tekrar deneyin.",
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                "Kullanıcı bilgileri alınamadı. Lütfen tekrar deneyin.",
              ),
            );
          }

          final User user = snapshot.data as User;

          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 32,
            ),
            children: [
              CircleAvatar(
                radius: 96,
                backgroundColor: colorGray,
                // Put first two letters of the name and surname
                child: Text(
                  user.nameSurname.leadingLetters.take(2).join(),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: colorWhite,
                      ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                user.nameSurname,
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<User?> _getCurrentUser() async {
    final response = await withAuth((authHeader) {
      return ApiServiceProvider.i.users.getUser(
        null,
        authHeader: authHeader,
      );
    });

    if (response.status != ResponseStatus.ok) {
      if (mounted) {
        context.showSnackbar(
          "Kullanıcı bilgileri alınamadı. Lütfen tekrar deneyin.",
          type: SnackbarType.error,
        );
      }

      return null;
    }

    assert(
      response.data != null,
      "The user data should not be null if the response status is ok.",
    );

    return response.data!;
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
