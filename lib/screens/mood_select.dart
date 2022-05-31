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



  @override
  Widget build(BuildContext context) {

    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Header"),
            Widgets.displayInfoBoxWithTitle("Motivational Quote", "Persistance powers passion.", constraints),
            Widgets.getMoodEmojis("Wie geht es Dir heute?", () { }, _state, () { }, constraints, moodList),
            Widgets.getInputField(noteController,TextInputType.text,constraints,"Teamname"),
            Widgets.getButtonStyleOrange("Erstellen", () {}, constraints,"Fertig"),





          ],
        ),
      );
    })));
  }

  void _state(){
    setState(){};
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
}
