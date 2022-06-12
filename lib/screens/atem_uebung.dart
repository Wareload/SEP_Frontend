import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/settings.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/team.dart';

class Atemuebung extends StatefulWidget {
  const Atemuebung({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AtemuebungState();
}

class _AtemuebungState extends State<Atemuebung> {
  Team _team = Team.empty();
  TextEditingController noteController = TextEditingController();
  int seconds = 4;
  Timer? timer;
  bool ausatmen = false;
  bool einatmen = false;

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    print(args);
    _setTeam(args["team"]);

    return Scaffold(
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
                        constraints, _back, "Atemübung"),
                    textWidgetCentered(getCurrentActivity()),
                    bubbleForSeconds(seconds),
                    Widgets.getButtonStyleOrange(
                        "Fertig", _goToTeamDetails, constraints, "Stopp"),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    })));
  }

  void _setTeam(Team team) async {
    try {
      _team = await Api.api.getTeam(team.id);
      setState(() {});
    } catch (e) {
      //no need to handle
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    setEinatmen();
  }

  void _back() {
    Navigator.pop(context);
  }

  void _goToTeamDetails() {
    Navigator.of(context)
        .pushNamed(RouteGenerator.teamDetails, arguments: {"team": _team});
  }

  textWidgetCentered(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget bubbleForSeconds(int second) {
    return Container(
      height: 400,
      width: 400,
      child: Center(
        child: Container(
            height: heightBySecound(second),
            width: heightBySecound(second),
            decoration: BoxDecoration(
              color: Settings.blueAccent,
              shape: BoxShape.circle,
            ),
            child: Center(
                child: Text(
              second.toString(),
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ))),
      ),
    );
  }

  double heightBySecound(int second) {
    if (ausatmen == false && einatmen == false) {
      return 200;
    }
    return (150 + 20 * (second + 1)).toDouble();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), updateSeconds);
  }

  updateSeconds(Timer timer) {
    setState(() => seconds--);
    if (seconds <= 0) {
      if (einatmen) {
        setHalten();
      } else if (ausatmen) {
        setEinatmen();
      } else {
        setAusatmen();
      }
    }
  }

  setEinatmen() {
    einatmen = true;
    ausatmen = false;
    seconds = 4;
  }

  setHalten() {
    einatmen = false;
    seconds = 7;
  }

  setAusatmen() {
    ausatmen = true;
    seconds = 7;
  }

  String getCurrentActivity() {
    if (ausatmen) {
      return "Ausatmen";
    } else if (einatmen) {
      return "Einatmen";
    } else {
      return "Halten";
    }
  }
}
