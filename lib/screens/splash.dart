import 'package:flutter/material.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/settings.dart';
import 'package:moody/widgets/widgets.dart';

import '../api/api.dart';

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

  void init() {
    Future.delayed(const Duration(seconds: 3), () async {
      await Api.setApi();
      //await Settings.api.logout(); //use to force clear flutter secure storage at start
      if (await Api.api.isLoggedIn()) {
        Navigator.pushReplacementNamed(context, RouteGenerator.teamOverview);
      } else {
        Navigator.pushReplacementNamed(context, RouteGenerator.login);
      }
    });
  }
}
