import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moody/structs/team.dart';
import 'package:moody/widgets/settings.dart';

//TODO Mood Logik mit der Map an neues Design (4 Emojis) anpassen

class Widgets {
  Widgets._();

  static Widget getTextFieldH1(String display, BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Text(
        display,
        style: const TextStyle(
fontWeight: FontWeight.bold, fontSize: 40),
      ),
    );
  }

  static Widget getTextFieldH2(String display, BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Text(
        display,
        style: TextStyle(
fontWeight: FontWeight.bold, fontSize: 20.sp),
      ),
    );
  }

  static Widget getTextFieldH2C(String display, BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Text(
        display,
        style: const TextStyle(color: Settings.blue, fontSize: 20),
      ),
    );
  }

  static Widget getTextFieldH2Black(
      String display, BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Text(
        display,
        style: const TextStyle(
            color: Colors.black, fontSize: 20,  
fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget getTextFieldH3(String display, BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Text(
        display,
        style: const TextStyle( 
fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  static Widget getTextFieldH3C(String display, BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Text(
        display,
        style: const TextStyle(color: Settings.blue),
      ),
    );
  }

  static Widget getTextFieldH3CWhite(
      String display, BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Text(
        display,
        style: const TextStyle(color: Settings.white),
      ),
    );
  }

  static Widget getTextFieldP1(String display, BoxConstraints constraints) {
    return Text(display);
  }

  static Widget getTextFieldE1(String display, BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Text(
        display,
        style: const TextStyle(color: Settings.red),
      ),
    );
  }

  static Widget getTextWhiteH3(String text, BoxConstraints constraints) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: Settings.mainFontSize,  
fontWeight: FontWeight.bold, color: Settings.white),
    );
  }

  static Widget getNormalTextH3(String text, BoxConstraints constraints) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 15.0,  
fontWeight: FontWeight.normal, color: Colors.black),
    );
  }

  static getNavHeaderText(String display, BoxConstraints constraints) {
    return Text(
      display,
      style: const TextStyle(
           
fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
    );
  }

  static Widget getInputFieldStyle1(TextEditingController ctr,
      TextInputType type, bool hidden, BoxConstraints constraints) {
    return TextField(
      textAlign: TextAlign.center,
      obscureText: hidden,
      controller: ctr,
      keyboardType: type,
    );
  }

  static Widget getInputFieldLoginStyle(
      String hint, TextEditingController ctr, TextInputType type) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: TextField(
        keyboardType: type,
        controller: ctr,
        inputFormatters: [
          LengthLimitingTextInputFormatter(322),
        ],
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

  static Widget getInputFieldLoginStyleObscured(
      String hint, TextEditingController ctr, TextInputType type) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: TextField(
        obscureText: true,
        enableSuggestions: false, //to not suggest past pws
        autocorrect: false, //to not autorrect past pws
        keyboardType: type,
        controller: ctr,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          hintText: hint,
          fillColor: Colors.white70,
        ),
      ),
    );
  }

  //A InputField with a title(Top Blue and Bottom white)
  static Widget getInputFieldWithTitle(
      TextEditingController ctr,
      TextInputType type,
      bool hidden,
      BoxConstraints constraints,
      String title,
      String hint) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Settings.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(20.0, 20),
                    topRight: Radius.elliptical(20.0, 20),
                  )),
              child: Center(
                  child: Text(
                title,
                style: const TextStyle(
                    fontSize: Settings.mainFontSize,
                     
fontWeight: FontWeight.bold,
                    color: Settings.white),
              )),
            ),
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.elliptical(20.0, 20),
                    bottomRight: Radius.elliptical(20.0, 20),
                  )),
              child: TextField(
                textAlign: TextAlign.center,
                obscureText: hidden,
                controller: ctr,
                keyboardType: type,
                decoration: new InputDecoration.collapsed(
                  hintText: hint,
                ),
              ),
            )
          ],
        ));
  }

  static Widget getButtonStyle1(
      String display, VoidCallback func, BoxConstraints constraints) {
    return ElevatedButton(
      onPressed: func,
      child: Text(display),
    );
  }

  static Widget getButtonStyleOrange(String display, VoidCallback func,
      BoxConstraints constraints, String btnText) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Material(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: func,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            height: 60.h,
            alignment: Alignment.center,
            child: Text(
              btnText,
              style: const TextStyle(
                  fontSize: Settings.mainFontSize,
                   
fontWeight: FontWeight.bold,
                  color: Settings.white),
            ),
          ),
        ),
      ),
    );
  }

  static Widget getButtonStyle2(
      String display, VoidCallback func, BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.9,
      height: 50.h,
      margin: EdgeInsets.only(bottom: constraints.maxWidth * 0.03),
      child: Material(
        color: Settings.blue,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: func,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            alignment: Alignment.center,
            child: Text(
              display,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 20.0,
                   
fontWeight: FontWeight.bold,
                  color: Settings.white),
            ),
          ),
        ),
      ),
    );
  }

  static Widget getButtonStyle2Disabled(
      String display, VoidCallback func, BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.9,
      height: 50.h,
      margin: EdgeInsets.only(bottom: constraints.maxWidth * 0.03),
      child: Material(
        color: Settings.grey,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: func,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            alignment: Alignment.center,
            child: Text(
              display,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 20.0,
                   
fontWeight: FontWeight.bold,
                  color: Settings.white),
            ),
          ),
        ),
      ),
    );
  }

  static Widget getTeamButton(
      String display, String teamImagePath, VoidCallback func, BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.9,
      height: Settings.teamBannerHeight + Settings.teamLogoHeight,
      margin: EdgeInsets.only(bottom: constraints.maxWidth * 0.03),
      decoration: BoxDecoration(
        color: Settings.blue,
        borderRadius: BorderRadius.circular(Settings.teamCornerRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(1),
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],),
      child: Stack(
        children: <Widget>[
          Column(
            children: [
              Container(
                height: Settings.teamBannerHeight,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                alignment: Alignment.center,
                child: Text(
                  display,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: Settings.mainFontSize,
                      fontWeight: FontWeight.bold,
                      color: Settings.white),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(Settings.teamCornerRadius),
                    ),
                    image: DecorationImage(
                      image: AssetImage(teamImagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(Settings.teamCornerRadius),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: func,
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Settings.teamCornerRadius),
                ),
                // borderRadius: BorderRadius.circular(50),
                child: Column(
                  children: [
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget getButtonStyle3(
      String display, String path, VoidCallback func, BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.40,
      height: 150.h,
      margin: EdgeInsets.only(bottom: constraints.maxWidth * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(1),
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],),
      child: Material(
        color: Settings.blue,
        borderRadius: BorderRadius.circular(40),
        child: InkWell(
          onTap: func,
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

              Container(
                padding: EdgeInsets.only(top: 15),
                child: Image(image: AssetImage(
                    path)),
              ),

              Container(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                display,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: Settings.mainFontSize,
fontWeight: FontWeight.bold,
                    color: Settings.white),
            ),) ],),

          ),
        ),
      ),
    );
  }

  static Widget getTextButtonStyle1(
      String display, VoidCallback func, BoxConstraints constraints) {
    return TextButton(
        onPressed: func,
        child: Text(
          display,
          style: const TextStyle(
             
fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ));
  }

  static Widget getTextButtonStyle1White(
      String display, VoidCallback func, BoxConstraints constraints) {
    return TextButton(
        onPressed: func,
        child: Text(
          display,
          style: const TextStyle(
            color: Settings.white,
             
fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ));
  }

  static Widget getProjectAddWidget(
      String display, VoidCallback func, BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.9,
      height: 50.h,
      margin: EdgeInsets.only(bottom: constraints.maxWidth * 0.03),
      child: Material(
        color: Settings.grey,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: func,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            height: constraints.maxWidth * 0.15,
            alignment: Alignment.center,
            child: Text(
              display,
              style: const TextStyle(
                  fontSize: 50.0,
                   
fontWeight: FontWeight.bold,
                  color: Settings.blue),
            ),
          ),
        ),
      ),
    );
  }

  static Widget getProfileImage(String link, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: constraints.maxWidth * 0.05),
      width: constraints.maxWidth * 0.5,
      height: constraints.maxWidth * 0.5,
      decoration: BoxDecoration(
          color: Settings.blue,
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: AssetImage(
                  "assets/pb_placeholder.jpg"))), //Over networkimage image: NetworkImage(link)
      // child: Image.network(link),
    );
  }

  static Widget getContainerTag(String text, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.fromLTRB(constraints.maxWidth * 0.03, 0, 0, 0),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      //color: Colors.amber,
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 14.0,
               
fontWeight: FontWeight.bold,
              color: Settings.white),
        ),
      ),
      decoration: BoxDecoration(
          color: Settings.orange,
          border: Border.all(
            color: Settings.orangeAccent,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
    );
  }

  static Widget getProfileTeam(display, VoidCallback click, VoidCallback leave,
      BoxConstraints constraints, Team team) {
    return Container(
        margin: EdgeInsets.only(bottom: constraints.maxWidth * 0.02),
        child: Row(
          children: [
            Container(
              width: constraints.maxWidth * 0.75,
              margin: EdgeInsets.only(left: constraints.maxWidth * 0.05),
              child: Material(
                color: Settings.blueAccent,
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  onTap: click,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    height: constraints.maxWidth * 0.15,
                    alignment: Alignment.center,
                    child: Text(
                      display,
                      style: const TextStyle(
                          fontSize: 20.0,
                           
fontWeight: FontWeight.bold,
                          color: Settings.white),
                    ),
                  ),
                ),
              ),
            ),
            getLeaveButton(constraints, leave, team.leader),
          ],
        ));
  }

  static getLeaveButton(
      BoxConstraints constraints, VoidCallback func, int isLeader) {
    if (isLeader == 1) {
      return SizedBox();
    } else {
      return Container(
          margin: EdgeInsets.only(left: constraints.maxWidth * 0.02),
          child: Center(
            child: Material(
              color: Settings.blueAccent,
              borderRadius: BorderRadius.circular(50),
              child: InkWell(
                onTap: func,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: constraints.maxWidth * 0.14,
                  height: constraints.maxWidth * 0.14,
                  alignment: Alignment.center,
                  child: const Text(
                    "-",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40, color: Settings.white),
                  ),
                ),
              ),
            ),
          ));
    }
  }

  static Widget getMoodEmojis(display, VoidCallback click, VoidCallback select1,
      VoidCallback leave, BoxConstraints constraints, Mood selectedMood) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(bottom: constraints.maxWidth * 0.02),
            child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Settings.blue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(20.0, 20),
                            topRight: Radius.elliptical(20.0, 20),
                          )),
                      child:
                          Center(child: getTextWhiteH3(display, constraints)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.elliptical(20.0, 20),
                            bottomRight: Radius.elliptical(20.0, 20),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              displayEmoji("assets/verygood.png", Colors.green,
                                  select1, selectedMood, 0),
                              displayEmoji("assets/good.png", Colors.lightGreen,
                                  select1, selectedMood, 1),
                              displayEmoji("assets/smile.png", Colors.orange,
                                  select1, selectedMood, 2),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              displayEmoji("assets/unamused.png",
                                  Colors.lightGreen, select1, selectedMood, 3),
                              displayEmoji("assets/bad.png", Colors.orange,
                                  select1, selectedMood, 4),
                              displayEmoji("assets/verybad.png", Colors.red,
                                  select1, selectedMood, 5),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ))),
      ],
    );
  }

  static Widget getDisabledMoodEmojis(
      display,
      VoidCallback click,
      VoidCallback select1,
      VoidCallback leave,
      BoxConstraints constraints,
      Mood selectedMood) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(bottom: constraints.maxWidth * 0.02),
            child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Settings.blue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(20.0, 20),
                            topRight: Radius.elliptical(20.0, 20),
                          )),
                      child:
                          Center(child: getTextWhiteH3(display, constraints)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.elliptical(20.0, 20),
                            bottomRight: Radius.elliptical(20.0, 20),
                          )),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              displaydisabledEmoji("assets/verygood.png",
                                  Colors.green, select1, selectedMood, 0),
                              displaydisabledEmoji("assets/good.png",
                                  Colors.lightGreen, select1, selectedMood, 1),
                              displaydisabledEmoji("assets/smile.png",
                                  Colors.orange, select1, selectedMood, 2),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              displaydisabledEmoji("assets/unamused.png",
                                  Colors.lightGreen, select1, selectedMood, 3),
                              displaydisabledEmoji("assets/bad.png",
                                  Colors.orange, select1, selectedMood, 4),
                              displaydisabledEmoji("assets/verybad.png",
                                  Colors.red, select1, selectedMood, 5),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ))),
      ],
    );
  }

  //Displays a single emoji icon in the mood selection view
  static displayEmoji(String s, MaterialColor color, VoidCallback callback,
      Mood selectedMood, int id) {
    List moodnames = <String>[
      "Sehr gut",
      "Gut",
      "Okay",
      "Naja",
      "Schlecht",
      "Sehr schlecht"
    ];
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      width: 95.w,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              selectedMood.setMood(id);
              callback();
            },
            child: CircleAvatar(
              radius: 31,
              backgroundColor: color,
              child: CircleAvatar(
                radius: getRadiusByState(selectedMood.activeMood ==
                    id), //getRadiusByState(states, id),
                backgroundImage: AssetImage(s),
                backgroundColor:
                    getColorByState(selectedMood.activeMood == id, color),
              ),
            ),
          ),
          const SizedBox(
            height: 2.0,
          ),
          Text(moodnames[id]),
        ],
      ),
    );
  }

  static displaydisabledEmoji(String s, MaterialColor color,
      VoidCallback callback, Mood selectedMood, int id) {
    List moodnames = <String>[
      "Sehr gut",
      "Gut",
      "alles gut",
      "naja",
      "Schlecht",
      "Sehr schlecht"
    ];
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      width: 95.w,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              selectedMood.setMood(id);
              callback();
            },
            child: CircleAvatar(
              radius: 31,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 29, //getRadiusByState(states, id),
                backgroundImage: AssetImage(s),
                backgroundColor: Colors.black,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 2.0,
          ),
          Text(moodnames[id]),
        ],
      ),
    );
  }

  static Color getColorByState(bool active, MaterialColor color) {
    if (active) {
      return Colors.black;
    } else {
      return color;
    }
  }

  static double getRadiusByState(bool active) {
    if (active) {
      return 20;
    } else {
      // print(20);
      return 29;
    }
  }

  static displaySingleMood(String mood, MaterialColor color) {
    return Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Row(
        children: [
          Text(
            "■",
            textAlign: TextAlign.center,
            style: TextStyle(color: color, fontSize: 20),
          ),
          Text(mood),
        ],
      ),
    );
  }

  static Widget displayInfoBoxWithTitle(
      String title, String description, BoxConstraints constraints) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: Settings.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(20.0, 20),
                    topRight: Radius.elliptical(20.0, 20),
                  )),
              child: Center(child: getTextWhiteH3(title, constraints)),
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.elliptical(20.0, 20),
                    bottomRight: Radius.elliptical(20.0, 20),
                  )),
              child: getNormalTextH3(description, constraints),
            )
          ],
        ));
  }

  static Widget getNavBar(constraints, VoidCallback callbackBack, String title,
      VoidCallback callbackProfile) {
    return Column(children: [
      Container(
        height: 10.h,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(right: 10, top: 10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            //color: Settings.blueAccent,
            height: 60.h,
            width: 60.w,
            child: IconButton(
                onPressed: callbackBack,
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 40,
                )),
          ),
          Center(
            child: Widgets.getNavHeaderText(title, constraints),
          ),
          Widgets.getProfileIcon(constraints, callbackProfile),
        ],
      ),
      Container(
        height: 10.h,
      ),
    ]);
  }

  /* static Widget getNavBarWithoutProfileWhite(
      constraints, VoidCallback callbackBack, String title) {
    return Column(children: [
      Container(
        height: 10.h,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Widgets.getTextButtonStyle1White("Back", callbackBack, constraints),
          Widgets.getTextFieldH3CWhite(title, constraints),
          SizedBox(
            width: 70.w,
          )
        ],
      ),
      Container(
        height: 10.h,
      ),
    ]);
  }*/

  static Widget getNavBarWithoutProfile(
      constraints, VoidCallback callbackBack, String title) {
    return Column(children: [
      Container(
        height: 10.h,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(right: 10, top: 10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            //color: Settings.blueAccent,
            height: 60.h,
            width: 60.w,
            child: IconButton(
                onPressed: callbackBack,
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 40,
                )),
          ),
          Widgets.getNavHeaderText(title, constraints),
          SizedBox(
            width: 70.w,
          )
        ],
      ),
      Container(
        height: 10.h,
      ),
    ]);
  }

  static Widget getProfileIcon(constraints, VoidCallback callback) {
    return Container(
      child: ElevatedButton(
        onPressed: callback,
        child: Icon(Icons.account_circle,
            color: Colors.grey, size: constraints.maxWidth * 0.15),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          primary: Colors.white, // <-- Button color
          onPrimary: Colors.red,
        ),
      ),
    );
  }

  static Widget getInputField(TextEditingController noteController,
      TextInputType text, BoxConstraints constraints) {
    return Container(
      height: 150.h,
      padding: EdgeInsets.all(5),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  width: 1.w, color: Colors.white, style: BorderStyle.solid)),
          child: TextField(
            controller: noteController,
            textAlign: TextAlign.center,
            minLines: 10,
            maxLines: 20,
            inputFormatters: [
              LengthLimitingTextInputFormatter(200),
            ],
            decoration: const InputDecoration(
                hintText: "Anmerkungen",
                contentPadding: EdgeInsets.all(15),
                border: InputBorder.none),
            onChanged: (value) {},
          ),
        ),
      ),
    );
  }
}

class Mood {
  int activeMood = -1;
  Mood();

  void setMood(int moodId) {
    activeMood = moodId;
  }
}

class MoodObject {
  int activeMood = 0;
  String date = "";
  String note = "";

  MoodObject(int mood, String date, String note) {
    this.activeMood = mood;
    this.date = date;
    this.note = note;
  }

  static List<MoodObject> getSimpleMoodObjects(List moods) {
    var toReturn = <MoodObject>[];
    for (var element in moods) {
      toReturn
          .add(MoodObject(element["mood"], element["date"], element["note"]));
    }
    return toReturn;
  }
  /*
    static List<Team> getSimpleTeams(List teams) {
    var toReturn = <Team>[];
    for (var element in teams) {
      toReturn.add(Team._(element["name"], element["teamid"], []));
    }
    return toReturn;
  }
   */
}

// <--------------------- Start Old Emotion Emojis -------------------------->
//changed name from "getMoodEmojis" to "getMoodEmojisOld"
//create the choose menu for the teamview
/*
static Widget getMoodEmojisOld(display, VoidCallback click, VoidCallback select1, VoidCallback leave, BoxConstraints constraints, List feelingStatus) {
  return Column(
    children: [
      Container(
          margin: EdgeInsets.only(bottom: constraints.maxWidth * 0.02),
          child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: Settings.blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(20.0, 20),
                          topRight: Radius.elliptical(20.0, 20),
                        )),
                    child: Center(child: getTextWhiteH3(display, constraints)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.elliptical(20.0, 20),
                          bottomRight: Radius.elliptical(20.0, 20),
                        )),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            displayEmoji("assets/smile.png", Colors.green, select1, feelingStatus, 0),
                            displayEmoji("assets/happy.png", Colors.orange, select1, feelingStatus, 1),
                            displayEmoji("assets/steam.png", Settings.blue, select1, feelingStatus, 2),
                            displayEmoji("assets/neutral.png", Colors.grey, select1, feelingStatus, 3),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            displayEmoji("assets/unamused.png", Colors.yellow, select1, feelingStatus, 4),
                            displayEmoji("assets/exhaling.png", Colors.red, select1, feelingStatus, 5),
                            displayEmoji("assets/sleeping.png", Colors.blueGrey, select1, feelingStatus, 6),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ))),
      displayEmojiLegende(),
    ],
  );

}



//umbenannt von "displayEmojiLegende" zu "displayEmojiLegendeOld"
static displayEmojiLegendeOld() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              displaySingeMood("glücklich", Colors.lightGreen),
              displaySingeMood("motiviert", Colors.orange),
              displaySingeMood("frustriert", Settings.blue),
              displaySingeMood("neutral", Colors.grey),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              displaySingeMood("gelangweilt", Colors.yellow),
              displaySingeMood("gefordert", Colors.red),
              displaySingeMood("antriebslos", Colors.blueGrey),
            ],
          )
        ],
      ),
    );
  }

    static List getMoodListOld() {
    List moodList = [];
    moodList.add(Mood('glücklich', false));
    moodList.add(Mood('motiviert', false));
    moodList.add(Mood('frustriert', false));
    moodList.add(Mood('neutral', false));
    moodList.add(Mood('gelangweilt', false));
    moodList.add(Mood('gefordert', false));
    moodList.add(Mood('antriebslos', false));

    return moodList;
  }
  */

// <--------------------- End Old Emotion Emojis -------------------------->
