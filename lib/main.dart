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

IOSOptions _getIOSOptions() => IOSOptions(
  accountName: "",
);

final _storage = const FlutterSecureStorage();


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager().registerOneOffTask("1", simplePeriodicTask,initialDelay: Duration(seconds: 5));
  /*Workmanager().registerPeriodicTask(
    "66",
    simplePeriodicTask,
    initialDelay: Duration(seconds: 3),
    frequency: Duration(minutes: 15),
  );*/

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

    int? settingHour = time?.hour.toInt();
    int settingHour2 = settingHour! + 0;

    int? settingMinute = time?.minute.toInt();
    int settingMinute2 = settingMinute! + 0;

    bool isAlredySend = await getNotification();
    if (settingHour2 <= _now.hour ||
        (settingHour2 == _now.hour && settingMinute2 <= _now.minute)) {
      if (!isAlredySend) {
        showNotification([
          "Stimmung eintragen",
          "nicht vergessen!",
        ], flp);
      } else {
        await setNotification();
      }
    }else{
      print("Zeit für notification noch nicht erreicht");
    }

    //
    print("------------------------------------------------------");
    print("MOODStuff");
    print("------------------------------------------------------");


    List<TeamMoods> teamMoods = await _getNotiificationList();
    List<String> notificationsSent = [];
    int counter = 0;

    //GetTeamids already in there
    List<String> teamIDs = [""];
    String splitSpa = "";
    await storage.read(key: "teamnotify").then((value) => {
      {
        splitSpa = value.toString(),
      }
    });
    teamIDs = splitSpa.split(",");

    print(
        "+++++++++++++++++++++++++++++++++++++++++++++++++++++++" + splitSpa);
    print("-------------------------------------------------------" +
        teamIDs.toString());

    teamMoods.forEach((item) async {
      counter++;

      if (teamIDs.toString().contains(item.teamid.toString())) {
        print("Schon drinnen " + item.teamid.toString());
        print("######################################################################");

      }else {
        print("Teamid " + item.teamid.toString());
        print("Teamavg " + item.avg.toString());
        Random r = Random();
        if (item.avg > 3) {
          print("avg under 3 notifi");
          showNotification([
            "Achtung!",
            "Die Stimmung deines Teams könnte in Gefahr sein!",
          ], flp);
          print("notified");
        }
        print("Teamid " + item.teamid.toString());
        print("Teammin " + item.min.toString());
        if (item.min >= 5) {
          print("avg under 5 notifi");
          showNotification([
            "Achtung! - schlechte Stimmung!",
            "Einer im Team ${item
                .teamname} hat eine sehr schlechte Stimmung!",
            item.teamid
          ], flp);
        }
      }
      DateTime dateToday = new DateTime.now();
      String date = dateToday.toString().substring(0, 10);


      notificationsSent.add(item.teamid.toString());

      if (teamMoods.length == counter) {
        print("Letzte iteration!!!!");
        if ((teamIDs.isEmpty || teamIDs[0] != date) &&
            notificationsSent.isEmpty) {
          print("Setting up because its empty");
          await storage.write(key: "notificationstoday", value: date);
          print("999999999999999999999999999999999999");
        }

        String writeSecret = date;
        for (String item1 in teamIDs) {
          writeSecret += "," + item1;
        }
        for (String item2 in notificationsSent) {
          writeSecret += "," + item2;
        }
        print("try to write");
        //setDate();
        print("Writing: "+writeSecret);
        await writeToNotificationToday(writeSecret);
        print("WROTE EVERYTHING");
      } else {
        print("nTeammoodss" + teamMoods.length.toString());
        print("nCounters: " + counter.toString());
      }
    });

    return Future.value(true);
  });
}

Future<void> writeToNotificationToday(String valueString) async {
  const storage = FlutterSecureStorage();

  //await storage.delete(key: "teamnotify");
  await storage.write(key: "teamnotify", value: valueString);
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
    print("already notified mit: "+responsedate);
    return true;
  } else {
    await storage.delete(key: "notification");
    await storage.write(key: "notification", value: date);
    print("setting notificationdate");
    return false;
  }
  return true;
}

setDateEmpty() async {
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
      'channel id', 'channel ID',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.max//,
      /*ticker: 'ticker'*/);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: iOS);
  await flp.show(
    rng.nextInt(99),
    v[0].toString(),
    v[1].toString(),
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
