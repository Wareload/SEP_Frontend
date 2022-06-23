import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

import '../route/route_generator.dart';
import '../structs/team.dart';
import '../widgets/settings.dart';

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
    String response = "Erfolgreich";
    try {
      response = await Api.api.addTeamMember(_team.id, emailController.text);
    } catch (e) {
      print("Error:" + e.toString());
    }
    createAlertDialog(context, response);
    setState(() {});
  }

  createAlertDialog(BuildContext context, String response) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(response),
            actions: [
              getButtonStyleOrange("", _goToTeam, "Ok"),
            ],
          );
        });
  }

  static Widget getButtonStyleOrange(String display, VoidCallback func, String btnText) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Material(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: func,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            height: 60,
            alignment: Alignment.center,
            child: Text(
              btnText,
              style: const TextStyle(fontSize: 18.0, fontFamily: Settings.mainFont, 
fontWeight: FontWeight.bold, color: Settings.white),
            ),
          ),
        ),
      ),
    );
  }

  void _goToProfile() {
    Navigator.pushReplacementNamed(context, RouteGenerator.profileOverview);
  }

  void _goToTeam() {
    Navigator.pushReplacementNamed(context, RouteGenerator.teamManage, arguments: {"team": _team});
  }

  void _back() {
    Navigator.pop(context);
  }

  void _setTeam(Team team) async {
    _team = team;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }
}
