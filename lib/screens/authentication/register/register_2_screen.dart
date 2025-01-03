import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/extensions/snackbars.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/screens/home_screen.dart";
import "package:bookfinder_app/utils/auth_utils.dart" as auth_utils;
import "package:flutter/material.dart";

class Register2Screen extends StatefulWidget {
  final String nameSurname;
  final String email;

  const Register2Screen({
    super.key,
    required this.email,
    required this.nameSurname,
  });

  @override
  State<Register2Screen> createState() => _Register2ScreenState();
}

class _Register2ScreenState extends State<Register2Screen> {
  String password = "";
  String confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text("Bir şifre oluşturunuz"),
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
                      labelText: "Şifreniz",
                      prefixIcon: Icon(Icons.lock_outlined),
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Şifreniz (tekrardan)",
                      prefixIcon: Icon(Icons.lock_outlined),
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        confirmPassword = value;
                      });
                    },
                  ),
                  // const SizedBox(height: 32),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: password.isEmpty || confirmPassword.isEmpty
                        ? null
                        : register,
                    label: const Text("Kayıt Ol"),
                    icon: const Icon(Icons.done_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> register() async {
    if (password != confirmPassword) {
      context.showSnackbar(
        "Şifreler uyuşmuyor.",
        type: SnackbarType.warning,
      );

      return;
    }

    final result = await auth_utils.register(
      nameSurname: widget.nameSurname,
      email: widget.email,
      password: password,
    );

    if (result.status == ResponseStatus.conflict) {
      if (mounted) {
        context.showSnackbar(
          "Bu e-posta adresi ile bir hesap zaten var.",
          type: SnackbarType.warning,
        );
      }

      return;
    }

    if (result.status != ResponseStatus.created) {
      if (mounted) {
        context.showSnackbar(
          "Bilinmeyen bir hata oluştu.",
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
