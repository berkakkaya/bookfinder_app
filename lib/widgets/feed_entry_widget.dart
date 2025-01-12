import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/language_ext.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/strings.dart";
import "package:bookfinder_app/models/feed_models.dart";
import "package:bookfinder_app/screens/book_lists/book_list_screen.dart";
import "package:bookfinder_app/screens/profile/profile_screen.dart";
import "package:bookfinder_app/widgets/cards/book_list_card.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class FeedEntryWidget extends StatelessWidget {
  final BaseFeedEntry feedEntry;
  final EdgeInsetsGeometry padding;

  const FeedEntryWidget({
    super.key,
    required this.feedEntry,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    const double avatarSize = 60;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => goToUserDetailsScreen(context),
                customBorder: CircleBorder(),
                child: Ink(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorGray,
                  ),
                  child: Center(
                    child: Text(
                      feedEntry.issuerNameSurname.leadingLetters.take(2).join(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colorWhite,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      feedEntry.issuerNameSurname,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      descriptionText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorGray,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (feedEntry is BookListPublishFeedEntry) ...[
            const SizedBox(height: 32),
            BookListCard(
              listTitle: (feedEntry as BookListPublishFeedEntry).bookListName,
              onTap: () => _goToBookListDetailsScreen(
                context,
                feedEntry as BookListPublishFeedEntry,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            DateFormat("dd MMMM yyyy, HH:mm", context.locale).format(
              feedEntry.issuedAt,
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorGray,
                ),
          )
        ],
      ),
    );
  }

  String get descriptionText {
    if (feedEntry is BookListPublishFeedEntry) {
      return "bir kitap listesi paylaştı";
    } else {
      return "";
    }
  }

  Widget? getDetailsWidget(BuildContext context, BaseFeedEntry entry) {
    if (entry is BookListPublishFeedEntry) {
      return BookListCard(
        listTitle: entry.bookListName,
        onTap: () => _goToBookListDetailsScreen(context, entry),
      );
    } else {
      return null;
    }
  }

  void goToUserDetailsScreen(BuildContext context) {
    context.navigateTo(ProfileScreen(
      userId: feedEntry.issuerUserId,
    ));
  }

  void _goToBookListDetailsScreen(
    BuildContext context,
    BookListPublishFeedEntry entry,
  ) {
    context.navigateTo(BookListScreen(
      bookListId: entry.bookListId,
      cachedListName: entry.bookListName,
      cacheIsFavoritesList: false,
    ));
  }
}
