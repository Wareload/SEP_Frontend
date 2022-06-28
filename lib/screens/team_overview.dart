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
  void initData(Profile loadedProfile, List loadedInvitations, List loadedTeams) {
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
              return Column(
                children: [
                  Container(padding: EdgeInsets.only(top: constraints.maxWidth * 0.03)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Widgets.getTextFieldH2Black("Hallo " + _profile.firstname + "!", constraints),
                      Widgets.getProfilePictureNavBar(_profile, constraints, _goToProfile),
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
                    child: SizedBox(
                      height: constraints.maxHeight - 10,
                      width: constraints.maxWidth,
                      child: ListView(children: getTeams(constraints)),
                    ),
                  ),
                ],
              );
            })),
            floatingActionButton: FloatingActionButton(
              elevation: 8,
              onPressed: _onCreateTeam,
              child: const Icon(
                Icons.add,
                size: 35,
              ),
            ));
  }

  List<Widget> getTeams(BoxConstraints constraints) {
    List<Widget> displayedTeams = [];
    for (var element in teams) {
      displayedTeams.add(Widgets.getTeamWithPictures(element.name, () => _goToTeam(element), constraints));
    }
    return displayedTeams;
  }

  void _goToTeam(Team team) {
    Navigator.pushNamed(context, RouteGenerator.teamDetails, arguments: {"team": team, "leader": team.leader});
  }

  void _goToProfile() {
    Navigator.pushNamed(context, RouteGenerator.profileOverview).then((value) => {apiCalls()});
  }

  void _goToInvitations() {
    isLoading = true;
    Navigator.pushNamed(context, RouteGenerator.showInvitations).then((value) => {setState(() {}), initInvitations()});
  }

  @override
  void initState() {
    initData(widget.data["profile"], widget.data["invitations"], widget.data["teams"]);
    super.initState();
  }

  void _onCreateTeam() {
    isLoading = true;
    Navigator.pushNamed(context, RouteGenerator.teamCreate, arguments: {"invitations": invitations}).then((value) => {apiCalls()});
  }

  Future<void> initInvitations() async {
    invitations = await Api.api.getInvitations();
    setState(() {
      isLoading = false;
    });
  }
}
