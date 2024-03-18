import 'package:flutter/material.dart';
import 'package:stock_management_tool/screens/login_screen.dart';
import 'package:stock_management_tool/screens/sign_up_screen.dart';

void main() {
  runApp(const StockManagementToolApp());
}

class StockManagementToolApp extends StatelessWidget {
  const StockManagementToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nanosoft Stock Management Tool',
      routes: {
        '/login' : (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen()
      },
      home: LoginScreen(),
    );
  }
}
