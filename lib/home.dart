import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isVisibleExplanation = false;
  bool isVisibleGif = false;
  String explanation = " ";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("img/beer1.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            title: Text("Tumult - das exzellente Trinkspiel"),
            centerTitle: true,
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildOutlinedButton(
                      "/higherLower",
                      "Higher-Lower ist ein Klassiker, aber hier eine exzellente Variante: Anfangs wird eine Karte offengelgt. Danach müsst ihr sagen, ob die Folgekarte höher, oder niedriger ist und die nächste Karte dann aufdecken. Liegt ihr falsch, so müsst ihr so viel trinken, wie die Karte es verlangt. Man ist so lange dran, bis man richtig rät. Setzt euch zu Beginn ein Ziel, zB 100 Karten. Gutes Gesaufe!",
                      "Higher-Lower"),
                  buildOutlinedButton(
                      "/drinkingCards",
                      "In allen Exzellentsstufen, für jeden was dabei: Einzel- und Gruppenkarten, die euren Alkoholpegel steigen lassen werden. Tragt am besten eueren Namen mit Geschlecht vorher ein, dann wird das Spiel optimal auf euch angepasst. Gerne könnt ihr auch angeben, wieviel ihr maximal trinken wollt und dann mit dem Shotcounter auf der rechten Seite mitzählen. Viel Spaß!",
                      "Saufkarten"),
                  buildOutlinedButton("null", "", "Mehr"),
                  Visibility(
                      visible: isVisibleExplanation,
                      child: buildExplanationContainer(explanation)),
                  Visibility(
                      visible: isVisibleGif,
                      child: Container(
                        height: 400,
                        width: 40,
                        child: Image(image: AssetImage("img/beer2.gif")),
                      ))
                ],
              ),
            ),
          )),
    );
  }

  Padding buildExplanationContainer(String explanation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
      child: Container(
        width: 40,
        height: 333,
        color: Colors.lightBlueAccent,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(explanation, style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  Padding buildOutlinedButton(String path, String explanation, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 3.0),
      child: OutlinedButton(
        onPressed: () {
          Navigator.pushNamed(context, path);
        },
        onLongPress: () {
          if (explanation == "") {
            isVisibleExplanation = false;
            setState(() {
              isVisibleGif = !isVisibleGif;
            });
          } else {
            this.explanation = explanation;
            isVisibleGif = false;
            setState(() {
              isVisibleExplanation = !isVisibleExplanation;
            });
          }
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
          elevation: 10,
          primary: Colors.lightBlueAccent,
          side: buildBorderSide(),
          shape: buildRoundedRectangleBorder(),
        ),
        child: buildText(name),
      ),
    );
  }

  Text buildText(String text) => Text(text, style: TextStyle(fontSize: 25));

  RoundedRectangleBorder buildRoundedRectangleBorder() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0));
  }

  BorderSide buildBorderSide() => BorderSide(color: Colors.grey[400]);
}
