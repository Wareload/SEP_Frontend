import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/settings.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/profile.dart';
import '../structs/team.dart';

class PersonalStatistic extends StatefulWidget {
  final Map data;

  const PersonalStatistic(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PersonalStatisticState();
}

Team _team = Team.empty();
Profile _profile = Profile.empty();
List<MoodObject> moods = [];
bool isLoading = true;

class _PersonalStatisticState extends State<PersonalStatistic> {
  TextEditingController noteController = TextEditingController();
  bool moodsLoaded = false;

  int _daysToShow = 6;

  void loadData(Team team, Profile profile) {
    _team = team;
    _profile = profile;
    _getPersonalMoods();
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
              Widgets.getNavBar(constraints, _back, "Eigene Statistik",
                  _goToProfile, _profile),
              getTopBar(_goToHistory, () {}),
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
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                            child: getMoodWidgets(constraints)),
                      ],
                    ),
                  ],
                ),
              ),
            ]);
          })));
  }

  Widget getMoodWidgets(BoxConstraints constraints) {
    List<Widget> widgets = [];
    widgets.add(getTitleOfContainer());
    bool switcher = true;
    int counter = 0;
    bool last = false;
    if (moods.isEmpty) {
      return Center(
          child: Container(
        child: Text("Keine Daten vorhanden"),
      ));
    }
    for (var element in moods) {
      counter++;
      if (moods.length == counter) last = true;
      widgets.add(getMoodWidget(constraints, element, switcher, last));
      switcher = !switcher;
    }
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

  @override
  void initState() {
    isLoading = true;
    loadData(widget.data["team"], widget.data["profile"]);
    super.initState();
  }

  Future<void> _getPersonalMoods() async {
    String twoDigits(int n) => n.toString().padLeft(2, '0'); //9 would get to 09
    DateTime now = new DateTime.now();
    String endDate =
        "${now.year}-${twoDigits(now.month)}-${twoDigits(now.day)}";
    DateTime startDateTime = new DateTime.now();
    startDateTime = startDateTime.subtract(Duration(days: _daysToShow));
    String startDate =
        "${startDateTime.year}-${twoDigits(startDateTime.month)}-${twoDigits(startDateTime.day)}";
    try {
      moods = await Api.api.getPersonalMood(_team.id, startDate, endDate);
      setState(() {});
    } catch (e) {}
  }

  void _back() {
    Navigator.pop(context);
  }

  void _goToProfile() {
    Navigator.pushReplacementNamed(context, RouteGenerator.profileOverview);
  }

  void _goToHistory() {
    Navigator.pushReplacementNamed(context, RouteGenerator.teamHistorie,
        arguments: {"team": _team, "profile": _profile});
  }

  Widget getTimeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        timeButton("Heute", 0, () => {setTime(0)}),
        timeButton("Letzte Woche", 6, () => {setTime(6)}),
        timeButton("Letzter Monat", 31, () => {setTime(31)}),
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
    _getPersonalMoods();
    setState(() {});
  }

  Widget getMoodWidget(BoxConstraints constraints, MoodObject element,
      bool lightState, bool last) {
    return Container(
        decoration: BoxDecoration(
          color: lightState
              ? Colors.grey.withOpacity(0.3)
              : Colors.grey.withOpacity(0.7),
          borderRadius: last
              ? const BorderRadius.only(
                  bottomRight: Radius.circular(18.0),
                  bottomLeft: Radius.circular(18.0))
              : const BorderRadius.only(),
        ),
        //margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        padding: const EdgeInsets.all(10),
        child: Container(
          //color: Colors.grey.withOpacity(0.5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: constraints.maxWidth * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textWhiteH3(getDateWithDay(element.date)),
                    textNotes(element.note),
                  ],
                ),
              ),
              displayEmoji("", getColorByMood(element.activeMood.toDouble()),
                  () => {}, element, 0),
            ],
          ),
        ));
  }

  Widget textNotes(String note) {
    return Center(
      child: Container(
        width: 250,
        child: Text(
          note,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
      ),
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

  Widget textWhiteH3(String teamname) {
    return Text(
      teamname,
      style: TextStyle(
          fontWeight: FontWeight.normal, fontSize: 20, color: Colors.black),
    );
  }

  Widget textWhiteH2(String teamname) {
    return Text(
      teamname,
      style: TextStyle(
          fontWeight: FontWeight.normal, fontSize: 15, color: Colors.black),
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
          //Text(moodnames[selectedMood.activeMood]),
        ],
      ),
    );
  }

  getTopBar(VoidCallback ownFunc, VoidCallback teamFunc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        btnSelector("Eigene Ansicht", true, teamFunc),
        btnSelector("Team", false, ownFunc),
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
