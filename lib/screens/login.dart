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
  bool _isObscure = true;
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
        body: LayoutBuilder(
          builder: (builder, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Widgets.getInputFieldLoginStyle("Email", emailController, TextInputType.emailAddress),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: TextField(
                    obscureText: _isObscure,
                    enableSuggestions: false, //to not suggest past pws
                    autocorrect: false, //to not autorrect past pws
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Password",
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
                Center(child: Widgets.getTextFieldE1(_errorText, constraints)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Widgets.getButtonStyleOrange("", _login, constraints, "Einloggen"),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text("noch keinen Account?"),
                      const SizedBox(
                        height: 5,
                      ),
                      btnWithoutBackground("Jetzt registrieren", _toRegister),
                      const SizedBox(
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
