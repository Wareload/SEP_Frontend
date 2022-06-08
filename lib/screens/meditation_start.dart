import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/settings.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/team.dart';

class MeditationStart extends StatefulWidget {
  const MeditationStart({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MeditationStartState();
}

class _MeditationStartState extends State<MeditationStart> {
  Team _team = Team.empty();
  TextEditingController noteController = TextEditingController();
  int minutes = 1;

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    print(args);
    minutes = args['minutes'];

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
                        Widgets.getNavBarWithoutProfileWhite(
                            constraints, _back, "Meditation"),
                        Center(
                          child: textWidgetCentered("Schließe deine Augen."),
                        ),
                        SizedBox(
                          height: 100,
                        )
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
    Timer(
        Duration(seconds: 4),
        () => Navigator.of(context).pushNamed(RouteGenerator.meditationTimer,
            arguments: {"minutes": minutes}));
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

  void _goToMeditationStart() {
    Navigator.pushNamed(context, RouteGenerator.profileOverview);
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
