import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_collection/myapp.dart';
import 'package:widget_collection/views/abfrage_view.dart';
import 'package:widget_collection/views/atem_uebung_view.dart';
import 'package:widget_collection/views/kalender_view.dart';
import 'package:widget_collection/views/login_view1.dart';
import 'package:widget_collection/views/profil_view.dart';
import 'package:widget_collection/views/teamover_view.dart';

import 'amination_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Textbox("Quote of the Day","Altern... da kannste nichts falsch machen. Altern ist prinzipiell erlaubt. Es wird nur nicht gern gesehen.Alter Olaf Schubert ----------- ---------- ----------- AAALLLLL DDDD AAAA --"),
          btnRedirect("Animation",AnimationView()),
          btnRedirect("Profilpage",ProfileView()),
          btnRedirect("Abrage Feelings",AbfrageView()),
          btnRedirect("BtnKalender",KalenderView()),
          btnRedirect("Login",LoginView()),
          btnRedirect("TeamOverview",TeamOverView()),
          textInputField(),

        ],
      ),
    );
  }

  btnRedirect(String btnText,Widget widgetTo) {
    return Container(
      child: Material(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => widgetTo),
            );
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 200,
            height: 50,
            alignment: Alignment.center,
            child: Text(btnText,),
          ),
        ),
      ),
    );
  }

  Widget textInputField() {
    return Container(
      child: Center(
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  width: 1, color: Colors.white, style: BorderStyle.solid)),
          child: TextField(
            textAlign: TextAlign.center,
            minLines: 10,
            maxLines: 20,
            decoration: const InputDecoration(
                hintText: 'Anmerkungen',
                contentPadding: EdgeInsets.all(15),
                border: InputBorder.none),
            onChanged: (value) {},
          ),
        ),
      ),
    );
  }
}

Widget Textbox(String title, String descritption) {
  return Container(
      padding: const EdgeInsets.all(10),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(20.0,20),
                topRight: Radius.elliptical(20.0,20),

              )
          ),
          child: Center(child: textUeberschrift(title)),
        ),
        Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.elliptical(20.0,20),
                bottomRight: Radius.elliptical(20.0,20),
              )
          ),
          child: textNormal(descritption),
        )
      ],
    )
  );
}

textUeberschrift(String title) {
  return Text(title,
    maxLines: 2,
    style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.black),
  );
}
  textNormal(String title) {
    return Text(title,
      maxLines: 20,
      style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          color: Colors.black),
    );

}
