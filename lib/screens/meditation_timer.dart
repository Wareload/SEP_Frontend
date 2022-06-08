import 'dart:async';

import 'package:flutter/material.dart';
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
                        Widgets.getNavBarWithoutProfileWhite(
                            constraints, _back, "Meditation"),
                        Center(
                            child: Column(
                          children: [
                            buildTime(),
                            SizedBox(
                              height: 30,
                            ),
                            timerControlBtn(),
                          ],
                        )),
                        Center(
                          child: halfBtnOrange("Fertig", () {
                            timer?.cancel();
                            Navigator.pushNamed(
                                context, RouteGenerator.meditationEnd);
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
        Navigator.pushNamed(context, RouteGenerator.meditationEnd);
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
      width: 150,
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
                  fontSize: 18.0,
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
              halfBtnOrange(isRunning ? 'Stop' : 'Weiter', () {
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
