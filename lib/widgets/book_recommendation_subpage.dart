import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/consts/custom_icons.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/snackbars.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/bookdata_models.dart";
import "package:bookfinder_app/screens/book_details/book_details_screen.dart";
import "package:bookfinder_app/services/api/api_service_provider.dart";
import "package:bookfinder_app/services/logging/logging_service_provider.dart";
import "package:bookfinder_app/utils/auth_utils.dart";
import "package:bookfinder_app/widgets/cover_image.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

class BookRecommendationSubpage extends StatefulWidget {
  final Future<BookRecommendation?> recommendationFuture;
  final int index;

  const BookRecommendationSubpage({
    super.key,
    required this.recommendationFuture,
    required this.index,
  });

  @override
  State<BookRecommendationSubpage> createState() =>
      _BookRecommendationSubpageState();
}

class _BookRecommendationSubpageState extends State<BookRecommendationSubpage>
    with AutomaticKeepAliveClientMixin {
  bool isLiked = false;
  bool _wantKeepAlive = true;

  @override
  bool get wantKeepAlive => _wantKeepAlive;

  @override
  void initState() {
    super.initState();

    _updateKeepAliveFromFuture();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<BookRecommendation?>(
      future: widget.recommendationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData) {
          return _getRecommendationLoadErrorWidget();
        }

        final recommendation = snapshot.data!;
        final heroTag = "bookCover:${recommendation.bookId}:${widget.index}";

        return Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              Expanded(
                flex: 13,
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: GestureDetector(
                    onTap: () => goToBookDetailsScreen(
                      bookId: recommendation.bookId,
                      thumbnailUrl: recommendation.thumbnailUrl,
                      heroTag: heroTag,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: recommendation.thumbnailUrl,
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
                        heroTag: heroTag,
                      ),
                      fadeInDuration: Duration(milliseconds: 200),
                      fadeOutDuration: Duration(milliseconds: 200),
                      placeholderFadeInDuration: Duration(milliseconds: 200),
                    ),
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
                          recommendation.title,
                          style:
                              context.theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          recommendation.authors.join(", "),
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
                    onPressed: () => isLiked
                        ? unlikeRecommendation(recommendation)
                        : likeRecommendation(recommendation),
                    color: isLiked ? colorWhite : colorBlack,
                    style: IconButton.styleFrom(
                      backgroundColor: isLiked ? colorRed : Colors.transparent,
                      shape: CircleBorder(),
                      side: isLiked
                          ? null
                          : BorderSide(color: colorBlack, width: 2),
                      padding: EdgeInsets.all(12),
                    ),
                    icon: Icon(isLiked
                        ? CustomIcons.heartCheckRounded
                        : CustomIcons.heartPlusOutlineRounded),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                recommendation.description ?? "Kitap açıklaması alınamadı.",
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: colorGray,
                ),
                maxLines: 3,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getRecommendationLoadErrorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.error,
          size: 96,
          color: colorLightBlack,
        ),
        SizedBox(height: 16),
        Text(
          "Kitap önerisi alınamadı.\nTekrar denemek için sayfayı "
          "aşağıya kaydırın.",
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: colorLightBlack,
          ),
          textAlign: TextAlign.center,
        ),
      ],
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

  void _updateKeepAliveFromFuture() async {
    final recommendation = await widget.recommendationFuture;

    if (recommendation != null) {
      _wantKeepAlive = false;
      updateKeepAlive();
    }
  }

  Future<void> likeRecommendation(BookRecommendation recommendation) async {
    final response = await withAuth((authHeader) {
      return ApiServiceProvider.i.library.addBookToList(
        "_likedBooks",
        bookId: recommendation.bookId,
        authHeader: authHeader,
      );
    });

    if (response.status != ResponseStatus.ok) {
      LoggingServiceProvider.i.error(
        "Failed to like book: ${recommendation.bookId} (${response.status})",
      );

      if (mounted) {
        context.showSnackbar(
          "Kitap beğenilirken bir hata meydana geldi.",
          type: SnackbarType.error,
        );
      }

      return;
    }

    if (mounted) {
      setState(() {
        isLiked = true;
      });
    }
  }

  Future<void> unlikeRecommendation(BookRecommendation recommendation) async {
    final response = await withAuth((authHeader) {
      return ApiServiceProvider.i.library.removeBookFromList(
        "_likedBooks",
        bookId: recommendation.bookId,
        authHeader: authHeader,
      );
    });

    if (![
      ResponseStatus.ok,
      ResponseStatus.notFound,
    ].contains(response.status)) {
      LoggingServiceProvider.i.error(
        "Failed to unlike book: ${recommendation.bookId} (${response.status})",
      );

      if (mounted) {
        context.showSnackbar(
          "Kitap beğenisi kaldırılırken bir hata meydana geldi.",
          type: SnackbarType.error,
        );
      }

      return;
    }

    if (mounted) {
      setState(() {
        isLiked = false;
      });
    }
  }

  void goToBookDetailsScreen({
    required String bookId,
    required String thumbnailUrl,
    required String heroTag,
  }) {
    context.navigateTo(BookDetailsScreen(
      bookId: bookId,
      thumbnailUrl: thumbnailUrl,
      heroTag: heroTag,
    ));
  }
}
