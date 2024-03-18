import 'package:flutter/material.dart';
import 'package:stock_management_tool/main.dart';
import 'package:stock_management_tool/screens/login_screen.dart';
import 'package:stock_management_tool/screens/sign_up_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return isLoginScreen ? LoginScreen() : SignUpScreen();
  }
}
