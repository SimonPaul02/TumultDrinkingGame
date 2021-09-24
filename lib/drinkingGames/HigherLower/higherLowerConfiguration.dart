import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:tumult_trinkspiel/Configuration.dart';
import 'package:tumult_trinkspiel/configurationFacade.dart';
import '../../Configuration.dart';
import 'HigherLowerGame.dart';

class HigherLowerConfiguration extends StatefulWidget {
  @override
  _HigherLowerConfigurationState createState() =>
      _HigherLowerConfigurationState();
}

class _HigherLowerConfigurationState extends State<HigherLowerConfiguration> {
  @override
  Widget build(BuildContext context) {
    ConfigurationFacade configurationFacade = ConfigurationFacade();
    return Configuration(
      path: "/playerConfigurationSimple",
      title: "Higher-Lower",
      buildNumberOfCards: true,
      buildNumberOfRounds: false,
      configurationFacade: configurationFacade,
      gameCreation: new MaterialPageRoute(
        builder: (context) => HigherLowerGame(
            players: configurationFacade.players,
            numberOfCards: configurationFacade.numberOfCards),
      ),
    );
  }
}
