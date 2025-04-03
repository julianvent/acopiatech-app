import 'package:flutter/material.dart';

class UserMenuProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void goTo(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
