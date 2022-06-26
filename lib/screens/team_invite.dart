import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

import '../route/route_generator.dart';
import '../structs/profile.dart';
import '../structs/team.dart';
import '../widgets/settings.dart';

class TeamInvite extends StatefulWidget {
  final Map data;
  const TeamInvite(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamInviteState();
}

Team _team = Team.empty();
Profile _profile = Profile.empty();
bool isLoading = true;

class _TeamInviteState extends State<TeamInvite> {
  TextEditingController emailController = TextEditingController();

  void loadData(Team team, Profile profile) {
    _team = team;
    _profile = profile;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (builder, constraints) {
            return Column(children: <Widget>[
              Widgets.getNavBar(constraints, _back, "Teammitglied hinzufügen", _goToProfile, _profile),
              Widgets.getInputFieldLoginStyle("Email *", emailController, TextInputType.emailAddress),
              Widgets.getButtonStyleOrange(_sendInvitation, constraints, "Einladung senden"),
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
    } catch (e) {}
    createAlertDialog(context, response);
    setState(() {});
  }

  createAlertDialog(BuildContext context, String response) {
    return showDialog(
        context: context,
        builder: (context) {
          //sehr undynamisch gelöst hier,,, vl bessere lösung mit errorcode??
          if (response == "Server Fehler") {
            return AlertDialog(
              title: const Text("Eingegebene Email ungültig."),
              actions: [
                getButtonStyleOrange("", _removeAlertDialog, "Ok"),
              ],
            );
          } else {
            return AlertDialog(
              title: const Text("Einladung gesendet!"),
              actions: [
                getButtonStyleOrange("", _goToTeam, "Ok"),
              ],
            );
          }
        });
  }

  static Widget getButtonStyleOrange(String display, VoidCallback func, String btnText) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 10, right: 10),
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
              style: const TextStyle(fontSize: Settings.mainFontSize, fontWeight: FontWeight.bold, color: Settings.white),
            ),
          ),
        ),
      ),
    );
  }

  void _goToProfile() {
    Navigator.pushReplacementNamed(context, RouteGenerator.profileOverview);
  }

  void _removeAlertDialog() {
    Navigator.pop(context);
  }

  void _goToTeam() {
    //zwei mal pop ist gewollt. Close Alertdialog und close screen.
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _back() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    loadData(widget.data["team"], widget.data["profile"]);
    super.initState();
  }
}
