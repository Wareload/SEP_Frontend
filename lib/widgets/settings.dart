import 'package:flutter/material.dart';
import 'package:moody/api/api_backend.dart';

class Settings {
//TODO define colors, fonts, etc here
  Settings._();

  static late ApiBackend api;

  static Future<void> setApi() async {
    api = await ApiBackend.instance();
  }

  //colors
  static const red = Colors.red;
  static const redAccent = Colors.redAccent;
  static const white = Colors.white;
  static const whiteAccent = Colors.white70;
  static const grey = Colors.grey;
  static const greyAccent = Colors.blueGrey;
  static const blue = Colors.blue;
  static const blueAccent = Colors.blueAccent;
  static const orange = Colors.orange;
  static const orangeAccent = Colors.orangeAccent;
}
