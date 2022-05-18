import 'package:flutter/material.dart';
import 'package:moody/screens/login.dart';
import 'package:moody/screens/register.dart';
import 'package:moody/screens/splash.dart';
import 'package:moody/screens/team_details.dart';
import 'package:moody/screens/team_overview.dart';

class RouteGenerator {
  static const String splash = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String teamOverview = "/teamOverview";
  static const String teamDetails = "/teamDetails";

  static Route<dynamic> generateRoute(RouteSettings settings) {
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
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text(
                          'Es ist keine Route fuer ${settings.name} definiert !')),
                ));
    }
  }
}
