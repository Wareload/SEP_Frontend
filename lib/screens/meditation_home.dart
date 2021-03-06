import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/profile.dart';
import '../structs/team.dart';
import '../widgets/settings.dart';

class MeditationHome extends StatefulWidget {
  final Map data;

  const MeditationHome(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MeditationHomeState();
}

bool isLoading = true;
Profile _profile = Profile.empty();

class _MeditationHomeState extends State<MeditationHome> {
  TextEditingController noteController = TextEditingController();
  int minutes = 5;

  void loadData(Profile profile) async {
    _profile = profile;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.white,
            child: const SizedBox(
              child: Align(
                child: CircularProgressIndicator(),
              ),
              width: 50,
              height: 50,
            ))
        : Scaffold(body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
            return CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Widgets.getNavBar(constraints, _back, "Meditation", _goToProfile, _profile),
                        textWidgetCentered("Setz dich gemütlich hin."),
                        textWidgetCentered("Wie lange möchtest du meditieren?"),
                        selectTime(),
                        Widgets.getButtonStyle2("Los geht's", _startMeditation, constraints),
                        SizedBox(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          })));
  }

  @override
  void initState() {
    loadData(widget.data["profile"]);
    super.initState();
  }

  void _back() {
    Navigator.pop(context);
  }

  void _goToProfile() {
    Navigator.pushReplacementNamed(context, RouteGenerator.profileOverview);
  }

  void _startMeditation() {
    Navigator.of(context).pushReplacementNamed(RouteGenerator.meditationInfo, arguments: {"minutes": minutes});
  }

  textWidgetCentered(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
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
      padding: const EdgeInsets.only(left: 50, right: 50),
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
