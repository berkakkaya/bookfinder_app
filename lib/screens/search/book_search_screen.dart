import "package:bookfinder_app/widgets/custom_bottom_navbar.dart";
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
  Widget build(BuildContext context) {
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
                  ),
                  onTapOutside: (event) {
                    widget.searchFieldFocusNode.unfocus();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavbar(
        selectedItem: CustomBottomNavbarItem.home,
        customIcon: Icon(Icons.search_rounded),
        customTitle: "Kitap Ara",
      ),
    );
  }
}
