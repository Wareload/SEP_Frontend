import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    List feelingStatus = Widgets.getMoodList();

    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    _setTeam(args["team"]);
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
          Widgets.getMoodEmojis(
              "Wie geht es dir heute?", () {}, () {
            List<dynamic> map = [];
            map.add("2");
            Navigator.of(context).pushNamed(RouteGenerator.moodSelect, arguments: {"feelingState":feelingStatus});
          }, () {}, constraints,feelingStatus),
          Container(
            height: 30,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(children: [
              Widgets.getButtonStyle2("Statistik", () {}, constraints),
              Widgets.getButtonStyle2("Meditation", _goToMeditation, constraints),
              Widgets.getButtonStyle2("Atemübungen", () {}, constraints),
              Widgets.getButtonStyle2("Umfragen", () {}, constraints),
              Widgets.getButtonStyle2("Team", () {
                Navigator.pushNamed(context, RouteGenerator.teamManage);
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

  void _setTeam(Team team) async {
    try {
      _team = await Api.api.getTeam(team.id);
      setState(() {});
    } catch (e) {
      //no need to handle
    }
  }

  void _back() {
    Navigator.pop(context);
  }

  void _goToProfile() {
    Navigator.pushNamed(context, RouteGenerator.profileOverview);
  }
  void _goToMeditation() {
    Navigator.pushNamed(context, RouteGenerator.meditationHome);
  }
}
