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
  int _daysToShow = 0;
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
        : Scaffold(body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
            return Column(children: <Widget>[
              Widgets.getNavBar(constraints, _back, "Team-Historie", _goToProfile, _profile),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        getTimeButtons(),
                        Text("Letzte ${_daysToShow + 1} Tage werden angezeigt"),
                        const SizedBox(height: 10),
                        SingleChildScrollView(child: getHistoryMoodWidgets()),
                      ],
                    ),
                    getBottomBar(_goToPersonalStatistic, () {}),
                  ],
                ),
              ),
            ]);
          })));
  }

  void _goToPersonalStatistic() {
    Navigator.pushReplacementNamed(context, RouteGenerator.personalStatistic, arguments: {"team": _team, "profile": _profile});
  }

  void _goToProfile() {
    Navigator.pushReplacementNamed(context, RouteGenerator.profileOverview);
  }

  void _goToTeamHistorieSingleDate(List<MoodObject> moodList) {
    Navigator.of(context).pushNamed(RouteGenerator.teamHistorieSingleDate, arguments: {"team": _team, "moodList": moodList, "profile": _profile});
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
    String endDate = "${now.year}-${twoDigits(now.month)}-${twoDigits(now.day)}";
    DateTime startDateTime = new DateTime.now();
    startDateTime = startDateTime.subtract(Duration(days: _daysToShow));
    String startDate = "${startDateTime.year}-${twoDigits(startDateTime.month)}-${twoDigits(startDateTime.day)}";
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
        timeButton("1Tag", () => {setTime(0)}),
        timeButton("3Tage", () => {setTime(2)}),
        timeButton("7Tage", () => {setTime(6)}),
        timeButton("14Tage", () => {setTime(13)}),
      ],
    );
  }

  timeButton(String display, VoidCallback func) {
    return Container(
      padding: EdgeInsets.only(left: 5),
      child: ElevatedButton(
          onPressed: func,
          child: Text(display),
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: const BorderSide(color: Settings.blueAccent))))),
    );
  }

  setTime(int days) {
    _daysToShow = days;
    _getTeamMoods();
    setState(() {});
  }

  Widget textWhiteH3(String teamname) {
    return Text(
      teamname,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
    );
  }

  Widget textWhiteH2(String teamname) {
    return Text(
      teamname,
      style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18, color: Colors.white),
    );
  }

  Widget getTeamAverage(double average) {
    return Text(
      (4 - (average + 1)).toString(),
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: getColorByMood(average)),
    );
  }

  getSubmitCounter(int submits) {
    return Text(
      "Abstimmungen: $submits",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Settings.white),
    );
  }

  static displayEmoji(String s, MaterialColor color, VoidCallback callback, MoodObject selectedMood) {
    List moodnames = <String>["Sehr gut", "Gut", "alles gut", "naja", "Schlecht", "Sehr schlecht"];
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
              backgroundColor: Colors.black,
            ),
          ),
          const SizedBox(
            height: 2.0,
          ),
          Text(moodnames[selectedMood.activeMood]),
        ],
      ),
    );
  }

  Widget getHistoryMoodWidgets() {
    List<Widget> widgets = [];
    moodDates.forEach((date, moodList) {
      double averageMood = 0;
      for (var element in moodList) {
        averageMood += element.activeMood;
      }
      averageMood = averageMood / moodList.length;
      widgets.add(getTeamMoodWidget(date, averageMood, moodList));
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  Widget getTeamMoodWidget(String date, double averageMood, List<MoodObject> moodList) {
    return InkWell(
      onTap: () {
        _goToTeamHistorieSingleDate(moodList);
      },
      child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              border: Border.all(color: Settings.blue),
              color: Settings.blueAccent,
              borderRadius: BorderRadius.circular(20) // use instead of BorderRadius.all(Radius.circular(20))
              ),
          child: Container(
            color: Settings.blueAccent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWhiteH3(date),
                    getSubmitCounter(moodList.length),
                  ],
                ),
                displayEmoji("", Colors.green, () => {}, MoodObject(averageMood.toInt(), date, "test")),
              ],
            ),
          )),
    );
  }

  getColorByMood(double average) {
    if (average > 2) {
      return Colors.red;
    } else if (average > 1) {
      return Colors.orange;
    } else if (average > 0) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  getBottomBar(VoidCallback ownFunc, VoidCallback teamFunc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        btnSelector("Eigene Ansicht", false, ownFunc),
        btnSelector(_team.name, true, teamFunc),
      ],
    );
  }

  btnSelector(String text, bool active, VoidCallback func) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FlatButton(
            padding: EdgeInsets.all(5),
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.transparent,
                  shadows: [Shadow(color: Colors.black, offset: Offset(0, -5))],
                  fontWeight: FontWeight.normal,
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
