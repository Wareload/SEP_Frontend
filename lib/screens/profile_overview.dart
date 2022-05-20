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
          return Column(mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Widgets.getTextButtonStyle1("Back", _back, constraints),
                  Widgets.getTextFieldH3C("Dein Profil", constraints),
                  Widgets.getTextButtonStyle1("Einstellungen", () => {}, constraints),
                ],
              ),

            ],
          );
    })));
  }

  void _back(){
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }
}
