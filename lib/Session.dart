import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String uid = '';
  String name = '';

  setUser(String uid, String name) {
    this.uid = uid;
    this.name = name;
    notifyListeners();
  }
}