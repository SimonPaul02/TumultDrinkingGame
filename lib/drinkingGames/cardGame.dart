import 'dart:math';

import 'package:flutter/material.dart';

import '../Player.dart';
import '../Shotcounter.dart';

mixin CardGame<T extends StatefulWidget> on State<T> {
  List<Player> players;
  List<bool> visibilities = [false, false, false];
  List<bool> emptyDrinks = [false, false, false];
  final String shotGlassFlag = "img/shotGlasses/";
  bool somebodyHasToDrink = false;
  var random = new Random();
  int randomNumber = 0;
  double opacity = 1.0;
  bool showGreenAnimation = true;
  final double cardPaddingTop = 30.0;
  final double cardHeight = 400.0;
  Color animationColor = Colors.green;
  int numberOfCards;
  final String cardFlag = "img/cardDeck/";
  int playerIndex = 0;
  bool showNextCard = false;
  List<String> cards =
      []; // not a stack or a queue, because of the nice shuffling method in lists
  int cardIndex = 0;
  final List<String> order = [
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "T",
    "J",
    "Q",
    "K",
    "A"
  ];

  void initCards() {
    for (int i = 2; i <= 9; i++) {
      addToCards(i.toString());
    }
    addToCards("A");
    addToCards("J");
    addToCards("K");
    addToCards("Q");
    addToCards("T");
    cards.shuffle();
  }

  void addToCards(String char) {
    cards.add(char + "C");
    cards.add(char + "D");
    cards.add(char + "H");
    cards.add(char + "S");
  }

  Container evaluateNextTurn(BuildContext context) {
    if (players != null) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 30,
        child: Text(
          (somebodyHasToDrink)
              ? players[(playerIndex - 1) % players.length].name +
                  " muss trinken"
              : players[playerIndex].name + " ist dran",
          style: TextStyle(color: Colors.white, fontSize: 22),
          textAlign: TextAlign.center,
        ),
      );
    }
    return Container();
  }

  SizedBox buildCardChild() {
    return SizedBox(
        width: 257,
        height: cardHeight,
        child: Image.asset(
          cardFlag + cards[cardIndex] + ".png",
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

  bool allInvisible() {
    for (int i = 0; i < visibilities.length; i++) {
      if (visibilities[i] == true) {
        return false;
      }
    }
    return true;
  }

  int findCurrentCardLevel() {
    String currentCardValue = cards[cardIndex].substring(0, 1);
    return order.indexOf(currentCardValue);
  }

  int findNextCardLevel() {
    String nextCardValue = cards[(cardIndex + 1) % 52].substring(0, 1);
    return order.indexOf(nextCardValue);
  }

  bool currentCardIsLower() {
    return (findCurrentCardLevel() > findNextCardLevel());
  }

  bool currentCardIsHigher() {
    return (findCurrentCardLevel() < findNextCardLevel());
  }

  double evaluateRightPadding() {
    if (players == null) {
      return 0;
    }
    return 20;
  }

  Image selectFullGlass(int i) {
    if (i == 0) {
      return Image.asset("${shotGlassFlag}shotGlassFull.png");
    }
    if (i == 1) {
      return Image.asset("${shotGlassFlag}cocktailFull.png");
    }
    return Image.asset("${shotGlassFlag}wineGlassFull.png");
  }

  Image selectEmptyGlass(int i) {
    if (i == 0) {
      return Image.asset("${shotGlassFlag}shotGlassEmpty.png");
    }
    if (i == 1) {
      return Image.asset("${shotGlassFlag}cocktailEmpty.png");
    }
    return Image.asset("${shotGlassFlag}wineGlassEmpty.png");
  }

  Widget buildCard() {
    return Positioned(
        top: cardPaddingTop,
        left: 70,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            color: animationColor,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: opacity,
              child: AnimatedCrossFade(
                firstCurve: Curves.decelerate,
                duration: Duration(milliseconds: 500),
                crossFadeState: showNextCard && opacity == 0.0
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: buildCardChild(),
                secondChild: buildCardChild(),
              ),
            ),
          ),
        ));
  }

  Widget buildShotCounter() {
    return Positioned(
        bottom: 20,
        child: ShotCounter(
          players: players,
        ));
  }

  void checkAllEmpty() {
    for (int i = 0; i < 3; i++) {
      if (emptyDrinks[i] == false && visibilities[i] == true) return;
    }
    setState(() {
      somebodyHasToDrink = false;
    });

    for (int i = 0; i < 3; i++) {
      emptyDrinks[i] = false;
      visibilities[i] = false;
    }
  }

  SizedBox fullScreen() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    EdgeInsets padding = MediaQuery.of(context).padding;
    height = height - padding.top - padding.bottom - kToolbarHeight;
    return SizedBox(
      width: width,
      height: height,
    );
  }

  Row buildShots() {
    return Row(children: [for (int i = 0; i < 3; i++) buildShot(i)]);
  }

  Widget buildShot(int visibilityIndex) {
    if (visibilities[visibilityIndex] == false &&
        emptyDrinks[visibilityIndex] == false) {
      return Row();
    }
    return Visibility(
      visible: visibilities[visibilityIndex],
      child: IconButton(
        icon: (emptyDrinks[visibilityIndex] == true)
            ? selectEmptyGlass(visibilityIndex)
            : selectFullGlass(visibilityIndex),
        iconSize: 80,
        onPressed: () {
          setState(() {
            if (players != null) {
              players[(playerIndex - 1) % players.length].currentShots++;
            }
            emptyDrinks[visibilityIndex] = true;
            checkAllEmpty();
          });
        },
      ),
    );
  }

  void nextCard() {
    setState(() {
      showNextCard = !showNextCard;
      cardIndex++;
      if (cardIndex == 52) {
        cardIndex = 0;
        cards.shuffle();
      }
    });
  }
}
