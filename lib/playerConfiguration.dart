import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'Player.dart';
import 'Sex.dart';

class PlayerConfiguration extends StatefulWidget {
  final bool simplePlayer;
  final bool iconPlayer;

  PlayerConfiguration(this.simplePlayer, this.iconPlayer);

  @override
  _PlayerConfigurationState createState() => _PlayerConfigurationState();
}

class _PlayerConfigurationState extends State<PlayerConfiguration> {
  final String male = "male.png";
  final String female = "female.png";
  final String diverse = "diverse.png";
  List<TextEditingController> textEditingControllers;
  List<Sex> sexes;
  List<String> icons = ["owlDrunk"];
  int numberOfPlayers = 1;
  int numberOfTextFields;
  final Sex sex = Sex("");
  Color finishButtonColor;

  @override
  void initState() {
    super.initState();
    finishButtonColor = Colors.grey;

    if (widget.simplePlayer || widget.iconPlayer) {
      numberOfTextFields = 2;
    } else {
      numberOfTextFields = 3;
      sexes = [Sex(sex.male)];
    }
    textEditingControllers =
        List.generate(numberOfTextFields, (index) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("img/alcohol1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            title: Text("Spieler hinzufügen"),
            centerTitle: true,
          ),
          backgroundColor: Colors.black12,
          body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 100),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildAllPlayers(),
                    ]),
              )),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                  left: 35,
                  bottom: 25,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: finishButtonColor,
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: () {
                      if (finishButtonColor == Colors.grey) {
                        return;
                      }
                      List<Player> players = [];
                      if (widget.iconPlayer) {
                        for (int i = 0;
                            i < textEditingControllers.length;
                            i += numberOfTextFields) {
                          players.add(Player(
                              name: textEditingControllers[i].text,
                              maxShots:
                                  int.parse(textEditingControllers[i + 1].text),
                              icon: Image.asset("img/playerIcons/" +
                                  icons[i ~/ numberOfTextFields] +
                                  ".png")));
                        }
                      } else if (widget.simplePlayer) {
                        for (int i = 0;
                            i < textEditingControllers.length;
                            i += numberOfTextFields) {
                          players.add(Player(
                              name: textEditingControllers[i].text,
                              maxShots: int.parse(
                                  textEditingControllers[i + 1].text)));
                        }
                      } else {
                        for (int i = 0;
                            i < textEditingControllers.length;
                            i += numberOfTextFields) {
                          players.add(Player(
                              name: textEditingControllers[i].text,
                              age:
                                  int.parse(textEditingControllers[i + 1].text),
                              maxShots:
                                  int.parse(textEditingControllers[i + 2].text),
                              sex: sexes[i ~/ numberOfTextFields]));
                        }
                      }
                      Navigator.pop(context, players);
                    },
                    child: const Text('Fertig'),
                  )),

              Positioned(
                bottom: 25,
                right: 25,
                child: FloatingActionButton(
                  backgroundColor: Colors.lightBlue,
                  onPressed: () {
                    setState(() {
                      finishButtonColor = Colors.grey;
                      numberOfPlayers += 1;
                      for (int i = 0; i < numberOfTextFields; i++) {
                        textEditingControllers.add(TextEditingController());
                      }
                      if (!widget.simplePlayer && !widget.iconPlayer) {
                        sexes.add(Sex(sex.male));
                      }
                      if (widget.iconPlayer) {
                        icons.add("owlDrunk");
                      }
                    });
                  },
                  child: Icon(Icons.add, size: 40),
                ),
              ),
              // Add more floating buttons if you want
              // There is no limit
            ],
          ),
        ));
  }

  Column buildAllPlayers() {
    List<Padding> playerFields = [];
    for (int i = 0;
        i < textEditingControllers.length;
        i += numberOfTextFields) {
      playerFields.add(buildPlayerField(i));
    }
    return new Column(
      children: playerFields,
    );
  }

  Padding buildPlayerField(int i) {
    if (widget.iconPlayer) {
      return buildNewIconPlayerField(i);
    }
    if (widget.simplePlayer) {
      return buildNewSmallPlayerField(i);
    }
    return buildNewFullPlayerField(i);
  }

  Padding buildNewIconPlayerField(int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          buildGarbageCan(i),
          buildName(i),
          buildNumberField("Shots", i + 1),
          buildPlayerIcon(i ~/ numberOfTextFields),
        ],
      ),
    );
  }

  Padding buildNewFullPlayerField(int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          buildGarbageCan(i),
          buildName(i),
          buildNumberField("Alter", i + 1),
          buildNumberField("Shots", i + 2),
          buildSex(i ~/ numberOfTextFields), //toInt
        ],
      ),
    );
  }

  Padding buildNewSmallPlayerField(int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          buildGarbageCan(i),
          buildName(i),
          buildNumberField("Shots", i + 1),
        ],
      ),
    );
  }

  Flexible buildName(int i) {
    return Flexible(
      flex: 9,
      child: Padding(
        padding: buildPadding(),
        child: TextFormField(
          decoration: buildInputDecoration("Name"),
          style: buildTextStyle(),
          maxLength: 50,
          cursorColor: Colors.blue,
          onChanged: (context) {
            evaluateFinishButtonColor();
          },
          controller: textEditingControllers[i],
        ),
      ),
    );
  }

  Flexible buildNumberField(String text, int i) {
    return Flexible(
      flex: 6,
      child: Padding(
        padding: buildPadding(),
        child: TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          decoration: buildInputDecoration(text),
          style: buildTextStyle(),
          maxLength: 3,
          cursorColor: Colors.blue,
          onChanged: (number) {
            evaluateFinishButtonColor();
          },
          controller: textEditingControllers[i],
        ),
      ),
    );
  }

  Expanded buildSex(int i) {
    return Expanded(
      flex: 6,
      child: Padding(
        padding: buildPadding(),
        child: SizedBox(
          height: 70,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black38,
            ),
            child: IconButton(
              icon: Image.asset("img/sex/" + sexes[i].sex + ".png"),
              onPressed: () {
                setState(() {
                  switch (sexes[i].sex) {
                    case "male":
                      {
                        //sex.male not possible
                        sexes[i] = Sex(sex.female);
                      }
                      break;
                    case "female":
                      {
                        sexes[i] = Sex(sex.diverse);
                      }
                      break;

                    default:
                      {
                        sexes[i] = Sex(sex.male);
                      }
                      break;
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  buildPlayerIcon(int i) {
    return Expanded(
      flex: 6,
      child: Padding(
        padding: buildPadding(),
        child: SizedBox(
          height: 70,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black38,
            ),
            child: IconButton(
                icon: Image.asset("img/playerIcons/" + icons[i] + ".png"),
                onPressed: () {
                  setState(() {
                    switch (icons[i]) {
                      case "owlDrunk":
                        {
                          icons[i] = "penguDrunk";
                          break;
                        }
                      case "penguDrunk":
                        {
                          icons[i] = "rabbitDrunk";
                          break;
                        }
                      default:
                        {
                          icons[i] = "owlDrunk";
                          break;
                        }
                    }
                  });
                }),
          ),
        ),
      ),
    );
  }

  Expanded buildGarbageCan(i) {
    return Expanded(
      flex: 4,
      child: Padding(
        padding: buildPadding(),
        child: SizedBox(
          height: 70,
          child: Container(
            child: IconButton(
              icon: Image.asset("img/garbageBin.png"),
              onPressed: () {
                setState(() {
                  for (int j = 0; j < numberOfTextFields; j++) {
                    textEditingControllers.removeAt(i);
                  }
                  if (!widget.simplePlayer && !widget.iconPlayer) {
                    sexes.removeAt(i ~/ numberOfTextFields);
                  }
                  if (widget.iconPlayer) {
                    icons.removeAt(i ~/ numberOfTextFields);
                  }
                  numberOfPlayers--;
                  evaluateFinishButtonColor();
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration(String labelText) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.0),
      ),
      counterText: "",
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.white)),
      fillColor: Colors.black38,
      filled: true,
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.white),
    );
  }

  TextStyle buildTextStyle() {
    return TextStyle(color: Colors.white);
  }

  EdgeInsets buildPadding() => const EdgeInsets.fromLTRB(2, 20, 2, 0);

  bool checkAllTextFields() {
    for (TextEditingController controller in textEditingControllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  void evaluateFinishButtonColor() {
    if (checkAllTextFields()) {
      setState(() {
        finishButtonColor = Colors.green;
      });
    } else {
      setState(() {
        finishButtonColor = Colors.grey;
      });
    }
  }
}
