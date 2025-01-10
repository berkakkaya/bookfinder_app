import "package:bookfinder_app/controllers/explore_recommendation_controller.dart";
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
      body: PageView.builder(
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
    );
  }
}
