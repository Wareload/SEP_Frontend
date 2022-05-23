import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

import '../route/route_generator.dart';
import '../structs/team.dart';

class TeamOverview extends StatefulWidget {
  const TeamOverview({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamOverviewState();
}

class _TeamOverviewState extends State<TeamOverview> {
  List<Team> teams = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(top: constraints.maxWidth * 0.03)),
            Row(
              children: [
                Widgets.getTextFieldH3C("Hallo David!", constraints),
                const Spacer(),
                //TODO fill in here profile
                Container(
                  margin: EdgeInsets.only(right: constraints.maxWidth * 0.08),
                  child: IconButton(
                    onPressed: _goToProfile,
                    icon: Icon(Icons.account_circle,
                        color: Colors.blueGrey,
                        size: constraints.maxWidth * 0.15),
                  ),
                )
              ],
            ),
            Container(
              height: constraints.maxWidth * 0.2,
            ),
            Widgets.getTextFieldH2("Deine Teams", constraints),
            Widgets.getProjectWidget("Bugs Bunnies", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Go Live or Go Home", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Go Live or Go Home", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Go Live or Go Home", _goToTeam, constraints),
            Widgets.getProjectAddWidget("+", () {}, constraints),
          ],
        ),
      );
    })));
  }

  void _loadTeams() async{
    teams = await Api.api.getTeams();
    setState(() {
    });
  }

  void _goToTeam() {
    Navigator.pushNamed(context, RouteGenerator.teamDetails)
        .then((value) => {_loadTeams()});
  }

  void _goToProfile() {
    Navigator.pushNamed(context, RouteGenerator.profileOverview)
        .then((value) => {_loadTeams()});
  }

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }
}
