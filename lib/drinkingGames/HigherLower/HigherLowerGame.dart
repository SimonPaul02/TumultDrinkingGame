import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:tumult_trinkspiel/drinkingGames/cardGame.dart';
import '../../Player.dart';


class HigherLowerGame extends StatefulWidget {
  @override
  _DrinkingCardsState createState() => _DrinkingCardsState();
  final List<Player> players;
  final int numberOfCards;

  HigherLowerGame({this.players, this.numberOfCards});
}

class _DrinkingCardsState extends State<HigherLowerGame> with CardGame {
  @override
  void initState() {
    super.initState();
    numberOfCards = widget.numberOfCards;
    players = widget.players;
    initCards();
  }

  @override
  Widget build(BuildContext context) {
    if (opacity != 1.0) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          opacity = 1.0;
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
           buildCard(),
            buildShotCounter(),
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
            Positioned(
                bottom: 25,
                child: evaluateNextTurn(
                    context) //PlayerTurnEvaluation(widget.players, somebodyHasToDrink, playerIndex)
                ),
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
              opacity = opacity == 1.0 ? 0.1 : 1.0;
              if (widget.players != null) {
                playerIndex = (playerIndex + 1) % widget.players.length;
              }
            });
          }
        },
      ),
    );
  }

}
