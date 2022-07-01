import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/screens/team_invite.dart';
import 'package:moody/widgets/widgets.dart';

import '../api/exception/invalid_permission_exception.dart';
import '../api/exception/user_feedback_exception.dart';
import '../route/route_generator.dart';
import '../structs/profile.dart';
import '../structs/team.dart';
import '../widgets/settings.dart';

class TeamManage extends StatefulWidget {
  const TeamManage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamManageState();
}

class _TeamManageState extends State<TeamManage> {
  List<Team> teams = [];
  Team _team = Team.empty();
  Profile _profile = Profile.empty();

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    _setTeam(args["team"]);
    _setProfile();

    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return SingleChildScrollView(
        child: Column(children: <Widget>[
          Widgets.getNavBar(constraints, _back, _team.name, _goToProfile),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              textCenteredHeader("Mitglieder"),
              const SizedBox(height: 3),
              _getMember(constraints),
              const SizedBox(height: 25),
              Widgets.getButtonStyle2(
                  "Hinzufügen", _goToTeamInvite, constraints),
              const SizedBox(height: 2),
              Widgets.getButtonStyle2("Team Care", () {
                _goToTeamCare(_team);
              }, constraints),
              const SizedBox(height: 2),
              getTeamDeleteButton(constraints),
              const SizedBox(height: 25),
              displayName(_profile.firstname + " " + _profile.lastname),
              checkBoxRole(),
            ],
          ),
        ]),
      );
    })));
  }

  Widget _getMember(constraints) {
    List<Widget> widgetsTop = [];
    List<Widget> widgetsBottom = [];

    bool top = true;
    for (var element in _team.members) {
      if (top) {
        top = false;
        widgetsTop.add(displayImageOfMember(
            element.firstName + " " + element.lastName, element.leader));
      } else {
        top = true;
        widgetsBottom.add(displayImageOfMember(
            element.firstName + " " + element.lastName, element.leader));
      }
    }
    return Container(
      child: SingleChildScrollView(
        child: RawScrollbar(
          thumbColor: Settings.blue,
          radius: Radius.circular(20),
          thickness: 5,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Row(
                  children: widgetsTop,
                ),
                Row(
                  children: widgetsBottom,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Get Profile
  void _setProfile() async {
    if (_profile.email != "email") {
    } else {
      try {
        _profile = await Api.api.getProfile();
        setState(() {});
      } catch (e) {
        //no need to handle
      }
    }
  }

  //Teams
  void _setTeam(Team team) async {
    _team = team;

    setState(() {});
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
    } catch (e) {
      print(e);
    }
    createAlertDialog(context, response);
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

  void _goToTeam(Team team) {
    Navigator.pushNamed(context, RouteGenerator.teamDetails,
        arguments: {"team": team});
  }

  void _goToHome() {
    Navigator.pushNamed(context, RouteGenerator.teamOverview);
  }

  void _goToTeamCare(Team team) {
    Navigator.pushNamed(context, RouteGenerator.teamCare,
        arguments: {"team": team});
  }

  void _goToProfile() {
    Navigator.pushNamed(context, RouteGenerator.profileOverview);
  }

  void _goToTeamInvite() {
    Navigator.of(context)
        .pushNamed(RouteGenerator.teamInvite, arguments: {"team": _team});
  }

  void _back() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  void _onCreateTeam() {
    Navigator.pushNamed(context, RouteGenerator.teamCreate);
  }

  static Widget getButtonStyleOrange(
      String display, VoidCallback func, String btnText) {
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
            height: 60.h,
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

  Widget textCenteredHeader(String fullName) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      alignment: Alignment.center,
      child: Text(
        fullName,
        style: TextStyle(
            fontSize: 26.0,  
fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  /*//Displays all Teammember in a team
  displayTeamIcons(BoxConstraints constraints) {
    return Container(
      child: SingleChildScrollView(
        child: RawScrollbar(
          thumbColor: Settings.blue,
          radius: Radius.circular(20),
          thickness: 5,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Row(
                  children: [
                    _getMember(constraints),
                    displayImageOfMember("Hans"),
                    displayImageOfMember("Hans"),
                  ],
                ),
                Row(
                  children: [
                    displayImageOfMember("Hans"),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }*/

  Widget displayName(String userFullName) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
      alignment: Alignment.center,
      child: Text(
        userFullName,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20.0,  
fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  checkBoxRole() {
    final theme = Theme.of(context);
    final oldCheckboxTheme = theme.checkboxTheme;

    final newCheckBoxTheme = oldCheckboxTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    );
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50),
      child: Theme(
        data: theme.copyWith(checkboxTheme: newCheckBoxTheme),
        child: Column(
          children: [
            getRightCheckbox(),
          ],
        ),
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

  btnDeleteTeam() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
          padding: EdgeInsets.only(bottom: 30),
          child: const Text(
            "Team löschen",
            style: TextStyle(
                color: Colors.black,
                 
fontWeight: FontWeight.normal,
                fontSize: 20),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  btnRedirect(String btnText, Widget widgetTo) {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Material(
        color: Settings.blue,
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
            width: 200.w,
            height: 50.h,
            alignment: Alignment.center,
            child: textOnRedirectBtn(btnText),
          ),
        ),
      ),
    );
  }

  displayImageOfMember(String name, int leader) {
    if (leader == 1) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 5),
            height: 70.h,
            width: 70.w,
            //color: Colors.red,
            child: Stack(children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: 46.0,
                child: ClipRRect(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: AssetImage(
                                "assets/king.png") /*NetworkImage(
                                "https://bugsbunnies.de/images/logo.png")*/
                            )),
                  ),
                ),
              ),
              /* Container(
                height: 70.h,
                width: 70.w,
                child: IconButton(
                    alignment: Alignment.bottomRight,
                    onPressed: _back,
                    icon: const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 30,
                    )),
              ),*/
            ]),
          ),
          Text(name),
        ],
      );
    }
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 5),
          height: 70.h,
          width: 70.w,
          //color: Colors.red,
          child: CircleAvatar(
            radius: 16.0,
            child: ClipRRect(
              child: Container(
                decoration: const BoxDecoration(
                    color: Settings.blue,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: NetworkImage(
                            "https://bugsbunnies.de/images/logo.png"))),
              ),
            ),
          ),
        ),
        Text(name),
      ],
    );
  }

  Widget textOnRedirectBtn(String btnText) {
    return Container(
      child: Text(
        btnText,
        style: TextStyle(
            fontSize: 20.0,  
fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget getTeamDeleteButton(BoxConstraints constraints) {
    if (intToBool(_team.leader)) {
      return Widgets.getButtonStyle2("Team löschen", () {
        _deleteTeam(_team);
      }, constraints);
    } else {
      return SizedBox();
    }
  }

  Widget getRightCheckbox() {
    if (intToBool(_team.leader)) {
      return CheckboxListTile(
        title: const Text(
          'Teamleader',
          style: TextStyle(fontSize: 20),
        ),
        value: true,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (bool? value) {},
      );
    }
    return CheckboxListTile(
      title: const Text(
        'Mitglied',
        style: TextStyle(fontSize: 20),
      ),
      value: true,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool? value) {},
    );
  }
}
