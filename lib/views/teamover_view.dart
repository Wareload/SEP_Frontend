import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:widget_collection/views/home_view.dart';


class TeamOverView extends StatefulWidget {
  const TeamOverView({Key? key}) : super(key: key);

  @override
  State<TeamOverView> createState() => _TeamOverViewState();
}

class _TeamOverViewState extends State<TeamOverView> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Teamname"),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              textCenteredHeader("Mitglieder"),
              displayTeamIcons(),
              SizedBox(height: 50),
              btnRedirect("Team-Care", HomeView()),
              SizedBox(height: 30),
              displayName("David Neus"),
              SizedBox(height: 50),
              checkBoxRole(),
              btnDeleteTeam(),
              //displayTeams(null,context),
            ],
          ),
        ));
  }


  Widget textCenteredHeader(String fullName) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      alignment: Alignment.center,
      child: Text(fullName,
        style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
    );
  }

  Widget displayName(String userFullName) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
      alignment: Alignment.center,
      child: Text(userFullName,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
    );
  }

  btnRedirect(String btnText,Widget widgetTo) {
    return Container(
      padding: EdgeInsets.only(left: 25,right: 25),
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
            child: textOnRedirectBtn(btnText),
          ),
        ),
      ),
    );
  }


  Widget textTitle(String text) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 20, 0, 10),
      child: Text(text,
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
    );
  }

  Widget textOnRedirectBtn(String btnText) {
    return Container(
      child: Text(btnText,
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    );
  }


  //Displays all Teammember in a team
  displayTeamIcons() {
    return Container(
      child: SingleChildScrollView (
        child: RawScrollbar(
          thumbColor: Colors.blue,
          radius: Radius.circular(20),
          thickness: 5,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
            children: [
              Row(
                children: [
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),


                ],
              ),
              Row(
                children: [
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),
                  displayImageOfMember(),

                ],
              )
            ],
          ),
    ),
        ),
      ),
    );
  }

  displayImageOfMember() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10,right: 5),
          height: 70,
          width: 70,
          //color: Colors.red,
          child: CircleAvatar(
            radius: 16.0,
            child: ClipRRect(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                width: 190.0,
                height: 190.0,
                decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: NetworkImage("https://bugsbunnies.de/images/logo.png")
                )
            ),
            ),
          ),
          ),
        ),
        Text("NAME")
      ],
    );
  }

  checkBoxRole() {
    final theme = Theme.of(context);
    final oldCheckboxTheme = theme.checkboxTheme;

    final newCheckBoxTheme = oldCheckboxTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    );

    /*return Theme(
      data: theme.copyWith(checkboxTheme: newCheckBoxTheme),
      child: CheckboxListTile(
        onChanged: (_) {},
        value: false,
      ),
    );*/
    return Container(
      padding: EdgeInsets.only(left: 50,right: 50),
      child: Theme(
          data: theme.copyWith(checkboxTheme: newCheckBoxTheme),
          child: Column(
            children: [
              CheckboxListTile(
                title: const Text('Teamleader',
            style: TextStyle(fontSize: 20),),
                value: true,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value){},
        ),
              CheckboxListTile(
                title: const Text('Mitglied',
                style: TextStyle(fontSize: 20),),
                value: false,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value){},
              ),
            ],
          ),
      ),
    );
  }

  btnDeleteTeam() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FlatButton(
            padding: EdgeInsets.only(bottom: 30),
            child: Text(
                "Team löschen",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 20
                ),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}