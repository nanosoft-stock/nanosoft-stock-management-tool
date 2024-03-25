import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/screens/login_screen.dart';
import 'package:stock_management_tool/screens/sign_up_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool isLoginScreen = true;
  final toggleButtonWidth = 200.0;
  final toggleButtonHeight = 45.0;

  double loginAlign = -1;
  double signInAlign = 1;
  Color selectedColor = Colors.black54;
  Color normalColor = kTertiaryBackgroundColor;
  late double xAlign;
  late Color loginColor;
  late Color signInColor;

  @override
  void initState() {
    super.initState();

    isLoginScreen = true;
    xAlign = loginAlign;
    loginColor = selectedColor;
    signInColor = normalColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryBackgroundColor,
        borderRadius: kBorderRadius,
      ),
      child: Center(
        child: SizedBox(
          width: 350.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: kBorderRadius,
              color: kSecondaryBackgroundColor,
              boxShadow: kBoxShadowList,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 10.0,
                    ),
                    child: Container(
                      width: toggleButtonWidth,
                      height: toggleButtonHeight,
                      decoration: BoxDecoration(
                        color: kPrimaryBackgroundColor,
                        borderRadius: kBorderRadius,
                      ),
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            alignment: Alignment(xAlign, 0),
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              width: toggleButtonWidth * 0.5,
                              height: toggleButtonHeight,
                              decoration: BoxDecoration(
                                  color: kInputFieldFillColor, borderRadius: kBorderRadius),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              isLoginScreen = true;
                              setState(() {
                                xAlign = loginAlign;
                                loginColor = selectedColor;

                                signInColor = normalColor;
                              });
                            },
                            child: Align(
                              alignment: const Alignment(-1, 0),
                              child: Container(
                                width: toggleButtonWidth * 0.5,
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: loginColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              isLoginScreen = false;
                              setState(() {
                                xAlign = signInAlign;
                                signInColor = selectedColor;

                                loginColor = normalColor;
                              });
                            },
                            child: Align(
                              alignment: const Alignment(1, 0),
                              child: Container(
                                width: toggleButtonWidth * 0.5,
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: signInColor,
                                    fontWeight: FontWeight.w600,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  isLoginScreen ? LoginScreen() : SignUpScreen(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
