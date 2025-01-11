import "package:bookfinder_app/consts/custom_icons.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/snackbars.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/book_tracking_models.dart";
import "package:bookfinder_app/screens/book_details/book_details_screen.dart";
import "package:bookfinder_app/services/api/api_service_provider.dart";
import "package:bookfinder_app/services/logging/logging_service_provider.dart";
import "package:bookfinder_app/utils/auth_utils.dart";
import "package:bookfinder_app/widgets/custom_bottom_navbar.dart";
import "package:bookfinder_app/widgets/cards/tracked_book_card.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class TrackedBooksScreen extends StatefulWidget {
  const TrackedBooksScreen({super.key});

  @override
  State<TrackedBooksScreen> createState() => _TrackedBooksScreenState();
}

class _TrackedBooksScreenState extends State<TrackedBooksScreen> {
  Future<List<BookTrackingDataWithBookData>?>? _trackedBooksFuture;
  Set<BookTrackingStatus> statusFilters = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _trackedBooksFuture = getTrackedBooks();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _trackedBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return getDataFetchErrorWidget();
          }

          if (snapshot.data == null) {
            return getDataFetchErrorWidget();
          }

          final List<BookTrackingDataWithBookData> trackedBooks =
              getFilteredTrackedBooks(snapshot.data!).toList();

          return CustomScrollView(
            slivers: [
              SliverFloatingHeader(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 64 + MediaQuery.viewInsetsOf(context).top,
                    left: 16,
                    right: 16,
                    bottom: 32,
                  ),
                  color: context.theme.scaffoldBackgroundColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Takip Altındaki Kitaplar",
                        style: context.theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: getStatusChips(),
                      ),
                    ],
                  ),
                ),
              ),
              if (trackedBooks.isEmpty)
                SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          Expanded(
                            flex: 5,
                            child: SvgPicture.asset(
                              "assets/illustrations/snow.svg",
                            ),
                          ),
                          SizedBox(height: 32),
                          Text(
                            statusFilters.isEmpty
                                ? "Henüz bir kitap takip etmiyorsunuz."
                                : "Belirtilen filtrelere eşleşen kitap bulunamadı.",
                            style: context.theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Text(
                            statusFilters.isEmpty
                                ? "Bir kitap takip etmeyi deneyin ve buraya yeniden uğrayın."
                                : 'Tüm kitapları görmek için "Tümü" seçeneğini seçebilirsiniz.',
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              if (trackedBooks.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.separated(
                    itemBuilder: (context, i) =>
                        getTrackedBookCard(trackedBooks[i]),
                    itemCount: trackedBooks.length,
                    separatorBuilder: (context, i) => SizedBox(height: 16),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavbar(
        key: const Key("tracked_books_screen_navbar"),
        selectedItem: CustomBottomNavbarItem.library,
        customTitle: "Takip Edilenler",
        customIcon: Icon(CustomIcons.circlesRounded),
      ),
    );
  }

  Center getDataFetchErrorWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Takip edilen kitaplar getirilirken bir hata oluştu."),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              setState(() {
                _trackedBooksFuture = getTrackedBooks();
              });
            },
            child: const Text("Tekrar Dene"),
          ),
        ],
      ),
    );
  }

  Widget getTrackedBookCard(BookTrackingDataWithBookData data) {
    final heroTag = "tracked_book:${data.bookId}";

    return TrackedBookCard(
      data: data,
      heroTag: heroTag,
      onTap: () => goToBookDetailsScreen(data, heroTag: heroTag),
    );
  }

  List<Widget> getStatusChips() {
    List<Widget> chips = [];

    chips.add(FilterChip(
      label: Text("Tümü"),
      selected: statusFilters.isEmpty,
      onSelected: (selected) {
        setState(() {
          statusFilters.clear();
        });
      },
    ));

    for (final status in BookTrackingStatus.values) {
      chips.add(FilterChip(
        label: Text(convertStatusToStr(status)),
        selected: statusFilters.contains(status),
        onSelected: (selected) {
          setState(() {
            if (selected) {
              statusFilters.add(status);
            } else {
              statusFilters.remove(status);
            }
          });
        },
      ));
    }

    return chips;
  }

  String convertStatusToStr(BookTrackingStatus status) {
    return switch (status) {
      BookTrackingStatus.willRead => "Okunacak",
      BookTrackingStatus.reading => "Okunuyor",
      BookTrackingStatus.completed => "Tamamlandı",
      BookTrackingStatus.dropped => "Bırakıldı",
    };
  }

  Future<List<BookTrackingDataWithBookData>?> getTrackedBooks() async {
    final result = await withAuth((authHeader) {
      return ApiServiceProvider.i.bookTracking.getBookTrackingDatas(
        authHeader: authHeader,
      );
    });

    if (result.status != ResponseStatus.ok) {
      LoggingServiceProvider.i.error(
        "Failed to get tracked books: ${result.status}",
      );

      if (mounted) {
        context.showSnackbar(
          "Takip edilen kitaplar getirilirken bir hata oluştu.",
          type: SnackbarType.error,
        );
      }

      return null;
    }

    assert(
      result.data != null,
      "getBookTrackingDatas should return data when status is ok",
    );

    return result.data!;
  }

  Iterable<BookTrackingDataWithBookData> getFilteredTrackedBooks(
    List<BookTrackingDataWithBookData> trackedBooks,
  ) sync* {
    for (final trackedBook in trackedBooks) {
      if (statusFilters.isEmpty || statusFilters.contains(trackedBook.status)) {
        yield trackedBook;
      }
    }
  }

  void goToBookDetailsScreen(
    BookTrackingDataWithBookData data, {
    required String heroTag,
  }) {
    context.navigateTo(BookDetailsScreen(
      bookId: data.bookId,
      thumbnailUrl: data.bookThumbnailUrl,
      heroTag: heroTag,
    ));
  }
}
