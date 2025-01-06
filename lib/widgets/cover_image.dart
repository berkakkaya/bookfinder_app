import "dart:ui";

import "package:flutter/material.dart";

class CoverImage extends StatelessWidget {
  final ImageProvider imageProvider;
  final double borderRadius;
  final BoxFit fit;
  final bool addBlurredShadow;
  final double shadowDownscale;
  final String? heroTag;

  const CoverImage({
    super.key,
    required this.imageProvider,
    this.borderRadius = 16,
    this.fit = BoxFit.cover,
    this.addBlurredShadow = false,
    this.shadowDownscale = 3,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final imageContent = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black26,
          width: 1.5,
        ),
        image: DecorationImage(
          image: imageProvider,
          fit: fit,
        ),
      ),
    );

    if (!addBlurredShadow) {
      if (heroTag != null) {
        return Hero(
          tag: heroTag!,
          child: imageContent,
        );
      } else {
        return imageContent;
      }
    }

    return Stack(
      children: [
        Positioned.fill(
          top: shadowDownscale,
          left: shadowDownscale,
          right: shadowDownscale,
          bottom: shadowDownscale,
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 15,
                sigmaY: 15,
              ),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: heroTag != null
              ? Hero(
                  tag: heroTag!,
                  child: imageContent,
                )
              : imageContent,
        ),
      ],
    );
  }
}
