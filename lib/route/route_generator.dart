import 'package:flutter/material.dart';
import 'package:moody/screens/login.dart';
import 'package:moody/screens/mood_select.dart';
import 'package:moody/screens/profile_overview.dart';
import 'package:moody/screens/register.dart';
import 'package:moody/screens/splash.dart';
import 'package:moody/screens/team_create.dart';
import 'package:moody/screens/team_details.dart';
import 'package:moody/screens/team_manage.dart';
import 'package:moody/screens/team_overview.dart';

class RouteGenerator {
  static const String splash = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String teamOverview = "/teamOverview";
  static const String teamDetails = "/teamDetails";
  static const String profileOverview = "/profileOverview";
  static const String teamCreate = "/teamCreate";
  static const String teamManage = "/teamManage";
  static const String moodSelect = "/moodSelect";



  static void reset(context){
    Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.splash, (route) => false);
  }

  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const Splash());
      case login:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const Login());
      case register:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const Register());
      case teamOverview:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const TeamOverview());
      case teamDetails:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const TeamDetails());
      case profileOverview:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ProfileOverview());
      case teamCreate:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const TeamCreate());
      case teamManage:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const TeamManage());
      case moodSelect:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const MoodSelect());
      default:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const Splash());
    }
  }
}
