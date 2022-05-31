import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/api/exception/invalid_permission_exception.dart';
import 'package:moody/route/route_generator.dart';

import '../api/exception/user_feedback_exception.dart';
import '../widgets/widgets.dart';

class TeamCreate extends StatefulWidget {
  const TeamCreate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TeamCreateState();
}

class _TeamCreateState extends State<TeamCreate> {
  String _errorText = "";
  TextEditingController teamNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: _onBack,
                  icon: Icon(Icons.arrow_back,
                      color: Colors.blue, size: constraints.maxWidth * 0.15)),
              Widgets.getTextFieldH3C("Team erstellen", constraints),
            ],
          ),
          SizedBox(height: 30,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Widgets.getInputFieldWithTitle(teamNameController,TextInputType.text,false,constraints,"Teamname","Teamname hier eintragen"),
                Widgets.getButtonStyleOrange("Erstellen", _onTeamCreate, constraints,"Fertig"),
              ],
            ),
          ),
          SizedBox(height: 30,),
        ],
      );
    })));
  }

  void _onBack() {
    Navigator.pop(context);
  }
  void _onTeamCreate() async {
    try{
      await Api.api.createTeam(teamNameController.text);
      _onBack();
    }catch(e){
      setState(() {
        if (e.runtimeType == UserFeedbackException) {
          _errorText = e.toString();
        }else if (e.runtimeType == InvalidPermissionException){
          RouteGenerator.reset(context);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
