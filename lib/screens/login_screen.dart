import 'package:flutter/material.dart';
import 'package:stock_management_tool/services/auth.dart';

import '../constants/constants.dart';
import '../main.dart';
import '../services/firebase_rest_api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signInUser() async {
    if (isDesktop) {
      await FirebaseRestApi().signInUserWithEmailAndPasswordRestApi(
        email: emailController.text.toLowerCase().trim(),
        password: passwordController.text.trim(),
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
                  fillColor: kTextFieldFillColor,
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
                cursorColor: kCursorColor,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) async {
                  await signInUser();
                },
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kTextFieldFillColor,
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
                await signInUser();
              },
              style: ButtonStyle(
                shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15.0,
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
