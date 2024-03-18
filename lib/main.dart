import 'package:flutter/material.dart';
import 'package:stock_management_tool/screens/login_screen.dart';

void main() {
  runApp(const StockManagementToolApp());
}

class StockManagementToolApp extends StatelessWidget {
  const StockManagementToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nanosoft Stock Management Tool',
      home: LoginScreen(),
    );
  }
}
