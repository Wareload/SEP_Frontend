import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/team.dart';

class MoodSelect extends StatefulWidget {
  const MoodSelect({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MoodSelectState();
}

class _MoodSelectState extends State<MoodSelect> {
  Team _team = Team.empty();
  TextEditingController noteController = TextEditingController();
  List moodList = Widgets.getMoodList();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    moodList = args['feelingState'];
    print(args);
    return Scaffold(body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Header"),
            Widgets.displayInfoBoxWithTitle("Motivational Quote", "Persistance powers passion.", constraints),
            Widgets.getMoodEmojis("Wie geht es Dir heute?", () {}, _renderNew, () {}, constraints, moodList),
            Widgets.getInputField(noteController, TextInputType.text, constraints, "Teamname"),
            getButtonStyleOrangeWithAnimation(_submitMood, constraints, "Fertig", isLoading),
          ],
        ),
      );
    })));
  }

  void _submitMood() {
    isLoading = !isLoading;
    print("TODO SEND MOOD TO BACKEND");
    print(moodList);
    print(noteController.text);
    setState(() {});
  }

  void _renderNew() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  void _setTeam(Team team) async {
    try {
      _team = await Api.api.getTeam(team.id);
      setState(() {});
    } catch (e) {
      //no need to handle
    }
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
                    style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
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
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
 */