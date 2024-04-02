import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/providers/firebase_provider.dart';
import 'package:stock_management_tool/services/auth.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signUpUser({required BuildContext context}) async {
    Auth().signUpUser(
      username: usernameController.text.toLowerCase().trim(),
      email: emailController.text.toLowerCase().trim(),
      password: passwordController.text.trim(),
      onSuccess: (value) {
        Provider.of<FirebaseProvider>(context, listen: false)
            .changeIsUserLoggedIn(isUserLoggedIn: value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 250,
              child: TextFormField(
                controller: usernameController,
                textInputAction: TextInputAction.next,
                cursorColor: kCursorColor,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kTertiaryBackgroundColor,
                  border: const OutlineInputBorder(),
                  labelText: 'Username',
                  labelStyle: kLabelTextStyle,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 250,
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                cursorColor: kCursorColor,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kTertiaryBackgroundColor,
                  border: const OutlineInputBorder(),
                  labelText: 'Email',
                  labelStyle: kLabelTextStyle,
                ),
                style: kLabelTextStyle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 250,
              child: TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                cursorColor: kCursorColor,
                obscureText: true,
                onFieldSubmitted: (_) async {
                  await signUpUser(context: context);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kTertiaryBackgroundColor,
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  labelStyle: kLabelTextStyle,
                ),
                style: kLabelTextStyle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: SizedBox(
              width: 250,
              child: CustomElevatedButton(
                text: 'Sign Up',
                onPressed: () async {
                  await signUpUser(context: context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
