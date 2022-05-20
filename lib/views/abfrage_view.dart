import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AbfrageView extends StatefulWidget {
  const AbfrageView({Key? key}) : super(key: key);

  @override
  State<AbfrageView> createState() => _AbfrageViewState();
}

class _AbfrageViewState extends State<AbfrageView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Stimmungsabfrage"),
        ),
        body: Column(
          children: [
            smileyAbfrageWidget("Wie geht es dir heute?"),
            displayLegende("???")
          ],
        ),
      ),
    );
  }

  Widget smileyAbfrageWidget(String ueberschrift) {
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
              child: Center(child: textUeberschrift(ueberschrift)),
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      displayEmoji("gl"),
                      displayEmoji("mo"),
                      displayEmoji("fr"),
                      displayEmoji("ne"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      displayEmoji("gel"),
                      displayEmoji("gef"),
                      displayEmoji("an"),
                    ],
                  )
                ],
              ),
            )
          ],
        )
    );
  }

  textUeberschrift(String title) {
    return Text(title,
      maxLines: 2,
      style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.black),
    );
  }

 Widget displayEmoji(String s) {
    return Container(
      padding: EdgeInsets.only(left: 2,right: 2),
      margin: EdgeInsets.only(left: 5,right: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 5),
      ),
      child: Text(s),
    );
  }
  Widget displayLegende(String s) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              displayGefuehl("glücklich", Colors.lightGreen),
              displayGefuehl("motiviert", Colors.orange),
              displayGefuehl("frustriert", Colors.blue),
              displayGefuehl("neutral", Colors.grey),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              displayGefuehl("gelangweilt", Colors.yellow),
              displayGefuehl("gefordert", Colors.red),
              displayGefuehl("antriebslos", Colors.blueGrey),
            ],
          )
        ],
      ),
    );
  }
  Widget displayGefuehl(String gefuehl,MaterialColor color) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        child: Row(
          children: [
            Text("-",
            textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 30
              ),
            ),
            Text(gefuehl),
          ],
        ),
      ),
    );
  }
}
