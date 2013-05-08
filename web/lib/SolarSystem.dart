library solarsystem;

import "PlanetaryBody.dart";
import 'dart:html';
import "Hex.dart";
import "GamePoint.dart";
import 'dart:math';

/**
 * A representation of the solar system.
 *
 * This class maintains a list of planetary bodies, knows how to draw its
 * background and the planets, and requests that it be redraw at appropriate
 * intervals using the [Window.requestAnimationFrame] method.
 */
class SolarSystem {
  CanvasElement canvas;

  num _width;
  num _height;
  HexField hex = new HexField(10, 20, 30);

  PlanetaryBody sun;

  num renderTime;

  SolarSystem(this.canvas) {

  }

  num get width => _width;

  num get height => _height;

  start() {
    // Measure the canvas element.
    window.setImmediate(() {
      _width = (canvas.parent as Element).client.width;
      _height = (canvas.parent as Element).client.height;

      canvas.width = _width;


      // Set Events
      _events();
      
      // Initialize the planets and start the simulation.
      _start();
    });
  }

  _events() {
    
    canvas.onClick.listen((e) => _onclick(e));
    
  }
  

  
  _getCanvasCoordinates(e){
    num x =  e.clientX - canvas.getBoundingClientRect().left;
    num y = e.clientY - canvas.getBoundingClientRect().top;
    var coords = new GamePoint(x, y);
    return coords;
  }
  
  
  _onclick(e) {
    var coords = _getCanvasCoordinates(e);
    Hex h = hex.clickedHex(coords.x, coords.y);
    query("#log").text = "Canvas Clicked. " + h.row.toString() + ", " + h.col.toString();
    
    hex.set_area(h.row, h.col);
    
    requestRedraw();
  }
  
  _showFps(num fps) {
    num fpsAverage;
    if (fpsAverage == null) {
      fpsAverage = fps;
    }

    fpsAverage = fps * 0.05 + fpsAverage * 0.95;

    query("#notes").text = "${fpsAverage.round().toInt()} fps";
  }  
  
  _start() {
    // Create the Sun.
    sun = new PlanetaryBody(this, "Sun", "#ff2", 14.0);

    // Add planets.
    sun.addPlanet(
        new PlanetaryBody(this, "Mercury", "orange", 0.382, 0.387, 0.241));
    sun.addPlanet(
        new PlanetaryBody(this, "Venus", "green", 0.949, 0.723, 0.615));

    var earth = new PlanetaryBody(this, "Earth", "#33f", 1.0, 1.0, 1.0);
    sun.addPlanet(earth);
    earth.addPlanet(new PlanetaryBody(this, "Moon", "gray", 0.2, 0.14, 0.075));

    sun.addPlanet(new PlanetaryBody(this, "Mars", "red", 0.532, 1.524, 1.88));

    addAsteroidBelt(sun, 150);

    final f = 0.1;
    final h = 1 / 1500.0;
    final g = 1 / 72.0;

  
    var jupiter = new PlanetaryBody(
        this, "Jupiter", "gray", 4.0, 5.203, 11.86);
    sun.addPlanet(jupiter);
    jupiter.addPlanet(new PlanetaryBody(
        this, "Io", "gray", 3.6 * f, 421 * h, 1.769 * g));
    jupiter.addPlanet(new PlanetaryBody(
        this, "Europa", "gray", 3.1 * f, 671 * h, 3.551 * g));
    jupiter.addPlanet(new PlanetaryBody(
        this, "Ganymede", "gray", 5.3 * f, 1070 * h, 7.154 * g));
    jupiter.addPlanet(new PlanetaryBody(
        this, "Callisto", "gray", 4.8 * f, 1882 * h, 16.689 * g));

    // Start the animation loop.
    requestRedraw();
  }

  void draw(num _) {
    num time = new DateTime.now().millisecondsSinceEpoch;

    if (renderTime != null) {
      _showFps((1000 / (time - renderTime)).round());
    }

    renderTime = time;

    var context = canvas.context2D;

    drawBackground(context);
    drawPlanets(context);
    
    hex.draw(context);
    
    //requestRedraw();
  }

  void drawBackground(CanvasRenderingContext2D context) {
    context.clearRect(0, 0, width, height);
  }

  void drawPlanets(CanvasRenderingContext2D context) {
    sun.draw(context, width / 2, height / 2);
  }

  void requestRedraw() {
    window.requestAnimationFrame(draw);
  }

  void addAsteroidBelt(PlanetaryBody body, int count) {
    Random random = new Random();

    // Asteroids are generally between 2.06 and 3.27 AUs.
    for (int i = 0; i < count; i++) {
      var radius = 2.06 + random.nextDouble() * (3.27 - 2.06);

      body.addPlanet(
          new PlanetaryBody(this, "asteroid", "#777",
              0.1 * random.nextDouble(),
              radius,
              radius * 2));
    }
  }

  num normalizeOrbitRadius(num r) {
    return r * (width / 10.0);
  }

  num normalizePlanetSize(num r) {
    return log(r + 1) * (width / 100.0);
  }
}

