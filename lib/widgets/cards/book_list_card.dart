import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/widgets/letter_container.dart";
import "package:flutter/material.dart";

class BookListCard extends StatelessWidget {
  final String listTitle;
  final String? internalTitle;

  final ({
    int bookCount,
    bool isPrivate,
  })? details;

  final void Function() onTap;

  const BookListCard({
    super.key,
    required this.onTap,
    required this.listTitle,
    this.internalTitle,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
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
          children: [
            LetterContainer(
              text: listTitle,
              size: 64,
              randomSeed: listTitle.hashCode,
              contentOverride: internalTitle == "_likedBooks"
                  ? Icon(
                      Icons.favorite,
                      color: colorWhite,
                      size: 32,
                    )
                  : null,
              colorOverride: internalTitle == "_likedBooks" ? colorRed : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (details != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${details!.bookCount} kitap",
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
                          details!.isPrivate
                              ? Icons.lock_outline
                              : Icons.public_rounded,
                          color: colorGray,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          details!.isPrivate ? "Gizli" : "Herkese Açık",
                          style: context.theme.textTheme.bodyMedium?.copyWith(
                            color: colorGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
