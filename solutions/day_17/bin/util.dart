import 'dart:io';

import 'dart:math';

class TargetArea {
  final Point<int> topLeft;
  final Point<int> bottomRight;

  TargetArea(this.topLeft, this.bottomRight);
}

Future<TargetArea> getTargetArea() async {
  final String inputString =
      await File('../../assets/inputs/day_17.txt').readAsString();

  final List<List<String>> parts = inputString
      .substring(13)
      .split(', ')
      .map((part) => part.substring(2).split('..'))
      .toList();

  final xValues = parts[0].map(int.parse);
  final yValues = parts[1].map(int.parse);

  return TargetArea(Point(xValues.reduce(min), yValues.reduce(max)),
      Point(xValues.reduce(max), yValues.reduce(min)));
}

Point<int> nextVelocity(Point<int> velocity) {
  final int nextVelocityX = velocity.x == 0
      ? 0
      : velocity.x < 0
      ? velocity.x + 1
      : velocity.x - 1;

  final int nextVelocityY = velocity.y - 1;

  return Point<int>(nextVelocityX, nextVelocityY);
}


class ShotResult {
  final bool hit;
  final int maxHeight;

  ShotResult(this.hit, this.maxHeight);
}

ShotResult shoot(Point<int> velocity, Point<int> topLeft, Point<int> bottomRight) {
  Point<int> position = Point(0, 0);
  bool stop = false;

  int maxHeight = 0;

  while (!stop) {
    position = position + velocity;
    velocity = nextVelocity(velocity);

    if (position.y < bottomRight.y && velocity.y < 0) {
      stop = true;
    }

    if (position.x > bottomRight.x && velocity.x >= 0) {
      stop = true;
    }

    if (position.x < topLeft.x && velocity.x <= 0) {
      stop = true;
    }

    maxHeight = [maxHeight, position.y].reduce(max);

    if (position.x >= topLeft.x &&
        position.x <= bottomRight.x &&
        position.y <= topLeft.y &&
        position.y >= bottomRight.y) {
      return ShotResult(true, maxHeight);
    }
  }

  return ShotResult(false, 0);
}
