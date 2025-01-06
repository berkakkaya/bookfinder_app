import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/consts/custom_icons.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/snackbars.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/bookdata_models.dart";
import "package:bookfinder_app/screens/book_details/book_details_screen.dart";
import "package:bookfinder_app/services/api/api_service_provider.dart";
import "package:bookfinder_app/utils/auth_utils.dart" as auth_utils;
import "package:bookfinder_app/widgets/cover_image.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  List<BookRecommendation> recommendations = [];

  bool initFinished = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getRecommendations();

      if (mounted) {
        setState(() {
          initFinished = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget innerChild = switch (recommendations.isEmpty) {
      true => Center(child: CircularProgressIndicator()),
      false => Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            Expanded(
              flex: 10,
              child: GestureDetector(
                onTap: () => goToBookDetailsScreen(
                  recommendations.first.bookId,
                  recommendations.first.thumbnailUrl,
                ),
                child: CachedNetworkImage(
                  imageUrl: recommendations.first.thumbnailUrl,
                  progressIndicatorBuilder: (context, url, progress) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                      ),
                    );
                  },
                  errorWidget: _getCoverImageLoadError,
                  imageBuilder: (_, imageProvider) => CoverImage(
                    imageProvider: imageProvider,
                    addBlurredShadow: true,
                    heroTag: "bookCover:${recommendations.first.bookId}",
                  ),
                  fadeInDuration: Duration(milliseconds: 200),
                  fadeOutDuration: Duration(milliseconds: 200),
                  placeholderFadeInDuration: Duration(milliseconds: 200),
                ),
              ),
            ),
            Spacer(),
            SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recommendations.first.title,
                        style: context.theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        recommendations.first.authors.join(", "),
                        style: context.theme.textTheme.titleMedium?.copyWith(
                          color: colorGray,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  onPressed: getNextRecommendation,
                  color: colorBlack,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: CircleBorder(),
                    side: BorderSide(
                      color: colorBlack,
                      width: 2,
                    ),
                    padding: EdgeInsets.all(12),
                  ),
                  icon: Icon(CustomIcons.heartPlusOutlineRounded),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              recommendations.first.description ??
                  "Kitap açıklaması alınamadı.",
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: colorGray,
              ),
              maxLines: 3,
            ),
          ],
        ),
    };

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(32),
        child: innerChild,
      ),
    );
  }

  Widget _getCoverImageLoadError(context, url, error) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.error,
            size: 96,
            color: colorLightBlack,
          ),
          SizedBox(height: 16),
          Text(
            "Kitap kapağı yüklenemedi.",
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: colorLightBlack,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> getRecommendations() async {
    final result = await auth_utils.withAuth(
      (authHeader) => ApiServiceProvider.i.recommendations.getRecommendations(
        authHeader: authHeader,
      ),
    );

    if (result.status != ResponseStatus.ok) {
      if (mounted) {
        context.showSnackbar(
          "Öneriler getirilirken bir hata meydana geldi.",
          type: SnackbarType.error,
        );
      }

      return;
    }

    if (mounted) {
      setState(() {
        recommendations.addAll(result.data!);
      });
    }
  }

  Future<void> getNextRecommendation() async {
    setState(() {
      recommendations.removeAt(0);
    });

    if (recommendations.length < 3 && initFinished) {
      await getRecommendations();
    }
  }

  void goToBookDetailsScreen(String bookId, String thumbnailUrl) {
    context.navigateTo(BookDetailsScreen(
      bookId: bookId,
      thumbnailUrl: thumbnailUrl,
    ));
  }
}
