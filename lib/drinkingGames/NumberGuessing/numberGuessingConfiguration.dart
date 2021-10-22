import 'package:tumult_trinkspiel/configurationFacade.dart';
import 'package:flutter/material.dart';

import '../../Configuration.dart';
import 'numberGuessingGame.dart';


class NumberGuessingConfiguration extends StatefulWidget {

  @override
  _NumberGuessingConfigurationState createState() => _NumberGuessingConfigurationState();
}

class _NumberGuessingConfigurationState extends State<NumberGuessingConfiguration> {
  @override
  Widget build(BuildContext context) {
    ConfigurationFacade configurationFacade = ConfigurationFacade();
    return Configuration(
      configPath: "/playerConfigurationIcon",
      title: "Zahlen-Raten",
      buildNumberOfCards: false,
      buildNumberOfRounds: true,
      configurationFacade: configurationFacade,
      shotCounterMustBeActive: true,
      gameBuilder:
          (context) => NumberGuessingGame(
          players: configurationFacade.players,),

    );
  }

}
