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
  TextEditingController noteController = TextEditingController();
  int seconds = 4;
  Timer? timer;
  bool ausatmen = false;
  bool einatmen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Widgets.getNavBarWithoutProfile(constraints, _back, "Atemübung"),
                  textWidgetCentered(getCurrentActivity()),
                  bubbleForSeconds(seconds),
                  Widgets.getButtonStyleOrange(_goToTeamDetails, constraints, "Stopp"),
                ],
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
    startTimer();
    setEinatmen();
  }

  void _back() {
    Navigator.pop(context);
  }

  void _goToTeamDetails() {
    Navigator.of(context).pop(context);
  }

  textWidgetCentered(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget bubbleForSeconds(int second) {
    return SizedBox(
      height: 400,
      width: 400,
      child: Center(
        child: Container(
            height: heightBySecond(second),
            width: heightBySecond(second),
            decoration: const BoxDecoration(
              color: Settings.blueAccent,
              shape: BoxShape.circle,
            ),
            child: Center(
                child: Text(
              second.toString(),
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ))),
      ),
    );
  }

  double heightBySecond(int second) {
    if (ausatmen == false && einatmen == false) {
      return 425;
    } else if (einatmen) {
      return (500 - (second + 1) * 75).toDouble();
    } else {
      return (65 + (second + 1) * 40).toDouble();
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), updateSeconds);
  }

  updateSeconds(Timer timer) {
    if (mounted) {
      setState(() => seconds--);
    }
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
    seconds = 8;
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
