import 'package:flutter/material.dart';
import 'package:moody/widgets/settings.dart';

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

  static Widget getInputFieldStyle1(TextEditingController ctr,
      TextInputType type, bool hidden, BoxConstraints constraints) {
    return TextField(
      textAlign: TextAlign.center,
      obscureText: hidden,
      controller: ctr,
      keyboardType: type,
    );
  }

  static Widget getButtonStyle1(
      String display, VoidCallback func, BoxConstraints constraints) {
    return ElevatedButton(
      onPressed: func,
      child: Text(display),
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

  static Widget getProjectWidget(
      String display, VoidCallback func, BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.9,
      margin: EdgeInsets.only(bottom: constraints.maxWidth * 0.03),
      child: Material(
        color: Settings.blue,
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
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Settings.white),
            ),
          ),
        ),
      ),
    );
  }

  static Widget getProjectAddWidget(
      String display, VoidCallback func, BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.9,
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
              fit: BoxFit.fitHeight, image: NetworkImage(link))),
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
      BoxConstraints constraints) {
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
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Settings.white),
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
}
