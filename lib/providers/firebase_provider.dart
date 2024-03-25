import 'dart:async';

import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  FirebaseProvider({
    this.isUserLoggedIn = false,
  });

  bool isUserLoggedIn;

  static StreamController<bool> isUserLoggedInStreamController = StreamController<bool>();

  void changeIsUserLoggedIn({required bool isUserLoggedIn}) async {
    this.isUserLoggedIn = isUserLoggedIn;
    isUserLoggedInStreamController.sink.add(isUserLoggedIn);
    notifyListeners();
  }

  StreamController<bool> get isUserLoggedInStream {
    return isUserLoggedInStreamController;
  }
}
