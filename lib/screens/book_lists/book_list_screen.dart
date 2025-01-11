import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/snackbars.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/library_models.dart";
import "package:bookfinder_app/models/user_models.dart";
import "package:bookfinder_app/screens/book_details/book_details_screen.dart";
import "package:bookfinder_app/services/api/api_service_provider.dart";
import "package:bookfinder_app/services/logging/logging_service_provider.dart";
import "package:bookfinder_app/utils/auth_utils.dart";
import "package:bookfinder_app/widgets/cards/book_card.dart";
import "package:bookfinder_app/widgets/custom_bottom_navbar.dart";
import "package:bookfinder_app/widgets/letter_container.dart";
import "package:flutter/material.dart";

class BookListScreen extends StatefulWidget {
  final BookListItem preitem;

  const BookListScreen({
    super.key,
    required this.preitem,
  });

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  Future<BookListItemWithBooks?>? _bookListFetchFuture;
  Future<User?>? _userFetchFuture;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _bookListFetchFuture = getBooksInsideList();
          _userFetchFuture = getUser();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _bookListFetchFuture,
        builder: (context, snapshot) {
          final BookListItemWithBooks? bookList = snapshot.data;
          final int bookCount = bookList?.bookCount ?? widget.preitem.bookCount;
          final bool isPrivate =
              bookList?.isPrivate ?? widget.preitem.isPrivate;

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _getPageHeader(
                    bookList,
                    context,
                    bookCount,
                    isPrivate,
                  ),
                ),
                if (snapshot.connectionState == ConnectionState.waiting)
                  SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (bookList == null)
                  SliverFillRemaining(
                    child: Center(
                      child: Text("Kitap listesi alınamadı."),
                    ),
                  )
                else if (bookCount == 0)
                  SliverFillRemaining(
                    child: _getEmptyListIndicator(context),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    sliver: SliverList.separated(
                      itemCount: bookList.books.length,
                      itemBuilder: (context, index) => BookCard(
                        title: bookList.books[index].title,
                        authors: bookList.books[index].authors.join(", "),
                        thumbnailUrl: bookList.books[index].thumbnailUrl,
                        heroTag:
                            "book_list_screen_item:${bookList.books[index].bookId}",
                        onTap: () => goToBookDetailScreen(
                          bookList.books[index],
                          "book_list_screen_item:${bookList.books[index].bookId}",
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline_rounded),
                          onPressed: () => removeBookFromList(
                            bookList.books[index],
                          ),
                        ),
                      ),
                      separatorBuilder: (context, i) =>
                          const SizedBox(height: 16),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavbar(
        key: const Key("book_list_custom_bottom_navbar"),
        selectedItem: CustomBottomNavbarItem.library,
        customTitle: "Kitap Listesi",
        customIcon: Icon(Icons.bookmark_rounded),
      ),
    );
  }

  Padding _getEmptyListIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              "Henüz bu listede bir kitap yok.",
              style: context.theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              "Birkaç kitap ekledikten sonra buraya tekrar uğrayın.",
              textAlign: TextAlign.center,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Padding _getPageHeader(
    BookListItemWithBooks? bookList,
    BuildContext context,
    int bookCount,
    bool isPrivate,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        top: 64,
        left: 16,
        right: 16,
        bottom: 96,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LetterContainer(
            text: bookList?.title ?? widget.preitem.title,
            size: 160,
            colorOverride:
                widget.preitem.internalTitle == "_likedBooks" ? colorRed : null,
            contentOverride: widget.preitem.internalTitle == "_likedBooks"
                ? const Icon(
                    Icons.favorite_rounded,
                    color: colorWhite,
                    size: 64,
                  )
                : null,
          ),
          SizedBox(height: 32),
          Text(
            bookList?.title ?? widget.preitem.title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          FutureBuilder(
            future: _userFetchFuture,
            builder: (context, snapshot) {
              final User? user = snapshot.data;
              final isLoading =
                  snapshot.connectionState == ConnectionState.waiting;

              return Text(
                isLoading
                    ? "Sahip bilgisi alınıyor..."
                    : user == null
                        ? "Sahip bilgisi alınamadı"
                        : user.nameSurname,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorGray,
                    ),
                textAlign: TextAlign.center,
              );
            },
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "$bookCount kitap",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: colorGray),
              ),
              const SizedBox(width: 8),
              Text(
                "⦁",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: colorGray),
              ),
              const SizedBox(width: 8),
              Icon(
                isPrivate ? Icons.lock_outline_rounded : Icons.public_rounded,
                color: colorGray,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                isPrivate ? "Gizli" : "Herkese Açık",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: colorGray),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<BookListItemWithBooks?> getBooksInsideList() async {
    final response = await withAuth((authHeader) {
      return ApiServiceProvider.i.library.getBookList(
        widget.preitem.internalTitle == "_likedBooks"
            ? "_likedBooks"
            : widget.preitem.bookListId,
        authHeader: authHeader,
      );
    });

    if (response.status != ResponseStatus.ok) {
      LoggingServiceProvider.i.error(
        "Failed to get book list with books inside. (${response.status})",
      );

      if (mounted) {
        context.showSnackbar(
          "Kitap listesi alınamadı.",
          type: SnackbarType.error,
        );
      }

      return null;
    }

    assert(
      response.data != null,
      "Response data can't be null when status is ok.",
    );

    return response.data!;
  }

  Future<User?> getUser() async {
    final response = await withAuth((authHeader) {
      return ApiServiceProvider.i.users.getUser(
        widget.preitem.internalTitle == "_likedBooks"
            ? null
            : widget.preitem.authorId,
        authHeader: authHeader,
      );
    });

    if (response.status != ResponseStatus.ok) {
      LoggingServiceProvider.i.error(
        "Failed to get user with ID ${widget.preitem.authorId}. (${response.status})",
      );

      if (mounted) {
        context.showSnackbar(
          "Kitap listesi sahip bilgisi alınamadı.",
          type: SnackbarType.error,
        );
      }

      return null;
    }

    assert(
      response.data != null,
      "Response data can't be null when status is ok.",
    );

    return response.data!;
  }

  void goToBookDetailScreen(BookListBookItem listItem, String heroTag) {
    context.navigateTo(BookDetailsScreen(
      bookId: listItem.bookId,
      thumbnailUrl: listItem.thumbnailUrl,
      heroTag: heroTag,
    ));
  }

  Future<void> removeBookFromList(BookListBookItem bookItem) async {
    final bool? userConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Kitabı listeden çıkar",
        ),
        content: Text(
          '"${bookItem.title}" adlı kitabı listeden çıkarmak istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("İptal"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              "Çıkar",
              style: TextStyle(color: colorRed),
            ),
          ),
        ],
      ),
    );

    if (userConfirmed != true) return;

    final response = await withAuth((authHeader) {
      return ApiServiceProvider.i.library.removeBookFromList(
        widget.preitem.internalTitle == "_likedBooks"
            ? "_likedBooks"
            : widget.preitem.bookListId,
        bookId: bookItem.bookId,
        authHeader: authHeader,
      );
    });

    if (![
      ResponseStatus.ok,
      ResponseStatus.notFound,
    ].contains(response.status)) {
      LoggingServiceProvider.i.error(
        "Failed to remove book from list. (${response.status})",
      );

      if (mounted) {
        context.showSnackbar(
          "Kitap listeden çıkarılamadı.",
          type: SnackbarType.error,
        );
      }

      return;
    }

    if (response.status == ResponseStatus.notFound) {
      LoggingServiceProvider.i.warning(
        "Book not found in list with ID ${widget.preitem.bookListId}. Book ID: ${bookItem.bookId}",
      );
    }

    if (mounted) {
      context.showSnackbar(
        "Kitap listeden çıkarıldı.",
        type: SnackbarType.success,
      );

      setState(() {
        _bookListFetchFuture = getBooksInsideList();
      });
    }
  }
}
