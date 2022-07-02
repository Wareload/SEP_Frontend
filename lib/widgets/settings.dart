import 'package:flutter/material.dart';
import 'package:moody/api/api_backend.dart';

class Settings {
//TODO define colors, fonts, etc here
  Settings._();

  static const mainFont = "Chivo";
  static const mainFontSize = 18.0;

  static const teamBannerHeight = 48.0;
  static const teamLogoHeight = 91.0;
  static const teamCornerRadius = 34.0;

  //colors
  static const mainAccentColor = Color(0xFF5A7CF8);
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
  //mood background colors
  static const moodVeryGood = 0xFFFF9900;
  static const moodGood = 0xFF9DE2A4;
  static const moodOkay = 0xFFFFDA57;
  static const moodMeh = 0xFF686868;
  static const moodBad = 0xFF271CA3;
  static const moodVeryBad = 0xFFF01212;
}
