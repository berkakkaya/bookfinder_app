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
import "package:bookfinder_app/widgets/custom_bottom_navbar.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class ProfileScreen extends StatefulWidget {
  final String? userId;
  final bool asTab;

  const ProfileScreen({
    super.key,
    required this.userId,
    this.asTab = false,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<User?>? _userFuture;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) return;

      setState(() {
        _userFuture = _getUser();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _userFuture,
          builder: (context, snapshot) {
            final bool isLoading =
                snapshot.connectionState == ConnectionState.waiting;
            final User? user = snapshot.data;

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _userFuture = _getUser();
                });

                await _userFuture;
              },
              child: CustomScrollView(
                slivers: [
                  if (widget.asTab)
                    SliverAppBar(
                      leading: null,
                      backgroundColor: context.theme.scaffoldBackgroundColor,
                      actions: [
                        if (kDebugMode)
                          IconButton(
                            onPressed: _showDeveloperDialog,
                            icon: const Icon(Icons.developer_mode_rounded),
                          ),
                        IconButton(
                          onPressed: logoutPressed,
                          icon: const Icon(Icons.logout_rounded),
                        ),
                      ],
                    ),
                  if (isLoading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (user == null)
                    const SliverFillRemaining(
                      child: Center(
                        child: Text("Kullanıcı bilgileri alınamadı"),
                      ),
                    )
                  else ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: widget.asTab ? 32 : 64,
                          left: 16,
                          right: 16,
                        ),
                        child: CircleAvatar(
                          radius: 96,
                          backgroundColor: colorGray,
                          // Put first two letters of the name and surname
                          child: Text(
                            user.nameSurname.leadingLetters.take(2).join(),
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  color: colorWhite,
                                ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 32,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              user.nameSurname,
                              style: Theme.of(context).textTheme.headlineLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              user.followedUsers.isEmpty
                                  ? "Takip edilen yok"
                                  : "${user.followedUsers.length} takip edilen kişi",
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: widget.asTab
          ? null
          : CustomBottomNavbar(
              key: const ValueKey("profile_screen_bottom_navbar"),
              selectedItem: CustomBottomNavbarItem.profile,
            ),
    );
  }

  Future<User?> _getUser() async {
    final response = await withAuth((authHeader) {
      return ApiServiceProvider.i.users.getUser(
        widget.userId,
        authHeader: authHeader,
      );
    });

    if (response.status != ResponseStatus.ok) {
      LoggingServiceProvider.i.error(
        "Failed to get user with ID ${widget.userId} (${response.status})",
      );

      if (mounted) {
        context.showSnackbar(
          "Kullanıcı bilgileri alınamadı",
          type: SnackbarType.error,
        );
      }

      return null;
    }

    assert(
      response.data != null,
      "Response status is OK but data is null",
    );

    return response.data;
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
