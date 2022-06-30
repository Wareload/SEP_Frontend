import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/settings.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/profile.dart';
import '../structs/team.dart';

class HistorySingleDate extends StatefulWidget {
  final Map data;

  const HistorySingleDate(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HistorySingleDateState();
}

Team _team = Team.empty();
Profile _profile = Profile.empty();
List<MoodObject> moods = [];
bool isLoading = true;
String dateString = "2022-6-1";

class _HistorySingleDateState extends State<HistorySingleDate> {
  TextEditingController noteController = TextEditingController();

  void loadData(Team team, List<MoodObject> moodList, Profile profile) {
    _team = team;
    _profile = profile;
    moods = moodList;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.white,
            child: const SizedBox(
              child: Align(
                child: CircularProgressIndicator(),
              ),
              width: 50,
              height: 50,
            ))
        : Scaffold(body:
            SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Widgets.getNavBar(
                      constraints, _back, "Statistik", _goToProfile, _profile),
                  //Text(moods),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(height: 10),
                            SingleChildScrollView(child: getMoodWidgets()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          })));
  }

  Widget getMoodWidgets() {
    List<Widget> widgets = [];
    widgets.add(getTitleOfContainer());
    bool switcher = true;
    int counter = 0;
    bool last = false;
    for (var element in moods) {
      counter++;
      if (moods.length == counter) last = true;
      dateString = element.date;
      widgets.add(getMoodWidget(element, switcher, last));
      switcher = !switcher;
    }
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgets,
        ),
      ),
    );
  }

  Widget getTitleOfContainer() {
    return Container(
      padding: EdgeInsets.only(top: 7, bottom: 3),
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(18.0),
          topLeft: Radius.circular(18.0),
        ),
      ),
      //height: 10,
      //color: Colors.blueAccent,
      child: Center(child: getTextByDayWidget()),
    );
  }

  Widget getTextByDayWidget() {
    return Text(
      dateString,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  getColorByMood(double average) {
    if (average == 5) {
      return Colors.blue;
    } else if (average >= 4) {
      return Colors.yellow;
    } else if (average >= 3) {
      return Colors.red;
    } else if (average >= 2) {
      return Colors.grey;
    } else if (average >= 1) {
      return Colors.green;
    } else if (average >= 0) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  void initState() {
    loadData(
        widget.data["team"], widget.data["moodList"], widget.data["profile"]);
    super.initState();
  }

  void _back() {
    Navigator.pop(context);
  }

  void _goToProfile() {
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, RouteGenerator.profileOverview);
  }

  timeButton(String display, VoidCallback func) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      child: ElevatedButton(
          onPressed: func,
          child: Text(display),
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Settings.blueAccent))))),
    );
  }

  Widget getMoodWidget(MoodObject element, bool lightState, bool last) {
    return Container(
        decoration: BoxDecoration(
          color: lightState
              ? Colors.grey.withOpacity(0.3)
              : Colors.grey.withOpacity(0.7),
          borderRadius: last
              ? BorderRadius.only(
                  bottomRight: Radius.circular(18.0),
                  bottomLeft: Radius.circular(18.0))
              : BorderRadius.only(),
        ),
        //margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        padding: EdgeInsets.all(15),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              displayEmoji("", getColorByMood(element.activeMood.toDouble()),
                  () => {}, element, 0),
              textWhiteH2(element.note),
            ],
          ),
        ));
  }

  Widget textWhiteH3(String teamname) {
    return Text(
      teamname,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
    );
  }

  Widget textWhiteH2(String teamname) {
    return Center(
      child: Container(
        width: 250,
        child: Text(
          teamname,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }

  static displayEmoji(String s, MaterialColor color, VoidCallback callback,
      MoodObject selectedMood, int id) {
    List moodPaths = <String>[
      "assets/verygood.png",
      "assets/good.png",
      "assets/smile.png",
      "assets/unamused.png",
      "assets/bad.png",
      "assets/verybad.png"
    ];

    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              radius: 29, //getRadiusByState(states, id),
              backgroundImage: AssetImage(moodPaths[selectedMood.activeMood]),
              backgroundColor: color,
            ),
          ),
          const SizedBox(
            height: 2.0,
          ),
        ],
      ),
    );
  }
}
