import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AtemView extends StatefulWidget {
  const AtemView({Key? key}) : super(key: key);

  @override
  State<AtemView> createState() => _AtemViewState();
}

class _AtemViewState extends State<AtemView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text("Atemübung"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
          ),
        ),
      ),
    ));
  }
}
