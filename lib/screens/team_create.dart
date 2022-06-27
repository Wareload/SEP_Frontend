import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/api/exception/invalid_permission_exception.dart';
import 'package:moody/route/route_generator.dart';

import '../api/exception/user_feedback_exception.dart';
import '../structs/invitation.dart';
import '../widgets/settings.dart';
import '../widgets/widgets.dart';

class TeamCreate extends StatefulWidget {
  const TeamCreate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamCreateState();
}

class _TeamCreateState extends State<TeamCreate> {
  String _errorText = "";
  TextEditingController teamNameController = TextEditingController();
  bool isSending = false;
  List<Invitation> invitations = [];

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    _setInvites(args["invitations"]);
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return Column(
        children: [
          Widgets.getNavBarWithoutProfile(
              constraints, _onBack, "Team erstellen"),
          SizedBox(
            height: 30,
          ),
          getButtonStyle2WithNotification(
              "Einladungen", _goToInvites, constraints),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Widgets.getInputFieldWithTitle(
                    teamNameController,
                    TextInputType.text,
                    false,
                    constraints,
                    "Teamname",
                    "Teamname hier eintragen"),
                getButtonStyleOrangeWithAnimation(
                    _onTeamCreate, constraints, "Fertig", isSending),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      );
    })));
  }

  void _setInvites(List<Invitation> invites) {
    invitations = invites;
  }

  void _onBack() {
    Navigator.pop(context);
  }

  void _goToInvites() {
    Navigator.pushNamed(context, RouteGenerator.showInvitations);
  }

  void _onTeamCreate() async {
    if (!isSending) {
      isSending = true;
      if (teamNameController.text != "") {
        try {
          await Api.api.createTeam(teamNameController.text);
          _onBack();
        } catch (e) {
          setState(() {
            if (e.runtimeType == UserFeedbackException) {
              _errorText = e.toString();
            } else if (e.runtimeType == InvalidPermissionException) {
              RouteGenerator.reset(context);
            }
          });
        }
      } else {
        isSending = false;
        createAlertDialog(context, "Gib einen Teamnamen ein!", () {
          Navigator.pop(context);
        });
        setState(() {});
      }
    }
  }

  //button with a circularbtn animation for sending the mood to our backend
  static Widget getButtonStyleOrangeWithAnimation(VoidCallback func,
      BoxConstraints constraints, String btnText, bool isLoading) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Material(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.orange,
            textStyle: TextStyle(fontSize: 20),
            shape: StadiumBorder(),
          ),
          onPressed: func,
          //borderRadius: BorderRadius.circular(50),
          child: isLoading
              ? Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      //animation/infotext?
                    ],
                  ),
                )
              : Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    btnText,
                    style: const TextStyle(
                        fontSize: Settings.mainFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }

  createAlertDialog(
      BuildContext context, String response, VoidCallback callback) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(response),
            actions: [
              getButtonStyleOrange("", callback, "Verstanden"),
            ],
          );
        });
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
            height: 60,
            alignment: Alignment.center,
            child: Text(
              btnText,
              style: const TextStyle(
                  fontSize: Settings.mainFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget getButtonStyle2WithNotification(
      String display, VoidCallback func, BoxConstraints constraints) {
    return Stack(
      children: [
        Container(
          height: 60,
          margin: EdgeInsets.only(
              bottom: constraints.maxWidth * 0.04, left: 10, right: 10),
          child: Material(
            color: Settings.blue,
            borderRadius: BorderRadius.circular(50),
            child: InkWell(
              onTap: func,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                alignment: Alignment.center,
                child: Text(
                  display,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Settings.white),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Container(
              margin: EdgeInsets.only(right: 10),
              alignment: Alignment.topRight,
              width: 30.0,
              height: 30,
              decoration: new BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),*/
            getNotification(),
          ],
        ),
      ],
    );
  }

  Widget getNotification() {
    if (invitations.length >= 1) {
      return Container(
        margin: EdgeInsets.only(right: 10),
        alignment: Alignment.topRight,
        width: 30.0,
        height: 30,
        decoration: new BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
