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
    );
  }

  void changeNavItem(CustomBottomNavbarItem item) {
    setState(() {
      selectedItem = item;
    });
  }
}
