import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/team.dart';

class TeamDetails extends StatefulWidget {
  final Map data;

  const TeamDetails(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamDetailsState();
}

bool isLoading = true;
Team _team = Team.empty();

bool canSelect = false;
String _timemessage = "Du hast heute schon abgestimmt";
bool gottimerstate = false;
int leaderState = 0;

class _TeamDetailsState extends State<TeamDetails> {
  Mood _currentSelectedMood = Mood();

  void loadData(team, leaderstate) async {
    try {
      //timerstate
      canSelect = await Api.api.getMoodTimer(team.id);
      gottimerstate = true;
      //teamapi
      _team = await Api.api.getTeam(team.id);
      _team.leader = leaderState;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      //no need to handle
    }
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
            return Column(
              children: [
                Widgets.getNavBar(constraints, _back, _team.name, _goToProfile),
                getMoodEmojisByState(constraints),
                Container(
                  height: 30,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Column(
                        children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Widgets.getButtonStyle3(
                          "Statistik", "assets/statistik_view.png", _goToStatistic, constraints),
                        Widgets.getButtonStyle3(
                            "Meditation", "assets/trees.png", _goToMeditation, constraints)],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        Widgets.getButtonStyle3(
                            "Atemübungen", "assets/windy.png", _goToAtemUebung, constraints),
                        // Widgets.getButtonStyle2("Umfragen", () {}, constraints), //Not implemented
                        Widgets.getButtonStyle3("Team", "assets/users.png", () {
                          Navigator.pushNamed(context, RouteGenerator.teamManage,
                              arguments: {"team": _team});
                        }, constraints)
                      ],)
                    ]),
                  ),
                ))
              ],
            );
          })));
  }

  @override
  void initState() {
    loadData(widget.data["team"], widget.data["leaderstate"]);
    super.initState();
  }

  void _back() {
    isLoading = true;
    Navigator.of(context).popUntil(
      (route) => route.isFirst,
    );
  }

  void _goToProfile() {
    Navigator.pushNamed(context, RouteGenerator.profileOverview);
  }

  void _goToStatistic() {
    Navigator.of(context)
        .pushNamed(RouteGenerator.teamHistorie, arguments: {"team": _team});
  }

  void _goToAtemUebung() {
    Navigator.of(context)
        .pushNamed(RouteGenerator.atemUebung, arguments: {"team": _team});
  }

  void _goToMeditation() {
    Navigator.of(context)
        .pushNamed(RouteGenerator.meditationHome, arguments: {"team": _team});
  }

  Widget getMoodEmojisByState(BoxConstraints constraints) {
    /*if (!gottimerstate) {
      return Widgets.getDisabledMoodEmojis("Loading...", () {}, () {}, () {}, constraints, _currentSelectedMood);
    } else
      */
    if (canSelect) {
      return Widgets.getMoodEmojis("Wie geht es dir heute?", () {}, () {
        Navigator.of(context).pushNamed(RouteGenerator.moodSelect,
            arguments: {'selectedMood': _currentSelectedMood, "team": _team});
      }, () {}, constraints, _currentSelectedMood);
    } else {
      return Widgets.getDisabledMoodEmojis(
          _timemessage, () {}, () {}, () {}, constraints, _currentSelectedMood);
    }
  }
}
