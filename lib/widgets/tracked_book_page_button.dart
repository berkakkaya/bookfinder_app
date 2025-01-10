import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/consts/custom_icons.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:flutter/material.dart";

class TrackedBookPageButton extends StatelessWidget {
  final void Function() onTap;

  const TrackedBookPageButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: colorPurple,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CustomIcons.circlesRounded,
              size: 24,
              color: colorWhite,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                "Takip altındaki kitaplarınız",
                style: context.theme.textTheme.titleMedium?.copyWith(
                  color: colorWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
