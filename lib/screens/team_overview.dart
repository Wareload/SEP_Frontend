import 'package:flutter/material.dart';
import 'package:moody/router/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

class TeamOverview extends StatefulWidget {
  const TeamOverview({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamOverviewState();
}

class _TeamOverviewState extends State<TeamOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(child: Column(
          children: [
            Container(padding: const EdgeInsets.fromLTRB(0, 0, 0, 20)),
            Row(
              children: [
                Widgets.getTextFieldH3C("Hallo David!", constraints),
                const Spacer(),
                //TODO fill in here profile
                Widgets.getTextButtonStyle1("Profile", _goToProfile,constraints)
              ],
            ),
            Widgets.getTextFieldH2("Deine Teams", constraints),
            Widgets.getProjectWidget("Bugs Bunnies", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Go Live or Go Home", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Work Smart and Hard", _goToTeam, constraints),
            Widgets.getProjectWidget("Bugs Bunnies", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Go Live or Go Home", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Work Smart and Hard", _goToTeam, constraints),
            Widgets.getProjectWidget("Bugs Bunnies", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Go Live or Go Home", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Work Smart and Hard", _goToTeam, constraints),
            Widgets.getProjectWidget("Bugs Bunnies", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Go Live or Go Home", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Work Smart and Hard", _goToTeam, constraints),
            Widgets.getProjectWidget("Bugs Bunnies", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Go Live or Go Home", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Work Smart and Hard", _goToTeam, constraints),
            Widgets.getProjectWidget("Bugs Bunnies", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Go Live or Go Home", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Work Smart and Hard", _goToTeam, constraints),
            Widgets.getProjectWidget("Bugs Bunnies", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Go Live or Go Home", _goToTeam, constraints),
            Widgets.getProjectWidget(
                "Work Smart and Hard", _goToTeam, constraints),
            Widgets.getProjectAddWidget("+", () {}, constraints),
          ],
        ),)
      );
    })));
  }

  void _goToTeam() {
    Navigator.pushNamed(context, RouteGenerator.teamDetails);
  }
  void _goToProfile(){
    Navigator.pushNamed(context, RouteGenerator.profileOverview);
  }

  @override
  void initState() {
    super.initState();
  }
}
