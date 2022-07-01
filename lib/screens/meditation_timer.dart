import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/settings.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/team.dart';

class MeditationTimer extends StatefulWidget {
  const MeditationTimer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MeditationTimerState();
}

class _MeditationTimerState extends State<MeditationTimer> {
  Team _team = Team.empty();
  TextEditingController noteController = TextEditingController();
  int minutesGlobal = 1;
  Duration duration = new Duration();
  Timer? timer;
  bool isRunning = true;
  bool initDone = false;

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    print(args);

    _setTeam(args['team']);

    minutesGlobal = args['minutes'];
    if (!initDone) {
      initCountdown();
      startCountdown();
      initDone = true;
    }

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
                        Center(
                            child: Column(
                          children: [
                            buildTime(),
                            SizedBox(
                              height: 30.h,
                            ),
                            timerControlBtn(),
                          ],
                        )),
                        Center(
                          child: halfBtnOrange("Fertig", () {
                            timer?.cancel();
                            Navigator.of(context).pushReplacementNamed(
                                RouteGenerator.meditationEnd,
                                arguments: {"team": _team});
                          }),
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

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0'); //9 would get to 09
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      '$minutes:$seconds',
      style: TextStyle(fontSize: 80, color: Settings.white),
    );
  }

  void startCountdown({bool resets = true}) {
    if (resets) {
      reset();
    }

    timer = Timer.periodic(Duration(seconds: 1), (_) => countTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  void countTime() {
    final addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds - addSeconds;
      if (seconds < 0) {
        timer?.cancel();
        Navigator.of(context).pushReplacementNamed(RouteGenerator.meditationEnd,
            arguments: {"team": _team});
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void reset() {
    setState(() => duration = Duration(minutes: minutesGlobal));
  }

  Widget halfBtnOrange(String btnText, VoidCallback func) {
    return Container(
      width: 150.w,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Material(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: func,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            height: 60.h,
            alignment: Alignment.center,
            child: Text(
              btnText,
              style: const TextStyle(
                  fontSize: Settings.mainFontSize,
                   
fontWeight: FontWeight.bold,
                  color: Settings.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget timerControlBtn() {
    isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 0;
    return isRunning || !isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              halfBtnOrange(isRunning ? 'Pause' : 'Weiter', () {
                if (isRunning) {
                  stopTimer(resets: false);
                } else {
                  startCountdown(resets: false);
                }
              }),
              halfBtnOrange("Neustart", () {
                reset();
                stopTimer();
              }),
            ],
          )
        : Text("Fertig");
  }

  void initCountdown() {
    setState(() => duration = Duration(minutes: minutesGlobal));
  }
}
