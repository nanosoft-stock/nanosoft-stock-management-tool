import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/screens/authentication_screen.dart';
import 'package:stock_management_tool/screens/home_screen.dart';
import 'package:stock_management_tool/services/auth.dart';
import 'package:stock_management_tool/services/firebase_provider.dart';
import 'package:stock_management_tool/services/firebase_rest_api.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.linux) {
    kIsDesktop = true;
    FirebaseRestApi().fetchApiKey();
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const StockManagementToolApp());
}

class StockManagementToolApp extends StatelessWidget {
  const StockManagementToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FirebaseProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Nanosoft Stock Management Tool',
        home: SafeArea(
          child: Scaffold(
            body: kIsDesktop
                ? StreamBuilder<bool>(
                    stream:
                        FirebaseProvider.isUserLoggedInStreamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        return const HomeScreen();
                      } else {
                        return const AuthenticationScreen();
                      }
                    })
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
      ),
    );
  }
}
