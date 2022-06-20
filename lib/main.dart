import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moody/structs/profile.dart';
import 'package:moody/structs/team.dart';
import 'package:workmanager/workmanager.dart';
import 'api/api.dart';
import 'api/api_backend.dart';
import 'route/route_generator.dart';

//this is the name given to the background fetch
const simplePeriodicTask = "simplePeriodicTask";

Profile profile = Profile("email", "firstname", "lastname", []);
// flutter local notification setup
void showNotification(v, flp) async {
  var rng = Random();

  var android = const AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: iOS);
  await flp.show(
    rng.nextInt(222222),
    v[0],
    v[1],
    platform,
    payload: 'item x',
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager().registerOneOffTask("1", "simpleTask",
      initialDelay: Duration(seconds: 5));

  /*Workmanager().registerOneOffTask(
    simplePeriodicTask,
    simplePeriodicTask, // Ignored on iOS
    initialDelay: Duration(seconds: 10),
  );
  Workmanager().registerPeriodicTask(
    simplePeriodicTask,
    simplePeriodicTask,
    initialDelay: Duration(seconds: 10),
    // When no frequency is provided the default 15 minutes is set.
    // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
    frequency: Duration(minutes: 15),
  );*/
  /*await Workmanager.registerPeriodicTask("5", simplePeriodicTask,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: Duration(minutes: 15), //when should it check the link
      initialDelay:
          Duration(seconds: 5), //duration before showing the notification
      constraints: Constraints(
        networkType: NetworkType.connected,
      ));*/
  runApp(const MyApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android: android, iOS: iOS);
    flp.initialize(initSetttings);

    List<TeamMoods> teamMoods = await _getNotiificationList();

    teamMoods.forEach((item) async {
      if (item.avg > 3) {
        showNotification([
          "Achtung - Teamstimmung unter 3!",
          "Die Teamstimmung in Team ${item.teamid} ist unter 3!",
          item.teamid
        ], flp);
      }
      if (item.min >= 5) {
        showNotification([
          "Achtung - Ein Teammitglied ist unter 2!",
          "Einer im Team ${item.teamid} hat eine Stimmung von 2 oder drunter!",
          item.teamid
        ], flp);
      }
    });
    //showNotification("${profile.firstname} ${profile.lastname} ist toll", flp);
    /* var convert = json.decode(response.body);
    if (convert['status']  == true) {
      showNotification(convert['msg'], flp);
    } else {
      print("no messgae");
    }*/

    return Future.value(true);
  });
}

//Get Profile
Future<List<TeamMoods>> _getNotiificationList() async {
  List<TeamMoods> teamMoods = [];
  print("submiting request for the teammood");
  try {
    teamMoods = await (await ApiBackend.instance()).getTeamMoods();
  } catch (e) {
    print(e);
  }

  return teamMoods;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Moody",
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: RouteGenerator.splash,
    );
  }
}
