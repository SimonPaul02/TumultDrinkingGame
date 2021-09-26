import 'dart:math';

import 'package:flutter/material.dart';

import '../Player.dart';
import '../Shotcounter.dart';

mixin CardGame<T extends StatefulWidget> on State<T> {
  bool showNextPlayer = true;
  List<Player> players;
  List<bool> visibilities = [false, false, false, false];
  List<bool> emptyDrinks = [false, false, false, false];
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
  bool showBackground = true;
  String cardBeforeShuffling = "";
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

  Widget buildNextPlayersTurn(BuildContext context, int playerIndexReduction) {
    if (players != null && showNextPlayer) {
      return Positioned(
        bottom: 25,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 30,
          child: Text(
            (somebodyHasToDrink)
                ? players[(playerIndex - playerIndexReduction) % players.length].name +
                    " muss trinken"
                : players[playerIndex].name + " ist dran",
            style: TextStyle(color: Colors.white, fontSize: 22),
            textAlign: TextAlign.center,
          ),
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
          (showBackground)
              ? cardFlag + "BG1" + ".png"
              : cardFlag + cards[cardIndex] + ".png",
        ));
  }

  void opacityAfterNextCard(){
    setState(() {
      opacity = opacity == 1.0 ? 0.1 : 1.0;
    });

  }

  int findPrevCardLevel() {
    String prevCardValue;
    if (cardIndex >= 1) {
      prevCardValue = cards[(cardIndex - 1)].substring(0, 1);
    } else {
      prevCardValue = cardBeforeShuffling;
    }
    return order.indexOf(prevCardValue);
  }

  int findCurrentCardLevel() {
    String currentCardValue = cards[cardIndex].substring(0, 1);
    return order.indexOf(currentCardValue);
  }

  int findNextCardLevel() {
    String nextCardValue = cards[(cardIndex + 1) % 52].substring(0, 1);
    return order.indexOf(nextCardValue);
  }

  bool nextCardIsHeart() {
    return (cards[(cardIndex + 1) % 52].substring(1, 2) == "H");
  }

  bool nextCardIsSpades() {
    return (cards[(cardIndex + 1) % 52].substring(1, 2) == "S");
  }

  bool nextCardIsDiamond() {
    return (cards[(cardIndex + 1) % 52].substring(1, 2) == "D");
  }

  bool nextCardIsClubs() {
    return (cards[(cardIndex + 1) % 52].substring(1, 2) == "C");
  }

  bool nextCardIsBlack() {
    return nextCardIsSpades() || nextCardIsClubs();
  }

  bool nextCardOut() {
    int prevCardLevel = findPrevCardLevel();
    int currentCardLevel = findCurrentCardLevel();
    int nextCardLevel = findNextCardLevel();

    return (prevCardLevel < nextCardLevel &&
            currentCardLevel < nextCardLevel) ||
        (prevCardLevel > nextCardLevel && currentCardLevel > nextCardLevel);
  }

  bool nextCardInBetween() {
    int prevCardLevel = findPrevCardLevel();
    int currentCardLevel = findCurrentCardLevel();
    int nextCardLevel = findNextCardLevel();

    return ((prevCardLevel < nextCardLevel &&
            nextCardLevel < currentCardLevel) ||
        (currentCardLevel < nextCardLevel && nextCardLevel < prevCardLevel));
  }

  bool nextCardIsLower() {
    return (findCurrentCardLevel() > findNextCardLevel());
  }

  bool nextCardIsHigher() {
    return (findCurrentCardLevel() < findNextCardLevel());
  }

  double evaluateRightPadding() {
    if (players == null) {
      return 0;
    }
    return 20;
  }

  Image selectFullGlass(int i) {
    if (i % 3 == 0) {
      return Image.asset("${shotGlassFlag}shotGlassFull.png");
    }
    if (i % 3 == 1) {
      return Image.asset("${shotGlassFlag}cocktailFull.png");
    }
    return Image.asset("${shotGlassFlag}wineGlassFull.png");
  }

  Image selectEmptyGlass(int i) {
    if (i % 3 == 0) {
      return Image.asset("${shotGlassFlag}shotGlassEmpty.png");
    }
    if (i % 3 == 1) {
      return Image.asset("${shotGlassFlag}cocktailEmpty.png");
    }
    return Image.asset("${shotGlassFlag}wineGlassEmpty.png");
  }

  Widget buildCardAnimation() {
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
        right: 10,
        child: ShotCounter(
          players: players,
        ));
  }

  void checkAllEmpty() {
    for (int i = 0; i < visibilities.length; i++) {
      if (emptyDrinks[i] == false && visibilities[i] == true) return;
    }
    setState(() {
      somebodyHasToDrink = false;
    });

    for (int i = 0; i < visibilities.length; i++) {
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

  Widget buildShots(BuildContext context, int playerIndexReduction) {
    return Positioned(
      top: 175,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < visibilities.length; i++) buildShot(i, playerIndexReduction)
          ],
        ),
      ),
    );
  }

  Widget buildShot(int visibilityIndex, int playerReduction) {
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
              players[(playerIndex - playerReduction) % players.length].currentShots++;
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
        cardBeforeShuffling = cards[cardIndex];
        cardIndex = 0;
        cards.shuffle();
      }
    });
  }

  void setOpacity() {
    if (opacity != 1.0) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          opacity = 1.0;
        });
      });
    }
  }
}
