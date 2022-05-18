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
      return Column(
        children: [
          Widgets.getTextFieldH1("Test", constraints),
          Widgets.getTextFieldH2("Test", constraints),
        ],
      );
    })));
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    await Settings.setApi();
    if (await Settings.api.isLoggedIn()) {
      Navigator.pushReplacementNamed(context, RouteGenerator.teamOverview);
    }else{
      Navigator.pushReplacementNamed(context, RouteGenerator.login);
    }
  }
}
