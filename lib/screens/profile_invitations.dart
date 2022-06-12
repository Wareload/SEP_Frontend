import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/api/exception/invalid_permission_exception.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/structs/invitation.dart';
import 'package:moody/widgets/settings.dart';

import '../api/exception/user_feedback_exception.dart';
import '../widgets/widgets.dart';

class ProfileInvitations extends StatefulWidget {
  const ProfileInvitations({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileInvitationsState();
}

class _ProfileInvitationsState extends State<ProfileInvitations> {
  TextEditingController teamNameController = TextEditingController();
  List<Invitation> invitations = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return Column(
        children: [
          Widgets.getNavBarWithoutProfile(
              constraints, _onBack, "Deine Einladungen"),
          Expanded(
            child: SingleChildScrollView(
              child: getInvitationwidgets(),
            ),
          ),
        ],
      );
    })));
  }

  void _onBack() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    getInvitations();
  }

  Future<void> getInvitations() async {
    try {
      invitations = await Api.api.getInvitations();
      setState(() {});
    } catch (e) {
      if (e.runtimeType == UserFeedbackException) {
        //TODO handle exception here
      } else if (e.runtimeType == InvalidPermissionException) {
        RouteGenerator.reset(context);
      }
    }
    _renderNew();
  }

  void _renderNew() {
    setState(() {});
  }

  Widget getInvitationWidget(Invitation invite) {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            color: Settings.blueAccent,
            borderRadius: BorderRadius.circular(
                20) // use instead of BorderRadius.all(Radius.circular(20))
            ),
        child: Container(
          color: Settings.blueAccent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textWhiteH3(invite.teamname),
              Row(
                children: [
                  acceptBtn(invite),
                  declineBtn(invite),
                ],
              ),
            ],
          ),
        ));
  }

  Widget getInvitationwidgets() {
    List<Widget> widgets = [];
    for (var element in invitations) {
      widgets.add(getInvitationWidget(element));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  Widget textWhiteH3(String teamname) {
    return Text(
      teamname,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
    );
  }

  Widget acceptBtn(Invitation invite) {
    return IconButton(
        icon: const Icon(Icons.check),
        tooltip: 'TestToolTip',
        color: Colors.greenAccent,
        highlightColor: Colors.red,
        hoverColor: Colors.green,
        focusColor: Colors.purple,
        splashColor: Colors.yellow,
        disabledColor: Colors.amber,
        iconSize: 48,
        onPressed: () {
          acceptInvitation(invite);
        });
  }

  declineBtn(Invitation invite) {
    return IconButton(
        icon: const Icon(Icons.clear),
        tooltip: 'TestToolTip',
        color: Colors.red,
        highlightColor: Colors.red,
        hoverColor: Colors.green,
        focusColor: Colors.purple,
        splashColor: Colors.yellow,
        disabledColor: Colors.amber,
        iconSize: 48,
        onPressed: () {
          denyInvitation(invite);
        });
  }

  Future<void> acceptInvitation(Invitation invite) async {
    try {
      await Api.api.acceptInvitation(invite.teamid);
      invitations.remove(invite);
      setState(() {});
    } catch (e) {
      //TODO handle errors
    }
  }

  Future<void> denyInvitation(Invitation invite) async {
    try {
      //await Api.api.(invite.teamid);
      invitations.remove(invite);
      setState(() {});
    } catch (e) {
      //TODO handle errors
    }
  }
}
