import 'package:flutter/material.dart';
import 'package:moody/screens/atem_uebung.dart';
import 'package:moody/screens/login.dart';
import 'package:moody/screens/meditation_end.dart';
import 'package:moody/screens/meditation_home.dart';
import 'package:moody/screens/meditation_info.dart';
import 'package:moody/screens/meditation_start.dart';
import 'package:moody/screens/meditation_timer.dart';
import 'package:moody/screens/mood_select.dart';
import 'package:moody/screens/personal_statistik.dart';
import 'package:moody/screens/profile_invitations.dart';
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
  static const String meditationHome = "/meditationHome";
  static const String meditationInfo = "/meditationInfo";
  static const String meditationStart = "/meditationStart";
  static const String meditationTimer = "/meditationTimer";
  static const String meditationEnd = "/meditationEnd";
  static const String atemUebung = "/atemUebung";
  static const String personalStatistic = "/personalStatistic";

  static const String showInvitations = "/getInvitations";

  static void reset(context) {
    Navigator.pushNamedAndRemoveUntil(
        context, RouteGenerator.splash, (route) => false);
  }

  RouteGenerator._();

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
      case meditationHome:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const MeditationHome());
      case meditationInfo:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const MeditationInfo());
      case meditationStart:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const MeditationStart());
      case meditationTimer:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const MeditationTimer());
      case meditationEnd:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const MeditationEnd());
      case atemUebung:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const Atemuebung());
      case personalStatistic:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const PersonalStatistic());
      case showInvitations:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ProfileInvitations());
      default:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const Splash());
    }
  }
}
