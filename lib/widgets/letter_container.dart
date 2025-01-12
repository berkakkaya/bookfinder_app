import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/lists.dart";
import "package:bookfinder_app/extensions/strings.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/utils/convert_utils.dart";
import "package:flutter/material.dart";

class LetterContainer extends StatelessWidget {
  final String text;
  final double size;
  final Widget? contentOverride;
  final Color? colorOverride;
  final int? randomSeed;
  final String? heroTag;

  const LetterContainer({
    super.key,
    required this.text,
    required this.size,
    this.contentOverride,
    this.colorOverride,
    this.randomSeed,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
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
                fontSize: size / 3,
              ),
            ),
      ),
    );

    return heroTag != null ? Hero(tag: heroTag!, child: content) : content;
  }

  Color pickRandomColor() {
    final seed = generateSeedFromString(text);

    return [
      colorBlue,
      colorGreen,
      colorPurple,
      colorRed,
      colorOrange,
    ].pickRandom(1, seed: seed).first;
  }
}
