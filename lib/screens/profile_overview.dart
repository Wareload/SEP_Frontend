import 'package:flutter/material.dart';
import 'package:moody/widgets/widgets.dart';

import '../api/api.dart';
import '../api/exception/invalid_permission_exception.dart';
import '../api/exception/user_feedback_exception.dart';
import '../route/route_generator.dart';
import '../structs/team.dart';

class ProfileOverview extends StatefulWidget {
  const ProfileOverview({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileOverviewState();
}

class _ProfileOverviewState extends State<ProfileOverview> {
  List<Team> teams = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: constraints.maxWidth * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: _back,
                  icon: Icon(Icons.arrow_back,
                      color: Colors.blue, size: constraints.maxWidth * 0.15)),
              Container(
                margin: EdgeInsets.only(right: constraints.maxWidth * 0.05),
                child: IconButton(
                    onPressed: () => {},
                    icon: Icon(Icons.settings,
                        color: Colors.blue, size: constraints.maxWidth * 0.15)),
              )
            ],
          ),
          Widgets.getProfileImage(
              "https://bugsbunnies.de/images/logo.png", constraints),
          Widgets.getTextFieldH2("David Neus", constraints),
          Widgets.getTextFieldH3("david.neus@gmx.de", constraints),
          _getTags(constraints),
          Container(
              margin: EdgeInsets.only(left: constraints.maxWidth * 0.05),
              child: Align(
                  child: Widgets.getTextFieldH3("Deine Teams:", constraints),
                  alignment: Alignment.centerLeft)),
          Expanded(
              child: SingleChildScrollView(
            child: _getTeams(constraints),
          ))
        ],
      );
    })));
  }

  Widget _getTeams(constraints) {
    List<Widget> widgets = [];
    for (var element in teams) {
      widgets.add(Widgets.getProfileTeam(element.name, () {
        _goToTeam(element);
      }, () {
        _deleteTeam(element);
      }, constraints));
    }
    return Column(
      children: widgets,
    );
  }

  Widget _getTags(BoxConstraints constraints) {
    return Container(
        margin: const EdgeInsets.all(10),
        height: 40,
        child: Center(
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Widgets.getContainerTag("Only", constraints),
              Widgets.getContainerTag("Fans", constraints),
              Widgets.getContainerTag("Jokes", constraints),
              Widgets.getContainerTag("Javascript", constraints),
              Widgets.getContainerTag("Testing", constraints),
              Widgets.getContainerTag("Spanish", constraints),
              Widgets.getContainerTag("Tryouts", constraints),
            ],
          ),
        ));
  }

  void _back() {
    Navigator.pop(context);
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

  void _deleteTeam(Team team) async{
    try {
      //TODO change delete team to leave team
      await Api.api.deleteTeam(team.id);
      teams.remove(team);
      setState(() {
      });
    } catch (e) {
      //TODO handle errors
    }
  }

  void _goToTeam(Team team) {
    Navigator.pushNamed(context, RouteGenerator.teamDetails, arguments: {"team":team})
        .then((value) => {_loadTeams()});
  }


  @override
  void initState() {
    super.initState();
    _loadTeams();
  }
}
