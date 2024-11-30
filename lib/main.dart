import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/screens/init_screen.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bookfinder",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: colorBackground,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.black,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(colorLightBlack),
            foregroundColor: const WidgetStatePropertyAll(colorBackground),
            padding: const WidgetStatePropertyAll(EdgeInsets.all(16)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            )),
            textStyle: WidgetStatePropertyAll(
              context.theme.textTheme.bodyLarge,
            ),
            overlayColor: const WidgetStatePropertyAll(Colors.white30),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: colorBlack,
              width: 2,
            ),
          ),
          floatingLabelStyle: context.theme.textTheme.bodyLarge,
          fillColor: colorWhite,
        ),
      ),
      home: const InitScreen(),
    );
  }
}
