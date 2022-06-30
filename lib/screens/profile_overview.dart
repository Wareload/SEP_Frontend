import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:moody/widgets/widgets.dart';

import '../api/api.dart';
import '../api/exception/invalid_permission_exception.dart';
import '../api/exception/user_feedback_exception.dart';
import '../route/route_generator.dart';
import '../structs/invitation.dart';
import '../structs/profile.dart';
import '../structs/team.dart';
import '../widgets/settings.dart';

class ProfileOverview extends StatefulWidget {
  const ProfileOverview({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProfileOverviewState();
}

bool isLoading = true;

List<Team> teams = [];
List<Invitation> invitations = [];
Profile _profile = Profile.empty();

final List teamImagesPaths = <String>[
  "assets/team_images/0.jpg",
  "assets/team_images/1.jpg",
  "assets/team_images/2.jpg",
  "assets/team_images/3.jpg",
  "assets/team_images/4.jpg",
  "assets/team_images/5.jpg",
  "assets/team_images/6.jpg",
  "assets/team_images/7.jpg",
  "assets/team_images/8.jpg",
  "assets/team_images/9.jpg",
  "assets/team_images/10.jpg",
  "assets/team_images/11.jpg",
  "assets/team_images/12.jpg",
  "assets/team_images/13.jpg",
  "assets/team_images/14.jpg",
  "assets/team_images/15.jpg",
  "assets/team_images/16.jpg",
  "assets/team_images/17.jpg",
  "assets/team_images/18.jpg",
  "assets/team_images/19.jpg",
  "assets/team_images/20.jpg",
];

int teamImageToShow = Random(DateTime.now().millisecond).nextInt(21);

class _ProfileOverviewState extends State<ProfileOverview> {
  void apiCalls() async {
    try {
      _profile = await Api.api.getProfile();
      teams = await Api.api.getTeams();
      invitations = await Api.api.getInvitations();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      //no need to handle
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
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
            key: _scaffoldKey,
            body:
                SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
              _getTeams(constraints);
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(right: 10, top: 10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        //color: Settings.blueAccent,
                        height: 60,
                        width: 60,
                        child: IconButton(
                            onPressed: _back,
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 40,
                            )),
                      ),
                      Center(
                        child: Widgets.getNavHeaderText(
                            "Dein Profil", constraints),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10, top: 10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.blueAccent),
                        //color: Settings.blueAccent,
                        height: 60,
                        width: 60,
                        child: IconButton(
                            onPressed: _openEndDrawer,
                            icon: Icon(Icons.settings,
                                color: Colors.white, size: 40)),
                      ),
                    ],
                  ),
                  Widgets.getProfilePictureInitials(
                      _profile.getFullName(), true, constraints),
                  Widgets.getTextFieldH2(_profile.getFullName(), constraints),
                  Widgets.getTextFieldH3(_profile.email, constraints),
                  displayTags(constraints),
                  Container(
                      margin:
                          EdgeInsets.only(left: constraints.maxWidth * 0.05),
                      child: Align(
                          child: Widgets.getTextFieldH3(
                              "Deine Teams:", constraints),
                          alignment: Alignment.centerLeft)),
                  Expanded(
                      child: SingleChildScrollView(
                    child: _getTeams(constraints),
                  ))
                ],
              );
            })),
            endDrawer: getDrawMenu(),
          );
  }

  //Teams

  Widget _getTeams(constraints) {
    List<Widget> widgets = [];
    for (var element in teams) {
      widgets.add(Widgets.getProfileTeam(element.name, () {
        _goToTeam(element);
      }, () {
        _leaveTeam(element);
      }, () {
        _deleteTeam(element);
      }, constraints, element,
          "assets/team_images/" + teamImageToShow.toString() + ".jpg"));
      teamImageToShow++;
      teamImageToShow %= 21;
    }
    return Column(
      children: widgets,
    );
  }

  Widget displayTags(BoxConstraints constraints) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 40,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemCount: _profile.tags.length,
          itemBuilder: (context, int index) {
            print(_profile.tags[index]);
            return Widgets.getContainerTag(_profile.tags[index], constraints);
          }),
    );
  }

  void _back() {
    Navigator.pop(context);
  }

  Future<void> _logout() async {
    await Api.api.logout();
    Navigator.pushNamedAndRemoveUntil(
        context, RouteGenerator.login, (r) => false);
  }

  void _leaveTeam(Team team) async {
    try {
      await Api.api.leaveTeam(team.id);
      teams.remove(team);
      setState(() {});
    } catch (e) {}
  }

  createAlertDialog(BuildContext context, String response, Team team) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(response),
            actions: [
              getButtonStyleOrange("", () => {_deleteTeamApi(team)}, "Ja"),
              getButtonStyleOrange("", () => {Navigator.pop(context)}, "Nein"),
            ],
          );
        });
  }

  static Widget getButtonStyleOrange(
      String display, VoidCallback func, String btnText) {
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
              style: const TextStyle(
                  fontSize: Settings.mainFontSize,
                  fontWeight: FontWeight.bold,
                  color: Settings.white),
            ),
          ),
        ),
      ),
    );
  }

  void _deleteTeam(Team team) async {
    createAlertDialog(
        context,
        "Möchtest du das Team " + team.name.toString() + " wirklich löschen?",
        team);
  }

  void _deleteTeamApi(Team team) async {
    String response = "Lädt...";
    try {
      response = await Api.api.deleteTeam(team.id);
    } catch (e) {}
    Navigator.pop(context);
    apiCalls();
  }

  void _goToTeam(Team team) {
    Navigator.popAndPushNamed(context, RouteGenerator.teamDetails,
        arguments: {"team": team, "leader": team.leader});
  }

  @override
  void initState() {
    apiCalls();
    super.initState();
  }

  Widget getDrawMenu() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
            child: ListTile(
                leading: const Icon(
                  Icons.people,
                  size: 35,
                ),
                title: const Text(
                  'zur Teamübersicht',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                onTap: () => {
                      Navigator.pushNamedAndRemoveUntil(context,
                          RouteGenerator.teamOverview, (route) => false,
                          arguments: {
                            "teams": teams,
                            "profile": _profile,
                            "invitations": invitations
                          }),
                    }),
          ),
          Divider(color: Colors.grey),
          ListTile(
              leading: const Icon(
                Icons.check,
                size: 35,
              ),
              title: const Text(
                'Tags bearbeiten',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              onTap: () => {
                    Navigator.pushReplacementNamed(
                        context, RouteGenerator.setTags,
                        arguments: {
                          "profile": _profile,
                        })
                  }),
          Divider(color: Colors.grey),
          ListTile(
              leading: const Icon(
                Icons.doorbell_outlined,
                size: 35,
              ),
              title: const Text(
                'Benachrichtigungen',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              onTap: () => {
                    Navigator.pushReplacementNamed(
                        context, RouteGenerator.personalNotificationSetting)
                  }),
          Divider(color: Colors.grey),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: GestureDetector(
                onTap: _logout,
                child: const ListTile(
                  leading: Icon(
                    Icons.logout,
                    size: 35,
                  ),
                  title: Text(
                    'Ausloggen',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
