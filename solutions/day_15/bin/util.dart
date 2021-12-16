import 'dart:io';

import 'dart:math';

class Cell {
  final int value;
  final int x;
  final int y;
  final List<Cell> neighbours;
  late Cell cameFrom;
  double cost = double.infinity;
  bool visited = false;

  Cell(this.value, this.x, this.y, this.neighbours);

  List<Cell> get unvisitedNeighbours {
    return neighbours.where((neighbour) => neighbour.visited == false).toList();
  }
}

Future<List<Cell>> getCells({bool shouldSetNeighbours = true}) async {
  final lines = await File('../../assets/inputs/day_15.txt').readAsLines();

  final List<Cell> cells = [];

  for (var y = 0; y < lines.length; y++) {
    final cellsInLine = lines[y].split('');
    for (var x = 0; x < cellsInLine.length; x++) {
      cells.add(Cell(int.parse(cellsInLine[x]), x, y, []));
    }
  }

  if (shouldSetNeighbours) {
    for (var y = 0; y < lines.length; y++) {
      final cellsInLine = lines[y].split('');
      for (var x = 0; x < cellsInLine.length; x++) {
        setNeighbours(x, y, cellsInLine.length, lines.length, cells);
      }
    }
  }

  return cells;
}

void setNeighbours(int x, int y, int width, int height, List<Cell> cells) {
  final int cellIndex = y * width + x;
  final Cell cell = cells[cellIndex];

  if (x > 0) {
    cell.neighbours.add(cells[cellIndex - 1]);
  }

  if (y > 0) {
    cell.neighbours.add(cells[cellIndex - width]);
  }

  if (x < width - 1) {
    cell.neighbours.add(cells[cellIndex + 1]);
  }

  if (y < height - 1) {
    cell.neighbours.add(cells[cellIndex + width]);
  }
}

Future<Point<int>> getDimensions() async {
  final lines = await File('../../assets/inputs/day_15.txt').readAsLines();
  return Point(lines.first.length, lines.length);
}
