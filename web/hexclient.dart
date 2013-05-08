// Copyright (c) 2013 Olof and Jonas


library hexclient;

import "lib/SolarSystem.dart";
import "lib/PlanetaryBody.dart";
import "lib/Hex.dart";
import "lib/GamePoint.dart";
import 'dart:html';
import 'dart:math';
import 'package:js/js.dart' as js;

/**
 * The entry point to the application.
 */
void main() {
  var solarSystem = new SolarSystem(query("#container"));

  solarSystem.start();
}













