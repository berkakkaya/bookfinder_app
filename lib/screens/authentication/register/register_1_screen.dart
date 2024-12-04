import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/extensions/navigation.dart";
import "package:bookfinder_app/screens/authentication/register/register_2_screen.dart";
import "package:flutter/material.dart";

class Register1Screen extends StatefulWidget {
  const Register1Screen({super.key});

  @override
  State<Register1Screen> createState() => _Register1ScreenState();
}

class _Register1ScreenState extends State<Register1Screen> {
  String nameSurname = "";
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text("Bilgilerinizi giriniz"),
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
                      labelText: "Adınız ve Soyadınız",
                      prefixIcon: Icon(Icons.person_outline_outlined),
                    ),
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) {
                      setState(() {
                        nameSurname = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "E-postanız",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  // const SizedBox(height: 32),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: nameSurname.isEmpty || email.isEmpty
                        ? null
                        : () => goToPasswordScreen(context),
                    label: const Text("Devam Et"),
                    icon: const Icon(Icons.arrow_forward_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void goToPasswordScreen(BuildContext context) {
    context.navigateTo(
      Register2Screen(
        email: email,
        nameSurname: nameSurname,
      ),
      animation: TransitionAnimationType.sharedAxisX,
    );
  }
}
