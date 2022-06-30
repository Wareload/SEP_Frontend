import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/settings.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/team.dart';

class NotificationSelect extends StatefulWidget {
  const NotificationSelect({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotificationSelectState();
}

class _NotificationSelectState extends State<NotificationSelect> {
  TextEditingController noteController = TextEditingController();

  TimeOfDay? time = const TimeOfDay(hour: 12, minute: 12);

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Widgets.getNavBarWithoutProfile(constraints, _back, "Notification"),
                        textWidgetCentered("wähle deine Zeit aus"),
                        textWidgetCentered("aktuelle Zeit: ${time!.hour.toString()}:${time!.minute.toString()}"),
                        Widgets.getButtonStyleOrange(_setTime, constraints, "Zeit setzen"),
                        SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        })));
  }

  TimeOfDay? stringToTime(String timeString) {
    var timeInString = timeString.split(":");
    print("timeSting" + timeString);
    print("timeInSting" + timeInString.toString());
    int minute = int.parse(timeInString[1].toString());
    int hour = int.parse(timeInString[0].toString());
    print("Setting new TimeOfDay with minute: " + minute.toString() + " hour:" + hour.toString());
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> setTimeFromStorage() async {
    const storage = FlutterSecureStorage();
    String timeString;
    await storage.read(key: "notificationtime").then((value) => {
          if (value != null) {timeString = value, time = stringToTime(timeString), _renderNew()}
        });
  }

  void _renderNew() {
    setState(() {});
  }

  Future<void> _setTime() async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: time!,
    );
    if (newTime != null) {
      setState(() => {time = newTime});
      const storage = FlutterSecureStorage();
      await storage.write(key: "notificationtime", value: "${time!.hour.toString()}:${time!.minute.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    setTimeFromStorage();
  }

  void _back() {
    Navigator.pop(context);
  }

  textWidgetCentered(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
