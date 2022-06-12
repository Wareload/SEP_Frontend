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
  TextEditingController passwordcheckController = TextEditingController();

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text("Registrieren"),
              centerTitle: true,
            ),
            body: Container(child: LayoutBuilder(builder: (builder, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Widgets.getInputFieldLoginStyle("Vorname *", firstnameController, TextInputType.emailAddress),
                  SizedBox(
                    height: 5,
                  ),
                  Widgets.getInputFieldLoginStyle("Nachname *", lastnameController, TextInputType.emailAddress),
                  SizedBox(
                    height: 5,
                  ),
                  Widgets.getInputFieldLoginStyle("E-Mail *", emailController, TextInputType.emailAddress),
                  SizedBox(
                    height: 5,
                  ),
                  Widgets.getInputFieldLoginStyleObscured("Passwort *", passwordController, TextInputType.visiblePassword),
                  SizedBox(
                    height: 5,
                  ),
                  Widgets.getInputFieldLoginStyleObscured("Passwort wiederholen *", passwordcheckController, TextInputType.visiblePassword),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30, top: 10),
                    child: Text(
                      "* Pflichtangaben",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  Center(child: Widgets.getTextFieldE1(_errorText, constraints)),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Widgets.getButtonStyleOrange("", _register, constraints, "Registrieren"),
                        SizedBox(
                          height: 25,
                        ),
                        Text("Bereits einen Account?"),
                        SizedBox(
                          height: 5,
                        ),
                        btnWithoutBackground("Jetzt Einloggen", _toLogin),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ],

                /*children: [
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
        ],*/
              );
            }))));
  }

  void _register() async {
    if (passwordcheckController.text != passwordController.text) {
      setState(() {
        _errorText = "Überprüfe die Passworteingabe!";
        ;
      });
    } else {
      try {
        await Api.api.register(emailController.text, passwordController.text, firstnameController.text, lastnameController.text);
        Navigator.pushReplacementNamed(context, RouteGenerator.teamOverview);
      } catch (e) {
        setState(() {
          if (e.runtimeType == UserFeedbackException) {
            _errorText = e.toString();
          }
        });
      }
    }
  }

  void _toLogin() {
    Navigator.pushReplacementNamed(context, RouteGenerator.login);
  }

  @override
  void initState() {
    super.initState();
  }

  Widget btnWithoutBackground(String text, VoidCallback func) {
    return FlatButton(
      //padding: EdgeInsets.only(bottom: 30),
      child: Text(
        text,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      onPressed: func,
    );
  }
}
