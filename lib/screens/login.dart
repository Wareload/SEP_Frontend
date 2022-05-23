import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/api/exception/user_feedback.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/widgets/settings.dart';
import 'package:moody/widgets/widgets.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _errorText = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
      return SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: constraints.maxHeight * 0.05,
          ),
          Widgets.getTextFieldH1("Login", constraints),
          Widgets.getTextFieldH3("E-Mail", constraints),
          Widgets.getInputFieldStyle1(
              emailController, TextInputType.emailAddress, false, constraints),
          Widgets.getTextFieldH3("Password", constraints),
          Widgets.getInputFieldStyle1(
              passwordController, TextInputType.text, true, constraints),
          Widgets.getTextFieldE1(_errorText, constraints),
          Widgets.getButtonStyle1("Einloggen", _login, constraints),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Widgets.getTextFieldP1("Noch keinen Account?", constraints),
              Widgets.getTextButtonStyle1(
                  "Jetzt registrieren!", _toRegister, constraints)
            ],
          )
        ],
      ));
    })));
  }

  void _login() async {
    try {
      await Api.api.login(emailController.text, passwordController.text);
      Navigator.pushReplacementNamed(context, RouteGenerator.teamOverview);
    } catch (e) {
      setState(() {
        if (e.runtimeType == UserFeedbackException) {
          _errorText = e.toString();
        }
      });
    }
  }

  void _toRegister() {
    Navigator.pushReplacementNamed(context, RouteGenerator.register);
  }

  @override
  void initState() {
    super.initState();
  }
}
