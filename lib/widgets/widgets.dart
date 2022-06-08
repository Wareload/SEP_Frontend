import 'package:flutter/material.dart';
import 'package:moody/widgets/settings.dart';

//TODO Mood Logik mit der Map an neues Design (4 Emojis) anpassen

class Widgets {
  Widgets._();

  static Widget getTextFieldH1(String display, BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Text(
        display,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
      ),
    );
  }

  static Widget getTextFieldH2(String display, BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Text(
        display,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      ),
    );
  }

  static Widget getTextFieldH3(String display, BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Text(
        display,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Settings.white),
    );
  }

  static Widget getNormalTextH3(String text, BoxConstraints constraints) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal, color: Colors.black),
    );
  }

  static Widget getInputFieldStyle1(TextEditingController ctr, TextInputType type, bool hidden, BoxConstraints constraints) {
    return TextField(
      textAlign: TextAlign.center,
      obscureText: hidden,
      controller: ctr,
      keyboardType: type,
    );
  }

  //A InputField with a title(Top Blue and Bottom white)
  static Widget getInputFieldWithTitle(
      TextEditingController ctr, TextInputType type, bool hidden, BoxConstraints constraints, String title, String hint) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(20.0, 20),
                    topRight: Radius.elliptical(20.0, 20),
                  )),
              child: Center(
                  child: Text(
                title,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Settings.white),
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

  static Widget getButtonStyle1(String display, VoidCallback func, BoxConstraints constraints) {
    return ElevatedButton(
      onPressed: func,
      child: Text(display),
    );
  }

  static Widget getButtonStyleOrange(String display, VoidCallback func, BoxConstraints constraints, String btnText) {
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
            height: 60,
            alignment: Alignment.center,
            child: Text(
              btnText,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Settings.white),
            ),
          ),
        ),
      ),
    );
  }

  static Widget getButtonStyle2(String display, VoidCallback func, BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.9,
      height: 50,
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
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Settings.white),
            ),
          ),
        ),
      ),
    );
  }

  static Widget getTextButtonStyle1(String display, VoidCallback func, BoxConstraints constraints) {
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

  static Widget getProjectAddWidget(String display, VoidCallback func, BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.9,
      height: 50,
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
              style: const TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold, color: Settings.blue),
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
          image:
              DecorationImage(fit: BoxFit.fitHeight, image: AssetImage("assets/pb_placeholderr.jpg"))), //Over networkimage image: NetworkImage(link)
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
          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Settings.white),
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

  static Widget getProfileTeam(display, VoidCallback click, VoidCallback leave, BoxConstraints constraints) {
    return Container(
        margin: EdgeInsets.only(bottom: constraints.maxWidth * 0.02),
        child: Row(
          children: [
            Container(
              width: constraints.maxWidth * 0.75,
              margin: EdgeInsets.only(left: constraints.maxWidth * 0.05),
              child: Material(
                color: Settings.blue,
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  onTap: click,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    height: constraints.maxWidth * 0.15,
                    alignment: Alignment.center,
                    child: Text(
                      display,
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Settings.white),
                    ),
                  ),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: constraints.maxWidth * 0.02),
                child: Center(
                  child: Material(
                    color: Settings.grey,
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      onTap: leave,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: constraints.maxWidth * 0.14,
                        height: constraints.maxWidth * 0.14,
                        alignment: Alignment.center,
                        child: const Text(
                          "-",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 40, color: Settings.blue),
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ));
  }

  static Widget getMoodEmojis(display, VoidCallback click, VoidCallback select1, VoidCallback leave, BoxConstraints constraints, List feelingStatus) {
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
                          color: Colors.blue,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              displayEmoji("assets/verygood.png", Colors.green, select1, feelingStatus, 0),
                              displayEmoji("assets/good.png", Colors.lightGreen, select1, feelingStatus, 1),
                              displayEmoji("assets/bad.png", Colors.orange, select1, feelingStatus, 2),
                              displayEmoji("assets/verybad.png", Colors.red, select1, feelingStatus, 3),
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
  static displayEmoji(String s, MaterialColor color, VoidCallback callback, List states, int id) {
    List moodnames = <String>["Sehr gut", "Gut", "Schlecht", "Sehr schlecht"];
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Mood m = states[id];
              m.setStatus(!m.status);
              callback();
            },
            child: CircleAvatar(
              radius: 31,
              backgroundColor: color,
              child: CircleAvatar(
                radius: getRadiusByState(states[id]), //getRadiusByState(states, id),
                backgroundImage: AssetImage(s),
                backgroundColor: getColorByState(states[id], color),
              ),
            ),
          ),
          SizedBox(
            height: 2.0,
          ),
          Text(moodnames[id]),
        ],
      ),
    );
  }

  static Color getColorByState(Mood mood, MaterialColor color) {
    if (mood.status) {
      return Colors.black;
    } else {
      return color;
    }
  }

  static double getRadiusByState(stat) {
    Mood m = stat;
    if (m.status == true) {
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

  static Widget displayInfoBoxWithTitle(String title, String description, BoxConstraints constraints) {
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

  static Widget getProfileIcon(constraints, VoidCallback callback) {
    return Container(
      child: ElevatedButton(
        onPressed: callback,
        child: Icon(Icons.account_circle, color: Colors.grey, size: constraints.maxWidth * 0.15),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          primary: Colors.white, // <-- Button color
          onPrimary: Colors.red,
        ),
      ),
    );
  }

  static Widget getInputField(TextEditingController noteController, TextInputType text, BoxConstraints constraints, String hint) {
    return Container(
      height: 150,
      padding: EdgeInsets.all(5),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 1, color: Colors.white, style: BorderStyle.solid)),
          child: TextField(
            controller: noteController,
            textAlign: TextAlign.center,
            minLines: 10,
            maxLines: 20,
            decoration: const InputDecoration(hintText: "Anmerkungen", contentPadding: EdgeInsets.all(15), border: InputBorder.none),
            onChanged: (value) {},
          ),
        ),
      ),
    );
  }

  static List getMoodList() {
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
}

class Mood {
  String moodname;
  bool status;
  Mood(this.moodname, this.status);
  @override
  String toString() {
    return '{ ${this.moodname}, ${this.status} }';
  }

  void setStatus(bool newState) {
    status = newState;
  }
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
                        color: Colors.blue,
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
                            displayEmoji("assets/steam.png", Colors.blue, select1, feelingStatus, 2),
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
              displaySingeMood("frustriert", Colors.blue),
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
  }*/
// <--------------------- End Old Emotion Emojis -------------------------->
