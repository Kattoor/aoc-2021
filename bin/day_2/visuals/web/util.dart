import 'dart:math';

import 'package:http/http.dart' as http;

enum Direction { forward, down, up }

extension DirectionExtension on Direction {
  bool get isHorizontal => this == Direction.forward;

  int get yMultiplier {
    switch (this) {
      case Direction.up:
        return -1;
      case Direction.down:
        return 1;
      default:
        return 0;
    }
  }

  int getAimAddition(int n) => yMultiplier * n;
}

class Instruction {
  final Direction direction;
  final int amount;

  const Instruction(this.direction, this.amount);
}

class PointWithAim {
  final Point point;
  final int aim;

  const PointWithAim(this.point, this.aim);
}

Future<List<Instruction>> getInstructions() async {
  final client = http.Client();
  final input = (await client.get(Uri.http('localhost:8081', '/inputs/day_2.txt'))).body;
  final matches = RegExp(r'(forward|up|down) (\d)+').allMatches(input);
  return matches
      .map((match) => Instruction(
          Direction.values.firstWhere((element) =>
              element.toString().split('.').last == match.group(1)),
          int.parse(match.group(2)!)))
      .toList();
}

String getImageUrl() => 'http://localhost:8081/submarine.png';

List<List<Point>> zipWithSelfSkip1(List<Point> list) {
  return [
    for (int i = 0; i < list.length - 1; i += 1) [list[i], list[i + 1]]
  ];
}
