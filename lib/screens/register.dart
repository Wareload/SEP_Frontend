import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _isObscure = true;
  bool _isObscureCheck = true;
  bool showRedBorder = false;
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
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*  const SizedBox(
                      height: 20,
                    ),*/
                    Widgets.getInputFieldLoginStyle("Vorname *", firstnameController, TextInputType.emailAddress),
                    const SizedBox(
                      height: 5,
                    ),
                    Widgets.getInputFieldLoginStyle("Nachname *", lastnameController, TextInputType.emailAddress),
                    const SizedBox(
                      height: 5,
                    ),
                    Widgets.getInputFieldLoginStyle("E-Mail *", emailController, TextInputType.emailAddress),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: TextField(
                        obscureText: _isObscure,
                        enableSuggestions: false, //to not suggest past pws
                        autocorrect: false, //to not autorrect past pws
                        keyboardType: TextInputType.visiblePassword,
                        controller: passwordController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Password *",
                          fillColor: Colors.white70,
                          suffixIcon: IconButton(
                              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              }),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: TextField(
                        obscureText: _isObscureCheck,
                        enableSuggestions: false, //to not suggest past pws
                        autocorrect: false, //to not autorrect past pws
                        keyboardType: TextInputType.visiblePassword,
                        controller: passwordcheckController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Password wiederholen *",
                          fillColor: Colors.white70,
                          suffixIcon: IconButton(
                              icon: Icon(_isObscureCheck ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isObscureCheck = !_isObscureCheck;
                                });
                              }),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      //padding: EdgeInsets.only(left: 30, top: 10),
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text(
                              "Passwort muss mind. 8 Zeichen lang sein, eine Zahl & einen Großbuchstaben enthalten.",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(padding: const EdgeInsets.fromLTRB(5, 0, 5, 0), child: Widgets.getTextFieldE1(_errorText, constraints)),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Widgets.getButtonStyleOrange(_register, constraints, "Registrieren"),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text("Bereits einen Account?"),
                          const SizedBox(
                            height: 5,
                          ),
                          btnWithoutBackground("Jetzt Einloggen", _toLogin),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }))));
  }

  void _register() async {
    if (passwordcheckController.text != passwordController.text) {
      setState(() {
        _errorText = "Überprüfe die Passworteingabe!";
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
