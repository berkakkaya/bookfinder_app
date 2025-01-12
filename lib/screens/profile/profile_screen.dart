import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/snackbars.dart";
import "package:bookfinder_app/extensions/strings.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/library_models.dart";
import "package:bookfinder_app/models/user_models.dart";
import "package:bookfinder_app/screens/book_lists/book_list_screen.dart";
import "package:bookfinder_app/services/api/api_service_provider.dart";
import "package:bookfinder_app/services/logging/logging_service_provider.dart";
import "package:bookfinder_app/utils/auth_utils.dart";
import "package:bookfinder_app/widgets/cards/book_list_card.dart";
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
  Future<
      ({
        User user,
        List<BookListItem> bookLists,
        bool? isFollowing,
      })?>? _dataFuture;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) return;

      setState(() {
        _dataFuture = _getData();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _dataFuture,
          builder: (context, snapshot) {
            final bool isLoading =
                snapshot.connectionState == ConnectionState.waiting;
            final data = snapshot.data;

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _dataFuture = _getData();
                });

                await _dataFuture;
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
                  else if (data == null)
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
                            data.user.nameSurname.leadingLetters.take(2).join(),
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
                        padding: EdgeInsets.only(
                          top: 32,
                          left: 16,
                          right: 16,
                          bottom: 16,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              data.user.nameSurname,
                              style: Theme.of(context).textTheme.headlineLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data.user.followedUsers.isEmpty
                                  ? "Takip edilen yok"
                                  : "${data.user.followedUsers.length} takip edilen kişi",
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.userId != null && data.isFollowing != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: FilledButton.icon(
                            icon: Icon(
                              data.isFollowing!
                                  ? Icons.person_remove_rounded
                                  : Icons.person_add_rounded,
                            ),
                            label: Text(
                              data.isFollowing! ? "Takip Bırak" : "Takip Et",
                            ),
                            onPressed: () => changeFollowStatus(
                              widget.userId!,
                              data.isFollowing!,
                            ),
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Text(
                          widget.userId == null
                              ? "Kitap Listelerim"
                              : "Kitap Listeleri",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 32,
                      ),
                      sliver: SliverList.separated(
                        separatorBuilder: (context, i) => const SizedBox(
                          height: 16,
                        ),
                        itemCount: data.bookLists.length,
                        itemBuilder: (context, i) {
                          final bookList = data.bookLists[i];

                          return BookListCard(
                            listTitle: bookList.title,
                            details: (
                              bookCount: bookList.bookCount,
                              isPrivate: bookList.isPrivate,
                            ),
                            internalTitle: bookList.internalTitle,
                            onTap: () => _goToBookListScreen(bookList),
                          );
                        },
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

  Future<
      ({
        User user,
        List<BookListItem> bookLists,
        bool? isFollowing,
      })?> _getData() async {
    final userFuture = _getUser();
    final bookListsFuture = _getBookLists();
    final Future<bool?> followStatusFuture = widget.userId == null
        ? Future.value()
        : _getFollowStatus(widget.userId!);

    await Future.wait([userFuture, bookListsFuture, followStatusFuture]);

    final user = await userFuture;
    final bookLists = await bookListsFuture;
    final isFollowing = await followStatusFuture;

    if (user == null || bookLists == null) {
      return null;
    }

    return (
      user: user,
      bookLists: bookLists,
      isFollowing: isFollowing,
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

  Future<List<BookListItem>?> _getBookLists() async {
    final response = await withAuth((authHeader) {
      return ApiServiceProvider.i.library.getBookLists(
        targetUserId: widget.userId,
        authHeader: authHeader,
      );
    });

    if (response.status != ResponseStatus.ok) {
      LoggingServiceProvider.i.error(
        "Failed to get book lists of user with ID ${widget.userId} "
        "(${response.status})",
      );

      if (mounted) {
        context.showSnackbar(
          "Kullanıcının kitap listeleri alınamadı",
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

  Future<bool> _getFollowStatus(String userId) async {
    final response = await withAuth((authHeader) {
      return ApiServiceProvider.i.users.checkFollowStatus(
        userId,
        authHeader: authHeader,
      );
    });

    if (response.status != ResponseStatus.ok) {
      LoggingServiceProvider.i.error(
        "Failed to get follow status of user with ID $userId "
        "(${response.status})",
      );

      if (mounted) {
        context.showSnackbar(
          "Takip durumu alınamadı",
          type: SnackbarType.error,
        );
      }

      return false;
    }

    assert(
      response.data != null,
      "Response status is OK but data is null",
    );

    return response.data!;
  }

  Future<void> changeFollowStatus(String userId, bool isFollowing) async {
    final response = await withAuth((authHeader) {
      if (isFollowing) {
        return ApiServiceProvider.i.users.unfollowUser(
          userId,
          authHeader: authHeader,
        );
      } else {
        return ApiServiceProvider.i.users.followUser(
          userId,
          authHeader: authHeader,
        );
      }
    });

    if (response.status != ResponseStatus.ok) {
      LoggingServiceProvider.i.error(
        "Failed to ${isFollowing ? "unfollow" : "follow"} user with ID $userId "
        "(${response.status})",
      );

      if (mounted) {
        context.showSnackbar(
          "Takip durumu değiştirilemedi",
          type: SnackbarType.error,
        );
      }

      return;
    }

    if (mounted) {
      context.showSnackbar(
        isFollowing
            ? "Kullanıcıyı takip bırakıldı"
            : "Kullanıcı takip ediliyor",
        type: SnackbarType.success,
      );

      setState(() {
        _dataFuture = _getData();
      });
    }
  }

  void _goToBookListScreen(BookListItem bookList) {
    context.navigateTo(
      BookListScreen(
        bookListId: bookList.bookListId,
        cacheIsFavoritesList: bookList.internalTitle == "_likedBooks",
        cachedListName: bookList.title,
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
