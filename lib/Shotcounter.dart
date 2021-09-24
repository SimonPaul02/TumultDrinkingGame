import 'package:flutter/material.dart';
import 'Player.dart';

class ShotCounter extends StatefulWidget {
  final String tooltip = "Shoutcounter";
  final List<Player> players;

  ShotCounter({this.players});

  @override
  _ShotCounterState createState() => _ShotCounterState();
}

const TWO_PI = 3.14 * 2;

class _ShotCounterState extends State<ShotCounter>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;
  final _borderSize = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linearToEaseOut,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -10.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget toggle() {
    // sources (August 2021): https://www.youtube.com/watch?v=DWVXBo5Z1pk&t=130s and
//https://medium.com/@agungsurya/create-a-simple-animated-floatingactionbutton-in-flutter-2d24f37cfbcc
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: _buttonColor.value,
      onPressed: animate,
      tooltip: "Shotcounter",
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }

  Padding buildPlayerButton(Player player, int factor) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: _borderSize,
        height: _borderSize,
        child: Stack(
          children: [
            ShaderMask(
              shaderCallback: (rect) {
                return SweepGradient(
                        transform: GradientRotation(4.64),
                        startAngle: 0.00,
                        endAngle: TWO_PI,
                        stops: calculateStops(player),
                        center: Alignment.center,
                        colors: [calculateColor(player), Colors.transparent])
                    .createShader(rect);
              },
              child: Container(
                width: _borderSize,
                height: _borderSize,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
            ),
            Center(
                child: ElevatedButton(
              onPressed: () {
                setState(() {
                  player.currentShots++;
                });
              },
              onLongPress: () {
                setState(() {
                  if (player.currentShots > 0) {
                    player.currentShots--;
                  }
                });
              },
              child: Text(
                player.currentShots.toString(),
                style: TextStyle(
                    color: (player.currentShots < player.maxShots)
                        ? Colors.black
                        : Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  //
                  primary: (player.currentShots < player.maxShots)
                      ? Colors.blue
                      : Colors.blueGrey,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(14)),
            )),
          ],
        ),
      ),
    );
  }

  List<double> calculateStops(Player player) {
    player.calculatePercentage();
    return [player.shotPercentage, player.shotPercentage + 0.05];
  }

  @override
  Widget build(BuildContext context) {
    return widget.players == null
        ? Column()
        : SizedBox(
            height: MediaQuery.of(context).size.height,
            width: 400,
            child: ListView(
                shrinkWrap: false,
                reverse: true,
                padding: buildTogglePadding(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        height: 25,
                      ),
                      if (widget.players != null && isOpened)
                        for (int i = widget.players.length; i > 0; i--)
                          buildButtonWithText(widget.players[i - 1], i),
                      //buildButtonWithText(widget.players[i - 1], 0),
                      SizedBox(
                        height: 25,
                      ),
                      toggle(),
                      // factor 0
                    ],
                  ),
                ]),
          );
  }

  Widget buildButtonWithText(Player player, int factor) {
    return Transform(
      transform: transform(factor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
            child: RichText(
              text: TextSpan(
                text: player.name,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          //Container(color: Colors.orange, width: 50, height: 20,),
          buildPlayerButton(player, factor)
        ],
      ),
    );
  }

  EdgeInsets buildTogglePadding() {
    if (!isOpened) {
      return const EdgeInsets.only(bottom: 15);
    }
    return const EdgeInsets.fromLTRB(0, 100, 0, 15);
  }

  Matrix4 transform(int factor) {
    return Matrix4.translationValues(
      0.0,
      _translateButton.value * factor,
      0.0,
    );
  }

  Color calculateColor(Player player) {
    // shot percentage is already updated
    if (player.shotPercentage < 0.1) {
      return Colors.green;
    }
    if (player.shotPercentage < 0.2) {
      return Colors.lightGreenAccent;
    }
    if (player.shotPercentage < 0.3) {
      return Colors.lime;
    }
    if (player.shotPercentage < 0.4) {
      return Colors.yellowAccent;
    }
    if (player.shotPercentage < 0.55) {
      return Colors.amber;
    }
    if (player.shotPercentage < 0.7) {
      return Colors.orange;
    }
    if (player.shotPercentage < 0.85) {
      return Colors.deepOrange;
    }
    return Colors.red;
  }
}
