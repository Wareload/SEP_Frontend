import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/screens/team_invite.dart';
import 'package:moody/widgets/widgets.dart';

import '../api/exception/invalid_permission_exception.dart';
import '../api/exception/user_feedback_exception.dart';
import '../route/route_generator.dart';
import '../structs/profile.dart';
import '../structs/team.dart';
import '../widgets/custom_icons.dart';
import '../widgets/settings.dart';

class TeamManage extends StatefulWidget {
  final Map data;
  const TeamManage(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamManageState();
}

bool isLoading = true;

class _TeamManageState extends State<TeamManage> {
  List<Team> teams = [];
  Team _team = Team.empty();
  Profile _profile = Profile.empty();

  void loadData(Team team, Profile profile, int leaderstate) async {
    _team = await Api.api.getTeam(team.id);
    _team.leader = leaderstate;
    _profile = profile;
    setState(() {
      isLoading = false;
    });
  }

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

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
        : Scaffold(
            body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
              return Column(children: <Widget>[
                Widgets.getNavBar(constraints, _back, _team.name, _goToProfile, _profile),
                textCenteredHeader("Mitglieder"),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  flex: 1,
                  child: ListView(
                    children: [
                      _getMember(constraints),
                    ],
                  ),
                ),
              ]);
            })),
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              overlayOpacity: 0.5,
              elevation: 8,
              spacing: 10,
              closeManually: true,
              openCloseDial: isDialOpen,
              children: getSpeedDialList(),
            ),
          );
  }

  Widget _getMember(constraints) {
    List<Widget> members = [];

    for (var element in _team.members) {
      members.add(displayImageOfMember(element.firstName + " " + element.lastName, element.leader, constraints));
    }
    return Column(
      children: members,
    );
  }

  createAlertDialog(BuildContext context, String response) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(response),
            actions: [
              getButtonStyleOrange("", _goToHome, "Ok"),
            ],
          );
        });
  }

  createAlertDialogNothing(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
            actions: [
              getButtonStyleOrange("", () {
                Navigator.pop(context);
              }, "Ok"),
            ],
          );
        });
  }

  void _deleteTeam(Team team) async {
    String response = "Lädt...";
    try {
      response = await Api.api.deleteTeam(team.id);
    } catch (e) {}
    createAlertDialog(context, response);
  }

  Widget getTeams(BoxConstraints constraints) {
    List<Widget> widgets = [];
    for (var element in teams) {
      widgets.add(Widgets.getButtonStyle2(element.name, () => _goToTeam(element), constraints));
    }
    widgets.add(Widgets.getProjectAddWidget("+", _onCreateTeam, constraints));
    return Column(
      children: widgets,
    );
  }

  void _goToTeam(Team team) {
    Navigator.pushNamed(context, RouteGenerator.teamDetails, arguments: {"team": team});
  }

  void _goToHome() {
    Navigator.pushNamed(context, RouteGenerator.teamOverview);
  }

  void _goToTeamCare(Team team) {
    Navigator.pushNamed(context, RouteGenerator.teamCare, arguments: {"team": team});
  }

  void _goToProfile() {
    isLoading = true;
    Navigator.popAndPushNamed(context, RouteGenerator.profileOverview);
  }

  void _goToTeamInvite() {
    Navigator.of(context).pushNamed(RouteGenerator.teamInvite, arguments: {"team": _team, "profile": _profile});
  }

  void _back() {
    isLoading = true;
    Navigator.pop(context);
  }

  @override
  void initState() {
    loadData(widget.data["team"], widget.data["profile"], widget.data["leaderstate"]);
    super.initState();
  }

  void _onCreateTeam() {
    Navigator.pushNamed(context, RouteGenerator.teamCreate);
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

  Widget textCenteredHeader(String fullName) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      alignment: Alignment.center,
      child: Text(
        fullName,
        style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  intToBool(int input) {
    if (input == 1) {
      return true;
    } else {
      return false;
    }
  }

  displayImageOfMember(String name, int leader, BoxConstraints constraints) {
    if (intToBool(leader)) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 15, 5),
        child: Row(children: <Widget>[
          Widgets.getProfilePictureInitials(name, false, constraints),
          const SizedBox(
            width: 30,
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              //decoration: TextDecoration.underline,
            ),
          ),
          const Icon(
            CustomIcons.queen_crown,
            color: Colors.amber,
          ),
        ]),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 15, 5),
        child: Row(children: <Widget>[
          Widgets.getProfilePictureInitials(name, false, constraints),
          const SizedBox(
            width: 30,
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 20),
          ),
        ]),
      );
    }
  }

  getSpeedDialList() {
    if (intToBool(_team.leader)) {
      return [
        SpeedDialChild(
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: "Mitglied hinzufügen",
            backgroundColor: Settings.blue,
            onTap: () => {_goToTeamInvite(), isDialOpen.value = false}),
        SpeedDialChild(
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            label: "Team löschen",
            backgroundColor: Settings.blue,
            onTap: () => {_deleteTeam(_team), isDialOpen.value = false}),
      ];
    } else {
      return [
        SpeedDialChild(
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: "Mitglied hinzufügen",
            backgroundColor: Settings.blue,
            onTap: () => {_goToTeamInvite(), isDialOpen.value = false}),
        SpeedDialChild(
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
          label: "Team löschen",
          backgroundColor: Colors.grey,
        ),
      ];
    }
  }
}
