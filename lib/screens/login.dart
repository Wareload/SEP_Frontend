import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          title: const Text("Anmelden"),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (builder, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Widgets.getInputFieldLoginStyle("Email", emailController, TextInputType.emailAddress),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: TextField(
                    obscureText: _isObscure,
                    enableSuggestions: false, //to not suggest past pws
                    autocorrect: false, //to not autorrect past pws
                    keyboardType: TextInputType.text,
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
                      SizedBox(
                        height: 25.h,
                      ),
                      const Text("noch keinen Account?"),
                      SizedBox(
                        height: 5.h,
                      ),
                      btnWithoutBackground("Jetzt registrieren", _toRegister),
                      SizedBox(
                        height: 15.h,
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
        style: const TextStyle(color: Colors.black,  
fontWeight: FontWeight.bold, fontSize: 20),
      ),
      onPressed: func,
    );
  }
}
