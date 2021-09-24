import 'package:flutter/material.dart';
import 'package:tumult_trinkspiel/drinkingGames/BusDriver/busDriverGame.dart';

import '../../Configuration.dart';
import '../../configurationFacade.dart';

class BusDriverConfiguration extends StatefulWidget {
  @override
  _BusDriverConfigurationState createState() => _BusDriverConfigurationState();
}

class _BusDriverConfigurationState extends State<BusDriverConfiguration> {
  @override
  Widget build(BuildContext context) {
    ConfigurationFacade configurationFacade = ConfigurationFacade();
    return Configuration(
      path: "/playerConfigurationSimple",
      title: "Busfahrer",
      buildNumberOfCards: false,
      buildNumberOfRounds: true,
      configurationFacade: configurationFacade,
      gameCreation: new MaterialPageRoute(
        builder: (context) => BusDriverGame(
            players: configurationFacade.players,
            numberOfRounds: configurationFacade.numberOfRounds),
      ),
    );
  }
}
