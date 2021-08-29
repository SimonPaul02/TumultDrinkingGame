import "package:flutter/material.dart";

class DrinkingCards extends StatefulWidget {
  @override
  _DrinkingCardsState createState() => _DrinkingCardsState();
}

class _DrinkingCardsState extends State<DrinkingCards> {
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
            body: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                      )
                    ]))));
  }
}
