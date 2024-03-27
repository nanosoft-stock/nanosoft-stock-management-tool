import 'dart:async';

import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  FirebaseProvider({
    this.isLoginScreen = true,
    this.isUserLoggedIn = false,
  });

  bool isLoginScreen;
  bool isUserLoggedIn;

  static StreamController<bool> isUserLoggedInStreamController = StreamController<bool>();

  void setIsLoginScreen({required bool isLoginScreen}) {
    this.isLoginScreen = isLoginScreen;
    notifyListeners();
  }

  void changeIsUserLoggedIn({required bool isUserLoggedIn}) {
    this.isUserLoggedIn = isUserLoggedIn;
    isUserLoggedInStreamController.sink.add(isUserLoggedIn);
    notifyListeners();
  }

  StreamController<bool> get isUserLoggedInStream {
    return isUserLoggedInStreamController;
  }
}
