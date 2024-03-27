import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/providers/firebase_provider.dart';
import 'package:stock_management_tool/services/auth.dart';
import 'package:stock_management_tool/services/firebase_rest_api.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInUser({required BuildContext context}) async {
    if (kIsDesktop) {
      await FirebaseRestApi().signInUserWithEmailAndPasswordRestApi(
        email: emailController.text.toLowerCase().trim(),
        password: passwordController.text.trim(),
        onSuccess: (value) {
          Provider.of<FirebaseProvider>(context, listen: false)
              .changeIsUserLoggedIn(isUserLoggedIn: value);
        },
      );
    } else {
      await Auth().signInWithEmailAndPassword(
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
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
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
                cursorColor: kCursorColor,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) async {
                  await signInUser(context: context);
                },
                obscureText: true,
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
                onPressed: () async {
                  await signInUser(context: context);
                },
                text: 'Login',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
