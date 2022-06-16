import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/settings.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/team.dart';

class PersonalStatistic extends StatefulWidget {
  const PersonalStatistic({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PersonalStatisticState();
}

class _PersonalStatisticState extends State<PersonalStatistic> {
  Team _team = Team.empty();
  TextEditingController noteController = TextEditingController();
  bool moodsLoaded = false;
  List<MoodObject> moods = [];
  int _daysToShow = 0;

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    _setTeam(args["team"]);
    if (!moodsLoaded && _team.id != 0) {
      _getPersonalMoods();
      moodsLoaded = true;
    }
    print(args);
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return Column(children: <Widget>[
        Widgets.getNavBar(
            constraints, _back, "Personal Statistic", _goToProfile),
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
                  getMoodWidgets()
                ],
              ),
              getBottomBar(() {}, _goToHistory),
            ],
          ),
        ),
      ]);
    })));
  }

  Widget getMoodWidgets() {
    List<Widget> widgets = [];
    for (var element in moods) {
      widgets.add(getMoodWidget(element));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  void _renderNew() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  void _setTeam(Team team) async {
    _team = team;
    setState(() {});
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
    } catch (e) {
      print(e);
    }
  }

  void _back() {
    Navigator.pop(context);
  }

  void _goToProfile() {
    Navigator.pushReplacementNamed(context, RouteGenerator.profileOverview);
  }

  void _goToHistory() {
    Navigator.pushReplacementNamed(context, RouteGenerator.teamHistorie,
        arguments: {"team": _team});
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
                      side: BorderSide(color: Settings.blueAccent))))),
    );
  }

  setTime(int days) {
    _daysToShow = days;
    _getPersonalMoods();
    setState(() {});
  }

  Widget getMoodWidget(MoodObject element) {
    return Container(
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
              displayEmoji(
                  "assets/verygood.png", Colors.green, () => {}, element, 0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  textWhiteH3(element.date),
                  textWhiteH2(element.note),
                ],
              )
            ],
          ),
        ));
  }

  Widget textWhiteH3(String teamname) {
    return Text(
      teamname,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
    );
  }

  Widget textWhiteH2(String teamname) {
    return Text(
      teamname,
      style: TextStyle(
          fontWeight: FontWeight.normal, fontSize: 15, color: Colors.white),
    );
  }

  static displayEmoji(String s, MaterialColor color, VoidCallback callback,
      MoodObject selectedMood, int id) {
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

  getBottomBar(VoidCallback ownFunc, VoidCallback teamFunc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        btnSelector("Eigene Ansicht", true, ownFunc),
        btnSelector(_team.name, false, teamFunc),
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
