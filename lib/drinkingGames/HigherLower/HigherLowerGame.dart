import "package:flutter/material.dart";
import '../../Player.dart';
import '../../FABMenu.dart';

class HigherLowerGame extends StatefulWidget {
  @override
  _DrinkingCardsState createState() => _DrinkingCardsState();
  final List<Player> players;
  final int numberOfCards;
  final FABMenu fabMenu = new FABMenu(
    tooltip: "Menu",
  );

  HigherLowerGame({this.players, this.numberOfCards});
}

class _DrinkingCardsState extends State<HigherLowerGame> {
  int numberOfCards;
  final String flag = "img/cardDeck/";
  FABMenu fabMenu;

  @override
  void initState() {
    super.initState();
    numberOfCards = widget.numberOfCards;
    fabMenu = widget.fabMenu;
  }

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
            title: Text(printNumberOfCards()),
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
                        width: 400,
                        height: 400,
                        child: Image.asset(flag + "2C" + ".png")),
                  ])),
          floatingActionButton: FloatingActionButton(onPressed: () {
            fabMenu.createState().build(null);
          }),
        ));
  }

  String printNumberOfCards() {
    if (numberOfCards > 1) {
      return "Higher-Lower: $numberOfCards Karten übrig";
    }
    if (numberOfCards == 1) {
      return "Higher-Lower: Letzte Karte!";
    }
    if (numberOfCards == 0) {
      return "Nice! Geschafft!";
    }
    return "Higher-Lower";
  }

  Widget buildStuff() {
    return FABMenu();
  }
}
