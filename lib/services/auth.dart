import 'package:flutter/material.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/services/auth_default.dart';
import 'package:stock_management_tool/services/auth_rest_api.dart';

class Auth {
  Future<void> signInUser(
      {required String email, required String password, required var onSuccess}) async {
    if (!kIsDesktop) {
      await AuthDefault().signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } else {
      await AuthRestApi().signInUserWithEmailAndPasswordRestApi(
        email: email,
        password: password,
        onSuccess: (value) {
          onSuccess(value);
        },
      );
    }
  }

  Future<void> signUpUser(
      {required String username,
      required String email,
      required String password,
      required var onSuccess}) async {
    if (!kIsDesktop) {
      await AuthDefault().createUserWithEmailAndPassword(
        username: username,
        email: email,
        password: password,
      );
    } else {
      await AuthRestApi().createUserWithEmailAndPasswordRestApi(
        username: username,
        email: email,
        password: password,
        onSuccess: (value) {
          onSuccess(value);
        },
      );
    }
  }

  Future<void> signOutUser({required VoidCallback onSuccess}) async {
    if (!kIsDesktop) {
      await AuthDefault().signOut();
    } else {
      onSuccess();
    }
  }
}
