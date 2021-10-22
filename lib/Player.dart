import 'package:flutter/cupertino.dart';
import 'Sex.dart';

class Player {
  String name = "";
  int age = 0;
  int maxShots = 0 ;
  Image icon = Image.asset("img/penguin.png");
  Sex sex = Sex("");
  int currentShots = 0;
  double shotPercentage = 0.0;
  int guessNumber = 0;


  Player({this.name, this.age, this.maxShots, this.icon, this.sex});

  
  @override
  String toString() {
    return ("Name: $name  age: $age maxshots: $maxShots sex: $sex, Icon: $icon");
  }

  void calculatePercentage() {
    shotPercentage = currentShots / maxShots;
  }
  
}
