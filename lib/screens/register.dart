import 'package:flutter/material.dart';
import 'package:moody/api/exception/user_feedback_exception.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/settings.dart';
import 'package:moody/widgets/widgets.dart';

import '../api/api.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _errorText = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return SingleChildScrollView(child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: constraints.maxHeight*0.05,
          ),
          Widgets.getTextFieldH1("Registrieren", constraints),
          Widgets.getTextFieldH3("E-Mail", constraints),
          Widgets.getInputFieldStyle1(emailController,
              TextInputType.emailAddress, false, constraints),
          Widgets.getTextFieldH3("Vorname", constraints),
          Widgets.getInputFieldStyle1(
              firstnameController, TextInputType.text, false, constraints),
          Widgets.getTextFieldH3("Nachname", constraints),
          Widgets.getInputFieldStyle1(
              lastnameController, TextInputType.text, false, constraints),
          Widgets.getTextFieldH3("Password", constraints),
          Widgets.getInputFieldStyle1(
              passwordController, TextInputType.text, true, constraints),
          Widgets.getTextFieldE1(_errorText, constraints),
          Widgets.getButtonStyle1(
              "Konto erstellen", _register, constraints),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Widgets.getTextFieldP1("Bereits einen Account?", constraints),
              Widgets.getTextButtonStyle1(
                  "Jetzt einloggen!", _toLogin, constraints)
            ],
          )
        ],
      ));
    })));
  }

  void _register() async {
    try {
      await Api.api.register(
          emailController.text, passwordController.text, "Rainer", "Zufall");
      Navigator.pushReplacementNamed(context, RouteGenerator.teamOverview);
    } catch (e) {
      setState(() {
        if (e.runtimeType == UserFeedbackException) {
          _errorText = e.toString();
        }
      });
    }
  }

  void _toLogin() {
    Navigator.pushReplacementNamed(context, RouteGenerator.login);
  }

  @override
  void initState() {
    super.initState();
  }
}
