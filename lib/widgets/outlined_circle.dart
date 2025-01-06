import "package:bookfinder_app/consts/colors.dart";
import "package:flutter/material.dart";

class OutlinedCircle extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final double size;
  final double borderWidth;

  const OutlinedCircle({
    super.key,
    required this.backgroundColor,
    this.borderColor = colorLightBlack,
    required this.size,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
    );
  }
}
