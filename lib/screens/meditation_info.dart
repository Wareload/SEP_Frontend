import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/settings.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/team.dart';

class MeditationInfo extends StatefulWidget {
  const MeditationInfo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MeditationInfoState();
}

class _MeditationInfoState extends State<MeditationInfo> {
  Team _team = Team.empty();
  TextEditingController noteController = TextEditingController();
  int minutes = 1;

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    minutes = args['minutes'];
    print(args);
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
                        SizedBox(
                          height: 100,
                        ),
                        textWidgetCentered("Setz dich gemütlich hin."),
                        textWidgetCentered("Wie lange möchtest du meditieren?"),
                        textWidgetCentered("Nimm deinen Körper wahr."),
                        textWidgetCentered("Spüre deine Atmung."),
                        textWidgetCentered("Bemerke wenn deine"),
                        textWidgetCentered("Gedanken abschweifen."),
                        textWidgetCentered("Sei nicht zu hart zu dir."),
                        textWidgetCentered("Konzentriere dich einfach wieder."),
                        textWidgetCentered("Wenn der Timer abläuft ertönt"),
                        textWidgetCentered("ein Signalton."),
                        Widgets.getButtonStyleOrange("Los geht's",
                            _goToMeditationStart, constraints, "Los geht's"),
                        SizedBox(
                          height: 100,
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
    Navigator.of(context).pushNamed(RouteGenerator.meditationStart,
        arguments: {"minutes": minutes});
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
}
