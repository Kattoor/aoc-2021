import 'dart:math';

import 'util.dart';

void main() async {
  final input = await getInput();
  var points = input.points;
  var foldInstructions = input.foldInstructions;

  for (final foldInstruction in foldInstructions) {
    points = fold(points, foldInstruction);
  }

  printGrid(points);
}

void printGrid(List<Point<int>> points) {
  final int maxX = points.map((point) => point.x).reduce(max);
  final int maxY = points.map((point) => point.y).reduce(max);

  List<List<bool>> grid = List.generate(
      maxY + 1, (index) => List.generate(maxX + 1, (index) => false));

  for (final point in points) {
    grid[point.y][point.x] = true;
  }

  for (final row in grid) {
    print(row.map((cell) => cell ? 'o' : ' ').join(''));
  }
}
