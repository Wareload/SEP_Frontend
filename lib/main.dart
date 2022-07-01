import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moody/api/notifications_api.dart';
import 'package:moody/structs/profile.dart';
import 'package:moody/widgets/settings.dart';
import 'package:workmanager/workmanager.dart';

import 'api/api_backend.dart';
import 'route/route_generator.dart';

//this is the name given to the background fetch
const simplePeriodicTask = "simplePeriodicTask";

Profile profile = Profile("email", "firstname", "lastname", []);

TimeOfDay? time = const TimeOfDay(hour: 18, minute: 0);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager().registerPeriodicTask(
    "66",
    simplePeriodicTask,
    initialDelay: Duration(seconds: 3),
    frequency: Duration(minutes: 15),
  );

  runApp(const MyApp());
}

//Notification
void callbackDispatcher() {
  print("calldispatcher");
  var storage = FlutterSecureStorage();

  Workmanager().executeTask((task, inputData) async {
    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android: android, iOS: iOS);
    flp.initialize(initSetttings);

    //Reminder to vote
    await setTimeFromStorage();
    DateTime _now = DateTime.now();
    print(
        'timestamp: ${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond}');
    int? settingHour = time?.hour.toInt();
    int settingHour2 = settingHour! + 0;

    int? settingMinute = time?.minute.toInt();
    int settingMinute2 = settingMinute! + 0;

    bool isAlredySend = await getNotification();
    if (settingHour2 <= _now.hour ||
        (settingHour2 == _now.hour && settingMinute2 <= _now.minute)) {
      if (!isAlredySend) {
        NotificationsApi.showNotification(
            body: "Du hast heute noch nicht deine Stimmung eingetragen!",
            title: "Trage deine Stimmung ein!");
      } else {
        await setNotification();
      }
    }

    //

    List<TeamMoods> teamMoods = await _getNotiificationList();
    List<String> notificationsSent = [];
    int counter = 0;
    teamMoods.forEach((item) async {
      counter++;
      List<String> teamIDs = [""];
      String splitSpa = "";
      await storage.read(key: "notificationstoday").then((value) => {
            {
              splitSpa = value.toString(),
              teamIDs = splitSpa.split(","),
              print("------------------" + value.toString())
            }
          });
      print(
          "+++++++++++++++++++++++++++++++++++++++++++++++++++++++" + splitSpa);
      print("-------------------------------------------------------" +
          teamIDs.toString());
      if (teamIDs.toString().contains(item.teamid.toString())) {
        print("Schon drinnen " + item.teamid.toString());
        return;
      }

      print("Teamid " + item.teamid.toString());
      print("Teamavg " + item.avg.toString());
      Random r = Random();
      if (item.avg > 3) {
        print("avg under 3 notifi");
        showNotification([
          "Achtung - Teamstimmung unter 3!",
          "Die Teamstimmung in Team ${item.teamname} ist unter 3 gesunken!",
        ], flp);
      }
      print("Teamid " + item.teamid.toString());
      print("Teammin " + item.min.toString());
      if (item.min >= 5) {
        print("avg under 5 notifi");
        showNotification([
          "Achtung - Ein Teammitglied hat eine schlechte Stimmung!",
          "Einer im Team ${item.teamname} hat eine Stimmung von 2 oder drunter!",
          item.teamid
        ], flp);
      }
      DateTime dateToday = new DateTime.now();
      String date = dateToday.toString().substring(0, 10);
      print("Date:" + date);
      print("Date2:" + date);

      /*await storage.read(key: "notificationstoday").then((value) => {
            {
              print("4_______________________" + value!),
              print("4------------------" + value.toString())
            }
          });*/
      print("Date3:" + date);

      notificationsSent.add(item.teamid.toString());
      print("Date31:" + date);

      if (teamMoods.length.toString() == counter.toString()) {
        if ((teamIDs.isEmpty || teamIDs[0] != date) &&
            notificationsSent.isEmpty) {
          print("Setting up because its empty");
          await storage.write(key: "notificationstoday", value: date);
        }
        print("Teammoodss" + teamMoods.length.toString());
        print("Counters: " + counter.toString());
        String writeSecret = date;
        for (String item1 in teamIDs) {
          writeSecret += "," + item1;
        }
        for (String item2 in notificationsSent) {
          writeSecret += "," + item2;
        }
        print("try to write");
        setDate();
        print("WROTE EVERYTHING");
      } else {
        print("nTeammoodss" + teamMoods.length.toString());
        print("nCounters: " + counter.toString());
      }
    });

    return Future.value(true);
  });
}

TimeOfDay? stringToTime(String timeString) {
  var timeInString = timeString.split(":");
  print("timeSting" + timeString);
  print("timeInSting" + timeInString.toString());
  int minute = int.parse(timeInString[1].toString());
  int hour = int.parse(timeInString[0].toString());
  print("Setting new TimeOfDay with minute: " +
      minute.toString() +
      " hour:" +
      hour.toString());
  return TimeOfDay(hour: hour, minute: minute);
}

Future<void> setTimeFromStorage() async {
  const storage = FlutterSecureStorage();
  String timeString;
  await storage.read(key: "notificationtime").then((value) => {
        if (value != null) {timeString = value, time = stringToTime(timeString)}
      });
}

setNotification() async {
  DateTime dateToday = new DateTime.now();
  String date = dateToday.toString().substring(0, 10);
  const storage = FlutterSecureStorage();
  await storage.delete(key: "notification");
  await storage.write(key: "notification", value: date);
}

Future<bool> getNotification() async {
  DateTime dateToday = new DateTime.now();
  String date = dateToday.toString().substring(0, 10);

  const storage = FlutterSecureStorage();
  String responsedate = "";
  await storage.read(key: "notification").then((value) => {
        if (value != null) {responsedate = value.toString()}
      });
  if (responsedate == date) {
    print("already notified");
    return true;
  } else {
    await storage.delete(key: "notification");
    await storage.write(key: "notification", value: date);
    print("setting notificationdate");
    return false;
  }
  return true;
}

setDate() async {
  print("Setting up because its empty");
  DateTime dateToday = new DateTime.now();
  String date = dateToday.toString().substring(0, 10);
  print("Date-:" + date);
  const storage = FlutterSecureStorage();
  await storage.delete(key: "notificationstoday");
  await storage.write(key: "notificationstoday", value: date);
  print("set null to notification");
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

void showNotification(v, flp) async {
  var rng = Random();

  var android = const AndroidNotificationDetails(
      'channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.min,
      priority: Priority.defaultPriority,
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Chivo',
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Settings.blue),
        primaryColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      title: "Moody",
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: RouteGenerator.splash,
    );
  }
}
