import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

import '../api/exception/user_feedback_exception.dart';
import '../structs/profile.dart';
import '../structs/team.dart';
import '../widgets/settings.dart';

class MoodSelect extends StatefulWidget {
  final Map data;

  const MoodSelect(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MoodSelectState();
}

bool isLoading = true;
Team _team = Team.empty();
Profile _profile = Profile.empty();
Mood _currentSelectedMood = Mood();

class _MoodSelectState extends State<MoodSelect> {
  TextEditingController noteController = TextEditingController();

  void loadData(Mood selectedMood, Team team) async {
    try {
      _currentSelectedMood = selectedMood;
      // _team = await Api.api.getTeam(team.id);
      _team = team;
      _profile = await Api.api.getProfile();
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
        : Scaffold(body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Widgets.getNavBar(constraints, _back, "Wie geht es dir heute?", _goToProfile, _profile),
                  Widgets.displayInfoBoxWithTitle("Motivational Quote", "Persistance powers passion.", constraints),
                  Widgets.getMoodEmojis("Wie geht es Dir heute?", () {}, _renderNew, () {}, constraints, _currentSelectedMood),
                  Widgets.getInputField(noteController, TextInputType.text, constraints),
                  getButtonStyleOrangeWithAnimation(_submitMood, constraints, "Fertig", isLoading),
                ],
              ),
            );
          })));
  }

  Future<void> _submitMood() async {
    isLoading = !isLoading;
    try {
      await Api.api.setMood(_team.id, _currentSelectedMood.activeMood, noteController.text);
    } catch (e) {
      print(e);
    }
    Navigator.pop(context);
    setState(() {});
  }

  void _renderNew() {
    setState(() {});
  }

  @override
  void initState() {
    loadData(widget.data["selectedMood"], widget.data["team"]);
    super.initState();
  }

  void _back() {
    Navigator.pop(context);
  }

  void _goToProfile() {
    Navigator.pushNamed(context, RouteGenerator.profileOverview);
  }

  //button with a circularbtn animation for sending the mood to our backend
  static Widget getButtonStyleOrangeWithAnimation(VoidCallback func, BoxConstraints constraints, String btnText, bool isLoading) {
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
                    style: const TextStyle(fontSize: Settings.mainFontSize, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}

/*
Container(
            height: 60,
            alignment: Alignment.center,
            child: Text(btnText,
              style: const TextStyle(
                  fontSize: Settings.mainFontSize,
                   
fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
 */
