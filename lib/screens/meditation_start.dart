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
  TextEditingController noteController = TextEditingController();
  int minutes = 1;

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

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
                        Widgets.getNavBarWithoutProfile(constraints, _back, "Meditation"),
                        Center(
                          child: textWidgetCentered("Schließe deine Augen."),
                        ),
                        const SizedBox(
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

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () => Navigator.of(context).pushReplacementNamed(RouteGenerator.meditationTimer, arguments: {"minutes": minutes}));
  }

  void _back() {
    Navigator.pop(context);
  }

  textWidgetCentered(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Settings.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
