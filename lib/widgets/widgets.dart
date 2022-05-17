import 'package:flutter/material.dart';
import 'package:moody/widgets/settings.dart';

class Widgets {
  Widgets._();

  static Widget getTextFieldH1(String display) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
      child: Text(
        display,
      ),
    );
  }

  static Widget getTextFieldH2(String display) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Text(display),
    );
  }

  static Widget getTextFieldP1(String display) {
    return Container(
      child: Text(display),
    );
  }

  static Widget getTextFieldE1(String display) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Text(
        display,
        style: const TextStyle(color: Settings.errorColor),
      ),
    );
  }

  static Widget getInputFieldStyle1(
      TextEditingController ctr, TextInputType type, bool hidden) {
    return TextField(
      textAlign: TextAlign.center,
      obscureText: hidden,
      controller: ctr,
      keyboardType: type,
    );
  }

  static Widget getButtonStyle1(String display, VoidCallback func) {
    return ElevatedButton(
      onPressed: func,
      child: Text(display),
    );
  }

  static Widget getTextButtonStyle1(String display, VoidCallback func) {
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
}
