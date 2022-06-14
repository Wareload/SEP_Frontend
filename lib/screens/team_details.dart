import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/team.dart';

class TeamDetails extends StatefulWidget {
  const TeamDetails({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  Team _team = Team.empty();
  Mood _currentSelectedMood = Mood();
  bool canSelect = false;
  String _timemessage = "Du hast heute schon abgestimmt";
  bool gottimerstate = false;

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    _setTeam(args["team"]);
    if (!gottimerstate && _team.id != 0) {
      _setTimerstate(_team);
    }
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return Column(
        children: [
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Widgets.getTextButtonStyle1("Back", _back, constraints),
              Widgets.getTextFieldH3C(_team.name, constraints),
              Widgets.getProfileIcon(constraints, _goToProfile),
            ],
          ),
          Container(
            height: 10,
          ),
          getMoodEmojisByState(constraints),
          Container(
            height: 30,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(children: [
              Widgets.getButtonStyle2("Statistik", _goToStatistic, constraints),
              Widgets.getButtonStyle2(
                  "Meditation", _goToMeditation, constraints),
              Widgets.getButtonStyle2(
                  "Atemübungen", _goToAtemUebung, constraints),
              Widgets.getButtonStyle2("Umfragen", () {}, constraints),
              Widgets.getButtonStyle2("Team", () {
                Navigator.pushNamed(context, RouteGenerator.teamManage,
                    arguments: {"team": _team});
              }, constraints),
            ]),
          ))
        ],
      );
    })));
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _setTimerstate(Team team) async {
    try {
      canSelect = await Api.api.getMoodTimer(team.id);
      gottimerstate = true;
      setState(() {});
    } catch (e) {
      //no need to handle
    }
  }

  void _setTeam(Team team) async {
    try {
      _team = await Api.api.getTeam(team.id);
      setState(() {});
    } catch (e) {
      //no need to handle
    }
  }

  void _back() {
    Navigator.popAndPushNamed(context, RouteGenerator.teamOverview);
  }

  void _goToProfile() {
    Navigator.pushNamed(context, RouteGenerator.profileOverview);
  }

  void _goToStatistic() {
    Navigator.of(context).pushNamed(RouteGenerator.personalStatistic,
        arguments: {"team": _team});
  }

  void _goToAtemUebung() {
    Navigator.of(context)
        .pushNamed(RouteGenerator.atemUebung, arguments: {"team": _team});
  }

  void _goToMeditation() {
    Navigator.pushNamed(context, RouteGenerator.meditationHome);
  }

  Widget getMoodEmojisByState(BoxConstraints constraints) {
    if (!gottimerstate) {
      return Widgets.getDisabledMoodEmojis(
          "Loading...", () {}, () {}, () {}, constraints, _currentSelectedMood);
    } else if (canSelect) {
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
