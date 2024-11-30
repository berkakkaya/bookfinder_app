import "package:bookfinder_app/consts/colors.dart";
import "package:flutter/material.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

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
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Spacer(),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "E-posta",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: "Şifre",
                      hintText: "Şifrenizi girin",
                      prefixIcon: Icon(Icons.lock_outlined),
                    ),
                    obscureText: true,
                  ),
                  // const SizedBox(height: 32),
                  const Spacer(),
                  FilledButton(
                    onPressed: () => login(context),
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

  Future<void> login(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    // TODO: Implement login logic
  }
}
