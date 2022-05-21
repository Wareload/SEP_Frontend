import 'package:flutter/material.dart';
import 'package:moody/widgets/widgets.dart';

class ProfileOverview extends StatefulWidget {
  const ProfileOverview({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileOverviewState();
}

class _ProfileOverviewState extends State<ProfileOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: constraints.maxWidth * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: _back,
                  icon: Icon(Icons.arrow_back,
                      color: Colors.blue, size: constraints.maxWidth * 0.15)),
              Container(
                margin: EdgeInsets.only(right: constraints.maxWidth * 0.05),
                child: IconButton(
                    onPressed: () => {},
                    icon: Icon(Icons.settings,
                        color: Colors.blue, size: constraints.maxWidth * 0.15)),
              )
            ],
          ),
          Widgets.getProfileImage(
              "https://bugsbunnies.de/images/logo.png", constraints),
          Widgets.getTextFieldH2("David Neus", constraints),
          Widgets.getTextFieldH3("david.neus@gmx.de", constraints),
          _getTags(constraints),
          Container(
              margin: EdgeInsets.only(left: constraints.maxWidth * 0.05),
              child: Align(
                  child: Widgets.getTextFieldH3("Deine Teams:", constraints),
                  alignment: Alignment.centerLeft)),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Widgets.getProfileTeam(
                    "Team1", () => {}, () => {}, constraints),
                Widgets.getProfileTeam(
                    "Team2", () => {}, () => {}, constraints),
                Widgets.getProfileTeam(
                    "Team3", () => {}, () => {}, constraints),
                Widgets.getProfileTeam(
                    "Team4", () => {}, () => {}, constraints),
                Widgets.getProfileTeam(
                    "Team4", () => {}, () => {}, constraints),
                Widgets.getProfileTeam(
                    "Team4", () => {}, () => {}, constraints),
                Widgets.getProfileTeam(
                    "Team6", () => {}, () => {}, constraints),
                Widgets.getProfileTeam(
                    "Team7", () => {}, () => {}, constraints),
                Widgets.getProfileTeam(
                    "Team8", () => {}, () => {}, constraints),
                Widgets.getProfileTeam(
                    "Team9", () => {}, () => {}, constraints),
                Widgets.getProfileTeam(
                    "Team10", () => {}, () => {}, constraints),
              ],
            ),
          ))
        ],
      );
    })));
  }

  Widget _getTags(BoxConstraints constraints) {
    return Container(
        margin: const EdgeInsets.all(10),
        height: 40,
        child: Center(
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Widgets.getContainerTag("Only", constraints),
              Widgets.getContainerTag("Fans", constraints),
              Widgets.getContainerTag("Jokes", constraints),
              Widgets.getContainerTag("Javascript", constraints),
              Widgets.getContainerTag("LGBTQ+HDTV_QHD", constraints),
              Widgets.getContainerTag("LGBTQ+HDTV_QHD", constraints),
              Widgets.getContainerTag("LGBTQ+HDTV_QHD", constraints),
            ],
          ),
        ));
  }

  void _back() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }
}
