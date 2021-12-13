import 'dart:io';

import 'dart:math';

enum Axis { x, y }

class FoldInstruction {
  final Axis axis;
  final int value;

  FoldInstruction(this.axis, this.value);
}

class Input {
  final List<Point<int>> points;
  final List<FoldInstruction> foldInstructions;

  Input(this.points, this.foldInstructions);
}

Future<Input> getInput() async {
  final lines = await File('../../assets/inputs/day_13.txt').readAsLines();
  final emptyLineIndex = lines.indexWhere((line) => line.isEmpty);
  final points = [
    for (var i = 0; i < emptyLineIndex; i++)
      Point(
          int.parse(lines[i].split(',')[0]), int.parse(lines[i].split(',')[1]))
  ];
  final foldInstructions = [
    for (var i = emptyLineIndex + 1; i < lines.length; i++)
      FoldInstruction(
          Axis.values.firstWhere((value) =>
              value.toString() ==
              'Axis.' + lines[i].split('').skip(11).take(1).first),
          int.parse(lines[i].split('=')[1]))
  ];

  return Input(points, foldInstructions);
}

List<Point<int>> fold(
    List<Point<int>> points, FoldInstruction foldInstruction) {
  points = points.where((point) {
    if (foldInstruction.axis == Axis.x) {
      return point.x != foldInstruction.value;
    } else {
      return point.y != foldInstruction.value;
    }
  }).toList();

  points = points.map((point) {
    if (foldInstruction.axis == Axis.x) {
      if (point.x < foldInstruction.value) {
        return point;
      } else {
        return Point(
            foldInstruction.value - (point.x - foldInstruction.value), point.y);
      }
    } else {
      if (point.y < foldInstruction.value) {
        return point;
      } else {
        return Point(
            point.x, foldInstruction.value - (point.y - foldInstruction.value));
      }
    }
  }).toList();

  return points;
}
