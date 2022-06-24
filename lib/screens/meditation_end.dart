import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/settings.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/team.dart';

class MeditationEnd extends StatefulWidget {
  const MeditationEnd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MeditationEndState();
}

class _MeditationEndState extends State<MeditationEnd> {
  Team _team = Team.empty();
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    print(args);
    _setTeam(args['team']);
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Widgets.getNavBarWithoutProfile(
                            constraints, _back, "Meditation"),
                        SizedBox(
                          height: 100,
                        ),
                        textWidgetCentered("Sehr gut!"),
                        textWidgetCentered("Nimm dir einen Moment, achte auf "),
                        textWidgetCentered(
                            "alle Geräusche in deiner Umgebung. "),
                        textWidgetCentered("Nimm wahr, wie sich dein Körper"),
                        textWidgetCentered("in diesem Moment fühlt."),
                        textWidgetCentered("Nimm deine Gedanken "),
                        textWidgetCentered("und Gefühle wahr."),
                        Widgets.getButtonStyleOrange(
                            "Fertig", _goToHome, constraints, "Fertig"),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        })));
  }

  void _renderNew() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  void _setTeam(Team team) async {
    _team = team;
    setState(() {});
  }

  void _back() {
    Navigator.pop(context);
  }

  void _goToHome() {
    Navigator.pop(context);
  }

  textWidgetCentered(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          color: Settings.white,
           
fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
