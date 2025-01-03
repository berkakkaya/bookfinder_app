import "package:bookfinder_app/exceptions/api_error_handling.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/screens/authentication/welcome_screen.dart";
import "package:bookfinder_app/screens/home_screen.dart";
import "package:bookfinder_app/services/api/api_service_provider.dart";
import "package:bookfinder_app/services/preferences/preference_service_provider.dart";
import "package:flutter/material.dart";

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox.square(
          dimension: 72,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> initApp() async {
    // Initialize the preference service
    PreferenceServiceProvider.initActual();
    final prefs = PreferenceServiceProvider.i;

    // Get the base API URI from the preferences
    Uri? baseUri = await prefs.getBaseUri();

    bool isInitialized = false;

    if (baseUri != null) {
      // Try to initialize the API service
      try {
        await ApiServiceProvider.initDio(
          baseUri: baseUri,
          tokens: null,
        );

        isInitialized = true;
      } on ApiUnreachableException {
        // If the API service is unreachable, unset the base URI
        await prefs.setBaseUri(null);
      }
    }

    // If the API service is failed to initialize, ask for new base
    // API URI and try again
    while (!isInitialized) {
      if (!mounted) {
        return;
      }

      baseUri = await showBaseUriDialog();
      if (baseUri == null) {
        continue;
      }

      // Try to initialize the API service with the new base URI
      try {
        await ApiServiceProvider.initDio(
          baseUri: baseUri,
          tokens: null,
        );

        // If the initialization is successful, save the base URI
        await prefs.setBaseUri(baseUri);
        isInitialized = true;
      } on ApiUnreachableException {
        isInitialized = false;
      }
    }

    // Try to get the tokens from the preferences
    final tokens = await prefs.getTokens();

    if (tokens != null) {
      if (mounted) {
        context.navigateToAndRemoveUntil(const HomeScreen());
      }

      return;
    }

    if (mounted) {
      context.navigateToAndRemoveUntil(const WelcomeScreen());
    }
  }

  Future<Uri?> showBaseUriDialog() {
    String rawUri = "";

    return showDialog<Uri>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("API URL Girin"),
          content: TextField(
            decoration: const InputDecoration(
              hintText: "http://192.168.1.39:5000",
            ),
            keyboardType: TextInputType.url,
            onChanged: (value) => rawUri = value,
          ),
          actions: [
            TextButton(
              onPressed: () {
                final uri = Uri.parse(rawUri);
                Navigator.of(context).pop(uri);
              },
              child: const Text("Tamam"),
            ),
          ],
        );
      },
    );
  }
}
