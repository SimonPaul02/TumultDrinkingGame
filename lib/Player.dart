import 'package:flutter/cupertino.dart';
import 'Sex.dart';

class Player {
  String name = "";
  int age = 0;
  int maxShots = 0 ;
  Image photo = Image.asset("img/penguin.png");
  Sex sex = Sex("");
  int currentShots = 0;
  double shotPercentage = 0.0;

  Player({this.name, this.age, this.maxShots, this.photo, this.sex});

  Image takePhoto() {
    // TODO: Add Take-Photo option
    return null;
  }
  
  @override
  String toString() {
    return ("Name: $name  age: $age maxshots: $maxShots sex: $sex ");
  }

  void calculatePercentage() {
    shotPercentage = currentShots / maxShots;
  }
  
}
