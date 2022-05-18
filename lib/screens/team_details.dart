import 'package:flutter/material.dart';
import 'package:moody/router/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

class TeamDetails extends StatefulWidget {
  const TeamDetails({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return Column(
        children: [
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Widgets.getTextButtonStyle1("Back", _back, constraints),
              Widgets.getTextFieldH3C("Bugs Bunnys", constraints),
              Widgets.getTextButtonStyle1("Profile", _goToProfile,constraints)
            ],
          ),
          Widgets.getTextFieldH1("Test", constraints),
          Widgets.getTextFieldH2("Test", constraints),
        ],
      );
    })));
  }

  @override
  void initState() {
    super.initState();
  }

  void _back() {
    Navigator.pop(context);
  }

  void _goToProfile(){
    Navigator.pushNamed(context, RouteGenerator.profileOverview);
  }
}
