import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

import '../api/exception/invalid_permission_exception.dart';
import '../api/exception/user_feedback_exception.dart';
import '../route/route_generator.dart';
import '../structs/profile.dart';
import '../structs/team.dart';

class TeamManage extends StatefulWidget {
  const TeamManage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamManageState();
}

class _TeamManageState extends State<TeamManage> {
  List<Team> teams = [];
  Profile _profile = Profile.empty();


  @override
  Widget build(BuildContext context) {
    _setProfile();
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
          return Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: constraints.maxWidth * 0.03)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Widgets.getTextFieldH3C("Hallo "+_profile.firstname+" !", constraints),
                  Widgets.getProfileIcon(constraints, _goToProfile),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  textCenteredHeader("Mitglieder"),
                  displayTeamIcons(),
                  SizedBox(height: 50),
                   btnRedirect("Team-Care", TeamManage()),
                  SizedBox(height: 30),
                  displayName("David Neus"),
                  SizedBox(height: 50),
                  checkBoxRole(),
                  SizedBox(height: 50),
                  //TODO: btn ist nicht responsive (also hängt nicht immer am bottom(weil es mit expanded einen error gibt(der nicht angezeit wird)));
                  btnDeleteTeam(),
                  //displayTeams(null,context),
                ],
              ),
            ],
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


  //Teams
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
    Navigator.pushNamed(context, RouteGenerator.teamDetails, arguments: {"team":team})
        .then((value) => {_loadTeams()});
  }

  void _goToProfile() {
    Navigator.pushNamed(context, RouteGenerator.profileOverview)
        .then((value) => {_loadTeams()});
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
      child: Text(fullName,
        style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
    );
  }

  //Displays all Teammember in a team
  displayTeamIcons() {
    return Container(
      child: SingleChildScrollView (
        child: RawScrollbar(
          thumbColor: Colors.blue,
          radius: Radius.circular(20),
          thickness: 5,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Row(
                  children: [
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),


                  ],
                ),
                Row(
                  children: [
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),
                    displayImageOfMember(),

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget displayName(String userFullName) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
      alignment: Alignment.center,
      child: Text(userFullName,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black),
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
      padding: EdgeInsets.only(left: 50,right: 50),
      child: Theme(
        data: theme.copyWith(checkboxTheme: newCheckBoxTheme),
        child: Column(
          children: [
            CheckboxListTile(
              title: const Text('Teamleader',
                style: TextStyle(fontSize: 20),),
              value: true,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value){},
            ),
            CheckboxListTile(
              title: const Text('Mitglied',
                style: TextStyle(fontSize: 20),),
              value: false,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value){},
            ),
          ],
        ),
      ),
    );
  }

  btnDeleteTeam() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
          padding: EdgeInsets.only(bottom: 30),
          child: Text(
            "Team löschen",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 20
            ),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  btnRedirect(String btnText,Widget widgetTo) {
    return Container(
      padding: EdgeInsets.only(left: 25,right: 25),
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
          margin: EdgeInsets.only(left: 10,right: 5),
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
                        image: NetworkImage("https://bugsbunnies.de/images/logo.png")
                    )
                ),
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
      child: Text(btnText,
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    );
  }
}
