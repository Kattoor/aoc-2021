import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'util.dart';

const submarineWidth = 115;
const submarineHeight = 112;
const totalTime = 191100;

late int width;
late int height;

late num yScale;
late num xScale;

late num maxDepth;
late num maxWidth;

late CanvasElement canvas;
late CanvasRenderingContext2D ctx;

late List<Point> points;
late List<double> angles;
late List<double> distances;
late List<double> timeList;

late double totalDistanceToTravel;
late num timeScale;

final submarineImage = ImageElement(src: getImageUrl());

void main() async {
  final instructions = await getInstructions();

  points = instructions
      .fold<List<PointWithAim>>([PointWithAim(Point(0, 0), 0)],
          (list, instruction) {
        final previousPointWithAim = list.last;

        if (instruction.direction.isHorizontal) {
          final newPoint = list.last.point +
              Point(instruction.amount, list.last.aim * instruction.amount);
          list.add(PointWithAim(newPoint, previousPointWithAim.aim));
        } else {
          list.last = PointWithAim(
              previousPointWithAim.point,
              previousPointWithAim.aim +
                  instruction.direction.getAimAddition(instruction.amount));
        }

        return list;
      })
      .map((pointWithAim) => pointWithAim.point)
      .toList();

  distances = zipWithSelfSkip1(points)
      .toList()
      .map((points) => (points[1].x - points[0].x).toDouble())
      .toList();

  totalDistanceToTravel = distances.reduce((value, element) => value + element);
  timeScale = totalTime / totalDistanceToTravel;

  timeList = distances.map((distance) => distance * timeScale).toList();

  maxWidth = points.map((p) => p.x).reduce(max);
  maxDepth = points.map((p) => p.y).reduce(max);

  width = window.innerWidth!;
  height = window.innerHeight!;

  yScale = (height - 1) / maxDepth;
  xScale = (width - 1) / maxWidth;

  angles = zipWithSelfSkip1(points)
      .toList()
      .map((angles) =>
          atan2(angles[1].y * yScale - angles[0].y * yScale,
              angles[1].x * xScale - angles[0].x * xScale) *
          180 /
          pi)
      .toList();

  canvas = querySelector('#canvas') as CanvasElement
    ..width = width
    ..height = height
    ..focus();

  ctx = canvas.getContext('2d') as CanvasRenderingContext2D;

  Game().run();
}

void drawSea() {
  final gradient = ctx.createLinearGradient(0, 0, 0, height)
    ..addColorStop(0, '#3b89ac')
    ..addColorStop(0.2, '#22646e')
    ..addColorStop(0.5, '#003851')
    ..addColorStop(0.7, '#002535')
    ..addColorStop(0.9, '#010e1f');

  ctx
    ..fillStyle = gradient
    ..fillRect(0, 0, width, height);
}

void clear() {
  ctx
    ..fillStyle = "white"
    ..fillRect(0, 0, width, height);
}

class Game {
  Submarine submarine = Submarine();

  Future run() async {
    update(await window.animationFrame);
  }

  void update(num delta) {
    clear();
    drawSea();
    submarine.update(delta);
    run();
  }
}

class Submarine {
  Point currentPosition = Point(0, 0);
  Point currentPositionScaled = Point(0, 0);

  double currentAngle = 0;

  int pointer = 0;

  void draw() {
    drawTracingLine();
    drawPositionLines();
    drawPositionText();
    drawSubmarine();
  }

  void drawPositionText() {
    ctx.font = '30px Calibri';

    ctx.fillStyle = 'white';
    ctx.fillText(
        currentPosition.x.toStringAsFixed(0),
        currentPositionScaled.x -
            ctx.measureText(currentPosition.x.toStringAsFixed(0)).width! -
            20,
        40);

    ctx.fillStyle = 'white';
    ctx.fillText(
        currentPosition.y.toStringAsFixed(0), 20, currentPositionScaled.y - 20);
  }

  void drawPositionLines() {
    final horizontalGradient = ctx.createLinearGradient(0, 0, 0, height)
      ..addColorStop(
          min(max(0, (currentPositionScaled.y - submarineHeight * 2) / height),
              1),
          '#146B3A')
      ..addColorStop(
          min(max(0, (currentPositionScaled.y) / height), 1), '#F8B229')
      ..addColorStop(
          min(max(0, (currentPositionScaled.y + submarineHeight * 2) / height),
              1),
          '#146B3A');

    final verticalGradient = ctx.createLinearGradient(0, 0, width, 0)
      ..addColorStop(
          min(max(0, (currentPositionScaled.x - submarineWidth * 2) / width),
              1),
          '#146B3A')
      ..addColorStop(
          min(max(0, (currentPositionScaled.x) / width), 1), '#F8B229')
      ..addColorStop(
          min(max(0, (currentPositionScaled.x + submarineWidth * 2) / width),
              1),
          '#146B3A');

    ctx.fillStyle = horizontalGradient;
    ctx.fillRect(currentPositionScaled.x, 0, 2, height);

    ctx.fillStyle = verticalGradient;
    ctx.fillRect(0, currentPositionScaled.y, width, 2);
  }

  void drawTracingLine() {
    final gradient = ctx.createLinearGradient(
        0, 0, currentPositionScaled.x, currentPositionScaled.y)
      ..addColorStop(0, '#165B33')
      ..addColorStop(0.2, '#146B3A')
      ..addColorStop(0.5, '#F8B229')
      ..addColorStop(0.8, '#EA4630')
      ..addColorStop(0.9, '#BB2528');

    ctx
      ..strokeStyle = gradient
      ..lineWidth = 2;

    ctx.beginPath();
    ctx.moveTo(points.first.x, points.first.y);
    for (var i = 1; i < pointer; i++) {
      ctx.lineTo(points[i].x * xScale, points[i].y * yScale);
    }
    ctx.stroke();
  }

  void drawSubmarine() {
    final x = currentPositionScaled.x;
    final y = currentPositionScaled.y;
    final w = submarineWidth;
    final h = submarineHeight;
    ctx.save();
    ctx.translate(x, y);
    ctx.rotate(currentAngle / 180 * pi);
    ctx.translate(-x - w / 2, -y - h / 2);
    ctx.drawImageScaled(submarineImage, x, y, submarineWidth, submarineHeight);
    ctx.restore();
  }

  IndicesAndTimeAccumulator? findCurrentPointIndicesWithTimeAccumulator(
      num currentTime) {
    double timeAccumulator = 0;

    for (var i = 0; i < timeList.length; i++) {
      if (currentTime >= timeAccumulator &&
          currentTime <= timeAccumulator + timeList[i]) {
        return IndicesAndTimeAccumulator(i, i + 1, timeAccumulator);
      }

      timeAccumulator += timeList[i];
    }
  }

  void update(num currentTime) {
    final result = findCurrentPointIndicesWithTimeAccumulator(currentTime);

    if (result != null) {
      pointer = result.firstPointIndex;

      final startPoint = points[result.firstPointIndex];
      final startPointTime = result.timeAccumulator;

      final endPoint = points[result.secondPointIndex];
      final endPointTime =
          result.timeAccumulator + timeList[result.firstPointIndex];

      final percentageBetweenPoints =
          (currentTime - startPointTime) / (endPointTime - startPointTime);

      final pointsDeltaX = endPoint.x - startPoint.x;
      final pointsDeltaY = endPoint.y - startPoint.y;
      final angleDelta = angles[result.secondPointIndex >= angles.length
              ? angles.length - 1
              : result.secondPointIndex] -
          angles[result.firstPointIndex];

      final point = Point(startPoint.x + pointsDeltaX * percentageBetweenPoints,
          startPoint.y + pointsDeltaY * percentageBetweenPoints);
      currentPosition = Point(point.x, point.y);
      currentAngle =
          angles[result.firstPointIndex] + angleDelta * percentageBetweenPoints;
    } else {
      currentPosition = Point(points.last.x, points.last.y);
    }

    currentPositionScaled =
        Point(currentPosition.x * xScale, currentPosition.y * yScale);

    draw();
  }
}

class IndicesAndTimeAccumulator {
  final int firstPointIndex;
  final int secondPointIndex;
  final double timeAccumulator;

  const IndicesAndTimeAccumulator(
      this.firstPointIndex, this.secondPointIndex, this.timeAccumulator);
}
