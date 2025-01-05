import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/screens/authentication/login_screen.dart";
import "package:bookfinder_app/screens/authentication/register/register_1_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Bookfinder",
                style: context.theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SvgPicture.asset(
                      "assets/illustrations/book_reading.svg",
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Kendine yeni kitaplar keşfet",
                style: context.theme.textTheme.headlineLarge,
              ),
              Spacer(),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      label: const Text("Kayıt Ol"),
                      icon: const Icon(Icons.app_registration_rounded),
                      onPressed: () => goToRegister(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton.icon(
                      label: const Text("Giriş Yap"),
                      icon: const Icon(Icons.login_rounded),
                      onPressed: () => goToLogin(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToRegister(BuildContext context) {
    context.navigateTo(
      const Register1Screen(),
      animation: TransitionAnimationType.sharedAxisX,
    );
  }

  void goToLogin(BuildContext context) {
    context.navigateTo(
      const LoginScreen(),
      animation: TransitionAnimationType.sharedAxisX,
    );
  }
}
