import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'util.dart';

const crabSubmarineWidth = 127.5;
const crabSubmarineHeight = 75;

late CanvasElement canvas;
late CanvasRenderingContext2D ctx;

late int width;
late int height;

late double optimalX;
late int amountOfCrabSubmarines;
late List<Point<double>> crabSubmarinePositions;

late double xScale;
late double yScale;

final whaleImage = ImageElement(src: getWhaleImageUrl());
final submarineImage = ImageElement(src: getSubmarineImageUrl());
final crabSubmarineImage = ImageElement(src: getCrabSubmarineImageUrl());

void main() async {
  width = window.innerWidth!;
  height = window.innerHeight!;

  canvas = querySelector('#canvas') as CanvasElement
    ..width = width
    ..height = height
    ..focus();

  ctx = canvas.getContext('2d') as CanvasRenderingContext2D;

  final horizontalPositions = await getHorizontalPositions();

  final leftMostCrabPosition = horizontalPositions.reduce(min);
  final rightMostCrabPosition = horizontalPositions.reduce(max);

  final deltaBetweenCrabExtremes = rightMostCrabPosition - leftMostCrabPosition;

  xScale = (width - crabSubmarineWidth) /
      (deltaBetweenCrabExtremes * crabSubmarineWidth);
  yScale = (height * .95) / (horizontalPositions.length * crabSubmarineHeight);

  final positionsToCheck = [
    for (var i = leftMostCrabPosition; i < rightMostCrabPosition; i += 1) i
  ];

  final positionWithLeastAmountOfFuelNeeded = positionsToCheck
      .map((position) => PositionAndFuelNeeded(
          position,
          calculateFuelUsageForPositionAtIncreasingRate(
              horizontalPositions, position)))
      .reduce((e1, e2) => e1.fuelNeeded < e2.fuelNeeded ? e1 : e2)
      .position;

  optimalX = (positionWithLeastAmountOfFuelNeeded - leftMostCrabPosition) *
      crabSubmarineWidth *
      xScale;

  crabSubmarinePositions = horizontalPositions
      .asMap()
      .entries
      .map((entry) => Point(
          (entry.value - leftMostCrabPosition) * crabSubmarineWidth * xScale,
          entry.key * crabSubmarineHeight * yScale))
      .toList();

  Game().run();
}

class FleeingCrabSubmarine {
  final int speedX;
  final int speedY;
  final Point destination;

  FleeingCrabSubmarine(this.speedX, this.speedY, this.destination);
}

class Game {
  var threshold = width / 4;

  bool crabsInPosition = false;
  bool crabsFleeing = false;
  int crabAttackState = 0;

  final attackTravelDuration = 250;
  final attackBombDuration = 10;

  Point submarine = Point(50, height / 4 * 3);
  bool submarineGoingDown = false;

  late List<FleeingCrabSubmarine> fleeingCrabSubmarines;
  late Point bombLocation;

  bool shouldDrawWhale = false;
  Point whalePosition = Point(width, height / 2);

  Future run() async {
    update(await window.animationFrame);
  }

  void update(num delta) {
    drawBackground();

    drawCrabSubmarines();

    if (!crabsInPosition) {
      updateCrabSubmarines();
    } else if (crabsFleeing) {
      updateSubmarine();
      updateCrabSubmarinesFleeing();
    }

    if (crabsInPosition) {
      crabAttackState += 1;
      drawCrabAttack();
      if (crabAttackState >= attackTravelDuration + attackBombDuration) {
        drawCrabSubmarines();
      }
    }

    drawSubmarine();

    if (shouldDrawWhale) {
      drawWhale();
      updateWhale();
    }

    run();
  }

  void drawBackground() {
    final gradient = ctx.createLinearGradient(0, 0, 0, height)
      ..addColorStop(0, '#3b89ac')
      ..addColorStop(0.2, '#22646e')
      ..addColorStop(0.5, '#003851')
      ..addColorStop(0.7, '#002535')
      ..addColorStop(0.9, '#010e1f')
      ..addColorStop(0.95, '#42281c');

    ctx
      ..fillStyle = gradient
      ..fillRect(0, 0, width, height);
  }

  void drawSubmarine() {
    const submarineWidth = 115;
    const submarineHeight = 112;
    ctx.drawImageScaled(submarineImage, submarine.x - submarineWidth / 2, submarine.y - submarineHeight / 2,
        submarineWidth, submarineHeight);
  }

  void drawWhale() {
    ctx.drawImage(whaleImage, whalePosition.x, whalePosition.y);
  }

  void updateWhale() {
    whalePosition = Point(whalePosition.x - 1, whalePosition.y);
  }

  void drawCrabSubmarines() {
    for (var point in crabSubmarinePositions) {
      final delta = (optimalX - point.x).abs();
      if (delta > threshold) {
        final x = point.x - crabSubmarineWidth / 2;
        final y = point.y - crabSubmarineHeight / 2;
        ctx.drawImageScaled(
            crabSubmarineImage, x, y, crabSubmarineWidth, crabSubmarineHeight);
      } else {
        final stepX = ((1 / xScale) - 1) / threshold;
        final stepY = ((1 / yScale) - 1) / threshold;

        final scaledWidth = crabSubmarineWidth * xScale * (1 + stepX * delta);
        final scaledHeight = crabSubmarineHeight * yScale * (1 + stepY * delta);

        final width = max(scaledWidth, 3.4);
        final height = max(scaledHeight, 2);

        final x = point.x - width / 2;
        final y = point.y - height / 2;

        ctx.drawImageScaled(crabSubmarineImage, x, y, width, height);
      }
    }
  }

  void updateCrabSubmarines() {
    const speed = 3;
    bool allCrabsReady = true;

    for (var i = 0; i < crabSubmarinePositions.length; i++) {
      final point = crabSubmarinePositions[i];
      if (point.x != optimalX) {
        allCrabsReady = false;

        final delta = optimalX - point.x;
        final newX = delta.abs() <= speed
            ? optimalX
            : point.x + (delta / delta.abs()) * speed;
        crabSubmarinePositions[i] = Point(newX, point.y);
      }
    }

    if (allCrabsReady) {
      bombLocation =
          Point(crabSubmarinePositions.last.x, crabSubmarinePositions.last.y);
      crabsInPosition = true;
    }
  }

  void updateSubmarine() {
    final speed = 3;

    if (!submarineGoingDown) {
      final destinationX = bombLocation.x;

      final deltaX = destinationX - submarine.x;

      if (deltaX == 0) {
        submarineGoingDown = true;
      } else {
        final num newX = deltaX.abs() <= speed
            ? bombLocation.x
            : submarine.x + (deltaX / deltaX.abs()) * speed;
        submarine = Point(newX.toDouble(), submarine.y);
      }
    } else {
      submarine = Point(submarine.x, submarine.y + speed);
      if (submarine.y > height * 1.3) {
        shouldDrawWhale = true;
      }
    }
  }

  void updateCrabSubmarinesFleeing() {
    for (var i = 0; i < crabSubmarinePositions.length; i++) {
      final point = crabSubmarinePositions[i];
      final fleeingCrabSubmarine = fleeingCrabSubmarines[i];
      final destination = fleeingCrabSubmarine.destination;
      final speedX = fleeingCrabSubmarine.speedX;
      final speedY = fleeingCrabSubmarine.speedY;

      final deltaX = destination.x - point.x;
      final deltaY = destination.y - point.y;

      if (deltaX != 0 || deltaY != 0) {
        final num newX = deltaX.abs() <= speedX
            ? destination.x
            : point.x + (deltaX / deltaX.abs()) * speedX;
        final num newY = deltaY.abs() <= speedY
            ? destination.y
            : point.y + (deltaY / deltaY.abs() * speedY);
        crabSubmarinePositions[i] = Point(newX.toDouble(), newY.toDouble());
      }
    }
  }

  void drawCrabAttack() {
    const beamBase = 2;
    const beamGrowth = 25;

    final amountOfCrabs = crabSubmarinePositions.length;

    final crabsStep = amountOfCrabs / attackTravelDuration;

    if (crabAttackState < attackTravelDuration) {
      for (var entry in crabSubmarinePositions
          .take((crabsStep * crabAttackState).toInt())
          .toList()
          .asMap()
          .entries) {
        final x = entry.value.x;
        final y = entry.value.y;
        final index = entry.key;

        final gradient = ctx.createRadialGradient(
            x, y, beamGrowth / 2, x, y, beamGrowth / 10)
          ..addColorStop(0.2, '#ff000055')
          ..addColorStop(0.3, '#ff5a0044')
          ..addColorStop(0.5, '#ff9a0033')
          ..addColorStop(0.7, '#ffce0022')
          ..addColorStop(0.9, '#ffe80811');

        ctx.fillStyle = gradient;

        final step = beamGrowth / amountOfCrabs;

        ctx.beginPath();
        ctx.arc(x, y, beamBase + (step * index) / 2, 0, 2 * pi);
        ctx.fill();
      }
    } else if (crabAttackState < attackTravelDuration + attackBombDuration) {
      final x = bombLocation.x;
      final y = bombLocation.y;

      final startSize = beamBase + beamGrowth / 2 * 2;
      final endSize = 150;
      final deltaSize = endSize - startSize;

      final step = deltaSize / attackBombDuration;
      final size = startSize + step * (crabAttackState - attackTravelDuration);

      final gradient = ctx.createRadialGradient(x, y, 100, x, y, 0)
        ..addColorStop(0.6, '#ff0000ff')
        ..addColorStop(0.7, '#ff5a00aa')
        ..addColorStop(0.8, '#ff9a0088')
        ..addColorStop(0.9, '#ffce0066')
        ..addColorStop(1, '#ffe80844');

      ctx.fillStyle = gradient;
      ctx.beginPath();
      ctx.arc(x, y, size, 0, 2 * pi);
      ctx.fill();
    } else {
      final x = bombLocation.x;
      final y = bombLocation.y;

      final size = 150;

      final gradient = ctx.createLinearGradient(0, 0, 0, height)
        ..addColorStop(0, '#3b89ac')
        ..addColorStop(0.2, '#22646e')
        ..addColorStop(0.5, '#003851')
        ..addColorStop(0.7, '#002535')
        ..addColorStop(0.9, '#010e1f');

      ctx.fillStyle = gradient;
      ctx.beginPath();
      ctx.arc(x, y, size, 0, 2 * pi);
      ctx.fill();

      if (!crabsFleeing) {
        crabsFleeing = true;
        threshold = width.toDouble();
        fleeingCrabSubmarines = crabSubmarinePositions
            .map((p) => FleeingCrabSubmarine(
                Random().nextInt(5) + 5,
                Random().nextInt(5) + 3,
                Point(Random().nextInt(width), p.y - height)))
            .toList();
      }
    }
  }
}
