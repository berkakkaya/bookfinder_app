import "package:bookfinder_app/exceptions/api_error_handling.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/screens/authentication/welcome_screen.dart";
import "package:bookfinder_app/screens/home_screen.dart";
import "package:bookfinder_app/services/api/api_service_provider.dart";
import "package:bookfinder_app/services/logging/logging_service_provider.dart";
import "package:bookfinder_app/services/preferences/preference_service_provider.dart";
import "package:flutter/foundation.dart";
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
    // Ask the user for the implementation type
    bool useRealImplementation = true;

    if (kDebugMode) {
      useRealImplementation = await askImplementationType() ?? true;
    }

    if (useRealImplementation) {
      await _initRealResources();
    } else {
      await _initFakeResources();
    }
  }

  Future<void> _initFakeResources() async {
    // Initialize the logging service
    LoggingServiceProvider.initTalker();
    final logger = LoggingServiceProvider.i;

    // Initialize the preference service
    PreferenceServiceProvider.initMock();

    // Initialize the API service
    ApiServiceProvider.initMock();

    logger.info(
      "Using fake resources, navigating to welcome screen...",
    );

    if (mounted) {
      context.navigateToAndRemoveUntil(const WelcomeScreen());
    }
  }

  Future<void> _initRealResources() async {
    // Initialize the logging service
    LoggingServiceProvider.initTalker();
    final logger = LoggingServiceProvider.i;

    logger.info("Initializing real resources...");

    // Get the Dio logger from the logging service
    final dioLogInterceptor = LoggingServiceProvider.dioInterceptor;

    logger.info("Initializing the preference service...");

    // Initialize the preference service
    PreferenceServiceProvider.initActual();
    final prefs = PreferenceServiceProvider.i;

    // Get the base API URI from the preferences
    Uri? baseUri = await prefs.getBaseUri();

    bool isInitialized = false;

    if (baseUri != null) {
      logger.info(
        "Base API URI is already set, trying to initialize the API service...",
      );

      // Try to initialize the API service
      try {
        await ApiServiceProvider.initDio(
          baseUri: baseUri,
          tokens: null,
          interceptors: dioLogInterceptor != null ? [dioLogInterceptor] : null,
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
      logger.warning(
        "API service could not be initialized, asking for new base URI...",
      );

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
          interceptors: dioLogInterceptor != null ? [dioLogInterceptor] : null,
        );

        // If the initialization is successful, save the base URI
        await prefs.setBaseUri(baseUri);
        isInitialized = true;
      } on ApiUnreachableException {
        isInitialized = false;
      }
    }

    logger.info("API service is initialized successfully...");

    // Try to get the tokens from the preferences
    final tokens = await prefs.getTokens();

    if (tokens != null) {
      logger.info(
        "User is already authenticated, navigating to home screen...",
      );

      ApiServiceProvider.i.auth.setTokenPair(tokens);

      if (mounted) {
        context.navigateToAndRemoveUntil(const HomeScreen());
      }

      return;
    }

    if (mounted) {
      logger.info(
        "User is not authenticated, navigating to welcome screen...",
      );

      context.navigateToAndRemoveUntil(const WelcomeScreen());
    }
  }

  Future<bool?> askImplementationType() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Geliştirici Modu"),
          content: const Text(
            "Uygulamanın geliştirici sürümünü çalıştırıyorsunuz. Uygulama "
            "servislerinin gerçek kaynaklarla mı çalışmasını yoksa sahte "
            "kaynaklarla mı çalışmasını istersiniz?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Gerçek Kaynakları Kullan"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Sahte Kaynakları Kullan"),
            ),
          ],
        );
      },
    );
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
