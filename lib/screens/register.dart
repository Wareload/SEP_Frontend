import 'package:flutter/material.dart';
import 'package:moody/router/route_generator.dart';
import 'package:moody/widgets/widgets.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _errorText = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Widgets.getTextFieldH1("Registrieren"),
              Widgets.getTextFieldH2("E-Mail"),
              Widgets.getInputFieldStyle1(
                  emailController, TextInputType.emailAddress, false),
              Widgets.getTextFieldH2("Password"),
              Widgets.getInputFieldStyle1(
                  emailController, TextInputType.text, true),
              Widgets.getTextFieldE1(_errorText),
              Widgets.getButtonStyle1("Konto erstellen", _register),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Widgets.getTextFieldP1("Bereits einen Account?"),
                  Widgets.getTextButtonStyle1("Jetzt einloggen!", _toLogin)
                ],
              )
            ],
          ));
    })));
  }

  void _register() {
    //TODO use api here
    Navigator.pushReplacementNamed(context, RouteGenerator.teamOverview);
  }

  void _toLogin() {
    Navigator.pushReplacementNamed(context, RouteGenerator.login);
  }

  @override
  void initState() {
    super.initState();
  }
}
