import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

import '../route/route_generator.dart';
import '../structs/team.dart';

class TeamInvite extends StatefulWidget {
  const TeamInvite({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamInviteState();
}

class _TeamInviteState extends State<TeamInvite> {
  Team _team = Team.empty();

  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    _setTeam(args["team"]);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (builder, constraints) {
            return Column(children: <Widget>[
              Widgets.getNavBar(constraints, _back, "Teammitglied hinzufügen", _goToProfile),
              Widgets.getInputFieldLoginStyle("Email *", emailController, TextInputType.emailAddress),
              Widgets.getButtonStyleOrange("", _sendInvitation, constraints, "Einladung senden"),
            ]);
          },
        ),
      ),
    );
  }

  void _sendInvitation() async {
    try {
      await Api.api.addTeamMember(_team.id, emailController.text);
    } catch (e) {
      print(e);
    }
    Navigator.pushReplacementNamed(context, RouteGenerator.teamManage, arguments: {"team": _team});
    setState(() {});
  }

  void _goToProfile() {
    Navigator.pushNamed(context, RouteGenerator.profileOverview);
  }

  void _back() {
    Navigator.pop(context);
  }

  void _setTeam(Team team) async {
    try {
      _team = await Api.api.getTeam(team.id);
      setState(() {});
    } catch (e) {
      //no need to handle
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
