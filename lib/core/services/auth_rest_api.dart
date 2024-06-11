import 'dart:async';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/resources/data_state.dart';
import 'package:stock_management_tool/core/services/firebase_options.dart';

class AuthRestApi {
  static String _apiKey = "";
  static String _idToken = "";
  final Dio _dio = Dio();
  static final StreamController<bool> _isUserLoggedInStreamController =
      StreamController<bool>();
  static late SharedPreferences preferences;

  Future<void> fetchApiKeyAndInitializePreferences() async {
    _apiKey = DefaultFirebaseOptions.web.apiKey;
    preferences = await SharedPreferences.getInstance();
  }

  StreamController<bool> get userLogInStatusStreamController =>
      _isUserLoggedInStreamController;

  void changeIsUserLoggedIn({required bool isUserLoggedIn}) {
    _isUserLoggedInStreamController.sink.add(isUserLoggedIn);
  }

  Future<void> _saveUserCredentialsToPreferences({
    required String email,
    required String password,
  }) async {
    await preferences.setString("email", email);
    await preferences.setString("password", password);
  }

  Future<DataState> checkUserPreviousLoginStatus() async {
    String? email = preferences.getString("email");
    String? password = preferences.getString("password");
    if (email != null && password != null) {
      return await signInUserWithEmailAndPasswordRestApi(
          email: email, password: password);
    } else {
      return DataFailed(Exception("No Previous user"));
    }
  }

  Future<void> removeUserCredentialsToPreferences() async {
    await preferences.remove("email");
    await preferences.remove("password");
  }

  Future<DataState> signInUserWithEmailAndPasswordRestApi({
    required String email,
    required String password,
  }) async {
    try {
      String url =
          "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apiKey";

      Response response = await _dio.post(
        url,
        data: {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        _idToken = jsonData['idToken'];
        await getUserData();
        await _saveUserCredentialsToPreferences(
            email: email, password: password);
        changeIsUserLoggedIn(isUserLoggedIn: true);
        return DataSuccess(jsonData);
      }
    } on Exception catch (error) {
      return DataFailed(error);
    }
    return DataFailed(Exception("Unknown Exception"));
  }

  Future<DataState> createUserWithEmailAndPasswordRestApi({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      String url =
          "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_apiKey";

      Response response = await _dio.post(
        url,
        data: {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      );

      if (response.statusCode == 200) {
        var jsonData = response.data;
        _idToken = jsonData['idToken'];
        await updateUserProfileDataRestApi(username: username);
        await getUserData();
        await _saveUserCredentialsToPreferences(
            email: email, password: password);
        changeIsUserLoggedIn(isUserLoggedIn: true);
        return DataSuccess(jsonData);
      }
    } on Exception catch (error) {
      return DataFailed(error);
    }
    return DataFailed(Exception("Unknown Exception"));
  }

  Future<DataState> updateUserProfileDataRestApi(
      {required String username}) async {
    try {
      String url =
          "https://identitytoolkit.googleapis.com/v1/accounts:update?key=$_apiKey";

      Response response = await _dio.post(
        url,
        data: {
          'idToken': _idToken,
          'displayName': username,
          'returnSecureToken': true,
        },
      );

      if (response.statusCode == 200) {
        var jsonData = response.data;
        return DataSuccess(jsonData);
      }
    } on Exception catch (error) {
      return DataFailed(error);
    }
    return DataFailed(Exception("Unknown Exception"));
  }

  Future<DataState> getUserData() async {
    try {
      String url =
          "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=$_apiKey";

      Response response = await _dio.post(
        url,
        data: {
          'idToken': _idToken,
        },
      );

      if (response.statusCode == 200) {
        var jsonData = response.data;
        userName = jsonData["users"][0]["displayName"];
        return DataSuccess(jsonData);
      }
    } on Exception catch (error) {
      return DataFailed(error);
    }
    return DataFailed(Exception("Unknown Exception"));
  }
}
