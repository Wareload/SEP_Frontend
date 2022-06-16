import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/team.dart';

class MeditationHome extends StatefulWidget {
  const MeditationHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MeditationHomeState();
}

class _MeditationHomeState extends State<MeditationHome> {
  Team _team = Team.empty();
  TextEditingController noteController = TextEditingController();
  int minutes = 5;

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    print(args);
    _setTeam(args['team']);
    return Scaffold(
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
                    Widgets.getNavBar(
                        constraints, _back, "Meditation", _goToProfile),
                    textWidgetCentered("Setz dich gemütlich hin."),
                    textWidgetCentered("Wie lange möchtest du meditieren?"),
                    selectTime(),
                    Widgets.getButtonStyle2(
                        "Los geht's", _startMeditation, constraints),
                    SizedBox(),
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
    _team = team;
    setState(() {});
  }

  void _back() {
    Navigator.pop(context);
  }

  //Navigator.of(context).pushNamed(RouteGenerator.moodSelect, arguments: {"feelingState":feelingStatus});
  //           }, () {}, constraints,feelingStatus),

  void _goToProfile() {
    Navigator.pushReplacementNamed(context, RouteGenerator.profileOverview);
  }

  void _startMeditation() {
    Navigator.of(context).pushReplacementNamed(RouteGenerator.meditationInfo,
        arguments: {"minutes": minutes, "team": _team});
  }

  textWidgetCentered(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  selectTime() {
    final theme = Theme.of(context);
    final oldCheckboxTheme = theme.checkboxTheme;

    final newCheckBoxTheme = oldCheckboxTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    );
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50),
      child: Theme(
        data: theme.copyWith(checkboxTheme: newCheckBoxTheme),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CheckboxListTile(
              title: const Text(
                '5 Minuten',
                style: TextStyle(fontSize: 20),
              ),
              value: stateMinutes(5),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                minutes = 5;
                setState(() {});
              },
            ),
            CheckboxListTile(
              title: const Text(
                '10 Minuten',
                style: TextStyle(fontSize: 20),
              ),
              value: stateMinutes(10),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                minutes = 10;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  bool stateMinutes(int i) {
    if (i == minutes) {
      return true;
    } else {
      return false;
    }
  }
}
