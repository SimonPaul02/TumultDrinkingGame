import 'package:flutter/material.dart';
import 'Player.dart';

// sources (August 2021): https://www.youtube.com/watch?v=DWVXBo5Z1pk&t=130s and
//https://medium.com/@agungsurya/create-a-simple-animated-floatingactionbutton-in-flutter-2d24f37cfbcc

class ShotCounter extends StatefulWidget {
  final String tooltip;
  List<Player> players;

  ShotCounter({this.tooltip, this.players});

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
  double _fabHeight = 56.0;
  final borderSize = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
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

  Widget add() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        onPressed: null,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget toggle() {
    return Container(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        heroTag: null,
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  Padding buildPlayerButton(Player player, int factor) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Transform(
        transform: transform(factor),
        child: Container(
          width: borderSize,
          height: borderSize,
          child: Stack(
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return SweepGradient(
                          startAngle: 0.0,
                          endAngle: TWO_PI,
                          stops: [0.9, 0.95],
                          // start percentage,
                          // 0.0 , 0.5 , 0.5 , 1.0
                          center: Alignment.center,
                          colors: [Colors.white, Colors.transparent])
                      .createShader(rect);
                },
                child: Container(
                  width: borderSize,
                  height: borderSize,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
              Center(
                  child: ElevatedButton(
                onPressed: () {
                  print("ffffffffffffff");
                },
                child: Text(
                  player.currentShots.toString(),
                  style: TextStyle(color: Colors.purple),
                ),
                style: TextButton.styleFrom(
                    //  backgroundColor: Colors.green,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(14)),
              )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.players == null
        ? Column()
        : SingleChildScrollView(
            padding: buildTogglePadding(),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                if (widget.players != null && isOpened)
                  for (int i = widget.players.length; i > 0; i--)
                    //buildPlayerButton(widget.players[i - 1], i),
                    buildButtonWithText(widget.players[i - 1], i),
                SizedBox(
                  height: 25,
                ),
                toggle(), // factor 0
              ],
            ),
          );
  }

  Row buildButtonWithText(Player player, int factor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Transform(
          transform: transform(factor),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 12, 0),
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
        ),
        //Container(color: Colors.orange, width: 50, height: 20,),
        buildPlayerButton(player, factor)
      ],
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
}
