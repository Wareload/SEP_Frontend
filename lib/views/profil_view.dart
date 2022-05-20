import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  List<Team> teams = [
    Team("Bugs Bunnies", 0),
    Team("Other Shit",1),
    Team("Other stuff idk",2),
    Team("Other stuff idk",3),
    Team("Other stuff idk",4),
    Team("Other stuff idk",5),
    Team("Other stuff idk",6),
    Team("Other stuff idk",7),

  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Dein Profil"),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              profileImage("https://bugsbunnies.de/images/logo.png"),
              textFullName("David Neus"),
              textEmail("david.neus@gmx.de"),
              displayTags("String"),
              textTitle("Deine Teams"),
              displayTeams(teams,context),
            ],
          ),
        ));
  }

  Widget profileImage(String link) {
    return Container(
      margin: EdgeInsets.only(top: 20),
        width: 190.0,
        height: 190.0,
        decoration: BoxDecoration(
          color: Colors.blue,
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: NetworkImage(link)
            )
        ),
     // child: Image.network(link),
    );
  }

  Widget textFullName(String fullName) {
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

  Widget textEmail(String fullName) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
      alignment: Alignment.center,
      child: Text(fullName,
        style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
    );
  }

  Widget textTag(String tagText) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
      alignment: Alignment.center,
      child: Text(tagText,
        style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: Colors.black),
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

  Widget textOnRedirectBtn (String btnText) {
    return Container(
      child: Text(btnText,
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    );
  }

  Widget displayTags(String text) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
            containerTag("Only"),
          containerTag("Fans"),
          containerTag("Jokes"),
          containerTag("Javascript"),
          containerTag("LGBTQ+HDTV_QHD"),
          containerTag("LGBTQ+HDTV_QHD"),
          containerTag("LGBTQ+HDTV_QHD"),

        ],
      ),
    );
  }

  Widget containerTag(String text){
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0,0, 0),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      //color: Colors.amber,
      child: textTag(text),
      decoration: BoxDecoration(
        color: Colors.orange,
          border: Border.all(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
    );
  }
  Widget displayTeams(List s,BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (BuildContext context,int index) => const Divider(),
        itemCount: teams.length,
        itemBuilder: (context, int index) {
          return displayTeam(teams[index].name, context);
        }
          );
        }

  Widget displayTeam(String teamName,BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        btnRedirect(teamName, ProfileView(),context),
        btnLeaveTeam(1),
    ],
    );
  }

  btnRedirect(String btnText,Widget widgetTo,BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
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
              height: 50,
              alignment: Alignment.center,
              child: textOnRedirectBtn(btnText),
            ),
          ),
        ),
      ),
    );
  }

  btnLeaveTeam(int i) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Material(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: () {
            print("Leave");
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Text("-",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 40,
                color: Colors.blue
            ),
            ),
          ),
        ),
      ),
    );
  }


  //Team


}///END
///
class Team{
  String name;
  int id;
  Team(this.name,this.id);
}

