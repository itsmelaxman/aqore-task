import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

DateTime? _currentBackPressTime;

/// Double tap to exit handler.
Future<bool> doubleTapTrigger() {
  DateTime now = DateTime.now();
  if (_currentBackPressTime == null ||
      now.difference(_currentBackPressTime!) > const Duration(seconds: 3)) {
    _currentBackPressTime = now;
    SnackBar snackBar = SnackBar(
      content: const Text('Press back again to exit'),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
    return Future.value(false);
  }
  SystemNavigator.pop();
  _currentBackPressTime = null;
  return Future.value(true);
}
