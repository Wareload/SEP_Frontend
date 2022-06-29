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
        : Scaffold(body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Widgets.getNavBar(constraints, _back, "Personal Statistic", _goToProfile, _profile),
                  //Text(moods),
                  getMoodWidgets()
                ],
              ),
            );
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

  @override
  void initState() {
    loadData(widget.data["team"], widget.data["moodList"], widget.data["profile"]);
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
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Settings.blueAccent))))),
    );
  }

  Widget getMoodWidget(MoodObject element) {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            border: Border.all(color: Settings.blue, width: 3),
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20) // use instead of BorderRadius.all(Radius.circular(20))
            ),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              displayEmoji("", Colors.green, () => {}, element, 0),
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
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
    );
  }

  Widget textWhiteH2(String teamname) {
    return Text(
      teamname,
      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15, color: Colors.black),
    );
  }

  static displayEmoji(String s, MaterialColor color, VoidCallback callback, MoodObject selectedMood, int id) {
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
}
