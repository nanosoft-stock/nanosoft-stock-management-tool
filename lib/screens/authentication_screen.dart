import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/providers/firebase_provider.dart';
import 'package:stock_management_tool/screens/login_screen.dart';
import 'package:stock_management_tool/screens/sign_up_screen.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseProvider>(
      builder: (BuildContext context, provider, Widget? child) {
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
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                        child: SizedBox(
                          width: 250,
                          child: SegmentedButton(
                            segments: [
                              ButtonSegment(
                                value: true,
                                label: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Login",
                                    style:
                                        provider.isLoginScreen ? kButtonTextStyle : kLabelTextStyle,
                                  ),
                                ),
                              ),
                              ButtonSegment(
                                value: false,
                                label: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Sign Up",
                                    style: !provider.isLoginScreen
                                        ? kButtonTextStyle
                                        : kLabelTextStyle,
                                  ),
                                ),
                              ),
                            ],
                            selected: {provider.isLoginScreen},
                            selectedIcon: const SizedBox.shrink(),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: kBorderRadius,
                                ),
                              ),
                            ),
                            onSelectionChanged: (value) {
                              provider.setIsLoginScreen(isLoginScreen: value.first);
                            },
                          ),
                        ),
                      ),
                      provider.isLoginScreen ? LoginScreen() : SignUpScreen(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
