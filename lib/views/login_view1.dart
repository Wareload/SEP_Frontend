import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_collection/views/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          inputTextFieldRoundWithHint("E-Mail *"),
          SizedBox(height: 20,),
          inputTextFieldRoundWithHint("Passwort *"),
          Container(
            margin: EdgeInsets.only(left: 30,top: 10),
            child: Text("* Pflichtangaben",
            style: TextStyle(
              color: Colors.grey[600]
            ),),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                getButtonStyleOrange(() { }, "Einloggen"),
                SizedBox(height: 25,),
                Text("noch keinen Account?"),
                SizedBox(height: 5,),
                btnWithoutBackground("Jetzt registrieren"),
                SizedBox(height: 15,),

              ],
            ),
          ),


        ],

      ),
    ));
  }

  Widget inputTextFieldRoundWithHint(String hint) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(

              borderRadius: BorderRadius.circular(30.0),
            ),
            filled: true,
            hintStyle: TextStyle(color: Colors.grey[800]),
            hintText: hint,
            fillColor: Colors.white70),
      ),
    );
  }
  static Widget getButtonStyleOrange(
      /*String display, */VoidCallback func, /*BoxConstraints constraints,*/String btnText) {
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10),
      child: Material(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: func,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            height: 60,
            alignment: Alignment.center,
            child: Text(btnText,
              style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

 Widget btnWithoutBackground(String text) {
    return FlatButton(
      //padding: EdgeInsets.only(bottom: 30),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterView()),
        );
      },
    );
  }


}
