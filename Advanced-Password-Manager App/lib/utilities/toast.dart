import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyToast {
  void show(String message) {
    Fluttertoast.showToast(
      msg: message,
    );
  }

  final _toastLength = Toast.LENGTH_LONG;
  final _gravity = ToastGravity.BOTTOM;
  final _timeInSecForIosWeb = 2;
  final _textColor = Colors.white;
  final _fontSize = 14.0;

  void showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: _toastLength,
      gravity: _gravity,
      timeInSecForIosWeb: _timeInSecForIosWeb,
      textColor: _textColor,
      fontSize: _fontSize,
      backgroundColor: Colors.red,
    );
  }

  void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: _toastLength,
      gravity: _gravity,
      timeInSecForIosWeb: _timeInSecForIosWeb,
      textColor: _textColor,
      fontSize: _fontSize,
      backgroundColor: Colors.green,
    );
  }

  void showInfo(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: _toastLength,
      gravity: _gravity,
      timeInSecForIosWeb: _timeInSecForIosWeb,
      textColor: _textColor,
      fontSize: _fontSize,
      backgroundColor: Colors.grey,
    );
  }
}
