import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/consts/custom_icons.dart";
import "package:bookfinder_app/consts/navigator_key.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:flutter/material.dart";

enum CustomBottomNavbarItem {
  home,
  explore,
  library,
  profile,
}

class CustomBottomNavbar extends StatelessWidget {
  final CustomBottomNavbarItem selectedItem;
  final String? customTitle;
  final bool? overrideBackButtonEnabled;
  final bool disableSubpageSelections;
  final void Function(CustomBottomNavbarItem)? onItemSelected;

  const CustomBottomNavbar({
    super.key,
    required this.selectedItem,
    this.customTitle,
    this.overrideBackButtonEnabled,
    this.disableSubpageSelections = false,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool backButtonEnabled = overrideBackButtonEnabled ??
        navigatorKey.currentState?.canPop() ??
        false;

    final String label = customTitle ??
        switch (selectedItem) {
          CustomBottomNavbarItem.home => "Ana Sayfa",
          CustomBottomNavbarItem.explore => "Keşfet",
          CustomBottomNavbarItem.library => "Kütüphane",
          CustomBottomNavbarItem.profile => "Profil",
        };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        color: colorWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (backButtonEnabled) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.navigateBack(),
            ),
            const SizedBox(width: 16),
          ],
          _PrimaryItemChip(
            currentItem: selectedItem,
            label: label,
          ),
          const Spacer(),
          if (!disableSubpageSelections) ...[
            IconButton(
              icon: const Icon(CustomIcons.homeOutlineRounded),
              tooltip: "Ana Sayfa",
              onPressed: () => selectedItem == CustomBottomNavbarItem.home
                  ? null
                  : onItemSelected?.call(CustomBottomNavbarItem.home),
            ),
            IconButton(
              icon: const Icon(CustomIcons.overviewKeyOutlineRounded),
              tooltip: "Keşfet",
              onPressed: () => selectedItem == CustomBottomNavbarItem.explore
                  ? null
                  : onItemSelected?.call(CustomBottomNavbarItem.explore),
            ),
            IconButton(
              icon: const Icon(CustomIcons.book5OutlineRounded),
              tooltip: "Kütüphane",
              onPressed: () => selectedItem == CustomBottomNavbarItem.library
                  ? null
                  : onItemSelected?.call(CustomBottomNavbarItem.library),
            ),
            IconButton(
              icon: const Icon(Icons.person_outline_rounded),
              tooltip: "Profil",
              onPressed: () => selectedItem == CustomBottomNavbarItem.profile
                  ? null
                  : onItemSelected?.call(CustomBottomNavbarItem.profile),
            ),
          ],
        ],
      ),
    );
  }
}

class _PrimaryItemChip extends StatelessWidget {
  final CustomBottomNavbarItem currentItem;
  final String label;

  const _PrimaryItemChip({
    required this.currentItem,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final Icon icon = switch (currentItem) {
      CustomBottomNavbarItem.home => const Icon(Icons.home_rounded),
      CustomBottomNavbarItem.explore =>
        const Icon(CustomIcons.overviewKeyRounded),
      CustomBottomNavbarItem.library => const Icon(CustomIcons.book5Rounded),
      CustomBottomNavbarItem.profile => const Icon(Icons.person_rounded),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorLightBlack,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconTheme(
            data: const IconThemeData(
              color: colorWhite,
              size: 24,
            ),
            child: icon,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: colorWhite,
            ),
          ),
        ],
      ),
    );
  }
}
