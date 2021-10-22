import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:tumult_trinkspiel/drinkingGames/drinkingGame.dart';
import '../../Player.dart';

class HigherLowerGame extends StatefulWidget {
  @override
  _DrinkingCardsState createState() => _DrinkingCardsState();
  final List<Player> players;
  final int numberOfCards;

  HigherLowerGame({this.players, this.numberOfCards});
}

class _DrinkingCardsState extends State<HigherLowerGame> with DrinkingGame {
  @override
  void initState() {
    super.initState();
    differentSpacing = 0;
    numberOfCards = widget.numberOfCards;
    players = widget.players;
    showBackground = false;
    initCards();
  }

  @override
  Widget build(BuildContext context) {
    print(cardIndex);
    setOpacity();
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
          actions: [
            buildHomeButton(),
          ],
          elevation: 0,
          centerTitle: true,
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(displayNumberOfCards()),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Stack(children: [
            fullScreen(),
            buildCardAnimation(),
            buildShotCounter(),
            Positioned(
              top: cardHeight + cardPaddingTop,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    higherLowerButton(true),
                    higherLowerButton(false),
                  ],
                ),
              ),
            ),
            buildNextPlayersTurn(context, 1),
            buildShots(context, 1),
          ]),
        ),
      ),
    );
  }

  Widget higherLowerButton(bool isHigher) {
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
            if (!isHigher && nextCardIsLower()) {
              animationColor = Colors.green;
            } else if (isHigher && nextCardIsHigher()) {
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
              opacityAfterNextCard();
              if (players != null) {
                playerIndex = (playerIndex + 1) % players.length;
              }
            });
          }
        },
      ),
    );
  }

  String displayNumberOfCards() {
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
}
