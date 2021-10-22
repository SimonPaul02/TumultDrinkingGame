import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Player.dart';
import 'package:tumult_trinkspiel/drinkingGames/drinkingGame.dart';

class NumberGuessingGame extends StatefulWidget {
  final List<Player> players;

  @override
  _NumberGuessingGameState createState() => _NumberGuessingGameState();

  NumberGuessingGame({this.players});
}

class _NumberGuessingGameState extends State<NumberGuessingGame>
    with DrinkingGame {
  int guessEndNumber = 100;
  int startPlayerIndex = 0;
  final _controller = TextEditingController();
  List<Player> winnerList = [];
  List<Player> loserList = [];
  bool displayShots = false;
  bool shotVisible = false;
  String title = "Zahlen raten";

  @override
  void initState() {
    super.initState();
    differentSpacing = 0;
    players = widget.players;
    showBackground = false;
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
          title: Text(title),
          centerTitle: true,
        ),
        backgroundColor: Colors.black12,
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              fullScreen(),
              Positioned(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: buildNumber(),
                ),
                top: (displayShots) ? 400 : 50,
              ),
              buildShotCounter(),
              Positioned(
                child: Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            guessEndNumber = (guessEndNumber * 10) % 10000;
                            if (guessEndNumber == 0) {
                              guessEndNumber = 10;
                            }
                            randomNumber = 0;
                          });
                        },
                        child: Text(
                          "Von 1 - $guessEndNumber",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                top: 5,
                left: 5,
              ),
              Visibility(
                visible: displayShots,
                child: Positioned(
                  top: 70,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: buildWinnerAndLoser(),
                  ),
                ),
              ),
              Visibility(
                visible: !displayShots,
                child: Positioned(
                  top: 260,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.blue.shade400,
                        Colors.blue.shade700,
                        Colors.blue.shade600
                      ]),
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          randomNumber = 1 + random.nextInt(guessEndNumber);
                        });
                      },
                      child: Text(
                          (players == null) ? "Weiter" : "Weiter ohne Eingabe",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: players == null ? 33 : 23)),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !displayShots,
                child: Positioned(
                  top: 390,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: (players == null)
                        ? Container()
                        : buildTextFormField("Deine Schätzung " +
                            players[playerIndex].name.toString()),
                  ),
                ),
              ),
              Positioned(top: 160, child: buildLoserShot()),
            ],
          ),
        ),
      ),
    );
  }

  buildNumber() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(70, 30, 70, 0),
      child: ClipOval(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0), //width of the border
            child: ClipOval(
              child: Container(
                height: 110,
                child: Text(
                  randomNumber.toString(),
                  style: TextStyle(
                    fontSize: 100.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.blue.shade900,
              Colors.lightBlueAccent,
              Colors.blue.shade800
            ]),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(String text) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: new SizedBox(height: 60, child: players[playerIndex].icon),
            ),
          ),
          Flexible(
            child: TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.white)),
                fillColor: Colors.black38,
                filled: true,
                labelText: text,
                labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                hintText: "Zwischen 1 und $guessEndNumber",
                hintStyle:
                    TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
              ),
              cursorColor: Colors.blue,
              onFieldSubmitted: (number) {
                players[playerIndex].guessNumber = int.parse(number);
                setState(() {
                  playerIndex = ((playerIndex + 1) % players.length);
                  if (everyoneHasSubmitted()) {
                    evaluateWinnerAndLoser();
                    title = (winnerList.length == 1)
                        ? "Der Gewinner verteilt"
                        : "Die Gewinner verteilen";
                    displayShots = true;
                    for (Player player in loserList) {
                      print("Loser " + player.name);
                    }
                    for (Player player in winnerList) {
                      print("Winner " + player.name);
                    }
                    startPlayerIndex = (startPlayerIndex + 1) % players.length;
                    playerIndex = startPlayerIndex;
                    randomNumber = 1 + random.nextInt(guessEndNumber);
                  }
                });
                _controller.clear();
              },
            ),
          ),
        ]));
  }

  bool everyoneHasSubmitted() {
    return playerIndex == startPlayerIndex;
  }

  void evaluateWinnerAndLoser() {
    winnerList.clear();
    loserList.clear();
    int winningDifference = guessEndNumber;
    int losingDifference = 0;

    for (Player player in players) {
      int difference = calculateDifference(player);
      if (difference < winningDifference) {
        winnerList = [player];
        winningDifference = difference;
      } else if (difference == winningDifference) {
        winnerList.add(player);
      }
      if (difference > losingDifference) {
        loserList = [player];
        losingDifference = difference;
      } else if (difference == losingDifference) {
        loserList.add(player);
      }
    }
  }

  int calculateDifference(Player player) {
    return (player.guessNumber - randomNumber).abs();
  }

  displayPlayer(Player player) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            player.currentShots++;
            winnerList.removeAt(0);
          });
        },
        child: Column(
          children: [
            Container(width: 100, height: 100, child: player.icon),
            Text(
              player.name,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  backgroundColor: Colors.black54),
            )
          ],
        ),
      ),
    );
  }

  buildWinnerAndLoser() {
    if (winnerList.isNotEmpty) {
      for (Player player in winnerList) {
        return buildWinner(player);
      }
    } else {
      shotVisible = true;
      if (displayShots) {
        setState(() {
          title = (loserList.length == 1)
              ? "Der Verlierer trinkt"
              : "Die Verlierer trinken";
        });
      }
      return buildLoser();
    }
  }

  Widget buildWinner(Player player) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade600,
                      Colors.green.shade800,
                      Colors.green.shade600,
                      Colors.green.shade800,
                      Colors.green.shade600,
                    ],
                  ),
                ),
                child: Text(
                  player.name + ", verteile einen Shot",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      backgroundColor: Colors.black54),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [for (Player player in players) displayPlayer(player)],
          ),
        )
      ],
    );
  }

  Widget buildLoser() {
    if (loserList.isEmpty) {
      return Container();
    }
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red.shade300,
              Colors.red.shade600,
              Colors.red.shade300,
              Colors.red.shade900
            ],
          ),
        ),
        child: Text(
          loserList[0].name + ", du musst bechern!",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildLoserShot() {
    if (winnerList.isNotEmpty || loserList.isEmpty) {
      return Container();
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Visibility(
        visible: shotVisible,
        child: IconButton(
          icon: selectFullGlass(random.nextInt(3)),
          iconSize: 220,
          onPressed: () {
            setState(() {
              loserList[0].currentShots++;
              shotVisible = false;
              loserList.removeAt(0);
              if (loserList.isEmpty && winnerList.isEmpty) {
                setState(() {
                  displayShots = false;
                  title = "Neue Runde";
                  Future.delayed(const Duration(milliseconds: 100), () {
                    title = "Zahlen eingeben";
                  });
                });
              }
            });
          },
        ),
      ),
    );
  }
}
