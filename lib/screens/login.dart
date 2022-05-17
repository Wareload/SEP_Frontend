import 'package:flutter/material.dart';
import 'package:moody/router/route_generator.dart';
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
      return Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Widgets.getTextFieldH1("Login"),
              Widgets.getTextFieldH2("E-Mail"),
              Widgets.getInputFieldStyle1(
                  emailController, TextInputType.emailAddress, false),
              Widgets.getTextFieldH2("Password"),
              Widgets.getInputFieldStyle1(
                  emailController, TextInputType.text, true),
              Widgets.getTextFieldE1(_errorText),
              Widgets.getButtonStyle1("Einloggen", _login),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Widgets.getTextFieldP1("Noch keinen Account?"),
                  Widgets.getTextButtonStyle1("Jetzt registrieren!", _toRegister)
                ],
              )
            ],
          ));
    })));
  }

  void _login() {
    //TODO use api here
    Navigator.pushReplacementNamed(context, RouteGenerator.teamOverview);
  }

  void _toRegister() {
    Navigator.pushReplacementNamed(context, RouteGenerator.register);
  }

  @override
  void initState() {
    super.initState();
  }
}
