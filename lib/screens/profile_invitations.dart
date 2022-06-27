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

var refreshKey = GlobalKey<RefreshIndicatorState>();
bool isLoading = true;

class _ProfileInvitationsState extends State<ProfileInvitations> {
  TextEditingController teamNameController = TextEditingController();
  List<Invitation> invitations = [];
  List<Widget> invitationWidgets = [];
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
            return RefreshIndicator(
              key: refreshKey,
              onRefresh: refreshInvitations,
              child: Column(children: <Widget>[
                Widgets.getNavBarWithoutProfile(
                    constraints, _onBack, "Deine Einladungen"),
                Expanded(
                  flex: 1,
                  child: ListView(
                    children: <Widget>[
                      getInvitationwidgets(constraints),
                    ],
                  ),
                ),
              ]),
            );
          })));
  }

  Future<void> refreshInvitations() async {
    refreshKey.currentState?.show(atTop: false);
    getInvitations();
    setState(() {});
  }

  void _onBack() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    getInvitations();
    super.initState();
  }

  Future<void> getInvitations() async {
    try {
      invitations = await Api.api.getInvitations();
      setState(() {
        isLoading = false;
      });
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

  void toggleActive(Invitation invite) {
    invite.toggleActive();
    _renderNew();
  }

  Widget getInvitationWidget(Invitation invite, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.all(10),
      //height: 300,
      decoration: getBoxDecoration(invite.active),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => {toggleActive(invite)},
            child: Container(
                //margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                padding: EdgeInsets.all(10),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWhiteH3(invite.teamname),
                      /* Row(
                        children: [
                          acceptBtn(invite),
                          declineBtn(invite),
                        ],
                      ),*/
                    ],
                  ),
                )),
          ),
          showActive(constraints, invite),
          /*Container(
            width: 300,
            child: Text("Du wurdest zu dem Team " +
                invitations[1].teamname +
                " eingeladen!"),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getButtonStyleOrangeMini(() => {}, "Annehmen", constraints),
              getButtonStyleOrangeMini(() => {}, "Ablehnen", constraints),
            ],
          )*/
        ],
      ),
    );
  }

  BoxDecoration getBoxDecoration(bool active) {
    if (!active) return BoxDecoration();
    return BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Settings.white,
        borderRadius: BorderRadius.circular(
            20) // use instead of BorderRadius.all(Radius.circular(20))
        );
  }

  Widget showActive(BoxConstraints constraints, Invitation invite) {
    if (!invite.active) return Container();
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          width: 270,
          child: Text(
            "Du wurdest zu dem Team " + invite.teamname + " eingeladen!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getButtonStyleOrangeMini(
                () => {acceptInvitation(invite)}, "Annehmen", constraints),
            getButtonStyleOrangeMini(
                () => {denyInvitation(invite)}, "Ablehnen", constraints),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget getInvitationwidgets(BoxConstraints constraints) {
    List<Widget> invitationWidgets = [];
    for (var element in invitations) {
      invitationWidgets.add(getInvitationWidget(element, constraints));
    }
    if (invitations.length == 0) {
      return Column(
        children: [
          Text("Du hast aktuell keine Einladungen"),
        ],
      );
    }
    return Column(
      children: invitationWidgets,
    );
  }

  Widget textWhiteH3(String teamname) {
    return Text(
      teamname,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
    );
  }

  /*Widget acceptBtn(Invitation invite) {
    return getButtonStyleOrangeMini(()=>{},c)
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
  }*/

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

  static Widget getButtonStyleOrangeMini(
      VoidCallback func, String btnText, BoxConstraints constraints) {
    return Container(
      padding: EdgeInsets.all(10),
      //margin: EdgeInsets.only(left: 10, right: 10),
      child: Material(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.orange,
            textStyle: TextStyle(fontSize: 20),
            shape: StadiumBorder(),
          ),
          onPressed: func,
          //borderRadius: BorderRadius.circular(50),
          child: Container(
            height: 40,
            width: constraints.maxWidth * 0.3,
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

  Future<void> acceptInvitation(Invitation invite) async {
    try {
      invitations.remove(invite);
      _renderNew();
      await Api.api.acceptInvitation(invite.teamid);
      Navigator.pushNamed(context, RouteGenerator.teamOverview);
    } catch (e) {
      //TODO handle errors
    }
  }

  Future<void> denyInvitation(Invitation invite) async {
    try {
      await Api.api.denyInvitation(invite.teamid);
      invitations.remove(invite);
      setState(() {});
    } catch (e) {
      //TODO handle errors
    }
  }
}
