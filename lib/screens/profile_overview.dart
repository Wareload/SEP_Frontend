import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:moody/widgets/widgets.dart';

import '../api/api.dart';
import '../api/exception/invalid_permission_exception.dart';
import '../api/exception/user_feedback_exception.dart';
import '../route/route_generator.dart';
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
Profile _profile = Profile.empty();
bool isSettingsOpen = false;

class _ProfileOverviewState extends State<ProfileOverview> {
  void apiCalls() async {
    try {
      _profile = await Api.api.getProfile();
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
        : Scaffold(body:
            SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
            _getTeams(constraints);
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(right: 10, top: 10),
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
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10, top: 10),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueAccent),
                              //color: Settings.blueAccent,
                              height: 60,
                              width: 60,
                              child: IconButton(
                                  onPressed: _openSettingsMenu,
                                  icon: Icon(Icons.settings,
                                      color: Colors.white, size: 40)),
                            ),
                          ],
                        )
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
                ),
                //Settings
                getSettings(constraints),
              ],
            );
          })));
  }

  Widget getSettings(BoxConstraints constraints) {
    if (!isSettingsOpen) {
      return Column(
        children: [
          SizedBox(
            height: 1,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(
            height: 80,
          ),
          Material(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: EdgeInsets.only(top: 10),
              //color: Colors.black.withOpacity(0.5),
              child: Column(
                children: [
                  getMiniButton(
                      constraints, "Profil bearbeiten", _openProfileEdit),
                  getMiniButton(constraints, "Benachrichtigung bearbeiten",
                      _openNotificationSettings),
                  getMiniButton(constraints, "Abmelden", _logout),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget getMiniButton(
      BoxConstraints constraints, String text, VoidCallback callback) {
    return Container(
        margin: EdgeInsets.only(bottom: constraints.maxWidth * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // margin: EdgeInsets.only(left: constraints.maxWidth * 0.05),
              width: constraints.maxWidth * 0.90,
              child: Material(
                color: Settings.blueAccent,
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  onTap: callback,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    height: constraints.maxWidth * 0.15,
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Settings.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  //Teams

  Widget _getTeams(constraints) {
    List<Widget> widgets = [];
    for (var element in teams) {
      widgets.add(Widgets.getProfileTeam(element.name, () {
        _goToTeam(element);
      }, () {
        _leaveTeam(element);
      }, constraints, element));
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
    //Navigator.popAndPushNamed(context, RouteGenerator.teamOverview);
  }

  void _openSettingsMenu() {
    isSettingsOpen = !isSettingsOpen;
    setState(() {});
  }

  void _openNotificationSettings() {
    Navigator.pushReplacementNamed(
        context, RouteGenerator.personalNotificationSetting);
  }

  void _openProfileEdit() {
    setState(() {});
  }

  Future<void> _logout() async {
    await Api.api.logout();
    Navigator.pushReplacementNamed(context, RouteGenerator.login);
  }

  void _leaveTeam(Team team) async {
    try {
      //TODO change delete team to leave team
      await Api.api.leaveTeam(team.id);
      teams.remove(team);
      setState(() {});
    } catch (e) {
      //TODO handle errors
    }
  }

  void _goToTeam(Team team) {
    Navigator.popAndPushNamed(context, RouteGenerator.teamDetails,
        arguments: {"team": team, "leader": team.leader});
  }

  @override
  void initState() {
    apiCalls();
    super.initState();
    isSettingsOpen = false;
  }
}
