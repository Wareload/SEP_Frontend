import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/settings.dart';
import 'package:moody/widgets/widgets.dart';

import '../api/exception/invalid_permission_exception.dart';
import '../api/exception/user_feedback_exception.dart';
import '../route/route_generator.dart';
import '../structs/invitation.dart';
import '../structs/profile.dart';
import '../structs/team.dart';

class TeamOverview extends StatefulWidget {
  const TeamOverview({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamOverviewState();
}

class _TeamOverviewState extends State<TeamOverview> {
  List<Team> teams = [];
  Profile _profile = Profile.empty();
  String _invitations = "";
  List<Invitation> invitations = [];

  @override
  Widget build(BuildContext context) {
    if (invitations.length >= 1) {
      _invitations = invitations.length.toString();
    } else {
      _invitations = "";
    }
    _setProfile();
    return Scaffold(body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return Column(
        children: [
          Container(padding: EdgeInsets.only(top: constraints.maxWidth * 0.03)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Widgets.getTextFieldH2C("Hallo " + _profile.firstname + "!", constraints),
              getInvitations(),
              Widgets.getProfileIcon(constraints, _goToProfile),
            ],
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Widgets.getTextButtonStyle1("Ausloggen", () async {
                await Api.api.logout();
                Navigator.pushReplacementNamed(context, RouteGenerator.login);
              }, constraints)),
          Container(
            height: constraints.maxWidth * 0.1,
          ),
          Widgets.getTextFieldH2("Deine Teams", constraints),
          Expanded(child: SingleChildScrollView(child: getTeams(constraints))),
          Container(
            height: 75,
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                  elevation: 12,
                  onPressed: _onCreateTeam,
                  child: const Text(
                    '+',
                    style: TextStyle(fontSize: 40),
                  )),
            ),
          ),
        ],
      );
    })));
  }

  //get Current Invitations
  Future<void> getInvitationList() async {
    try {
      invitations = await Api.api.getInvitations();
      print(invitations.length);
      setState(() {});
    } catch (e) {
      if (e.runtimeType == UserFeedbackException) {
        //TODO handle exception here
      } else if (e.runtimeType == InvalidPermissionException) {
        RouteGenerator.reset(context);
      }
    }
    setState(() {});
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
    List<Widget> displayedTeams = [];
    for (var element in teams) {
      displayedTeams.add(Widgets.getButtonStyle2(element.name, () => _goToTeam(element), constraints));
    }
    return Column(
      children: displayedTeams,
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
    Navigator.pushNamed(context, RouteGenerator.teamDetails, arguments: {"team": team, "leader": team.leader}).then((value) => {_loadTeams()});
  }

  void _goToProfile() {
    Navigator.pushNamed(context, RouteGenerator.profileOverview).then((value) => {_loadTeams()});
  }

  void _goToInvitations() {
    Navigator.pushNamed(context, RouteGenerator.showInvitations);
  }

  @override
  void initState() {
    super.initState();
    _loadTeams();
    getInvitationList();
  }

  void _onCreateTeam() {
    Navigator.pushNamed(context, RouteGenerator.teamCreate).then((value) => {_loadTeams()});
  }

  Widget getInvitations() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Settings.whiteAccent, //background color of button
          elevation: 0, //elevation of button
          shape: RoundedRectangleBorder(
              //to set border radius to button
              borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(0) //content padding inside button
          ),
      onPressed: _goToInvitations,
      child: Center(
        child: Stack(
          children: <Widget>[
            Container(
              child: Icon(
                Icons.person_add_alt_1,
                size: 40,
                color: Colors.black,
              ),
            ),
            Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.only(left: 45, top: 10),
                child: Text(
                  "${_invitations}",
                  style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 22.0),
                )),
          ],
        ), //Icon(I
      ),
    ); // cons.person_add_alt_1, size: 34),
  }
}
