import "dart:math";

import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/models/library_models.dart";
import "package:bookfinder_app/utils/parsing_utils.dart";
import "package:flutter/material.dart";

class BookListCard extends StatelessWidget {
  final BookListItem listItem;

  const BookListCard({
    super.key,
    required this.listItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
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
        spacing: 16,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: pickRandomColor(),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                parseLeadingLetters(listItem.title, count: 2),
                style: context.theme.textTheme.titleLarge?.copyWith(
                  color: colorWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listItem.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${listItem.bookCount} kitap",
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: colorGray,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "⦁",
                      style: TextStyle(color: colorGray),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      listItem.isPrivate
                          ? Icons.lock_outline
                          : Icons.public_rounded,
                      color: colorGray,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      listItem.isPrivate ? "Gizli" : "Herkese Açık",
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: colorGray,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color pickRandomColor() {
    final random = Random(listItem.bookListId.hashCode);

    final List<Color> colorChoices = [
      colorBlue,
      colorGreen,
      colorPurple,
      colorRed,
      colorOrange,
    ];

    return colorChoices[random.nextInt(colorChoices.length)];
  }
}
