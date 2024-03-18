import 'package:flutter/material.dart';
import 'package:stock_management_tool/screens/sign_up_screen.dart';

import '../constants/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 350.0,
          height: 400.0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5), spreadRadius: 5)
                ]),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: emailController,
                        cursorColor: kCursorColor,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: kTextFieldFillColor,
                            border: const OutlineInputBorder(),
                            labelText: 'Email'),
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
                        obscureText: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: kTextFieldFillColor,
                            border: const OutlineInputBorder(),
                            labelText: 'Password'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Container()));
                      },
                      child: const Text('Login'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(
                                context,
                                '/signup');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
