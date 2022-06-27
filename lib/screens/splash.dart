import 'package:flutter/material.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/settings.dart';
import 'package:moody/widgets/widgets.dart';

import '../api/api.dart';
import '../structs/invitation.dart';
import '../structs/profile.dart';
import '../structs/team.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  List<Color> colorList = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];
  int index = 0;
  Color bottomColor = Colors.red;
  Color topColor = Colors.yellow;
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;

  List<Team> teams = [];
  Profile _profile = Profile.empty();
  List<Invitation> invitations = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return AnimatedContainer(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        duration: const Duration(milliseconds: 800),
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(0, 0, 0, constraints.maxHeight * 0.4),
            child: Widgets.getTextFieldH1("moody", constraints)),
        onEnd: () {
          setState(() {
            index = index + 1;
            // animate the color
            bottomColor = colorList[index % colorList.length];
            topColor = colorList[(index + 1) % colorList.length];
          });
        },
        decoration: BoxDecoration(gradient: LinearGradient(begin: begin, end: end, colors: [bottomColor, topColor])),
      );
    })));
  }

  @override
  void initState() {
    super.initState();
    init();
    _startAnimation();
  }

  Widget _startAnimation() {
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        bottomColor = Colors.blue;
      });
    });
    return Container();
  }

  Future<void> profileAsync() async {
    _profile = await Api.api.getProfile();
  }

  Future<void> invitationsAsync() async {
    invitations = await Api.api.getInvitations();
  }

  Future<void> teamsAsync() async {
    teams = await Api.api.getTeams();
  }

  void apiCalls() async {
    try {
      Future.wait([profileAsync(), invitationsAsync(), teamsAsync()]);
      isLoading = false;
    } catch (e) {
      //no need to handle
    }
  }

  Future<void> checkCurrentState() async {
    if (isLoading) {
      Future.delayed(const Duration(milliseconds: 100), () async {
        checkCurrentState();
      });
    } else {
      print("Got everything!!!");
      if (await Api.api.isLoggedIn()) {
        Navigator.pushReplacementNamed(context, RouteGenerator.teamOverview,
            arguments: {"teams": teams, "profile": _profile, "invitations": invitations});
      } else {
        Navigator.pushReplacementNamed(context, RouteGenerator.login);
      }
    }
  }

  void init() async {
    await Api.setApi();
    apiCalls();
    Future.delayed(const Duration(seconds: 1), () async {
      checkCurrentState();
    });
  }
}
