import 'dart:io';

import 'dart:math';

class Line {
  final Point p1;
  final Point p2;

  Line(this.p1, this.p2);
}

class OceanFloor {
  late List<List<int>> state;

  OceanFloor.empty(Point dimensions) {
    state = [
      for (var y = 0; y < dimensions.y; y += 1)
        [for (var x = 0; x < dimensions.x; x += 1) 0]
    ];
  }

  int get amountOfDangerousAreas => state.fold(
      0,
      (cumSum, row) =>
          cumSum +
          row.fold(0, (rowCumSum, cell) => rowCumSum + (cell >= 2 ? 1 : 0)));
}

Future<List<Line>> getLines() async {
  final input = await File('../../assets/inputs/day_5.txt').readAsString();
  final lines = RegExp(r'(\d+),(\d+) -> (\d+),(\d+)').allMatches(input).map(
      (rowMatch) => Line(
          Point(num.parse(rowMatch.group(1)!), num.parse(rowMatch.group(2)!)),
          Point(num.parse(rowMatch.group(3)!), num.parse(rowMatch.group(4)!))));
  return lines.toList();
}

OceanFloor getOceanFloor(List<Line> lines, {bool takeDiagonalLinesIntoAccount = false}) {
  final dimensions = lines.fold<Point>(
          Point(0, 0),
          (bottomRight, line) => Point(
              [bottomRight.x, line.p1.x, line.p2.x].reduce(max),
              [bottomRight.y, line.p1.y, line.p2.y].reduce(max))) +
      Point(1, 1);

  final oceanFloor = OceanFloor.empty(dimensions);

  for (var line in lines) {
    if (!takeDiagonalLinesIntoAccount) {
      if (line.p1.x != line.p2.x && line.p1.y != line.p2.y) {
        continue;
      }
    }

    final horizontalLength = line.p2.x - line.p1.x;
    final verticalLength = line.p2.y - line.p1.y;
    final length =
        (horizontalLength != 0 ? horizontalLength : verticalLength).abs();

    int x = line.p1.x.toInt();
    int y = line.p1.y.toInt();

    for (var i = 0; i < length + 1; i += 1) {
      oceanFloor.state[y][x] += 1;
      x += horizontalLength ~/ length;
      y += verticalLength ~/ length;
    }
  }

  return oceanFloor;
}
