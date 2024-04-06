import 'package:dio/dio.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/core/resources/data_state.dart';
import 'package:stock_management_tool/helper/firebase_options.dart';

class AuthRestApi {
  static String apiKey = "";
  static String idToken = "";
  static String refreshToken = "";
  final Dio _dio = Dio();

  void fetchApiKey() {
    apiKey = DefaultFirebaseOptions.web.apiKey;
  }

  Future<DataState> createUserWithEmailAndPasswordRestApi({
    required String username,
    required String email,
    required String password,
    required void Function(bool) onSuccess,
  }) async {
    try {
      String url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey";

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
        idToken = jsonData['idToken'];
        refreshToken = jsonData['refreshToken'];
        await updateUserProfileDataRestApi(username: username, onSuccess: onSuccess);
        await getUserData();
        return DataSuccess(jsonData);
      }
    } on Exception catch (error) {
      return DataFailed(error);
    }
    return DataFailed(Exception("Unknown Exception"));
  }

  Future<DataState> updateUserProfileDataRestApi({
    required String username,
    required void Function(bool) onSuccess,
  }) async {
    try {
      String url = "https://identitytoolkit.googleapis.com/v1/accounts:update?key=$apiKey";

      Response response = await _dio.post(
        url,
        data: {
          'idToken': idToken,
          'displayName': username,
          'returnSecureToken': true,
        },
      );

      if (response.statusCode == 200) {
        var jsonData = response.data;
        onSuccess(true);
        return DataSuccess(jsonData);
      }
    } on Exception catch (error) {
      return DataFailed(error);
    }
    return DataFailed(Exception("Unknown Exception"));
  }

  Future<DataState> signInUserWithEmailAndPasswordRestApi({
    required String email,
    required String password,
    required void Function(bool) onSuccess,
  }) async {
    try {
      String url =
          "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey";

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
        idToken = jsonData['idToken'];
        refreshToken = jsonData['refreshToken'];
        await getUserData();
        onSuccess(true);
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
          "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey";

      Response response = await _dio.post(
        url,
        data: {
          'idToken': idToken,
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
