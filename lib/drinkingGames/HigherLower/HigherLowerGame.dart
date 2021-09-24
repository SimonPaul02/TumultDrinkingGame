import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import '../../Player.dart';
import '../../Shotcounter.dart';

class HigherLowerGame extends StatefulWidget {
  @override
  _DrinkingCardsState createState() => _DrinkingCardsState();
  final List<Player> players;
  final int numberOfCards;

  HigherLowerGame({this.players, this.numberOfCards});
}

class _DrinkingCardsState extends State<HigherLowerGame> {
  bool somebodyHasToDrink = false;
  List<bool> visibilities = [false, false, false];
  List<bool> emptyDrinks = [false, false, false];
  final String shotGlassFlag = "img/shotGlasses/";

  List<int> states = [
    2,
    2
  ]; // 0 is invisible drink, 1 is visible and full 2 is visible and empty
  var random = new Random();
  int randomNumber = 0;
  double _opacity = 1.0;
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

  @override
  void initState() {
    super.initState();
    numberOfCards = widget.numberOfCards;
    for (int i = 2; i <= 9; i++) {
      addToCards(i.toString());
    }
    addToCards("A");
    addToCards("J");
    addToCards("K");
    addToCards("Q");
    addToCards("T");
    //cards.add("BG1");
    //cards.add("BG2");
    cards.shuffle();
  }

  void addToCards(String char) {
    cards.add(char + "C");
    cards.add(char + "D");
    cards.add(char + "H");
    cards.add(char + "S");
  }

  @override
  Widget build(BuildContext context) {
    if (_opacity != 1.0) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _opacity = 1.0;
        });
      });
    }
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("img/wine1.jpg"),
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
        body: SingleChildScrollView(
          child: Stack(children: [
            fullScreen(),
            Positioned(
                top: cardPaddingTop,
                left: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    color: animationColor,
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: _opacity,
                      child: AnimatedCrossFade(
                        firstCurve: Curves.decelerate,
                        duration: Duration(milliseconds: 500),
                        crossFadeState: showNextCard && _opacity == 0.0
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: buildCard(),
                        secondChild: buildCard(),
                      ),
                    ),
                  ),
                )),
            Positioned(
                bottom: 20,
                child: ShotCounter(
                  players: widget.players,
                )),
            Positioned(
              top: cardHeight + cardPaddingTop,
              left: 85.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  higherLowerButton(true),
                  higherLowerButton(false),
                ],
              ),
            ),
            Positioned(bottom: 25, child: evaluatePlayerTurn()),
            Positioned(
              left: 55,
              top: 175,
              child: buildShots(),
            ),
          ]),
        ),
      ),
    );
  }

  Padding higherLowerButton(bool isHigher) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: IconButton(
        iconSize: 80,
        icon: Icon(
          isHigher
              ? Icons.arrow_circle_up_sharp
              : Icons.arrow_circle_down_sharp,
          color: (somebodyHasToDrink) ? Colors.white24 : Colors.lightBlueAccent,
        ),
        tooltip: isHigher ? "Higher" : "Lower",
        onPressed: () {
          if (!somebodyHasToDrink) {
            if (!isHigher && currentCardIsLower()) {
              animationColor = Colors.green;
            } else if (isHigher && currentCardIsHigher()) {
              animationColor = Colors.green;
            } else {
              animationColor = Colors.red;
              somebodyHasToDrink = true;
              for (int i = 0; i <= randomNumber; i++) {
                visibilities[i] = true;
                emptyDrinks[i] = false;
              }
              setState(() {
                randomNumber = random.nextInt(3);
              });
            }
            nextCard();
            setState(() {
              if (numberOfCards > 0) {
                numberOfCards--;
              }
              _opacity = _opacity == 1.0 ? 0.1 : 1.0;
              if (widget.players != null) {
                playerIndex = (playerIndex + 1) % widget.players.length;
              }
            });
          }
        },
      ),
    );
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

  Widget evaluatePlayerTurn() {
    if (widget.players != null) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 30,
        child: Text(
          (somebodyHasToDrink)
              ? widget.players[(playerIndex - 1) % widget.players.length].name +
                  " muss trinken"
              : widget.players[playerIndex].name + " ist dran",
          style: TextStyle(color: Colors.white, fontSize: 22),
          textAlign: TextAlign.center,
        ),
      );
    }
    return Text("");
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
    if (widget.players == null) {
      return 0;
    }
    return 20;
  }

  SizedBox buildCard() {
    return SizedBox(
        width: 257,
        height: cardHeight,
        child: Image.asset(
          cardFlag + cards[cardIndex] + ".png",
        ));
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
            if (widget.players != null) {
              widget.players[(playerIndex - 1) % widget.players.length]
                  .currentShots++;
            }
            emptyDrinks[visibilityIndex] = true;
            checkAllEmpty();
          });
        },
      ),
    );
  }

  Row buildShots() {
    return Row(children: [for (int i = 0; i < 3; i++) buildShot(i)]);
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

  bool allInvisible() {
    for (int i = 0; i < visibilities.length; i++) {
      if (visibilities[i] == true) {
        return false;
      }
    }
    return true;
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
}
