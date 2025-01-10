import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/models/book_tracking_models.dart";
import "package:bookfinder_app/screens/book_details/book_details_screen.dart";
import "package:bookfinder_app/widgets/outlined_circle.dart";
import "package:flutter/material.dart";

class SetBookTrackingModalSheet extends StatelessWidget {
  static const double circleSize = 24;
  static const double borderWidth = 1.3;
  static const Color borderColor = colorLightBlack;

  const SetBookTrackingModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Kitabı takip et",
            style: context.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListTile(
          title: Text("Takipten çıkar"),
          leading: OutlinedCircle(
            backgroundColor: Colors.transparent,
            size: circleSize,
            borderWidth: borderWidth,
            borderColor: borderColor,
          ),
          onTap: () {
            Navigator.of(context).pop<BookTrackingStatusChoice>(
              (choice: null),
            );
          },
        ),
        ListTile(
          title: Text("Okunacak"),
          leading: OutlinedCircle(
            backgroundColor: colorBlue,
            size: circleSize,
            borderWidth: borderWidth,
            borderColor: borderColor,
          ),
          onTap: () {
            Navigator.of(context).pop<BookTrackingStatusChoice>(
              (choice: BookTrackingStatus.willRead),
            );
          },
        ),
        ListTile(
          title: Text("Devam ediliyor"),
          leading: OutlinedCircle(
            backgroundColor: colorOrange,
            size: circleSize,
            borderWidth: borderWidth,
            borderColor: borderColor,
          ),
          onTap: () {
            Navigator.of(context).pop<BookTrackingStatusChoice>(
              (choice: BookTrackingStatus.reading),
            );
          },
        ),
        ListTile(
          title: Text("Tamamlandı"),
          leading: OutlinedCircle(
            backgroundColor: colorGreen,
            size: circleSize,
            borderWidth: borderWidth,
            borderColor: borderColor,
          ),
          onTap: () {
            Navigator.of(context).pop<BookTrackingStatusChoice>(
              (choice: BookTrackingStatus.completed),
            );
          },
        ),
        ListTile(
          title: Text("Bırakıldı"),
          leading: OutlinedCircle(
            backgroundColor: colorRed,
            size: circleSize,
            borderWidth: borderWidth,
            borderColor: borderColor,
          ),
          onTap: () {
            Navigator.of(context).pop<BookTrackingStatusChoice>(
              (choice: BookTrackingStatus.dropped),
            );
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
