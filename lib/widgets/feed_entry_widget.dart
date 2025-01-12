import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/strings.dart";
import "package:bookfinder_app/models/feed_models.dart";
import "package:flutter/material.dart";

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
    // TODO: Add feed entry type handling

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
              CircleAvatar(
                radius: 24,
                backgroundColor: colorGray,
                child: Text(
                  feedEntry.issuerNameSurname.leadingLetters.take(2).join(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorWhite,
                        fontWeight: FontWeight.bold,
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
                      "bir kitap listesi paylaştı",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorGray,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
