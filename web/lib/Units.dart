// Copyright (c) 2013 Olof and Jonas


library units;

class Unit {
  String name;
  String sign;
  num attack;
  num defense;
  num range;
  num movement;
  
  Unit(name, sign, attack, defense, range, movement){
    this.name = name;
    this.sign = sign;
    this.attack = attack;
    this.defense = defense;
    this.range = range;
    this.movement = movement;

  }
  
  String get_sign(){
    return this.sign;
  }
}
