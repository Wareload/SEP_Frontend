import 'package:flutter/material.dart';
import 'package:moody/router/route_generator.dart';

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
          return const Text("Splash Screen");
        })));
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //TODO try to autologin here
    await Future.delayed(const Duration(seconds: 3), () {});
    //check for auto login
    Navigator.pushReplacementNamed(context, RouteGenerator.login);
  }
}
