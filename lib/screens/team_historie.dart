import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/screens/team_invite.dart';
import 'package:moody/widgets/widgets.dart';

import '../api/exception/invalid_permission_exception.dart';
import '../api/exception/user_feedback_exception.dart';
import '../route/route_generator.dart';
import '../structs/profile.dart';
import '../structs/team.dart';
import '../widgets/settings.dart';

class TeamHistorie extends StatefulWidget {
  final Map data;

  const TeamHistorie(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamHistorieState();
}

bool isLoading = true;
List<Team> teams = [];
Team _team = Team.empty();
Profile _profile = Profile.empty();
List<MoodObject> moods = [];

class _TeamHistorieState extends State<TeamHistorie> {
  int _daysToShow = 6;
  Map<String, List<MoodObject>> moodDates = {};

  void loadData(Team team, Profile profile) async {
    _team = team;
    _profile = profile;
    await _getTeamMoods();
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
            return Column(children: <Widget>[
              Widgets.getNavBar(
                  constraints, _back, "Team-Historie", _goToProfile, _profile),
              getTopBar(_goToPersonalStatistic, () {}),
              getTimeButtons(),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Text("Letzte ${_daysToShow + 1} Tage werden angezeigt"),
                        const SizedBox(height: 10),
                        SingleChildScrollView(child: getHistoryMoodWidgets()),
                      ],
                    ),
                  ],
                ),
              ),
            ]);
          })));
  }

  void _goToPersonalStatistic() {
    Navigator.pushReplacementNamed(context, RouteGenerator.personalStatistic,
        arguments: {"team": _team, "profile": _profile});
  }

  void _goToProfile() {
    Navigator.pushReplacementNamed(context, RouteGenerator.profileOverview);
  }

  void _goToTeamHistorieSingleDate(List<MoodObject> moodList) {
    Navigator.of(context).pushNamed(RouteGenerator.teamHistorieSingleDate,
        arguments: {"team": _team, "moodList": moodList, "profile": _profile});
  }

  void _back() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    loadData(widget.data["team"], widget.data["profile"]);
    super.initState();
  }

  Future<void> _getTeamMoods() async {
    String twoDigits(int n) => n.toString().padLeft(2, '0'); //9 would get to 09
    DateTime now = new DateTime.now();
    String endDate =
        "${now.year}-${twoDigits(now.month)}-${twoDigits(now.day)}";
    DateTime startDateTime = new DateTime.now();
    startDateTime = startDateTime.subtract(Duration(days: _daysToShow));
    String startDate =
        "${startDateTime.year}-${twoDigits(startDateTime.month)}-${twoDigits(startDateTime.day)}";
    try {
      moods = await Api.api.getTeamMood(_team.id, startDate, endDate);
      moodDates = {};
      for (var element in moods) {
        if (moodDates['${element.date}'] == null) {
          List<MoodObject> moodList = [];
          moodList.add(element);
          moodDates.putIfAbsent(element.date, () => moodList);
        } else {
          List<MoodObject>? moodList = [];
          moodList = moodDates["${element.date}"];
          moodList?.add(element);
          moodDates[element.date] = moodList!;
        }
      }
      setState(() {});
    } catch (e) {}
  }

  Widget getTimeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        timeButton("Heute", 0, () => {setTime(0)}),
        timeButton("Letzte Woche", 6, () => {setTime(6)}),
        timeButton("Letzter Monat", 31, () => {setTime(31)}),
        //timeButton("14Tage", () => {setTime(13)}),
      ],
    );
  }

  timeButton(String display, int id, VoidCallback func) {
    return Container(
      padding: EdgeInsets.only(left: 5),
      child: ElevatedButton(
          onPressed: func,
          child: Text(
            display,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
          ),
          style: ButtonStyle(
              backgroundColor: checkIfActive(id)
                  ? MaterialStateProperty.all<Color>(Colors.blueAccent)
                  : MaterialStateProperty.all<Color>(Colors.white54),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: getDisabledColor(id)))))),
    );
  }

  bool checkIfActive(int id) {
    if (id == _daysToShow) {
      return true;
    }
    return false;
  }

  Color getDisabledColor(int id) {
    if (id == _daysToShow) {
      return Colors.blueAccent;
    } else {
      return Colors.grey;
    }
  }

  setTime(int days) {
    _daysToShow = days;
    _getTeamMoods();
    setState(() {});
  }

  Widget textBlackH3(String teamname) {
    return Text(
      teamname,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
    );
  }

  Widget textWhiteH2(String teamname) {
    return Text(
      teamname,
      style: const TextStyle(
          fontWeight: FontWeight.normal, fontSize: 18, color: Colors.white),
    );
  }

  getSubmitCounter(int submits) {
    return Text(
      "Abstimmungen: $submits",
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
    );
  }

  static displayEmoji(String s, MaterialColor color, VoidCallback callback,
      MoodObject selectedMood) {
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

  Widget getHistoryMoodWidgets() {
    List<Widget> widgets = [];
    widgets.add(getTitleOfContainer());
    bool switcher = true;
    int counter = 0;
    bool last = false;
    if (moodDates.isEmpty) {
      return Center(
          child: Container(
        child: Text("Keine Daten vorhanden"),
      ));
    }
    moodDates.forEach((date, moodList) {
      counter++;
      if (moodDates.length == counter) last = true;
      double averageMood = 0;
      for (var element in moodList) {
        averageMood += element.activeMood;
      }
      averageMood = averageMood / moodList.length;
      widgets
          .add(getTeamMoodWidget(date, averageMood, moodList, switcher, last));
      switcher = !switcher;
    });
    return Container(
      height: MediaQuery.of(context).size.height / 1.6,
      child: SingleChildScrollView(
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
      getTextByDay(),
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  String getTextByDay() {
    if (_daysToShow == 6) {
      return "Letzte Woche";
    } else if (_daysToShow == 0) {
      return "Heute";
    } else {
      return "Letzter Monat";
    }
  }

  Widget getTeamMoodWidget(String date, double averageMood,
      List<MoodObject> moodList, bool switcher, bool last) {
    const blue1 = const Color(0xff89abe3);
    const blue2 = const Color(0xff2271D8);
    const blue3 = const Color(0xff0063b2);

    return InkWell(
      onTap: () {
        _goToTeamHistorieSingleDate(moodList);
      },
      child: Container(
          child: Container(
        decoration: BoxDecoration(
          color: switcher ? blue2.withOpacity(0.6) : blue2.withOpacity(0.9),
          borderRadius: last
              ? BorderRadius.only(
                  bottomRight: Radius.circular(18.0),
                  bottomLeft: Radius.circular(18.0))
              : BorderRadius.only(),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textBlackH3(getDateWithDay(date)),
                  getSubmitCounter(moodList.length),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 20),
              child: displayEmoji("", getColorByMood(averageMood), () => {},
                  MoodObject(averageMood.toInt(), date, "test")),
            ),
          ],
        ),
      )),
    );
  }

  String getDateWithDay(String date) {
    var dateLocal = DateTime.parse(date);
    return getWeekdayByInt(dateLocal.weekday) + ", " + date;
  }

  String getWeekdayByInt(int day) {
    if (day == 1) {
      return "Montag";
    } else if (day == 2) {
      return "Dienstag";
    } else if (day == 3) {
      return "Mittwoch";
    } else if (day == 4) {
      return "Donnerstag";
    } else if (day == 5) {
      return "Freitag";
    } else if (day == 6) {
      return "Samstag";
    } else {
      return "Sonntag";
    }
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

  getTopBar(VoidCallback ownFunc, VoidCallback teamFunc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        btnSelector("Eigene Ansicht", false, ownFunc),
        btnSelector("Team", true, teamFunc),
      ],
    );
  }

  btnSelector(String text, bool active, VoidCallback func) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FlatButton(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.transparent,
                  shadows: [Shadow(color: Colors.black, offset: Offset(0, -5))],
                  fontWeight: FontWeight.bold,
                  decoration: getUnderlineByBool(active),
                  decorationColor: Settings.blue,
                  decorationThickness: 4,
                  fontSize: 20),
            ),
            onPressed: func,
          ),
        ],
      ),
    );
  }

  getUnderlineByBool(bool active) {
    if (active) {
      return TextDecoration.underline;
    } else {
      return TextDecoration.none;
    }
  }
}

class MoodDates {
  List<MoodObject> moods = [];
  String date = "";
  MoodDates(this.date, MoodObject mood) {
    moods.add(mood);
  }
}
