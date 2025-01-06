import "dart:async";

import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/snackbars.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/bookdata_models.dart";
import "package:bookfinder_app/screens/book_details/book_details_screen.dart";
import "package:bookfinder_app/services/api/api_service_provider.dart";
import "package:bookfinder_app/utils/auth_utils.dart" as auth_utils;
import "package:bookfinder_app/widgets/cover_image.dart";
import "package:bookfinder_app/widgets/custom_bottom_navbar.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

class BookSearchScreen extends StatefulWidget {
  final FocusNode searchFieldFocusNode;

  const BookSearchScreen({
    super.key,
    required this.searchFieldFocusNode,
  });

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  Timer? _searchDebounce;
  List<BookSearchResult>? searchResults;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        FocusScope.of(context).requestFocus(widget.searchFieldFocusNode);
      }
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final Widget content;

    if (searchResults == null) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.search_rounded, size: 64, color: Colors.black38),
            SizedBox(height: 16),
            Text(
              "Arama yapmak için bir şeyler yazın.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else if (searchResults!.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.search_rounded, size: 64, color: Colors.black38),
            SizedBox(height: 16),
            Text(
              "Arama sonucu bulunamadı. Lütfen başka bir şey deneyin.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      content = Column(
        children: searchResults!.map((e) {
          return ListTile(
            onTap: () => goToBookDetailsScreen(e.bookId, e.thumbnailUrl),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            leading: AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: e.thumbnailUrl,
                fit: BoxFit.fitHeight,
                progressIndicatorBuilder: (context, url, progress) {
                  return Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return const Icon(
                    Icons.error,
                    size: 64,
                    color: colorLightBlack,
                  );
                },
                imageBuilder: (_, imageProvider) => CoverImage(
                  imageProvider: imageProvider,
                  borderRadius: 8,
                  heroTag: "bookCover:${e.bookId}",
                ),
                fadeInDuration: const Duration(milliseconds: 200),
                fadeOutDuration: const Duration(milliseconds: 200),
                placeholderFadeInDuration: const Duration(milliseconds: 200),
              ),
            ),
            title: Text(e.title),
          );
        }).toList(),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          children: [
            Hero(
              tag: "searchField",
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  focusNode: widget.searchFieldFocusNode,
                  decoration: InputDecoration(
                    hintText: "Bir kitap arayın",
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    suffixIcon: isSearching
                        ? Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: const CircularProgressIndicator(),
                          )
                        : null,
                    suffixIconConstraints: const BoxConstraints(
                      maxHeight: 16,
                      maxWidth: 32,
                    ),
                  ),
                  onTapOutside: (event) {
                    widget.searchFieldFocusNode.unfocus();
                  },
                  onChanged: _onSearchFieldChanged,
                ),
              ),
            ),
            const SizedBox(height: 32),
            content,
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavbar(
        key: ValueKey("SearchBottomNavbar"),
        selectedItem: CustomBottomNavbarItem.home,
        customIcon: Icon(Icons.search_rounded),
        customTitle: "Kitap Ara",
      ),
    );
  }

  void _onSearchFieldChanged(String value) {
    if (_searchDebounce?.isActive ?? false) {
      _searchDebounce?.cancel();
    }

    if (value.length < 3) {
      setState(() {
        searchResults = null;
      });

      return;
    }

    _searchDebounce = Timer(
      const Duration(milliseconds: 300),
      () => _onSearchFieldSubmitted(value),
    );
  }

  void goToBookDetailsScreen(String bookId, String thumbnailUrl) {
    context.navigateTo(BookDetailsScreen(
      bookId: bookId,
      thumbnailUrl: thumbnailUrl,
    ));
  }

  Future<void> _onSearchFieldSubmitted(String value) async {
    setState(() {
      isSearching = true;
    });

    final result = await auth_utils.withAuth(
      (authHeader) => ApiServiceProvider.i.bookDatas.searchBooks(
        value,
        authHeader: authHeader,
      ),
    );

    if (![ResponseStatus.ok, ResponseStatus.notFound].contains(result.status)) {
      if (mounted) {
        setState(() {
          isSearching = false;
          searchResults = null;
        });

        context.showSnackbar(
          "Arama sırasında bir hata oluştu.",
          type: SnackbarType.error,
        );
      }

      return;
    }

    if (mounted) {
      setState(() {
        isSearching = false;
        searchResults =
            result.status == ResponseStatus.notFound ? [] : result.data;
      });
    }
  }
}
