import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/services/auth.dart';
import 'package:stock_management_tool/services/firebase_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (kIsDesktop) {
            Provider.of<FirebaseProvider>(context, listen: false)
                .changeIsUserLoggedIn(isUserLoggedIn: false);
          } else {
            await Auth().signOut();
          }
        },
        child: Text('Sign Out'),
      ),
    );
  }
}
