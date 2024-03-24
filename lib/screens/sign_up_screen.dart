import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/services/auth.dart';
import 'package:stock_management_tool/services/firebase_rest_api.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signUpUser({required BuildContext context}) async {
    if (kIsDesktop) {
      await FirebaseRestApi().createUserWithEmailAndPasswordRestApi(
        context: context,
        username: usernameController.text.toLowerCase().trim(),
        email: emailController.text.toLowerCase().trim(),
        password: passwordController.text.trim(),
      );
    } else {
      await Auth().createUserWithEmailAndPassword(
        username: usernameController.text.toLowerCase().trim(),
        email: emailController.text.toLowerCase().trim(),
        password: passwordController.text.trim(),
      );
    }
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
                ),
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
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              onPressed: () async {
                await signUpUser(context: context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kButtonBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: kBorderRadius,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
