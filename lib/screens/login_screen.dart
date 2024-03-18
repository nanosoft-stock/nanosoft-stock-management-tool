import 'package:flutter/material.dart';
import 'package:stock_management_tool/services/auth.dart';

import '../constants/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Auth _auth = Auth();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final toggleButtonWidth = 200.0;
  final toggleButtonHeight = 45.0;

  double loginAlign = -1;
  double signInAlign = 1;
  Color selectedColor = Colors.white;
  Color normalColor = Colors.black54;
  late double xAlign;
  late Color loginColor;
  late Color signInColor;

  @override
  void initState() {
    super.initState();

    xAlign = loginAlign;
    loginColor = selectedColor;
    signInColor = normalColor;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350.0,
        height: 400.0,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 5)
              ]),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  child: Container(
                    width: toggleButtonWidth,
                    height: toggleButtonHeight,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                    ),
                    child: Stack(
                      children: [
                        AnimatedAlign(
                          alignment: Alignment(xAlign, 0),
                          duration: Duration(milliseconds: 200),
                          child: Container(
                            width: toggleButtonWidth * 0.5,
                            height: toggleButtonHeight,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              xAlign = loginAlign;
                              loginColor = selectedColor;

                              signInColor = normalColor;
                            });
                          },
                          child: Align(
                            alignment: Alignment(-1, 0),
                            child: Container(
                              width: toggleButtonWidth * 0.5,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: loginColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              xAlign = signInAlign;
                              signInColor = selectedColor;

                              loginColor = normalColor;
                            });
                          },
                          child: Align(
                            alignment: Alignment(1, 0),
                            child: Container(
                              width: toggleButtonWidth * 0.5,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: signInColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // const Padding(
                //   padding:
                //       EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                //   child: Text(
                //     'Login',
                //     style:
                //         TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 250,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
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
                    onPressed: () async {
                      await _auth.signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);
                      // Navigator.popAndPushNamed(context, '/home');
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
                          Navigator.popAndPushNamed(context, '/signup');
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
    );
  }
}
