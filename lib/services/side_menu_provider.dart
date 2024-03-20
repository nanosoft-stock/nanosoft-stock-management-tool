import 'package:flutter/material.dart';

class SideMenuProvider extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}
