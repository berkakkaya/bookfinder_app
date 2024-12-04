import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/snackbars.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/screens/home_screen.dart";
import "package:bookfinder_app/services/api/api_service_auth.dart";
import "package:flutter/material.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text("Giriş Yap"),
            centerTitle: true,
            floating: true,
            snap: true,
            backgroundColor: colorBackground,
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Spacer(),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "E-posta",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Şifre",
                      hintText: "Şifrenizi girin",
                      prefixIcon: Icon(Icons.lock_outlined),
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  // const SizedBox(height: 32),
                  const Spacer(),
                  FilledButton(
                    onPressed: email.isEmpty || password.isEmpty ? null : login,
                    child: const Text("Giriş Yap"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> login() async {
    final result = await ApiServiceAuth.login(email, password);

    if (result.status == ResponseStatus.unauthorized) {
      if (mounted) {
        context.showSnackbar(
          "E-posta veya şifre hatalı.",
          type: SnackbarType.warning,
        );
      }

      return;
    }

    if (result.status != ResponseStatus.ok) {
      if (mounted) {
        context.showSnackbar(
          "Bir hata oluştu. Lütfen tekrar deneyin.",
          type: SnackbarType.error,
        );
      }

      return;
    }

    if (mounted) {
      context.navigateToAndRemoveUntil(const HomeScreen());
    }
  }
}
