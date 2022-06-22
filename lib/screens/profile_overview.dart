import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:moody/widgets/widgets.dart';

import '../api/api.dart';
import '../api/exception/invalid_permission_exception.dart';
import '../api/exception/user_feedback_exception.dart';
import '../route/route_generator.dart';
import '../structs/profile.dart';
import '../structs/team.dart';

class ProfileOverview extends StatefulWidget {
  const ProfileOverview({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProfileOverviewState();
}

bool isLoading = true;

List<Team> teams = [];
Profile _profile = Profile.empty();

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
                      width: 120,
                      child: IconButton(
                          onPressed: _back,
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.blue,
                            size: 40,
                          )),
                    ),
                    Center(
                      child:
                          Widgets.getNavHeaderText("Dein Profil", constraints),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10, top: 10),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blueAccent),
                          //color: Settings.blueAccent,
                          height: 60,
                          width: 60,
                          child: IconButton(
                              onPressed: _openSettingsMenu,
                              icon: Icon(Icons.settings,
                                  color: Colors.white, size: 40)),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10, top: 10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blueAccent),
                          //color: Settings.blueAccent,
                          height: 60,
                          width: 60,
                          child: IconButton(
                              onPressed: _logout,
                              icon: Icon(Icons.logout,
                                  color: Colors.white, size: 40)),
                        )
                      ],
                    )
                  ],
                ),
                Widgets.getProfileImage(
                    "https://bugsbunnies.de/images/logo.png", constraints),
                Widgets.getTextFieldH2(_profile.getFullName(), constraints),
                Widgets.getTextFieldH3(_profile.email, constraints),
                displayTags(constraints),
                Container(
                    margin: EdgeInsets.only(left: constraints.maxWidth * 0.05),
                    child: Align(
                        child:
                            Widgets.getTextFieldH3("Deine Teams:", constraints),
                        alignment: Alignment.centerLeft)),
                Expanded(
                    child: SingleChildScrollView(
                  child: _getTeams(constraints),
                ))
              ],
            );
          })));
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
    print("running");
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
    print("Opensettings todo");
    //TODO: Create a openSetting Menu
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
    Navigator.pushNamed(context, RouteGenerator.teamDetails,
        arguments: {"team": team});
  }

  @override
  void initState() {
    apiCalls();
    super.initState();
  }
}
