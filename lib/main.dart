import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/consts/navigator_key.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/screens/init_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/date_symbol_data_local.dart";

void main() async {
  await initializeDateFormatting("tr_TR");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bookfinder",
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("tr", "TR"),
      ],
      locale: const Locale("tr", "TR"),
      theme: ThemeData(
        colorSchemeSeed: colorLightBlack,
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: colorBackground,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.black,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) {
                if (states.contains(WidgetState.disabled)) {
                  return colorGray;
                }

                return colorLightBlack;
              },
            ),
            foregroundColor: const WidgetStatePropertyAll(colorBackground),
            iconColor: const WidgetStatePropertyAll(colorBackground),
            padding: const WidgetStatePropertyAll(EdgeInsets.all(16)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            )),
            textStyle: WidgetStatePropertyAll(
              context.theme.textTheme.bodyLarge,
            ),
            overlayColor: const WidgetStatePropertyAll(Colors.white24),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              return states.contains(WidgetState.disabled)
                  ? colorGray
                  : colorLightBlack;
            }),
            iconColor: WidgetStateProperty.resolveWith((states) {
              return states.contains(WidgetState.disabled)
                  ? colorGray
                  : colorLightBlack;
            }),
            padding: const WidgetStatePropertyAll(EdgeInsets.all(16)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            )),
            side: WidgetStateProperty.resolveWith(
              (states) {
                if (states.contains(WidgetState.disabled)) {
                  return const BorderSide(
                    color: Colors.black26,
                    width: 2,
                  );
                }

                return const BorderSide(
                  color: colorLightBlack,
                  width: 2,
                );
              },
            ),
            textStyle: WidgetStatePropertyAll(
              context.theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            overlayColor: const WidgetStatePropertyAll(Colors.black12),
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
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: colorLightBlack,
          foregroundColor: colorWhite,
          splashColor: Colors.white30,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: colorGray,
          contentTextStyle: TextStyle(
            color: colorWhite,
            fontSize: 16,
          ),
          closeIconColor: colorWhite,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: colorBackground,
          modalBackgroundColor: colorBackground,
          showDragHandle: true,
          dragHandleColor: colorLightBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            side: BorderSide(
              color: colorLightBlack,
              width: 1,
            ),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorGray;
            }

            if (states.contains(WidgetState.selected)) {
              return colorLightBlack;
            }

            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorGray;
            }

            return colorWhite;
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorGray;
            }

            return colorLightBlack;
          }),
          side: BorderSide(
            color: colorLightBlack,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(96),
          ),
          side: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
        ),
      ),
      navigatorKey: navigatorKey,
      home: const InitScreen(),
    );
  }
}
