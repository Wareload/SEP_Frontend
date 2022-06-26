import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/profile.dart';
import '../structs/team.dart';

class TeamDetails extends StatefulWidget {
  final Map data;

  const TeamDetails(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamDetailsState();
}

bool isLoading = true;
Team _team = Team.empty();
Profile _profile = Profile.empty();

bool canSelect = false;
String _timemessage = "Du hast heute schon abgestimmt";
bool gottimerstate = false;

class _TeamDetailsState extends State<TeamDetails> {
  Mood _currentSelectedMood = Mood();

  void loadData(Team team, int leaderstate) async {
    try {
      canSelect = await Api.api.getMoodTimer(team.id);
      gottimerstate = true;
      leaderstate = team.leader;
      // _team = await Api.api.getTeam(team.id);
      _team = team;
      _team.leader = leaderstate;
      _profile = await Api.api.getProfile();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      //no need to handle
    }
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
            return Column(
              children: [
                Widgets.getNavBar(constraints, _back, _team.name, _goToProfile, _profile),
                getMoodEmojisByState(constraints),
                Container(
                  height: 30,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Widgets.getButtonStyle3("Statistik", "assets/statistik_view.png", _goToStatistic, constraints),
                          Widgets.getButtonStyle3("Meditation", "assets/trees.png", _goToMeditation, constraints)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Widgets.getButtonStyle3("Atemübungen", "assets/windy.png", _goToAtemUebung, constraints),
                          // Widgets.getButtonStyle2("Umfragen", () {}, constraints), //Not implemented
                          Widgets.getButtonStyle3("Team", "assets/users.png", _goToTeam, constraints)
                        ],
                      )
                    ]),
                  ),
                ))
              ],
            );
          })));
  }

  @override
  void initState() {
    loadData(widget.data["team"], widget.data["leader"]);
    super.initState();
  }

  void _back() {
    isLoading = true;
    Navigator.of(context).popUntil(
      (route) => route.isFirst,
    );
  }

  void _goToProfile() {
    Navigator.pushNamed(context, RouteGenerator.profileOverview);
  }

  void _goToStatistic() {
    Navigator.of(context).pushNamed(RouteGenerator.teamHistorie, arguments: {"team": _team, "profile": _profile});
  }

  void _goToAtemUebung() {
    Navigator.of(context).pushNamed(RouteGenerator.atemUebung).then((value) => {
          setState(() {}),
          //to refresh the site when coming back
          loadData(widget.data["team"], widget.data["leader"])
        });
    ;
  }

  void _goToMeditation() {
    Navigator.of(context).pushNamed(RouteGenerator.meditationHome, arguments: {"profile": _profile});
  }

  void _goToTeam() {
    isLoading = true;
    Navigator.pushNamed(context, RouteGenerator.teamManage, arguments: {"team": _team});
    ;
  }

  Widget getMoodEmojisByState(BoxConstraints constraints) {
    if (canSelect) {
      return Widgets.getMoodEmojis("Wie geht es dir heute?", () {}, () {
        //set boolean to display loading icon when coming back
        isLoading = true;
        Navigator.of(context).pushNamed(RouteGenerator.moodSelect, arguments: {'selectedMood': _currentSelectedMood, "team": _team}).then((value) => {
              setState(() {
                //to reset selected mood when going back
                _currentSelectedMood = Mood();
              }),
              //to refresh the site when coming back
              loadData(widget.data["team"], widget.data["leader"])
            });
      }, () {}, constraints, _currentSelectedMood);
    } else {
      return Widgets.getDisabledMoodEmojis(_timemessage, () {}, () {}, () {}, constraints, _currentSelectedMood);
    }
  }
}
