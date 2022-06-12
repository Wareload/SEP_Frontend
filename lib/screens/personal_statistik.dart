import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/team.dart';

class PersonalStatistic extends StatefulWidget {
  const PersonalStatistic({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PersonalStatisticState();
}

class _PersonalStatisticState extends State<PersonalStatistic> {
  Team _team = Team.empty();
  TextEditingController noteController = TextEditingController();
  String _response = "Loading..";
  bool moodsLoaded = false;

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    _setTeam(args["team"]);
    if (!moodsLoaded && _team.id != 0) {
      getMoods(_team);
      moodsLoaded = true;
    }
    print(args);
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Widgets.getNavBar(
                constraints, _back, "Personal Statistic", _goToProfile),
            Text(_response),
          ],
        ),
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

  getMoods(Team team) async {
    print(team.id);
    print("-------------------------------------------------");
    try {
      _response =
          await Api.api.getPersonalMood(team.id, "2022-06-12", "2022-06-12");
      setState(() {});
    } catch (e) {
      print(e);
    }
  }
}
