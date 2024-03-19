import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stock_management_tool/firebase_options.dart';
import 'package:stock_management_tool/services/firebase_provider.dart';

class FirebaseRestApi {
  static String apiKey = "";
  static String idToken = "";
  static String refreshToken = "";

  void fetchApiKey() {
    apiKey = DefaultFirebaseOptions.web.apiKey;
  }

  Future<void> createUserWithEmailAndPasswordRestApi(
      {required BuildContext context,
      required String username,
      required String email,
      required String password}) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          <String, dynamic>{
            'email': email,
            'password': password,
            'returnSecureToken': true
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        idToken = responseData['idToken'];
        refreshToken = responseData['refreshToken'];
      }

      await updateUserProfileDataRestApi(context: context, username: username);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserProfileDataRestApi(
      {required BuildContext context, required String username}) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://identitytoolkit.googleapis.com/v1/accounts:update?key=$apiKey"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          <String, dynamic>{
            'idToken': idToken,
            'displayName': username,
            'returnSecureToken': true
          },
        ),
      );
      if (response.statusCode == 200) {
        Provider.of<FirebaseProvider>(context, listen: false)
            .changeIsUserLoggedIn(isUserLoggedIn: true);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> signInUserWithEmailAndPasswordRestApi(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          <String, dynamic>{
            'email': email,
            'password': password,
            'returnSecureToken': true
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        idToken = responseData['idToken'];
        refreshToken = responseData['refreshToken'];
        Provider.of<FirebaseProvider>(context, listen: false)
            .changeIsUserLoggedIn(isUserLoggedIn: true);
      }
    } catch (e) {
      print(e);
    }
  }
}
