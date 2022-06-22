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
  final Map data;
  const TeamOverview(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamOverviewState();
}

bool isLoading = true;
List<Team> teams = [];
Profile _profile = Profile.empty();
String _invitations = "";
List<Invitation> invitations = [];

class _TeamOverviewState extends State<TeamOverview> {
  void initData(
      Profile loadedProfile, List loadedInvitations, List loadedTeams) {
    try {
      _profile = loadedProfile;
      invitations = loadedInvitations as List<Invitation>;
      teams = loadedTeams as List<Team>;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      //no need to handle
    }
  }

  void apiCalls() async {
    try {
      _profile = await Api.api.getProfile();
      invitations = await Api.api.getInvitations();
      teams = await Api.api.getTeams();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      //no need to handle
    }
  }

  @override
  Widget build(BuildContext context) {
    if (invitations.length >= 1) {
      _invitations = invitations.length.toString();
    } else {
      _invitations = "";
    }
    return isLoading
        ? const SizedBox(
            child: Align(
              child: CircularProgressIndicator(),
            ),
            width: 50,
            height: 50,
          )
        : Scaffold(body:
            SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
            return Column(
              children: [
                Container(
                    padding: EdgeInsets.only(top: constraints.maxWidth * 0.03)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Widgets.getTextFieldH2C(
                        "Hallo " + _profile.firstname + "!", constraints),
                    getInvitations(),
                    Widgets.getProfileIcon(constraints, _goToProfile),
                  ],
                ),
                /*Align(
                    alignment: Alignment.centerLeft,
                    child: Widgets.getTextButtonStyle1("Ausloggen", () async {
                      await Api.api.logout();
                      Navigator.pushReplacementNamed(context, RouteGenerator.login);
                    }, constraints)),*/
                Container(
                  height: constraints.maxWidth * 0.1,
                ),
                Widgets.getTextFieldH2("Deine Teams", constraints),
                Expanded(
                    child: SingleChildScrollView(child: getTeams(constraints))),
                Container(
                  height: 75,
                  child: Scaffold(
                    floatingActionButton: FloatingActionButton(
                        elevation: 8,
                        onPressed: _onCreateTeam,
                        child: const Text(
                          '+',
                          style: TextStyle(fontSize: 40),
                        )),
                  ),
                ),
                Container(
                  height: 10,
                )
              ],
            );
          })));
  }

  Widget getTeams(BoxConstraints constraints) {
    List<Widget> displayedTeams = [];
    for (var element in teams) {
      displayedTeams.add(Widgets.getButtonStyle2(
          element.name, () => _goToTeam(element), constraints));
    }
    return Column(
      children: displayedTeams,
    );
  }

  void _goToTeam(Team team) {
    Navigator.pushNamed(context, RouteGenerator.teamDetails,
        arguments: {"team": team, "leader": team.leader});
  }

  void _goToProfile() {
    Navigator.pushNamed(context, RouteGenerator.profileOverview)
        .then((value) => {apiCalls()});
  }

  void _goToInvitations() {
    Navigator.pushNamed(context, RouteGenerator.showInvitations);
  }

  @override
  void initState() {
    initData(widget.data["profile"], widget.data["invitations"],
        widget.data["teams"]);
    super.initState();
  }

  void _onCreateTeam() {
    Navigator.pushNamed(context, RouteGenerator.teamCreate)
        .then((value) => {apiCalls()});
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
            const Icon(
              Icons.email_outlined,
              size: 40,
              color: Colors.black,
            ),
            Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.only(left: 45, top: 10),
                child: Text(
                  "${_invitations}",
                  style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0),
                )),
          ],
        ), //Icon(I
      ),
    ); // cons.person_add_alt_1, size: 34),
  }
}
