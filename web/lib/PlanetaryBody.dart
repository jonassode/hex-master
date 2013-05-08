library planetarybody;

import "SolarSystem.dart";
import 'dart:html';
import 'dart:math';

/**
 * A representation of a plantetary body.
 *
 * This class can calculate its position for a given time index, and draw itself
 * and any child planets.
 */
class PlanetaryBody {
  final String name;
  final String color;
  final num orbitPeriod;
  final SolarSystem solarSystem;

  num bodySize;
  num orbitRadius;
  num orbitSpeed;

  List<PlanetaryBody> planets;

  PlanetaryBody(this.solarSystem, this.name, this.color, this.bodySize,
      [this.orbitRadius = 0.0, this.orbitPeriod = 0.0]) {
    planets = [];

    bodySize = solarSystem.normalizePlanetSize(bodySize);
    orbitRadius = solarSystem.normalizeOrbitRadius(orbitRadius);
    orbitSpeed = _calculateSpeed(orbitPeriod);
  }

  void addPlanet(PlanetaryBody planet) {
    planets.add(planet);
  }

  void draw(CanvasRenderingContext2D context, num x, num y) {
    Point pos = _calculatePos(x, y);

    drawSelf(context, pos.x, pos.y);

    drawChildren(context, pos.x, pos.y);
  }

  void drawSelf(CanvasRenderingContext2D context, num x, num y) {
    // Check for clipping.
    if (x + bodySize < 0 || x - bodySize >= context.canvas.width) {
      return;
    }

    if (y + bodySize < 0 || y - bodySize >= context.canvas.height) {
      return;
    }

    // Draw the figure.
    context.lineWidth = 0.5;
    context.fillStyle = color;
    context.strokeStyle = color;

    if (bodySize >= 2.0) {
      context.shadowOffsetX = 2;
      context.shadowOffsetY = 2;
      context.shadowBlur = 2;
      context.shadowColor = "#ddd";
    }

    context.beginPath();
    context.arc(x, y, bodySize, 0, PI * 2, false);
    context.fill();
    context.closePath();

    context.shadowOffsetX = 0;
    context.shadowOffsetY = 0;
    context.shadowBlur = 0;

    context.beginPath();
    context.arc(x, y, bodySize, 0, PI * 2, false);
    context.fill();
    context.closePath();
    context.stroke();
  }

  void drawChildren(CanvasRenderingContext2D context, num x, num y) {
    for (var planet in planets) {
      planet.draw(context, x, y);
    }
  }

  num _calculateSpeed(num period) {
    if (period == 0.0) {
      return 0.0;
    } else {
      return 1 / (60.0 * 24.0 * 2 * period);
    }
  }

  Point _calculatePos(num x, num y) {
    if (orbitSpeed == 0.0) {
      return new Point(x, y);
    } else {
      num angle = solarSystem.renderTime * orbitSpeed;

      return new Point(
        orbitRadius * cos(angle) + x,
        orbitRadius * sin(angle) + y);
    }
  }

}

