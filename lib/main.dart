import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stock_management_tool/screens/home_screen.dart';
import 'package:stock_management_tool/screens/login_screen.dart';
import 'package:stock_management_tool/screens/sign_up_screen.dart';
import 'package:stock_management_tool/services/auth.dart';
import 'firebase_options.dart';

bool isLoginScreen = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(StockManagementToolApp());
}

class StockManagementToolApp extends StatelessWidget {
  StockManagementToolApp({super.key});

  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nanosoft Stock Management Tool',
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
      },
      home: SafeArea(
        child: Scaffold(
          body: StreamBuilder(
            stream: _auth.authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return HomeScreen();
              } else {
                return LoginScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}
