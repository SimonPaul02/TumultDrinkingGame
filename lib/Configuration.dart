import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tumult_trinkspiel/configurationFacade.dart';

class Configuration extends StatefulWidget {
  final String configPath;
  final String title;
  final bool buildNumberOfCards;
  final bool buildNumberOfRounds;
  final Function(BuildContext) gameBuilder;
  final ConfigurationFacade configurationFacade;

  Configuration(
      {this.configPath,
      this.title,
      this.buildNumberOfCards,
      this.buildNumberOfRounds,
      this.gameBuilder,
      this.configurationFacade});

  @override
  _ConfigurationState createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  int numberOfPlayers = -1;
  int numberOfCards = -2;
  int numberOfRounds = -3;
  Color continueButtonColor = Colors.grey;
  bool shotCounterActive = false;

  @override
  Widget build(BuildContext context) {
    if (allTextFieldsActive()) {
      setState(() {
        continueButtonColor = Colors.green;
      });
    } else {
      continueButtonColor = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("img/wine2.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            title: Text(widget.title),
            centerTitle: true,
          ),
          backgroundColor: Colors.black12,
          body: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTextFormField("Anzahl Spieler:", numberOfPlayers),
                  (widget.buildNumberOfCards)
                      ? buildTextFormField("Anzahl Karten:", numberOfCards)
                      : Container(),
                  (widget.buildNumberOfRounds)
                      ? (buildTextFormField("Anzahl Runden", numberOfRounds))
                      : Container(),
                  buildShoutCounterCheckbox(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(85.0, 20, 85.0, 10.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (continueButtonColor == Colors.green) {
                          if (shotCounterActive) {
                            var players = await Navigator.pushNamed(
                                context, widget.configPath);
                            widget.configurationFacade.players = players;
                            if (players == null) {
                              return;
                            }
                          }
                          widget.configurationFacade.numberOfPlayers =
                              numberOfPlayers;
                          widget.configurationFacade.numberOfCards =
                              numberOfCards;
                          widget.configurationFacade.numberOfRounds =
                              numberOfRounds;
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: widget.gameBuilder));
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
                        Navigator.of(context).push(
                            new MaterialPageRoute(builder: widget.gameBuilder));
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
              } else if (objectCounter == numberOfCards) {
                numberOfCards = -2;
              } else if (objectCounter == numberOfRounds) {
                numberOfRounds = -3;
              }
            });
          } else {
            setState(() {
              if (objectCounter == numberOfPlayers) {
                numberOfPlayers = int.parse(number);
              } else if (objectCounter == numberOfCards) {
                numberOfCards = int.parse(number);
              } else if (objectCounter == numberOfRounds) {
                numberOfRounds = int.parse(number);
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
        int cardRecommendation = 10 + numberOfPlayers * 15;
        return ("Empfehlung: " + cardRecommendation.toString());
      }
      return ("Empfehlung: 20 pro Spieler");
    }
    if (objectCounter == numberOfRounds) {
      if (numberOfPlayers > 0) {
        int roundsRecommendation = numberOfPlayers * 3;
        return ("Empfehlung: " + roundsRecommendation.toString());
      }
      return ("Empfehlung: 3 pro Spieler");
    }
    if (objectCounter == numberOfPlayers) {
      return ("Für 2-10 Spieler empfohlen");
    }

    return "";
  }

  Text buildText(String text) => Text(text, style: TextStyle(fontSize: 20));

  Widget buildShoutCounterCheckbox() => Padding(
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
              shotCounterActive = !shotCounterActive;
            });
          },
          onLongPress: () {},
          leading: Checkbox(
            value: shotCounterActive,
            fillColor: MaterialStateProperty.all(Colors.white),
            checkColor: Colors.blue,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (value) {
              setState(() {
                shotCounterActive = value;
              });
            },
          ),
          title: Text("Shotcounter",
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ));

  bool allTextFieldsActive() {
    if (widget.buildNumberOfRounds && numberOfRounds <= 0) {
      return false;
    }
    if (widget.buildNumberOfCards && numberOfCards <= 0) {
      return false;
    }
    return (numberOfPlayers > 0);
  }
}
