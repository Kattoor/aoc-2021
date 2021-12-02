import 'dart:io';

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

Future<List<Instruction>> getInstructions() async {
  final input = await File('./assets/inputs/day_2.txt').readAsString();
  final matches = RegExp(r'(forward|up|down) (\d)+').allMatches(input);
  return matches
      .map((match) => Instruction(
          Direction.values.firstWhere((element) =>
              element.toString().split('.').last == match.group(1)),
          int.parse(match.group(2)!)))
      .toList();
}
