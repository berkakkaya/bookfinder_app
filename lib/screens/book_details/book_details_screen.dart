import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/consts/custom_icons.dart";
import "package:bookfinder_app/extensions/snackbars.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/book_tracking_models.dart";
import "package:bookfinder_app/models/bookdata_models.dart";
import "package:bookfinder_app/services/api/api_service_provider.dart";
import "package:bookfinder_app/services/logging/logging_service_provider.dart";
import "package:bookfinder_app/utils/auth_utils.dart";
import "package:bookfinder_app/utils/convert_utils.dart";
import "package:bookfinder_app/widgets/cover_image.dart";
import "package:bookfinder_app/widgets/custom_bottom_navbar.dart";
import "package:bookfinder_app/widgets/info_card.dart";
import "package:bookfinder_app/widgets/outlined_circle.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

typedef BookTrackingStatusChoice = ({BookTrackingStatus? choice});

class BookDetailsScreen extends StatefulWidget {
  final String bookId;
  final String thumbnailUrl;
  final String? heroTag;

  const BookDetailsScreen({
    super.key,
    required this.bookId,
    required this.thumbnailUrl,
    this.heroTag,
  });

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  Future<BookData?>? bookDataFuture;
  Future<BookTrackingData?>? bookTrackingDataFuture;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        bookDataFuture = fetchBookData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: bookDataFuture,
          builder: (context, snapshot) {
            List<Widget> content = [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: CachedNetworkImage(
                    imageUrl: widget.thumbnailUrl,
                    progressIndicatorBuilder: (context, url, downloadProgress) {
                      return Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Center(
                        child: Icon(Icons.error),
                      );
                    },
                    imageBuilder: (context, imageProvider) => CoverImage(
                      imageProvider: imageProvider,
                      addBlurredShadow: true,
                      heroTag: widget.heroTag,
                    ),
                  ),
                ),
              ),
            ];

            if (snapshot.connectionState == ConnectionState.waiting) {
              content.add(Center(
                child: CircularProgressIndicator(),
              ));
            } else if (snapshot.hasError) {
              content.add(Center(
                child: Text("Error: ${snapshot.error}"),
              ));
            } else if (!snapshot.hasData) {
              content.add(Center(
                child: Text("Kitap verisi alınamadı."),
              ));
            } else {
              final BookData bookData = snapshot.data!;

              content.addAll([
                SizedBox(height: 48),
                Text(
                  bookData.title,
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  bookData.authors.join(", "),
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    color: colorGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _getBookTrackingButton(),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.icon(
                        icon: Icon(CustomIcons.book5Rounded),
                        label: Text(
                          "Listeme Ekle",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48),
                Text(
                  "Kitap Açıklaması",
                  style: context.theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  bookData.description ??
                      "Bu kitabın bir açıklamasını maalesef ki bulamadık.",
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 36),
                if (bookData.identifiers.isNotEmpty) ...[
                  Text(
                    "Kitap Bilgileri",
                    style: context.theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  for (final identifier in bookData.identifiers)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: InfoCard(
                        title:
                            convertIndustryIdentifierToString(identifier.type),
                        content: identifier.identifier,
                      ),
                    ),
                ],
              ]);
            }

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 32,
              ),
              children: content,
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        selectedItem: CustomBottomNavbarItem.library,
        customIcon: Icon(Icons.menu_book_rounded),
        customTitle: "Kitap Detayları",
        disableSubpageSelections: true,
      ),
    );
  }

  Widget _getBookTrackingButton() {
    return FutureBuilder(
      future: bookTrackingDataFuture,
      builder: (context, snapshot) {
        final bool isLoaded = snapshot.connectionState == ConnectionState.done;

        final BookTrackingStatus? status = snapshot.data?.status;

        final Color circleColor = switch (status) {
          BookTrackingStatus.willRead => colorBlue,
          BookTrackingStatus.reading => colorOrange,
          BookTrackingStatus.completed => colorGreen,
          BookTrackingStatus.dropped => colorRed,
          _ => Colors.transparent,
        };

        final String buttonLabel = switch (status) {
          BookTrackingStatus.willRead => "Okunacak",
          BookTrackingStatus.reading => "Devam ediliyor",
          BookTrackingStatus.completed => "Tamamlandı",
          BookTrackingStatus.dropped => "Bırakıldı",
          _ => "Takibe Al",
        };

        return OutlinedButton.icon(
          icon: status == null
              ? Icon(CustomIcons.circlesRounded)
              : OutlinedCircle(
                  backgroundColor: circleColor,
                  size: 16,
                ),
          label: Text(
            isLoaded ? buttonLabel : "Yükleniyor...",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onPressed: () => setBookTrackData(oldStatus: status),
        );
      },
    );
  }

  Future<void> setBookTrackData({
    required BookTrackingStatus? oldStatus,
  }) async {
    final result = await showModalBottomSheet<BookTrackingStatusChoice>(
      context: context,
      builder: (context) {
        const double circleSize = 24;
        const double borderWidth = 1.3;
        const Color borderColor = colorLightBlack;

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Kitabı takip et",
                style: context.theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text("Takipten çıkar"),
              leading: OutlinedCircle(
                backgroundColor: Colors.transparent,
                size: circleSize,
                borderWidth: borderWidth,
                borderColor: borderColor,
              ),
              onTap: () {
                Navigator.of(context).pop<BookTrackingStatusChoice>(
                  (choice: null),
                );
              },
            ),
            ListTile(
              title: Text("Okunacak"),
              leading: OutlinedCircle(
                backgroundColor: colorBlue,
                size: circleSize,
                borderWidth: borderWidth,
                borderColor: borderColor,
              ),
              onTap: () {
                Navigator.of(context).pop<BookTrackingStatusChoice>(
                  (choice: BookTrackingStatus.willRead),
                );
              },
            ),
            ListTile(
              title: Text("Devam ediliyor"),
              leading: OutlinedCircle(
                backgroundColor: colorOrange,
                size: circleSize,
                borderWidth: borderWidth,
                borderColor: borderColor,
              ),
              onTap: () {
                Navigator.of(context).pop<BookTrackingStatusChoice>(
                  (choice: BookTrackingStatus.reading),
                );
              },
            ),
            ListTile(
              title: Text("Tamamlandı"),
              leading: OutlinedCircle(
                backgroundColor: colorGreen,
                size: circleSize,
                borderWidth: borderWidth,
                borderColor: borderColor,
              ),
              onTap: () {
                Navigator.of(context).pop<BookTrackingStatusChoice>(
                  (choice: BookTrackingStatus.completed),
                );
              },
            ),
            ListTile(
              title: Text("Bırakıldı"),
              leading: OutlinedCircle(
                backgroundColor: colorRed,
                size: circleSize,
                borderWidth: borderWidth,
                borderColor: borderColor,
              ),
              onTap: () {
                Navigator.of(context).pop<BookTrackingStatusChoice>(
                  (choice: BookTrackingStatus.dropped),
                );
              },
            ),
            SizedBox(height: 16),
          ],
        );
      },
    );

    if (result == null) return;

    final choice = result.choice;
    if (choice == oldStatus) return;

    final response = await withAuth((authHeader) {
      if (choice == null) {
        return ApiServiceProvider.i.bookTracking.removeBookTrackingData(
          widget.bookId,
          authHeader: authHeader,
        );
      }

      return ApiServiceProvider.i.bookTracking.updateBookTrackingData(
        bookId: widget.bookId,
        status: choice,
        authHeader: authHeader,
      );
    });

    if (![ResponseStatus.ok, ResponseStatus.notFound].contains(
      response.status,
    )) {
      LoggingServiceProvider.i.error(
        "Failed to update book tracking data (response: ${response.status})",
      );

      if (mounted) {
        context.showSnackbar(
          "Kitap takip verisi güncellenemedi.",
          type: SnackbarType.error,
        );
      }

      return;
    }

    if (mounted) {
      setState(() {
        bookTrackingDataFuture = fetchBookTrackingData();
      });
    }
  }

  Future<BookData?> fetchBookData() async {
    final response = await withAuth((authHeader) {
      return ApiServiceProvider.i.bookDatas.getBookData(
        widget.bookId,
        authHeader: authHeader,
      );
    });

    if (response.status != ResponseStatus.ok) {
      LoggingServiceProvider.i.error(
        "Failed to fetch book data (response: ${response.status})",
      );

      return null;
    }

    assert(
      response.data != null,
      "Book data is must not be null after successful response",
    );

    if (mounted) {
      setState(() {
        bookTrackingDataFuture = fetchBookTrackingData();
      });
    }

    return response.data!;
  }

  Future<BookTrackingData?> fetchBookTrackingData() async {
    final response = await withAuth((authHeader) {
      return ApiServiceProvider.i.bookTracking.getBookTrackingData(
        widget.bookId,
        authHeader: authHeader,
      );
    });

    if (![ResponseStatus.notFound, ResponseStatus.ok].contains(
      response.status,
    )) {
      LoggingServiceProvider.i.error(
        "Failed to fetch book tracking data (response: ${response.status})",
      );

      if (mounted) {
        context.showSnackbar(
          "Kitap takip verisi alınamadı.",
          type: SnackbarType.error,
        );
      }

      return null;
    }

    return response.data;
  }
}
