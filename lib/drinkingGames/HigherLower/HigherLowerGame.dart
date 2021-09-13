import 'dart:collection';

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
  int numberOfCards;
  final String flag = "img/cardDeck/";
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
    cards.add("BG1");
    cards.add("BG2");
    cards.shuffle();
  }

  void addToCards(String char) {
    cards.add("$char C");
    cards.add("$char D");
    cards.add("$char H");
    cards.add("$char S");
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedCrossFade(
                      duration: Duration(milliseconds: 1000),
                      crossFadeState: showNextCard
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: SizedBox(
                        width: 300,
                        height: 400,
                        child: Image.asset(
                          flag + "2C" + ".png",
                        ),
                      ),
                      secondChild: SizedBox(
                        width: 300,
                        height: 400,
                        child: Image.asset(
                          flag + "9S" + ".png",
                        ),
                      ),
                    ),
                    //ShotCounter(tooltip: "Menu", players: widget.players),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        higherLowerButton(true),
                        higherLowerButton(false)
                      ],
                    ),
                    evaluatePlayerTurn(),
                  ]),
            ),
          ),
          floatingActionButton:
              ShotCounter(tooltip: "Menu", players: widget.players),
        )
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
          color: Colors.lightBlueAccent,
        ),
        tooltip: isHigher ? "Higher" : "Lower",
        onPressed: () {
          print("afdsklkjadslöfjaslödfjasklöjfd");
          nextCard();
          setState(() {
            if (numberOfCards > 0) {
              numberOfCards--;
            }
          });
          if (isHigher && currentCardIsHigher() ||
              !isHigher && currentCardIsLower()) {
          } else {}
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

  Text evaluatePlayerTurn() {
    if (widget.players == null) {
      return Text("");
    }
    return Text(
      widget.players[playerIndex].name + " ist dran",
      style: TextStyle(color: Colors.white, fontSize: 22),
    );
  }

  void nextCard() {
    setState(() {
      showNextCard = !showNextCard;
      cardIndex++;
      if (cardIndex == 56) {
        cardIndex = 0;
        cards.shuffle();
      }
    });
  }

  int findCurrentCardLevel() {
    String currentCardValue = cards[cardIndex].substring(0, 1);
    return order.indexOf(currentCardValue);
  }

  int findPrevCardLevel() {
    String prevCardValue = cards[(cardIndex - 1) % 56].substring(0, 1);
    return order.indexOf(prevCardValue);
  }

  bool currentCardIsLower() {
    return (findCurrentCardLevel() > findPrevCardLevel());
  }

  bool currentCardIsHigher() {
    return (findCurrentCardLevel() < findPrevCardLevel());
  }
}
