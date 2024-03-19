import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stock_management_tool/screens/authentication_screen.dart';
import 'package:stock_management_tool/screens/home_screen.dart';
import 'package:stock_management_tool/services/auth.dart';
import 'package:stock_management_tool/services/firebase_rest_api.dart';

import 'firebase_options.dart';

bool isLoginScreen = true;
bool isDesktop = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.linux) {
    isDesktop = true;
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(StockManagementToolApp());
}

class StockManagementToolApp extends StatefulWidget {
  StockManagementToolApp({super.key});

  @override
  State<StockManagementToolApp> createState() => _StockManagementToolAppState();
}

class _StockManagementToolAppState extends State<StockManagementToolApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (isDesktop) {
      FirebaseRestApi().fetchApiKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nanosoft Stock Management Tool',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/auth': (context) => const AuthenticationScreen(),
      },
      home: SafeArea(
        child: Scaffold(
          body: isDesktop
              ? AuthenticationScreen()
              : StreamBuilder(
                  stream: Auth().authStateChanges,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return const HomeScreen();
                    } else {
                      return const AuthenticationScreen();
                    }
                  },
                ),
        ),
      ),
    );
  }
}
