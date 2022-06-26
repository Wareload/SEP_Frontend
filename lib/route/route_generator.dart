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
import 'package:moody/screens/team_historie.dart';
import 'package:moody/screens/team_historie_singledate.dart';
import 'package:moody/screens/team_manage.dart';
import 'package:moody/screens/team_overview.dart';
import 'package:moody/screens/team_teamcare.dart';

import '../screens/team_invite.dart';

class RouteGenerator {
  static const String splash = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String teamOverview = "/teamOverview";
  static const String teamDetails = "/teamDetails";
  static const String profileOverview = "/profileOverview";
  static const String teamCreate = "/teamCreate";
  static const String teamManage = "/teamManage";
  static const String teamInvite = "/teamInvite";
  static const String teamCare = "/teamCare";
  static const String teamHistorie = "/teamHistorie";
  static const String teamHistorieSingleDate = "/teamHistorieSingleDate";

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
    Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.splash, (route) => false);
  }

  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case splash:
        return MaterialPageRoute(settings: settings, builder: (_) => const Splash());
      case login:
        return MaterialPageRoute(settings: settings, builder: (_) => const Login());
      case register:
        return MaterialPageRoute(settings: settings, builder: (_) => const Register());
      case teamOverview:
        if (args is Map) {
          return MaterialPageRoute(
              settings: settings, builder: (context) => TeamOverview(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>));
        }
        return MaterialPageRoute(settings: settings, builder: (_) => const Splash());
      case teamDetails:
        if (args is Map) {
          return MaterialPageRoute(
              settings: settings, builder: (context) => TeamDetails(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>));
        }
        return MaterialPageRoute(settings: settings, builder: (_) => const Splash());
      case profileOverview:
        return MaterialPageRoute(settings: settings, builder: (_) => const ProfileOverview());
      case teamCreate:
        return MaterialPageRoute(settings: settings, builder: (_) => const TeamCreate());
      case teamManage:
        if (args is Map) {
          return MaterialPageRoute(
              settings: settings, builder: (context) => TeamManage(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>));
        }
        return MaterialPageRoute(settings: settings, builder: (_) => const Splash());
      case teamInvite:
        if (args is Map) {
          return MaterialPageRoute(
              settings: settings, builder: (context) => TeamInvite(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>));
        }
        return MaterialPageRoute(settings: settings, builder: (_) => const Splash());
      case teamCare:
        return MaterialPageRoute(settings: settings, builder: (_) => const TeamCare());
      case teamHistorie:
        return MaterialPageRoute(settings: settings, builder: (_) => const TeamHistorie());
      case teamHistorieSingleDate:
        return MaterialPageRoute(settings: settings, builder: (_) => const HistorySingleDate());
      case moodSelect:
        if (args is Map) {
          return MaterialPageRoute(
              settings: settings, builder: (context) => MoodSelect(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>));
        }
        return MaterialPageRoute(settings: settings, builder: (_) => const Splash());

      case meditationHome:
        if (args is Map) {
          return MaterialPageRoute(
              settings: settings, builder: (context) => MeditationHome(ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>));
        }
        return MaterialPageRoute(settings: settings, builder: (_) => const Splash());

      case meditationInfo:
        return MaterialPageRoute(settings: settings, builder: (_) => const MeditationInfo());
      case meditationStart:
        return MaterialPageRoute(settings: settings, builder: (_) => const MeditationStart());
      case meditationTimer:
        return MaterialPageRoute(settings: settings, builder: (_) => const MeditationTimer());
      case meditationEnd:
        return MaterialPageRoute(settings: settings, builder: (_) => const MeditationEnd());
      case atemUebung:
        return MaterialPageRoute(settings: settings, builder: (_) => const Atemuebung());
      case personalStatistic:
        return MaterialPageRoute(settings: settings, builder: (_) => const PersonalStatistic());
      case showInvitations:
        return MaterialPageRoute(settings: settings, builder: (_) => const ProfileInvitations());
      default:
        return MaterialPageRoute(settings: settings, builder: (_) => const Splash());
    }
  }
}
