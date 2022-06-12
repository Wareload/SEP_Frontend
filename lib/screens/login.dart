import 'package:flutter/material.dart';
import 'package:moody/api/api.dart';
import 'package:moody/api/exception/user_feedback_exception.dart';
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Anmelden"),
          centerTitle: true,
        ),
        body: Container(
          child: LayoutBuilder(
            builder: (builder, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Widgets.getInputFieldLoginStyle("Email *", emailController, TextInputType.emailAddress),
                  SizedBox(
                    height: 20,
                  ),
                  Widgets.getInputFieldLoginStyleObscured("Password *", passwordController, TextInputType.text),
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
                        Widgets.getButtonStyleOrange("", _login, constraints, "Einloggen"),
                        SizedBox(
                          height: 25,
                        ),
                        Text("noch keinen Account?"),
                        SizedBox(
                          height: 5,
                        ),
                        btnWithoutBackground("Jetzt registrieren", _toRegister),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
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
