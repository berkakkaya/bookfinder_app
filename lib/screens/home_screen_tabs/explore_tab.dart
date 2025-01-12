import "dart:isolate";

import "package:bookfinder_app/controllers/explore_recommendation_controller.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/models/book_category_type.dart";
import "package:bookfinder_app/widgets/book_recommendation_subpage.dart";
import "package:flutter/material.dart";

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final recommendationController = ExploreRecommendationController();
  final pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: ActionChip(
                label: Text(
                  recommendationController.selectedCategory != null
                      ? convertBookCategoryToDisplayStr(
                          recommendationController.selectedCategory!,
                        )
                      : "Kategori Seç",
                ),
                avatar: Icon(Icons.filter_alt_outlined),
                onPressed: changeCategoryFilter,
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return BookRecommendationSubpage(
                    recommendationFuture:
                        recommendationController.getNextRecommendation(),
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> changeCategoryFilter() async {
    bool userMadeSelection = false;

    final Future<List<({BookCategory category, String displayStr})>>
        optionsFuture = Isolate.run(
      () {
        return BookCategory.values.map((category) {
          return (
            category: category,
            displayStr: convertBookCategoryToDisplayStr(category),
          );
        }).toList();
      },
    );

    final BookCategory? newCategory = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: FutureBuilder(
              future: optionsFuture,
              builder: (context, snapshot) {
                final options = snapshot.data;

                if (options == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Kategori Seç",
                      style: context.theme.textTheme.titleLarge,
                    ),
                    SizedBox(height: 24),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ActionChip(
                          label: Text("Filtreyi Kaldır"),
                          onPressed: () {
                            userMadeSelection = true;
                            Navigator.of(context).pop(null);
                          },
                        ),
                        ...options.map(
                          (o) => ActionChip(
                            label: Text(o.displayStr),
                            onPressed: () {
                              userMadeSelection = true;
                              Navigator.of(context).pop(o.category);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
        );
      },
    );

    if (!userMadeSelection) return;

    setState(() {
      recommendationController.forceFetchNewRecommendations(newCategory);
      pageController.jumpToPage(0);
    });
  }
}
