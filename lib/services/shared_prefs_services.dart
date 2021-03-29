import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShredPrefsServices {
  Future<bool> showOnBoardingScreens() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool check = sharedPreferences.getBool('show') ?? true;
    return check;
  }

  Future<void> setOnBoardingFlag() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('show', false);
  }
}
