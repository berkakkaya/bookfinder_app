import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/screens/authentication/welcome_screen.dart";
import "package:bookfinder_app/services/api/base_api_service.dart";
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
    // Try to initialize the API service
    bool isInitialized = await BaseApiService.init();

    // If the API service is failed to initialize, ask for new base
    // API URI and try again
    while (!isInitialized) {
      if (!mounted) {
        return;
      }

      final uri = await showBaseUriDialog();
      if (uri == null) {
        continue;
      }

      isInitialized = await BaseApiService.init(uri);
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
