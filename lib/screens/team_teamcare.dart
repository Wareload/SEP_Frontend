import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/screens/team_invite.dart';
import 'package:moody/widgets/widgets.dart';

import '../api/exception/invalid_permission_exception.dart';
import '../api/exception/user_feedback_exception.dart';
import '../route/route_generator.dart';
import '../structs/profile.dart';
import '../structs/team.dart';

class TeamCare extends StatefulWidget {
  const TeamCare({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamCareState();
}

class _TeamCareState extends State<TeamCare> {
  List<Team> teams = [];
  int teamid = 0;
  Profile _profile = Profile.empty();

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    teamid = (args["teamid"]);
    _setProfile();
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return SingleChildScrollView(
        child: Column(children: <Widget>[
          Widgets.getNavBar(constraints, _back, "Team-Care", _goToProfile),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              displayText(),
              const SizedBox(height: 25),
              Widgets.getButtonStyle2("Umfragen", () {
                print("TODO: Umfragen");
              }, constraints),
              const SizedBox(height: 2),
              Widgets.getButtonStyle2("Historie", () {
                _goToTeamHistorie();
              }, constraints),
            ],
          ),
        ]),
      );
    })));
  }

  //Get Profile
  void _setProfile() async {
    if (_profile.email != "email") {
    } else {
      print("submiting request for the profile");
      try {
        _profile = await Api.api.getProfile();
        setState(() {});
      } catch (e) {
        //no need to handle
      }
    }
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
    Navigator.pushNamed(context, RouteGenerator.teamDetails,
        arguments: {"team": team}).then((value) => {_loadTeams()});
  }

  void _goToProfile() {
    Navigator.pushNamed(context, RouteGenerator.profileOverview)
        .then((value) => {_loadTeams()});
  }

  void _goToTeamHistorie() {
    Navigator.of(context)
        .pushNamed(RouteGenerator.teamHistorie, arguments: {"teamid": teamid});
  }

  void _back() {
    Navigator.pop(context);
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

  Widget textCenteredHeader(String fullName) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      alignment: Alignment.center,
      child: Text(
        fullName,
        style: TextStyle(
            fontSize: 26.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  btnRedirect(String btnText, Widget widgetTo) {
    return Container(
      padding: EdgeInsets.only(left: 25, right: 25),
      child: Material(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => widgetTo),
            );
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 200,
            height: 50,
            alignment: Alignment.center,
            child: textOnRedirectBtn(btnText),
          ),
        ),
      ),
    );
  }

  displayImageOfMember() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 5),
          height: 70,
          width: 70,
          //color: Colors.red,
          child: CircleAvatar(
            radius: 16.0,
            child: ClipRRect(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                width: 190.0,
                height: 190.0,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: NetworkImage(
                            "https://bugsbunnies.de/images/logo.png"))),
              ),
            ),
          ),
        ),
        Text("NAME")
      ],
    );
  }

  Widget textOnRedirectBtn(String btnText) {
    return Container(
      child: Text(
        btnText,
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  displayText() {
    return Container(
      padding: EdgeInsets.all(30),
      child: Text(
          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."),
    );
  }
}
