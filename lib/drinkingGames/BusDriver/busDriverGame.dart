import 'package:flutter/material.dart';
import 'package:tumult_trinkspiel/drinkingGames/cardGame.dart';
import '../../Player.dart';

class BusDriverGame extends StatefulWidget {
  final List<Player> players;
  final int numberOfRounds;

  @override
  _BusDriverGameState createState() => _BusDriverGameState();

  BusDriverGame({this.players, this.numberOfRounds});
}

class _BusDriverGameState extends State<BusDriverGame> with CardGame {
  final String suitsFlag = "img/suits/";

  int roundsRemaining;
  String firstCard = "";
  String secondCard = "";
  bool isRight = false;

  // 0 = red or black, 1=higher or lower, 2=in between or outside 3 = exact color 4=everything right
  int state = 0;

  @override
  void initState() {
    super.initState();
    roundsRemaining = widget.numberOfRounds;
    players = widget.players;
    initCards();
  }

  @override
  Widget build(BuildContext context) {
    setOpacity();
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("img/backgroundMountains.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text(printNumberOfRounds()),
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 1.2,
            child: SafeArea(
              bottom: false,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  fullScreen(),
                  buildCardAnimation(),
                  buildShotCounter(),
                  Positioned(
                    top: cardHeight + cardPaddingTop + 20,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildBusDriverButton(true),
                              buildBusDriverButton(false),
                            ],
                          ),
                          state != 2
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          cardFlag + firstCard + ".png",
                                          width: 80,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          cardFlag + secondCard + ".png",
                                          width: 80,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  buildNextPlayersTurn(context, 0),
                  buildShots(context, 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String printNumberOfRounds() {
    if (widget.numberOfRounds < 0) {
      return ("Busfahrer");
    }
    if (roundsRemaining < 0) {
      int outputNumber = widget.numberOfRounds - roundsRemaining;
      return ("Nice! $outputNumber Runden durch!");
    }
    if (roundsRemaining == 0) {
      return ("Stark! Geschafft!");
    }
    if (roundsRemaining == 1) {
      return ("Letzte Runde!");
    }
    return ("Noch $roundsRemaining Runden");
  }

  void onPressedState3() {
    animationColor = isRight ? Colors.green : Colors.red;
    if (!isRight) {
      makeDrinksVisible();
    } else {
      if (players != null) {
        setState(() {
          playerIndex = (playerIndex + 1) % players.length;
        });
      }
    }

    nextCard();
    nextState();
    opacityAfterNextCard();
  }

  Widget buildBusDriverButton(bool leftButton) {
    if (state == 3) {
      if (leftButton) {
        return Container();
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Image.asset(
                    suitsFlag + "clubs.png",
                  ),
                  iconSize: 60,
                  onPressed: () {
                    if (!somebodyHasToDrink) {
                      isRight = nextCardIsClubs() ? true : false;
                      onPressedState3();
                    }
                  }),
              IconButton(
                  icon: Image.asset(
                    suitsFlag + "hearts.png",
                  ),
                  iconSize: 60,
                  onPressed: () {
                    if (!somebodyHasToDrink) {
                      isRight = nextCardIsHeart() ? true : false;
                      onPressedState3();
                    }
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Image.asset(
                    suitsFlag + "diamonds.png",
                  ),
                  iconSize: 60,
                  onPressed: () {
                    if (!somebodyHasToDrink) {
                      isRight = nextCardIsDiamond() ? true : false;
                      onPressedState3();
                    }
                  }),
              IconButton(
                  icon: Image.asset(
                    suitsFlag + "spades.png",
                  ),
                  iconSize: 60,
                  onPressed: () {
                    if (!somebodyHasToDrink) {
                      isRight = nextCardIsSpades() ? true : false;
                      onPressedState3();
                    }
                  }),
            ],
          )
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextButton(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 35, color: Colors.black),
          side: BorderSide(color: Colors.black, width: 2),
        ),
        onPressed: () {
          if (showBackground) {
            showBackground = false;
          }
          if (!somebodyHasToDrink) {
            if (evaluateCorrectClick(leftButton)) {
              isRight = true;
              animationColor = Colors.green;
            } else {
              animationColor = Colors.red;
              makeDrinksVisible();
            }

            nextCard();
            nextState();
            opacityAfterNextCard();
          }
        },
        child: evaluateText(leftButton),
      ),
    );
  }

  bool evaluateCorrectClick(bool leftButton) {
    if (state == 0) {
      return (leftButton && !nextCardIsBlack() ||
          (!leftButton && nextCardIsBlack()));
    }
    if (state == 1) {
      return ((leftButton && nextCardIsHigher()) ||
          (!leftButton && nextCardIsLower()));
    }
    if (state == 2) {
      return ((leftButton && nextCardInBetween()) ||
          (!leftButton && nextCardOut()));
    }
    return false;
  }

  void makeDrinksVisible() {
    somebodyHasToDrink = true;
    for (int i = 0; i <= state; i++) {
      visibilities[i] = true;
      emptyDrinks[i] = false;
    }
  }

  Text evaluateText(bool leftButton) {
    if (leftButton) {
      if (state == 0) {
        return Text(
          "Rot",
          style: TextStyle(color: Colors.red),
        );
      }
      if (state == 1) {
        return Text(
          "Höher",
          style: TextStyle(fontSize: 39, color: Colors.black),
        );
      }
      if (state == 2) {
        return Text(
          "Dazwischen",
          style: TextStyle(fontSize: 30, color: Colors.black),
        );
      }
    }
    if (state == 0) {
      return Text(
        "Schwarz",
        style: TextStyle(color: Colors.black),
      );
    }
    if (state == 1) {
      return Text(
        "Tiefer",
        style: TextStyle(fontSize: 35, color: Colors.black),
      );
    }
    if (state == 2) {
      return Text("Außerhalb",
          style: TextStyle(fontSize: 30, color: Colors.black));
    }
    return Text("");
  }

  void nextState() {
    if (state < 3 && isRight) {
      if (state == 0) {
        firstCard = cards[cardIndex];
      }
      if (state == 1) {
        secondCard = cards[cardIndex];
      }
      setState(() {
        state++;
      });
    } else {
      setState(() {
        state = 0;
        if (isRight) {
          roundsRemaining--;
        }
      });
    }
    isRight = false;
    if (state == 2) {
      showNextPlayer = false;
    } else {
      showNextPlayer = true;
    }
  }
}
