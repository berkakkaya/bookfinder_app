import "package:bookfinder_app/screens/home_screen_tabs/explore_tab.dart";
import "package:bookfinder_app/screens/home_screen_tabs/homepage_tab.dart";
import "package:bookfinder_app/screens/home_screen_tabs/library_tab.dart";
import "package:bookfinder_app/screens/profile/profile_screen.dart";
import "package:bookfinder_app/widgets/custom_bottom_navbar.dart";
import "package:bookfinder_app/widgets/tab_container.dart";
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
        key: const ValueKey("HomeBottomNavbar"),
        selectedItem: selectedItem,
        onItemSelected: changeNavItem,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            TabContainer(
              key: const ValueKey("HomeTab"),
              selected: selectedItem == CustomBottomNavbarItem.home,
              child: const HomepageTab(),
            ),
            TabContainer(
              key: const ValueKey("ExploreTab"),
              selected: selectedItem == CustomBottomNavbarItem.explore,
              child: const ExploreTab(),
            ),
            TabContainer(
              key: const ValueKey("LibraryTab"),
              selected: selectedItem == CustomBottomNavbarItem.library,
              child: const LibraryTab(),
            ),
            TabContainer(
              key: const ValueKey("ProfileTab"),
              selected: selectedItem == CustomBottomNavbarItem.profile,
              child: const ProfileScreen(
                userId: null,
                asTab: true,
              ),
            ),
          ],
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
