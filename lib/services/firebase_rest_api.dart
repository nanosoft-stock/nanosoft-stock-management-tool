import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/helper/firebase_options.dart';
import 'package:stock_management_tool/providers/firebase_provider.dart';

class FirebaseRestApi {
  static String apiKey = "";
  static String projectId = "";
  static String idToken = "";
  static String refreshToken = "";

  void fetchApiKey() {
    apiKey = DefaultFirebaseOptions.web.apiKey;
  }

  void fetchProjectId() {
    projectId = DefaultFirebaseOptions.web.projectId;
  }

  Future<void> createUserWithEmailAndPasswordRestApi(
      {required BuildContext context,
      required String username,
      required String email,
      required String password}) async {
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
        await updateUserProfileDataRestApi(context: context, username: username);
        await getUserData();
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> updateUserProfileDataRestApi(
      {required BuildContext context, required String username}) async {
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
        Provider.of<FirebaseProvider>(context, listen: false)
            .changeIsUserLoggedIn(isUserLoggedIn: true);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> signInUserWithEmailAndPasswordRestApi(
      {required BuildContext context, required String email, required String password}) async {
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
        Provider.of<FirebaseProvider>(context, listen: false)
            .changeIsUserLoggedIn(isUserLoggedIn: true);
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

  Future<List> getDocuments({required String path}) async {
    try {
      String url =
          "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$path?key=$apiKey";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body.trim());
        // print(jsonData);
        var data = jsonData['documents'] != null
            ? jsonData['documents'].map((e) => e['fields']).toList()
            : [];
        return data;
      }
    } catch (e) {
      print("Error: $e");
    }
    return [];
  }

  Future<Map> getFields({required String path}) async {
    try {
      String url =
          "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$path?key=$apiKey";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body.trim());
        // print(jsonData);
        var data = jsonData['fields'];
        return data;
      }
    } catch (e) {
      print("Error: $e");
    }
    return {};
  }

  Map? select;
  List? from;
  Map? where;
  List? orderBy;
  Map? startAt;
  Map? endAt;

  Future<List> filterQuery({path, select, from, where, orderBy, startAt, endAt}) async {
    try {
      String url =
          "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents${path != '' ? '/$path' : ''}:runQuery?key=$apiKey";

      Map structuredQuery = {};

      if (select != null) {
        structuredQuery["select"] = select;
      }
      if (from != null) {
        structuredQuery["from"] = from;
      }
      if (where != null) {
        structuredQuery["where"] = where;
      }
      if (orderBy != null) {
        structuredQuery["orderBy"] = orderBy;
      }
      if (startAt != null) {
        structuredQuery["startAt"] = startAt;
      }
      if (endAt != null) {
        structuredQuery["endAt"] = endAt;
      }

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          <String, dynamic>{
            "structuredQuery": structuredQuery,
          },
        ),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body.trim());
        var data = jsonData.map((e) => e["document"]["name"].toString().split("/").last).toList();
        // print(data);
        return data;
      }
    } catch (e) {
      print("Error: $e");
    }
    return [];
  }

  Future<void> createDocument({required String path, required Map json}) async {
    try {
      String url =
          "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$path?key=$apiKey";
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          <String, dynamic>{
            "fields": json,
          },
        ),
      );

      if (response.statusCode == 200) {
        print(response.body.trim());
      }
    } catch (e) {
      print(e);
    }
  }
}
