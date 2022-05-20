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
        style: const TextStyle(color: Colors.blueAccent),
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
        style: const TextStyle(color: Settings.errorColor),
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
    return SizedBox(
        width: constraints.maxWidth * 0.8,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
          ),
          onPressed: func,
          child: Container(
              margin: const EdgeInsets.fromLTRB(0, 9, 0, 9),
              child: Text(
                display,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
        ));
  }

  static Widget getProjectAddWidget(
      String display, VoidCallback func, BoxConstraints constraints) {
    return SizedBox(
        width: constraints.maxWidth * 0.8,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.grey),
          onPressed: func,
          child: Text(
            display,
            style: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ));
  }
}
