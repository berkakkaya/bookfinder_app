import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/snackbars.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/feed_models.dart";
import "package:bookfinder_app/screens/search/book_search_screen.dart";
import "package:bookfinder_app/services/api/api_service_provider.dart";
import "package:bookfinder_app/services/logging/logging_service_provider.dart";
import "package:bookfinder_app/utils/auth_utils.dart";
import "package:bookfinder_app/widgets/feed_entry_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

class HomepageTab extends StatefulWidget {
  const HomepageTab({super.key});

  @override
  State<HomepageTab> createState() => _HomepageTabState();
}

class _HomepageTabState extends State<HomepageTab> {
  final searchbarFocusNode = FocusNode();
  final scrollController = ScrollController();
  bool showFeedsFromOtherUsers = false;

  Future<List<BaseFeedEntry>?>? _feedsFuture;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        _feedsFuture = getFeeds();
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    searchbarFocusNode.dispose();
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _feedsFuture,
          builder: (context, snapshot) {
            final isLoading =
                snapshot.connectionState == ConnectionState.waiting;
            final data = snapshot.data;

            return CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Text(
                      "Bookfinder",
                      style: context.theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 32,
                    ),
                    child: Hero(
                      tag: "searchField",
                      child: Material(
                        color: Colors.transparent,
                        child: TextField(
                          readOnly: true,
                          onTap: goToSearchScreen,
                          decoration: InputDecoration(
                            hintText: "Bir kitap arayın",
                            prefixIcon: const Icon(Icons.search_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverFloatingHeader(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 32,
                    ),
                    color: context.theme.scaffoldBackgroundColor,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: Text("Takip Ettiklerim"),
                          selected: !showFeedsFromOtherUsers,
                          onSelected: (_) => changeActivityType(
                            showFeedsFromOtherUsers: false,
                          ),
                        ),
                        ChoiceChip(
                          label: Text("Herkes"),
                          selected: showFeedsFromOtherUsers,
                          onSelected: (_) => changeActivityType(
                            showFeedsFromOtherUsers: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isLoading)
                  SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (data == null)
                  SliverFillRemaining(
                    child: Center(
                      child: Text("Aktiviteler yüklenirken bir hata oluştu."),
                    ),
                  )
                else if (data.isEmpty)
                  SliverFillRemaining(
                    child: _getEmptyFeedWidget(context),
                  )
                else
                  SliverList.separated(
                    itemCount: data.length,
                    itemBuilder: (context, i) => FeedEntryWidget(
                      feedEntry: data[i],
                    ),
                    separatorBuilder: (context, i) => const Divider(),
                  ),
                if (data != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "Aktivitelerin sonu",
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color: colorGray,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
    );
  }

  Padding _getEmptyFeedWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Expanded(
              flex: 5,
              child: SvgPicture.asset(
                "assets/illustrations/book_reading.svg",
              ),
            ),
            SizedBox(height: 32),
            Text(
              "Aktiviteniz boş görünüyor",
              style: context.theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              "Başkalarını takip ettikçe onların aktivitelerini bu sayfada göreceksiniz.",
              textAlign: TextAlign.center,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Future<List<BaseFeedEntry>?> getFeeds() async {
    final response = await withAuth((authHeader) {
      return ApiServiceProvider.i.feed.getFeedEntries(
        fetchUpdatesFromOthers: showFeedsFromOtherUsers,
        authHeader: authHeader,
      );
    });

    if (response.status != ResponseStatus.ok) {
      LoggingServiceProvider.i.error(
        "Failed to fetch feeds: ${response.status}",
      );

      if (mounted) {
        context.showSnackbar(
          "Aktiviteler yüklenirken bir hata oluştu.",
          type: SnackbarType.error,
        );
      }

      return null;
    }

    assert(
      response.data != null,
      "Response status is OK but data is null",
    );

    return response.data!;
  }

  void changeActivityType({required bool showFeedsFromOtherUsers}) {
    setState(() {
      this.showFeedsFromOtherUsers = showFeedsFromOtherUsers;
      scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
      _feedsFuture = getFeeds();
    });
  }

  void goToSearchScreen() {
    context.navigateTo(
      BookSearchScreen(searchFieldFocusNode: searchbarFocusNode),
      animation: TransitionAnimationType.fadeThrough,
    );
  }
}
