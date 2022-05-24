import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

import '../api/exception/invalid_permission_exception.dart';
import '../api/exception/user_feedback_exception.dart';
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
          return Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: constraints.maxWidth * 0.03)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Widgets.getTextFieldH3C("Hallo David!", constraints),
                  Widgets.getProfileIcon(constraints, _goToProfile),
                ],
              ),
              Align(alignment: Alignment.centerLeft, child: Widgets.getTextButtonStyle1("Ausloggen", () async {
                await Api.api.logout();
                Navigator.pushReplacementNamed(context, RouteGenerator.login);
              }, constraints)),
              Container(
                height: constraints.maxWidth * 0.2,
              ),
              Widgets.getTextFieldH2("Deine Teams", constraints),
              Expanded(
                  child: SingleChildScrollView(child: getTeams(constraints))),
              Container(height: 10,)
            ],
          );
        })));
  }

  Widget getTeams(BoxConstraints constraints) {
    List<Widget> widgets = [];
    for (var element in teams) {
      widgets.add(Widgets.getButtonStyle2(
          element.name, () => _goToTeam(element), constraints));
    }
    widgets.add(Widgets.getProjectAddWidget("+", _onCreateTeam, constraints));
    return Column(
      children: widgets,
    );
  }

  void _loadTeams() async {
    try {
      teams = await Api.api.getTeams();
      setState(() {});
    } catch (e) {
      if (e.runtimeType == UserFeedbackException) {
        //TODO handle exception here
      } else if (e.runtimeType == InvalidPermissionException) {
        RouteGenerator.reset(context);
      }
    }
  }

  void _goToTeam(Team team) {
    Navigator.pushNamed(context, RouteGenerator.teamDetails, arguments: {"team":team})
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

  void _onCreateTeam() {
    Navigator.pushNamed(context, RouteGenerator.teamCreate)
        .then((value) => {_loadTeams()});
  }
}
