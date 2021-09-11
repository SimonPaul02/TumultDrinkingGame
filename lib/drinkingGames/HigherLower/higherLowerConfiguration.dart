import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:tumult_trinkspiel/drinkingGames/HigherLower/HigherLowerGame.dart';
import '../../Player.dart';
import 'HigherLowerGame.dart';
import 'package:tumult_trinkspiel/playerConfiguration.dart';

class HigherLowerConfiguration extends StatefulWidget {
  @override
  _HigherLowerConfigurationState createState() =>
      _HigherLowerConfigurationState();
}

class _HigherLowerConfigurationState extends State<HigherLowerConfiguration> {
  int numberOfPlayers = -1;
  int numberOfCards = -2;
  Color continueButtonColor = Colors.grey;
  bool shotCounter = false;

  @override
  Widget build(BuildContext context) {
    if (numberOfPlayers > 0 && numberOfCards > 0) {
      setState(() {
        continueButtonColor = Colors.green;
      });
    } else {
      continueButtonColor = Colors.grey;
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
            title: Text("Higher-Lower Konfiguration"),
            centerTitle: true,
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTextFormField("Anzahl Spieler:", numberOfPlayers),
                  buildTextFormField("Kartenziel:", numberOfCards),
                  buildShoutcounterCheckbox(),
                  Checkbox(
                    focusColor: Colors.blue,
                    value: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(85.0, 20, 85.0, 10.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (continueButtonColor == Colors.green) {
                          if (shotCounter) {
                            var players = await Navigator.pushNamed(
                                context, "/playerConfigurationSimple");
                            if (players != null) {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => HigherLowerGame(
                                          players: players,
                                          numberOfCards: numberOfCards)));
                            }
                          } else {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => HigherLowerGame(
                                        players: null,
                                        numberOfCards: numberOfCards)));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: continueButtonColor),
                      child: buildText("Weiter"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(85.0, 0, 85.0, 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => HigherLowerGame(
                                    players: null, numberOfCards: -1)));
                      },
                      child: buildText("Überspringen"),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Padding buildTextFormField(String text, int objectCounter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 85.0, vertical: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 17.0, horizontal: 20.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.white)),
          fillColor: Colors.black38,
          filled: true,
          labelText: text,
          labelStyle: TextStyle(color: Colors.white),
          hintText: buildHintText(objectCounter),
          hintStyle: TextStyle(color: Colors.lightBlueAccent, fontSize: 15),
        ),
        cursorColor: Colors.blue,
        onChanged: (number) {
          if (number == "") {
            setState(() {
              if (objectCounter == numberOfPlayers) {
                numberOfPlayers = -1;
              } else {
                numberOfCards = -2;
              }
            });
          } else {
            setState(() {
              if (objectCounter == numberOfPlayers) {
                numberOfPlayers = int.parse(number);
              } else if (objectCounter == numberOfCards) {
                numberOfCards = int.parse(number);
              }
            });
          }
        },
      ),
    );
  }

  String buildHintText(int objectCounter) {
    if (objectCounter == numberOfCards) {
      if (numberOfPlayers > 0) {
        int recommendation = 10 + numberOfPlayers * 15;
        return ("Empfehlung: " + recommendation.toString());
      }
      return ("Empfehlung: 20 pro Spieler");
    }
    if (objectCounter == numberOfPlayers) {
      return ("Für 2-10 Spieler empfohlen");
    }
    return "";
  }

  Text buildText(String text) => Text(text, style: TextStyle(fontSize: 20));

  Widget buildShoutcounterCheckbox() => Padding(
      padding: const EdgeInsets.fromLTRB(85, 10, 85, 0),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.black38,
          border: Border.all(
              color: Colors.white, // set border color
              width: 0.9), // set border width
          borderRadius: BorderRadius.all(
              Radius.circular(5.0)), // set rounded corner radius
        ),
        child: ListTile(
          onTap: () {
            setState(() {
              shotCounter = !shotCounter;
            });
          },
          onLongPress: () {},
          leading: Checkbox(
            value: shotCounter,
            fillColor: MaterialStateProperty.all(Colors.white),
            checkColor: Colors.blue,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (value) {
              setState(() {
                this.shotCounter = value;
              });
            },
          ),
          title: Text("Shotcounter",
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ));
}
