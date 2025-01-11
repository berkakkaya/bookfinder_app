import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/models/book_tracking_models.dart";
import "package:bookfinder_app/widgets/cover_image.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

class BookCard extends StatelessWidget {
  final String title;
  final String authors;
  final String thumbnailUrl;
  final BookTrackingStatus? trackingStatus;
  final Widget? trailing;
  final String? heroTag;
  final void Function() onTap;

  const BookCard({
    super.key,
    required this.title,
    required this.authors,
    required this.thumbnailUrl,
    this.trackingStatus,
    this.trailing,
    this.heroTag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorGray,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 96,
              ),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: CachedNetworkImage(
                  imageUrl: thumbnailUrl,
                  progressIndicatorBuilder: (context, url, progress) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                      ),
                    );
                  },
                  errorWidget: (context, url, error) => DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorGray,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.error_outline,
                        color: colorWhite,
                      ),
                    ),
                  ),
                  imageBuilder: (context, imageProvider) => CoverImage(
                    imageProvider: imageProvider,
                    heroTag: heroTag,
                  ),
                  fadeInDuration: Duration(milliseconds: 200),
                  fadeOutDuration: Duration(milliseconds: 200),
                  placeholderFadeInDuration: Duration(milliseconds: 200),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authors,
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      color: colorGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (trackingStatus != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 16,
                          color: getColor(trackingStatus!),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          getLabel(trackingStatus!),
                          style: context.theme.textTheme.bodyMedium?.copyWith(
                            color: colorGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 16),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }

  Color getColor(BookTrackingStatus status) {
    return switch (status) {
      BookTrackingStatus.willRead => colorBlue,
      BookTrackingStatus.reading => colorOrange,
      BookTrackingStatus.completed => colorGreen,
      BookTrackingStatus.dropped => colorRed,
    };
  }

  String getLabel(BookTrackingStatus status) {
    return switch (status) {
      BookTrackingStatus.willRead => "Okunacak",
      BookTrackingStatus.reading => "Okunuyor",
      BookTrackingStatus.completed => "Tamamlandı",
      BookTrackingStatus.dropped => "Bırakıldı",
    };
  }
}
