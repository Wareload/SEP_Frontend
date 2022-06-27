import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/api/exception/invalid_permission_exception.dart';
import 'package:moody/route/route_generator.dart';

import '../api/exception/user_feedback_exception.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: _onBack,
                  icon: Icon(Icons.arrow_back,
                      color: Settings.blue, size: constraints.maxWidth * 0.15)),
              Widgets.getTextFieldH3C("Team erstellen", constraints),
            ],
          ),
          SizedBox(
            height: 30,
          ),
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

  void _onBack() {
    Navigator.pop(context);
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

  @override
  void initState() {
    super.initState();
  }
}
