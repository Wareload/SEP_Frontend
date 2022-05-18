import 'package:flutter/material.dart';
import 'package:moody/api/api_backend.dart';

class Settings {
//TODO define colors, fonts, etc here
  Settings._();


  static late ApiBackend api;

  static Future<void> setApi() async{
    api = await ApiBackend.instance();
  }

  //colors
  static const errorColor = Color.fromRGBO(255, 0, 0, 1);
}
