import "package:bookfinder_app/screens/home_screen_tabs/explore_tab.dart";
import "package:bookfinder_app/screens/home_screen_tabs/homepage_tab.dart";
import "package:bookfinder_app/screens/home_screen_tabs/library_tab.dart";
import "package:bookfinder_app/screens/home_screen_tabs/profile_tab.dart";
import "package:bookfinder_app/widgets/custom_bottom_navbar.dart";
import "package:flutter/material.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CustomBottomNavbarItem selectedItem = CustomBottomNavbarItem.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavbar(
        selectedItem: selectedItem,
        onItemSelected: changeNavItem,
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: switch (selectedItem) {
            CustomBottomNavbarItem.home => const HomepageTab(
                key: ValueKey("HomepageTab"),
              ),
            CustomBottomNavbarItem.library => const LibraryTab(
                key: ValueKey("LibraryTab"),
              ),
            CustomBottomNavbarItem.explore => const ExploreTab(
                key: ValueKey("ExploreTab"),
              ),
            CustomBottomNavbarItem.profile => const ProfileTab(
                key: ValueKey("ProfileTab"),
              ),
          },
        ),
      ),
    );
  }

  void changeNavItem(CustomBottomNavbarItem item) {
    setState(() {
      selectedItem = item;
    });
  }
}
