import "dart:math";

import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/strings.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:flutter/material.dart";

class LetterContainer extends StatelessWidget {
  final String text;
  final double size;
  final Widget? contentOverride;
  final Color? colorOverride;
  final int? randomSeed;

  const LetterContainer({
    super.key,
    required this.text,
    required this.size,
    this.contentOverride,
    this.colorOverride,
    this.randomSeed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorOverride ?? pickRandomColor(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: contentOverride ??
            Text(
              text.leadingLetters.take(2).join(),
              style: context.theme.textTheme.titleLarge?.copyWith(
                color: colorWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
    );
  }

  Color pickRandomColor() {
    final random = Random(randomSeed);

    final List<Color> colorChoices = [
      colorBlue,
      colorGreen,
      colorPurple,
      colorRed,
      colorOrange,
    ];

    return colorChoices[random.nextInt(colorChoices.length)];
  }
}
