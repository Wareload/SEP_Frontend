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
  const TeamHistorie({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamHistorieState();
}

class _TeamHistorieState extends State<TeamHistorie> {
  List<Team> teams = [];
  Team _team = Team.empty();
  Profile _profile = Profile.empty();
  bool moodsLoaded = false;
  List<MoodObject> moods = [];
  int _daysToShow = 0;
  Map<String, List<MoodObject>> moodDates = {};

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    _setTeam(args["team"]);
    _setProfile();
    if (!moodsLoaded && _team.id != 0) {
      print("Gettingteammoods");
      _getTeamMoods();
      moodsLoaded = true;
    }
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return Column(children: <Widget>[
        Widgets.getNavBar(constraints, _back, "Team-Historie", _goToProfile),
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

  //Get Profile
  void _setProfile() async {
    if (_profile.email != "email") {
    } else {
      print("submiting request for the profile");
      try {
        _profile = await Api.api.getProfile();
        setState(() {});
      } catch (e) {
        //no need to handle
      }
    }
  }

  //Teams
  void _setTeam(Team team) async {
    _team = team;
    setState(() {});
  }

  void _goToPersonalStatistic() {
    Navigator.pushReplacementNamed(context, RouteGenerator.personalStatistic,
        arguments: {"team": _team});
  }

  void _goToProfile() {
    Navigator.pushReplacementNamed(context, RouteGenerator.profileOverview);
  }

  void _goToTeamHistorieSingleDate(List<MoodObject> moodList) {
    Navigator.of(context).pushNamed(RouteGenerator.teamHistorieSingleDate,
        arguments: {"team": _team, "moodList": moodList});
  }

  void _back() {
    Navigator.pop(context);
  }

  @override
  void initState() {
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
      print("teamid: ${_team.id} ${startDate} ${endDate}");
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
    } catch (e) {
      print(e);
    }
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
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Settings.blueAccent))))),
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
      style: const TextStyle(
           
fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
    );
  }

  Widget textWhiteH2(String teamname) {
    return Text(
      teamname,
      style: const TextStyle(
           
fontWeight: FontWeight.normal, fontSize: 18, color: Colors.white),
    );
  }

  Widget getTeamAverage(double average) {
    return Text(
      (4 - (average + 1)).toString(),
      style: TextStyle(
           
fontWeight: FontWeight.bold,
          fontSize: 30,
          color: getColorByMood(average)),
    );
  }

  getSubmitCounter(int submits) {
    return Text(
      "Abstimmungen: $submits",
      style: TextStyle(
           
fontWeight: FontWeight.bold, fontSize: 20, color: Settings.white),
    );
  }

  static displayEmoji(String s, MaterialColor color, VoidCallback callback,
      MoodObject selectedMood) {
    List moodnames = <String>[
      "Sehr gut",
      "Gut",
      "alles gut",
      "naja",
      "Schlecht",
      "Sehr schlecht"
    ];
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
    moodDates.forEach((date, moodlist) {
      double averageMood = 0;
      for (var element in moodlist) {
        averageMood += element.activeMood;
      }
      averageMood = averageMood / moodlist.length;
      print("-------------------------" + averageMood.toString());
      widgets.add(getTeamMoodWidget(date, averageMood, moodlist));
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  Widget getTeamMoodWidget(
      String date, double averageMood, List<MoodObject> moodList) {
    print("-------------------------" + averageMood.toInt().toString());

    return InkWell(
      onTap: () {
        _goToTeamHistorieSingleDate(moodList);
      },
      child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              color: Settings.blueAccent,
              borderRadius: BorderRadius.circular(
                  20) // use instead of BorderRadius.all(Radius.circular(20))
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
                displayEmoji("", Colors.green, () => {},
                    MoodObject(averageMood.toInt(), date, "test")),
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
                  decorationColor: Colors.blue,
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
