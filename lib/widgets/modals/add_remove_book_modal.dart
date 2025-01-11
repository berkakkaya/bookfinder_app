import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/snackbars.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/library_models.dart";
import "package:bookfinder_app/services/api/api_service_provider.dart";
import "package:bookfinder_app/services/logging/logging_service_provider.dart";
import "package:bookfinder_app/utils/auth_utils.dart";
import "package:bookfinder_app/widgets/letter_container.dart";
import "package:flutter/material.dart";

class AddRemoveBookModal extends StatelessWidget {
  final String bookId;
  final List<(BookListItem, bool)> bookContainStatus;

  const AddRemoveBookModal({
    super.key,
    required this.bookId,
    required this.bookContainStatus,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Listeme Ekle",
            style: context.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16),
        for (var (bookList, doesContain) in bookContainStatus)
          CheckboxListTile(
            value: doesContain,
            onChanged: (value) =>
                changeBookListStatus(context, bookList, value!),
            contentPadding: const EdgeInsets.all(16),
            secondary: LetterContainer(
              text: bookList.title,
              size: 48,
              randomSeed: bookList.title.hashCode,
              colorOverride:
                  bookList.internalTitle == "_likedBooks" ? colorRed : null,
              contentOverride: bookList.internalTitle == "_likedBooks"
                  ? Icon(Icons.favorite_rounded, color: colorWhite)
                  : null,
            ),
            title: Text(bookList.title),
          ),
        SizedBox(height: 16),
      ],
    );
  }

  Future<void> changeBookListStatus(
    BuildContext context,
    BookListItem bookList,
    bool value,
  ) async {
    final res = await withAuth<void>(
      (authHeader) {
        if (value == true) {
          return ApiServiceProvider.i.library.addBookToList(
            bookList.internalTitle == "_likedBooks"
                ? "_likedBooks"
                : bookList.bookListId,
            bookId: bookId,
            authHeader: authHeader,
          );
        }

        return ApiServiceProvider.i.library.removeBookFromList(
          bookList.internalTitle == "_likedBooks"
              ? "_likedBooks"
              : bookList.bookListId,
          bookId: bookId,
          authHeader: authHeader,
        );
      },
    );

    if (![
      ResponseStatus.ok,
      ResponseStatus.created,
    ].contains(res.status)) {
      LoggingServiceProvider.i.error(
        "Failed to add/remove book from list (response: ${res.status})",
      );

      if (context.mounted) {
        context.showSnackbar(
          "İstenilen işlem başarısız oldu.",
          type: SnackbarType.error,
        );
      }

      return;
    }

    if (context.mounted) {
      context.showSnackbar(
        value == true ? "Kitap listeye eklendi." : "Kitap listeden çıkarıldı.",
        type: SnackbarType.success,
      );

      context.navigateBack();
    }
  }
}
