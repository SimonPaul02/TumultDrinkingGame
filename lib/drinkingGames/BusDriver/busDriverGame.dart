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

class _BusDriverGameState extends State<BusDriverGame> with CardGame{
  int roundsRemaining;

  @override
  void initState() {
    super.initState();
    roundsRemaining = widget.numberOfRounds;
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
              title: Text(printNumberOfRounds()),
              centerTitle: true,
            ),
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView()));
  }

  String printNumberOfRounds() {
    if (widget.numberOfRounds < 0) {
      return ("Busfahrer");
    }
    if (roundsRemaining == 0) {
      return ("Nice! Geschafft!");
    }
    if (roundsRemaining == 1) {
      return ("Letzte Runde!");
    }
    return ("Noch $roundsRemaining Runden");
  }
}
