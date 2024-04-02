import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/helper/firebase_options.dart';

class AuthRestApi {
  static String apiKey = "";
  static String idToken = "";
  static String refreshToken = "";

  void fetchApiKey() {
    apiKey = DefaultFirebaseOptions.web.apiKey;
  }

  Future<void> createUserWithEmailAndPasswordRestApi({
    required String username,
    required String email,
    required String password,
    required var onSuccess,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          <String, dynamic>{'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        idToken = responseData['idToken'];
        refreshToken = responseData['refreshToken'];
        await updateUserProfileDataRestApi(username: username, onSuccess: onSuccess);
        await getUserData();
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> updateUserProfileDataRestApi({
    required String username,
    required var onSuccess,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:update?key=$apiKey"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          <String, dynamic>{'idToken': idToken, 'displayName': username, 'returnSecureToken': true},
        ),
      );
      if (response.statusCode == 200) {
        onSuccess.call(true);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> signInUserWithEmailAndPasswordRestApi({
    required String email,
    required String password,
    required var onSuccess,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          <String, dynamic>{'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        idToken = responseData['idToken'];
        refreshToken = responseData['refreshToken'];
        await getUserData();
        onSuccess.call(true);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> getUserData() async {
    try {
      final response = await http.post(
        Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=$apiKey"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          <String, dynamic>{'idToken': idToken},
        ),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        userName = responseData["users"][0]["displayName"];
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
