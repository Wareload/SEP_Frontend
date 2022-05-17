import 'package:flutter/material.dart';

class TeamOverview extends StatefulWidget {
  const TeamOverview({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamOverviewState();
}

class _TeamOverviewState extends State<TeamOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
          return const Text("Hallo Welt Splash");
        })));
  }

  @override
  void initState() {
    super.initState();
  }


}
