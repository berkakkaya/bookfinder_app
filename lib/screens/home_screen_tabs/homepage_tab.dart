import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/screens/search/book_search_screen.dart";
import "package:flutter/material.dart";

class HomepageTab extends StatefulWidget {
  const HomepageTab({super.key});

  @override
  State<HomepageTab> createState() => _HomepageTabState();
}

class _HomepageTabState extends State<HomepageTab> {
  final searchbarFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        children: [
          Text(
            "Bookfinder",
            style: context.theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 96),
          Hero(
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
        ],
      ),
    );
  }

  void goToSearchScreen() {
    context.navigateTo(
      BookSearchScreen(searchFieldFocusNode: searchbarFocusNode),
      animation: TransitionAnimationType.fadeThrough,
    );
  }
}
