import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/services/auth_default.dart';
import 'package:stock_management_tool/core/services/auth_rest_api.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';

class Auth {
  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    if (!kIsLinux) {
      await sl.get<AuthDefault>().signInWithEmailAndPassword(
            email: email,
            password: password,
          );
    } else {
      await sl.get<AuthRestApi>().signInUserWithEmailAndPasswordRestApi(
            email: email,
            password: password,
          );
    }
  }

  Future<void> signUpUser({
    required String username,
    required String email,
    required String password,
  }) async {
    if (!kIsLinux) {
      await sl.get<AuthDefault>().createUserWithEmailAndPassword(
            username: username,
            email: email,
            password: password,
          );
    } else {
      await sl.get<AuthRestApi>().createUserWithEmailAndPasswordRestApi(
            username: username,
            email: email,
            password: password,
          );
    }
  }

  Future<void> signOutUser() async {
    if (!kIsLinux) {
      await sl.get<AuthDefault>().signOut();
    } else {
      await sl.get<AuthRestApi>().removeUserCredentialsToPreferences();
      sl.get<AuthRestApi>().changeIsUserLoggedIn(isUserLoggedIn: false);
    }
  }
}
