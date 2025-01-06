import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/consts/custom_icons.dart";
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

class BookDetailsScreen extends StatefulWidget {
  final String bookId;
  final String thumbnailUrl;

  const BookDetailsScreen({
    super.key,
    required this.bookId,
    required this.thumbnailUrl,
  });

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  Future<BookData?>? bookDataFuture;

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
                      heroTag: "bookCover:${widget.bookId}",
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
                      child: OutlinedButton.icon(
                        icon: Icon(CustomIcons.circlesRounded),
                        label: Text(
                          "Takibe Al",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: showBookTrackCard,
                      ),
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

  Future<void> showBookTrackCard() async {
    final result = await showModalBottomSheet<BookTrackingStatus>(
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
                Navigator.of(context).pop(null);
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
                Navigator.of(context).pop(BookTrackingStatus.willRead);
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
                Navigator.of(context).pop(BookTrackingStatus.reading);
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
                Navigator.of(context).pop(BookTrackingStatus.completed);
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
                Navigator.of(context).pop(BookTrackingStatus.dropped);
              },
            ),
            SizedBox(height: 16),
          ],
        );
      },
    );

    if (result != null) {
      // TODO: Handle the result
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

    return response.data!;
  }
}
