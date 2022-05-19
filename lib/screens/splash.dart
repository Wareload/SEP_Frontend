import 'package:flutter/material.dart';
import 'package:moody/router/route_generator.dart';
import 'package:moody/widgets/settings.dart';
import 'package:moody/widgets/widgets.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      //TODO add splash screen here
      return Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0.5 * constraints.maxHeight),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.lightBlueAccent, Colors.deepPurple])),
          alignment: Alignment.center,
          child: Widgets.getTextFieldH1("Moody", constraints));
    })));
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    Future.delayed(const Duration(seconds: 3), () async {
      await Settings.setApi();
      await Settings.api
          .logout(); //use to force clear flutter secure storage at start
      if (await Settings.api.isLoggedIn()) {
        Navigator.pushReplacementNamed(context, RouteGenerator.teamOverview);
      } else {
        Navigator.pushReplacementNamed(context, RouteGenerator.login);
      }
    });
  }
}
