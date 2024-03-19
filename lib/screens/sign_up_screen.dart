import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../main.dart';
import '../services/auth.dart';
import '../services/firebase_rest_api.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signUpUser() async {
    if (isDesktop) {
      await FirebaseRestApi().createUserWithEmailAndPasswordRestApi(
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
                  fillColor: kTextFieldFillColor,
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
                textInputAction: TextInputAction.done,
                cursorColor: kCursorColor,
                obscureText: true,
                onFieldSubmitted: (_) async {
                  await signUpUser();
                },
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
                await signUpUser();
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
                  'Sign Up',
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
