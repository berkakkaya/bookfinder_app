import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/snackbars.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/library_models.dart";
import "package:bookfinder_app/services/api/api_service_provider.dart";
import "package:bookfinder_app/services/logging/logging_service_provider.dart";
import "package:bookfinder_app/utils/auth_utils.dart";
import "package:bookfinder_app/widgets/book_list_card.dart";
import "package:bookfinder_app/widgets/create_list_modal_sheet.dart";
import "package:bookfinder_app/widgets/tracked_book_page_button.dart";
import "package:flutter/material.dart";

class LibraryTab extends StatefulWidget {
  const LibraryTab({super.key});

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  List<BookListItem>? bookListItems;
  bool hasError = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        getBookListItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    late Widget child;

    if (hasError) {
      child = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Kitap listeleriniz getirilirken bir hata oluştu."),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                setState(() {
                  hasError = false;
                });

                getBookListItems();
              },
              child: Text("Tekrar Dene"),
            ),
          ],
        ),
      );
    } else if (bookListItems == null) {
      child = Center(child: CircularProgressIndicator());
    } else {
      child = RefreshIndicator(
        onRefresh: getBookListItems,
        child: ListView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 32,
            bottom: 96,
          ),
          children: [
            Text(
              "Kütüphanem",
              style: context.theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 96),
            TrackedBookPageButton(onTap: goToTrackedBooksScreen),
            const SizedBox(height: 36),
            for (final bookListItem in bookListItems!) ...[
              BookListCard(
                listItem: bookListItem,
                onTap: () => goToBookListScreen(bookListItem),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createNewListPressed,
        label: Text("Yeni Liste"),
        icon: Icon(Icons.add_rounded),
      ),
    );
  }

  Future<void> createNewListPressed() async {
    ({String listName, bool isPublic})? result;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CreateListModalSheet(
        onSuccess: (listName, isPublic) {
          result = (listName: listName, isPublic: isPublic);
          context.navigateBack();
        },
      ),
    );

    if (result == null) return;

    final response = await withAuth((authHeader) {
      return ApiServiceProvider.i.library.createBookList(
        title: result!.listName,
        isPrivate: result!.isPublic == false,
        authHeader: authHeader,
      );
    });

    if (response.status != ResponseStatus.created) {
      LoggingServiceProvider.i.error(
        "Failed to create book list. Status: ${response.status}",
      );

      if (mounted) {
        context.showSnackbar(
          "Kitap listesi oluşturulamadı.",
          type: SnackbarType.error,
        );
      }

      return;
    }

    if (mounted) {
      getBookListItems();
    }
  }

  Future<void> getBookListItems() async {
    final response = await withAuth((authHeader) {
      return ApiServiceProvider.i.library.getBookLists(authHeader: authHeader);
    });

    if (response.status != ResponseStatus.ok) {
      LoggingServiceProvider.i.error(
        "Failed to get book list items. Status: ${response.status}",
      );

      if (mounted) {
        context.showSnackbar(
          "Kitap listeleri alınamadı.",
          type: SnackbarType.error,
        );

        setState(() {
          bookListItems = null;
          hasError = true;
        });
      }

      return;
    }

    assert(
      response.data != null,
      "Book list items should not be null when response status is ok.",
    );

    if (mounted) {
      setState(() {
        bookListItems = response.data!;
        hasError = false;
      });
    }
  }

  void goToTrackedBooksScreen() {
    // TODO: Implement navigation to TrackedBooksScreen
  }

  void goToBookListScreen(BookListItem bookListItem) {
    // TODO: Implement navigation to BookListDetailsScreen
  }
}
